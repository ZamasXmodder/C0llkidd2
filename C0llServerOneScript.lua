local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Lista de brainrots secrets para ESP
local secretBrainrots = {
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

-- Variables
local espEnabled = false
local autoLaserEnabled = false
local espConnections = {}
local autoLaserConnection = nil
local espBoxes = {}

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotPanel"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Brainrot Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Botón ESP
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.8, 0, 0, 40)
espButton.Position = UDim2.new(0.1, 0, 0, 60)
espButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
espButton.Text = "ESP Secrets: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextScaled = true
espButton.Font = Enum.Font.Gotham
espButton.Parent = mainFrame

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 5)
espCorner.Parent = espButton

-- Botón Auto Laser
local autoLaserButton = Instance.new("TextButton")
autoLaserButton.Size = UDim2.new(0.8, 0, 0, 40)
autoLaserButton.Position = UDim2.new(0.1, 0, 0, 120)
autoLaserButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
autoLaserButton.Text = "Auto Laser: OFF"
autoLaserButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoLaserButton.TextScaled = true
autoLaserButton.Font = Enum.Font.Gotham
autoLaserButton.Parent = mainFrame

local autoLaserCorner = Instance.new("UICorner")
autoLaserCorner.CornerRadius = UDim.new(0, 5)
autoLaserCorner.Parent = autoLaserButton

-- Función para verificar si es un brainrot secret
local function isSecretBrainrot(name)
    for _, secretName in pairs(secretBrainrots) do
        if string.find(name:lower(), secretName:lower()) then
            return true
        end
    end
    return false
end

-- Función para crear ESP de cuerpo completo
local function createFullBodyESP(model)
    if not model or not model:FindFirstChild("HumanoidRootPart") then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. model.Name
    espFolder.Parent = model
    
    -- Crear highlight para todo el modelo
    local highlight = Instance.new("Highlight")
    highlight.Parent = model
    highlight.FillColor = Color3.fromRGB(255, 0, 255) -- Color magenta
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Outline blanco
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Se ve a través de paredes
    
    -- Crear caja alrededor del modelo
    local function createBox()
        local cf, size = model:GetBoundingBox()
        
        local box = Instance.new("BoxHandleAdornment")
        box.Parent = workspace.CurrentCamera
        box.Size = size
        box.CFrame = cf
        box.Color3 = Color3.fromRGB(255, 0, 255)
        box.Transparency = 0.7
        box.AlwaysOnTop = true
        box.ZIndex = 10
        
        return box
    end
    
    local box = createBox()
    
    -- Actualizar la caja constantemente
    local connection = RunService.Heartbeat:Connect(function()
        if model.Parent and model:FindFirstChild("HumanoidRootPart") then
            local cf, size = model:GetBoundingBox()
            box.Size = size
            box.CFrame = cf
        else
            box:Destroy()
            highlight:Destroy()
            connection:Disconnect()
        end
    end)
    
    return {highlight, box, connection}
end

-- Función para toggle ESP
local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        espButton.Text = "ESP Secrets: ON"
        espButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Buscar brainrots en el workspace
        local function scanWorkspace(parent)
            for _, child in pairs(parent:GetChildren()) do
                if child:IsA("Model") and isSecretBrainrot(child.Name) then
                    local esp = createFullBodyESP(child)
                    if esp then
                        espBoxes[child] = esp
                    end
                elseif child:IsA("BasePart") and isSecretBrainrot(child.Name) then
                    -- Para partes individuales, crear un modelo temporal
                    local tempModel = Instance.new("Model")
                    tempModel.Name = child.Name
                    tempModel.Parent = workspace
                    child.Parent = tempModel
                    tempModel.PrimaryPart = child
                    
                    local esp = createFullBodyESP(tempModel)
                    if esp then
                        espBoxes[tempModel] = esp
                    end
                end
                scanWorkspace(child)
            end
        end
        
        scanWorkspace(workspace)
        
        -- Conectar para nuevos objetos
        local connection = workspace.DescendantAdded:Connect(function(descendant)
            if (descendant:IsA("Model") or descendant:IsA("BasePart")) and isSecretBrainrot(descendant.Name) then
                wait(0.1)
                if descendant:IsA("Model") then
                    local esp = createFullBodyESP(descendant)
                    if esp then
                        espBoxes[descendant] = esp
                    end
                end
            end
        end)
        table.insert(espConnections, connection)
        
    else
        espButton.Text = "ESP Secrets: OFF"
        espButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        -- Limpiar ESP
        for model, espData in pairs(espBoxes) do
            for _, item in pairs(espData) do
                if typeof(item) == "RBXScriptConnection" then
                    item:Disconnect()
                elseif item and item.Parent then
                    item:Destroy()
                end
            end
        end
        espBoxes = {}
        
        for _, connection in pairs(espConnections) do
            if typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            end
        end
        espConnections = {}
    end
end

-- Función para auto laser
local function toggleAutoLaser()
    autoLaserEnabled = not autoLaserEnabled
    
    if autoLaserEnabled then
        autoLaserButton.Text = "Auto Laser: ON"
        autoLaserButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        autoLaserConnection = RunService.Heartbeat:Connect(function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                return
            end
            
            local humanoidRootPart = player.Character.HumanoidRootPart
            
            -- Buscar jugadores cercanos
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (humanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                    
                    -- Si hay un jugador cerca (menos de 50 studs)
                    if distance < 50 then
                        -- Intentar disparar el laser
                        pcall(function()
                            -- Buscar el LaserCape en el inventario del jugador
                            local backpack = player:FindFirstChild("Backpack")
                            local laserCape = nil
                            
                            if backpack then
                                laserCape = backpack:FindFirstChild("LaserCape")
                            end
                            
                            -- Si no está en el backpack, buscar si está equipado
                            if not laserCape and player.Character then
                                laserCape = player.Character:FindFirstChild("LaserCape")
                            end
                            
                            if laserCape then
                                -- Simular el disparo del laser usando el RemoteEvent
                                local Net_upvr = ReplicatedStorage:FindFirstChild("Net_upvr")
                                if Net_upvr then
                                    local PlayerMouse = player:GetMouse()
                                    PlayerMouse.Target = otherPlayer.Character.HumanoidRootPart
                                    
                                    -- Disparar hacia el jugador objetivo
                                    Net_upvr:FireServer(PlayerMouse.Hit.Position, otherPlayer.Character.HumanoidRootPart)
                                end
                            end
                        end)
                        
                        wait(0.1) -- Pequeña pausa entre disparos
                        break -- Solo disparar a un jugador por frame
                    end
                end
            end
        end)
        
    else
        autoLaserButton.Text = "Auto Laser: OFF"
        autoLaserButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        if autoLaserConnection then
            autoLaserConnection:Disconnect()
            autoLaserConnection = nil
        end
    end
end

-- Conectar botones
espButton.MouseButton1Click:Connect(toggleESP)
autoLaserButton.MouseButton1Click:Connect(toggleAutoLaser)

-- Hacer el panel arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("Brainrot Panel cargado exitosamente!")
print("ESP: Muestra brainrots secrets con highlight completo")
print("Auto Laser: Dispara automáticamente a jugadores cercanos")
