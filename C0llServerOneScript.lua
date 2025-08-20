local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crear RemoteEvent
local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "AntiHitRemote"
remoteEvent.Parent = ReplicatedStorage

-- Tabla para trackear jugadores con anti-hit activo
local antiHitPlayers = {}

-- Función para crear GUI del jugador
local function createGUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Crear ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntiHitGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Botón principal
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    button.Text = "Activar Anti-Hit"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = frame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Label de tiempo
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, -20, 0, 30)
    timeLabel.Position = UDim2.new(0, 10, 0, 60)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = ""
    timeLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.Parent = frame
    
    -- Script local dentro del GUI
    local localScript = Instance.new("LocalScript")
    localScript.Source = [[
        local button = script.Parent.Frame.TextButton
        local timeLabel = script.Parent.Frame.TextLabel
        local remoteEvent = game.ReplicatedStorage:WaitForChild("AntiHitRemote")
        
        local isActive = false
        local timeLeft = 0
        
        button.MouseButton1Click:Connect(function()
            if not isActive then
                remoteEvent:FireServer("activate")
            end
        end)
        
        remoteEvent.OnClientEvent:Connect(function(action, data)
            if action == "start" then
                isActive = true
                timeLeft = 10
                button.Text = "Anti-Hit Activo"
                button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
                
            elseif action == "update" then
                timeLeft = data
                timeLabel.Text = "Tiempo: " .. timeLeft .. "s"
                
            elseif action == "end" then
                isActive = false
                timeLeft = 0
                button.Text = "Activar Anti-Hit"
                button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                timeLabel.Text = ""
            end
        end)
    ]]
    localScript.Parent = screenGui
end

-- Función para activar anti-hit
local function activateAntiHit(player)
    if antiHitPlayers[player] then return end -- Ya está activo
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    -- Configurar anti-hit
    antiHitPlayers[player] = {
        timeLeft = 10,
        originalPlatformStand = humanoid.PlatformStand,
        bodyVelocity = nil,
        bodyPosition = nil
    }
    
    -- Crear BodyVelocity para anular knockback
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000) -- Solo X y Z, permitir gravedad
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    antiHitPlayers[player].bodyVelocity = bodyVelocity
    
    -- Hacer invulnerable (método más efectivo)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    
    -- Notificar al cliente
    remoteEvent:FireClient(player, "start")
    
    print(player.Name .. " activó anti-hit por 10 segundos")
end

-- Función para desactivar anti-hit
local function deactivateAntiHit(player)
    local data = antiHitPlayers[player]
    if not data then return end
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid then
            -- Restaurar estados
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
        
        -- Limpiar BodyVelocity
        if data.bodyVelocity then
            data.bodyVelocity:Destroy()
        end
        if data.bodyPosition then
            data.bodyPosition:Destroy()
        end
    end
    
    antiHitPlayers[player] = nil
    
    -- Notificar al cliente
    remoteEvent:FireClient(player, "end")
    
    print(player.Name .. " anti-hit desactivado")
end

-- Manejar solicitudes del cliente
remoteEvent.OnServerEvent:Connect(function(player, action)
    if action == "activate" then
        activateAntiHit(player)
    end
end)

-- Loop principal para countdown
RunService.Heartbeat:Connect(function(deltaTime)
    for player, data in pairs(antiHitPlayers) do
        if data.timeLeft > 0 then
            data.timeLeft = data.timeLeft - deltaTime
            
            -- Actualizar UI cada segundo aproximadamente
            local timeLeftInt = math.ceil(data.timeLeft)
            remoteEvent:FireClient(player, "update", timeLeftInt)
            
            -- Verificar si terminó el tiempo
            if data.timeLeft <= 0 then
                deactivateAntiHit(player)
            end
        end
    end
end)

-- Limpiar al desconectar
Players.PlayerRemoving:Connect(function(player)
    if antiHitPlayers[player] then
        antiHitPlayers[player] = nil
    end
end)

-- Crear GUI cuando el jugador se une
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Esperar a que cargue completamente
        createGUI(player)
    end)
end)

-- Para jugadores ya conectados
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        createGUI(player)
    end
    player.CharacterAdded:Connect(function()
        wait(1)
        createGUI(player)
    end)
end
