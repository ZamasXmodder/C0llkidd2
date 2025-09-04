local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear el ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GamePanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
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
titleLabel.Text = "Game Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- ScrollingFrame para los botones
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ButtonContainer"
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

-- Variables para funciones
local aimbotEnabled = false
local laserAimbotEnabled = false
local espEnabled = false
local secretEspEnabled = false
local aimbotConnection = nil
local laserAimbotConnection = nil

-- Lista de secretos brainrots
local brainrotSecrets = {
    "La Vacca Saturno Saturnita",
    "Torrtuginni Dragonfrutini",
    "Agarrini La Palini",
    "Los Tralaleritos",
    "Las Tralaleritas",
    "Job Job Job Sahur",
    "Las Vaquitas Saturnitas",
    "Ketupat Kepat",
    "Graipuss Medussi",
    "Pot Hotspot",
    "Chicleteira Bicicleteira",
    "La Grande Combinasion",
    "Los Combinasionas",
    "Nuclearo Dinossauro",
    "Los Hotspotsitos",
    "Esok Sekolah",
    "Garama and Madundung",
    "Los Matteos",
    "Dragon Cannelloni",
    "Los Spyderinis",
    "La Supreme Combinasion",
    "Spaghetti Tualetti",
    "Secret Lucky Block"
}

-- Función para crear botones
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    -- Efecto hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    
    return button
end

-- Función para obtener la LaserCape
local function getLaserCape()
    if player.Character then
        return player.Character:FindFirstChild("LaserCape") or player.Backpack:FindFirstChild("LaserCape")
    end
    return nil
end

-- Función para disparar LaserCape
local function fireLaserCape(targetPosition, target)
    local laserCape = getLaserCape()
    if not laserCape then
        return false
    end
    
    -- Si la capa está en el backpack, equiparla
    if laserCape.Parent == player.Backpack then
        player.Character.Humanoid:EquipTool(laserCape)
        wait(0.1) -- Pequeña espera para que se equipe
    end
    
    -- Intentar encontrar el RemoteEvent
    local remoteEvent = nil
    
    -- Buscar en ReplicatedStorage
    if ReplicatedStorage:FindFirstChild("Net") then
        remoteEvent = ReplicatedStorage.Net
    elseif ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net") then
        remoteEvent = ReplicatedStorage.Packages.Net
    end
    
    if remoteEvent and remoteEvent:FindFirstChild("UseItem") then
        -- Disparar usando el RemoteEvent
        remoteEvent.UseItem:FireServer(targetPosition, target)
        return true
    else
        -- Método alternativo: activar la tool directamente
        if laserCape:FindFirstChild("RemoteEvent") then
            laserCape.RemoteEvent:FireServer(targetPosition, target)
            return true
        end
    end
    
    return false
end

-- Función Aimbot normal
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    
    if aimbotEnabled then
        aimbotConnection = RunService.Heartbeat:Connect(function()
            local camera = workspace.CurrentCamera
            local closestPlayer = nil
            local shortestDistance = math.huge
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
                    local distance = (player.Character.Head.Position - otherPlayer.Character.Head.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
            
            if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, closestPlayer.Character.Head.Position)
            end
        end)
        print("Aimbot activado")
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
        print("Aimbot desactivado")
    end
end

-- Función Aimbot con LaserCape (Auto-disparo)
local function toggleLaserAimbot()
    laserAimbotEnabled = not laserAimbotEnabled
    
    if laserAimbotEnabled then
        laserAimbotConnection = RunService.Heartbeat:Connect(function()
            if not getLaserCape() then
                return
            end
            
            local camera = workspace.CurrentCamera
            local targets = {}
            
            -- Encontrar jugadores cercanos (dentro de 100 studs)
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
                    local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 100 then -- Rango de 100 studs
                        table.insert(targets, {player = otherPlayer, distance = distance})
                    end
                end
            end
            
            -- Ordenar por distancia (más cercano primero)
            table.sort(targets, function(a, b) return a.distance < b.distance end)
            
            -- Disparar a los 3 jugadores más cercanos
            for i = 1, math.min(3, #targets) do
                local target = targets[i].player
                if target.Character and target.Character:FindFirstChild("Head") then
                    -- Apuntar a la cabeza del jugador
                    local targetPosition = target.Character.Head.Position
                    
                    -- Disparar LaserCape
                    fireLaserCape(targetPosition, target.Character)
                    
                    -- Pequeña pausa entre disparos
                    wait(0.05)
                end
            end
        end)
        print("Laser Aimbot activado - Auto-disparo a jugadores cercanos")
    else
        if laserAimbotConnection then
            laserAimbotConnection:Disconnect()
            laserAimbotConnection = nil
        end
        print("Laser Aimbot desactivado")
    end
end

-- Función Instant TP
local function instantTp()
    local mouse = player:GetMouse()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
        print("Teletransportado a: " .. tostring(mouse.Hit.Position))
    end
end

-- Función ESP Players
local function togglePlayerEsp()
    espEnabled = not espEnabled
    
    if espEnabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "PlayerESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = otherPlayer.Character
            end
        end
        print("ESP Players activado")
    else
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer.Character and otherPlayer.Character:FindFirstChild("PlayerESP") then
                otherPlayer.Character.PlayerESP:Destroy()
            end
        end
        print("ESP Players desactivado")
    end
end

-- Función ESP Brainrots Secrets
local function toggleSecretEsp()
    secretEspEnabled = not secretEspEnabled
    
    if secretEspEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                for _, secretName in pairs(brainrotSecrets) do
                    if string.find(obj.Name:lower(), secretName:lower()) or 
                       (obj.Parent and string.find(obj.Parent.Name:lower(), secretName:lower())) then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "SecretESP"
                        highlight.FillColor = Color3.fromRGB(0, 255, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        highlight.Parent = obj
                        break
                    end
                end
            end
        end
        print("ESP Brainrots Secrets activado")
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("SecretESP") then
                obj.SecretESP:Destroy()
            end
        end
        print("ESP Brainrots Secrets desactivado")
    end
end

-- Crear botones
createButton("Aimbot Player", toggleAimbot)
createButton("Laser Aimbot (Auto-Fire)", toggleLaserAimbot)
createButton("Instant TP", instantTp)
createButton("ESP Players", togglePlayerEsp)
createButton("ESP Brainrots Secrets", toggleSecretEsp)

-- Botón para abrir/cerrar panel
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
toggleButton.Text = "Panel"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Función para toggle del panel
local function togglePanel()
    mainFrame.Visible = not mainFrame.Visible
    
    if mainFrame.Visible then
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        toggleButton.Text = "Cerrar"
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        toggleButton.Text = "Panel"
    end
end

toggleButton.MouseButton1Click:Connect(togglePanel)

-- Tecla para abrir/cerrar (Insert)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        togglePanel()
    end
end)

-- Actualizar canvas size del scroll frame
local function updateScrollSize()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
    updateScrollSize)
updateScrollSize()

print("Panel de juego cargado. Presiona Insert o el botón 'Panel' para abrir/cerrar.")
print("Laser Aimbot: Dispara automáticamente a jugadores dentro de 100 studs")
