local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables para las funcionalidades
local isFloating = false
local espEnabled = false
local backpackForced = false
local floatConnection = nil
local espConnections = {}

-- Crear la GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Cheat Panel - F4 to Toggle"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botón de Float
local floatButton = Instance.new("TextButton")
floatButton.Name = "FloatButton"
floatButton.Size = UDim2.new(0.9, 0, 0, 35)
floatButton.Position = UDim2.new(0.05, 0, 0, 60)
floatButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
floatButton.BorderSizePixel = 0
floatButton.Text = "Float: OFF"
floatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
floatButton.TextScaled = true
floatButton.Font = Enum.Font.SourceSans
floatButton.Parent = mainFrame

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 5)
floatCorner.Parent = floatButton

-- Botón de ESP
local espButton = Instance.new("TextButton")
espButton.Name = "ESPButton"
espButton.Size = UDim2.new(0.9, 0, 0, 35)
espButton.Position = UDim2.new(0.05, 0, 0, 105)
espButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
espButton.BorderSizePixel = 0
espButton.Text = "ESP: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextScaled = true
espButton.Font = Enum.Font.SourceSans
espButton.Parent = mainFrame

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 5)
espCorner.Parent = espButton

-- Botón de Backpack
local backpackButton = Instance.new("TextButton")
backpackButton.Name = "BackpackButton"
backpackButton.Size = UDim2.new(0.9, 0, 0, 35)
backpackButton.Position = UDim2.new(0.05, 0, 0, 150)
backpackButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
backpackButton.BorderSizePixel = 0
backpackButton.Text = "Force Backpack: OFF"
backpackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
backpackButton.TextScaled = true
backpackButton.Font = Enum.Font.SourceSans
backpackButton.Parent = mainFrame

local backpackCorner = Instance.new("UICorner")
backpackCorner.CornerRadius = UDim.new(0, 5)
backpackCorner.Parent = backpackButton

-- Función para toggle del panel
local function togglePanel()
    mainFrame.Visible = not mainFrame.Visible
    
    if mainFrame.Visible then
        -- Animación de entrada
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 300, 0, 200)
        })
        tween:Play()
    end
end

-- Función de Float
local function toggleFloat()
    isFloating = not isFloating
    
    if isFloating then
        floatButton.Text = "Float: ON"
        floatButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            -- Crear BodyVelocity para el float
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = humanoidRootPart
            
            floatConnection = RunService.Heartbeat:Connect(function()
                if character and character.Parent and humanoidRootPart and humanoidRootPart.Parent then
                    local camera = workspace.CurrentCamera
                    local moveVector = Vector3.new(0, 0, 0)
                    
                    -- Movimiento con W (hacia adelante según la cámara)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveVector = camera.CFrame.LookVector * 16
                    end
                    
                    -- Mantener flotando
                    bodyVelocity.Velocity = Vector3.new(moveVector.X, 16, moveVector.Z)
                    
                    -- Desactivar la gravedad del personaje
                    if humanoid then
                        humanoid.PlatformStand = true
                    end
                else
                    -- Si el personaje se destruye, desactivar float
                    toggleFloat()
                end
            end)
        end
    else
        floatButton.Text = "Float: OFF"
        floatButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            -- Remover BodyVelocity
            local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
            
            -- Reactivar movimiento normal
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
end

-- Función de ESP
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    
    local function addESP()
        local character = targetPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local humanoidRootPart = character.HumanoidRootPart
        local head = character:FindFirstChild("Head")
        
        -- Crear BillboardGui para el nombre
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ESP_" .. targetPlayer.Name
        billboardGui.Adornee = head or humanoidRootPart
        billboardGui.Size = UDim2.new(0, 200, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 2, 0)
        billboardGui.Parent = character
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = targetPlayer.DisplayName or targetPlayer.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Parent = billboardGui
        
        -- Crear highlight para el personaje
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = character
    end
    
    -- Agregar ESP inmediatamente si el personaje existe
    if targetPlayer.Character then
        addESP()
    end
    
    -- Conectar para cuando el personaje respawnee
    local connection = targetPlayer.CharacterAdded:Connect(addESP)
    espConnections[targetPlayer] = connection
end

local function removeESP(targetPlayer)
    if espConnections[targetPlayer] then
        espConnections[targetPlayer]:Disconnect()
        espConnections[targetPlayer] = nil
    end
    
    if targetPlayer.Character then
        local esp = targetPlayer.Character:FindFirstChild("ESP_" .. targetPlayer.Name)
        local highlight = targetPlayer.Character:FindFirstChild("ESP_Highlight")
        
        if esp then esp:Destroy() end
        if highlight then highlight:Destroy() end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        espButton.Text = "ESP: ON"
        espButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Agregar ESP a todos los jugadores
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            createESP(targetPlayer)
        end
        
        -- Conectar para nuevos jugadores
        espConnections.playerAdded = Players.PlayerAdded:Connect(createESP)
    else
        espButton.Text = "ESP: OFF"
        espButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        -- Remover ESP de todos los jugadores
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            removeESP(targetPlayer)
        end
        
        if espConnections.playerAdded then
            espConnections.playerAdded:Disconnect()
            espConnections.playerAdded = nil
        end
    end
end

-- Función de Force Backpack
local function toggleBackpack()
    backpackForced = not backpackForced
    
    if backpackForced then
        backpackButton.Text = "Force Backpack: ON"
        backpackButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Forzar que el backpack esté siempre visible
        local starterGui = game:GetService("StarterGui")
        starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
        
        -- Mantener el backpack habilitado
        spawn(function()
            while backpackForced do
                wait(1)
                starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
            end
        end)
    else
        backpackButton.Text = "Force Backpack: OFF"
        backpackButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end

-- Conectar eventos de los botones
floatButton.MouseButton1Click:Connect(toggleFloat)
espButton.MouseButton1Click:Connect(toggleESP)
backpackButton.MouseButton1Click:Connect(toggleBackpack)

-- Conectar la tecla F4 para toggle del panel
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F4 then
        togglePanel()
    end
end)

-- Limpiar conexiones cuando el jugador se va
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if espConnections[leavingPlayer] then
        espConnections[leavingPlayer]:Disconnect()
        espConnections[leavingPlayer] = nil
    end
end)

-- Limpiar cuando el personaje del jugador local respawnea
player.CharacterAdded:Connect(function()
    if isFloating then
        -- Reactivar float después del respawn
        wait(1)
        isFloating = false
        toggleFloat()
    end
end)

print("Cheat Panel cargado. Presiona F4 para abrir/cerrar el panel.")
