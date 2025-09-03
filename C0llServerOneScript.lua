-- Instant Chilli v3 - Advanced Panel with ESP Features

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local panelOpen = false
local aimbotEnabled = false
local instantTeleportEnabled = false
local playersEspEnabled = false
local basesEspEnabled = false
local aimbotConnection = nil
local autoEquipConnection = nil
local teleportConnection = nil
local playersEspConnection = nil
local basesEspConnection = nil
local lastEquipTime = 0
local playerInitialSpawn = nil
local espObjects = {}

-- Configuración
local TOOL_NAMES = {
    "Clonador cuántico",
    "Quantum Cloner", 
    "QuantumCloner",
    "Clonador",
    "Cloner"
}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InstantChilliV3"
screenGui.Parent = playerGui

-- Main Frame (más grande y moderno)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Efecto de gradiente de fondo
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Bordes redondeados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Borde brillante
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 100, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- Header con gradiente
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 50, 150))
}
headerGradient.Rotation = 90
headerGradient.Parent = header

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

-- Title con efecto de brillo
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🧠 Instant Chilli v3 - Steal a Brainrot"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(255, 255, 255)
titleStroke.Thickness = 1
titleStroke.Transparency = 0.5
titleStroke.Parent = title

-- Close Button (mejorado)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0, 12.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Container para los botones
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsContainer"
buttonsFrame.Size = UDim2.new(1, -20, 1, -80)
buttonsFrame.Position = UDim2.new(0, 10, 0, 70)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

-- Función para crear botones modernos
local function createModernButton(name, text, position, color, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0, 45)
    button.Position = position
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = parent
    
    -- Efecto de gradiente
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, Color3.new(color.R * 0.7, color.G * 0.7, color.B * 0.7))
    }
    buttonGradient.Rotation = 90
    buttonGradient.Parent = button
    
    -- Bordes redondeados
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    -- Borde sutil
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Thickness = 1
    buttonStroke.Transparency = 0.8
    buttonStroke.Parent = button
    
    -- Efecto hover
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(color.R * 1.2, color.G * 1.2, color.B * 1.2)})
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = color})
        leaveTween:Play()
    end)
    
    return button
end

-- Crear botones con diseño moderno
local teleportButton = createModernButton("TeleportButton", "🚀 Instant Teleport: OFF", 
    UDim2.new(0, 0, 0, 0), Color3.fromRGB(60, 180, 75), buttonsFrame)

local aimbotButton = createModernButton("AimbotButton", "🎯 Unlimited Aimbot: OFF", 
    UDim2.new(0, 0, 0, 60), Color3.fromRGB(255, 99, 71), buttonsFrame)

local playersEspButton = createModernButton("PlayersEspButton", "👥 Players ESP: OFF", 
    UDim2.new(0, 0, 0, 120), Color3.fromRGB(138, 43, 226), buttonsFrame)

local basesEspButton = createModernButton("BasesEspButton", "🏠 Bases ESP: OFF", 
    UDim2.new(0, 0, 0, 180), Color3.fromRGB(255, 165, 0), buttonsFrame)

-- Separador visual
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, -20, 0, 2)
separator.Position = UDim2.new(0, 10, 0, 240)
separator.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
separator.BorderSizePixel = 0
separator.Parent = buttonsFrame

local sepCorner = Instance.new("UICorner")
sepCorner.CornerRadius = UDim.new(0, 1)
sepCorner.Parent = separator

-- Panel de información
local infoPanel = Instance.new("Frame")
infoPanel.Name = "InfoPanel"
infoPanel.Size = UDim2.new(1, -20, 0, 180)
infoPanel.Position = UDim2.new(0, 10, 0, 260)
infoPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
infoPanel.BorderSizePixel = 0
infoPanel.Parent = buttonsFrame

local infoPanelCorner = Instance.new("UICorner")
infoPanelCorner.CornerRadius = UDim.new(0, 10)
infoPanelCorner.Parent = infoPanel

local infoPanelStroke = Instance.new("UIStroke")
infoPanelStroke.Color = Color3.fromRGB(70, 70, 70)
infoPanelStroke.Thickness = 1
infoPanelStroke.Parent = infoPanel

-- Información del script
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 1, -20)
infoText.Position = UDim2.new(0, 10, 0, 10)
infoText.BackgroundTransparency = 1
infoText.Text = [[📋 FEATURES:
• Instant Teleport cuando tienes brainrot
• Aimbot ilimitado con auto-equip
• ESP de jugadores con distancia
• ESP de bases (abiertas/cerradas)
• Detección inteligente de brainrot

⌨️ Press F to toggle panel
🎮 Made for Steal a Brainrot]]
infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
infoText.TextSize = 12
infoText.Font = Enum.Font.Gotham
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextWrapped = true
infoText.Parent = infoPanel

-- Functions
local function togglePanel()
    panelOpen = not panelOpen
    mainFrame.Visible = panelOpen
    
    if panelOpen then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Visible = true
        
        local tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 380, 0, 520)}
        )
        tween:Play()
    end
end

local function clearEspObjects()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}
end

local function createEspBox(part, color, text, distance)
    if not part or not part.Parent then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. part.Name
    billboard.Parent = part
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    
    -- Fondo del ESP
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = color
    frameStroke.Thickness = 2
    frameStroke.Parent = frame
    
    -- Texto principal
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0.6, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextWrapped = true
    label.Parent = frame
    
    -- Distancia
    if distance then
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, -10, 0.4, 0)
        distanceLabel.Position = UDim2.new(0, 5, 0.6, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = distance .. " studs"
        distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distanceLabel.TextSize = 12
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.Parent = frame
    end
    
    table.insert(espObjects, billboard)
    return billboard
end

local function findPlayerBase()
    local character = player.Character
    if not character then return Vector3.new(0, 50, 0) end
    
    -- En Steal a Brainrot, las bases están en workspace.Bases
    local basesFolder = workspace:FindFirstChild("Bases")
    if basesFolder then
        -- Buscar base por nombre del jugador
        local playerBase = basesFolder:FindFirstChild(player.Name) or basesFolder:FindFirstChild(tostring(player.UserId))
        if playerBase then
            -- Buscar el punto de spawn en la base
            local spawnPart = playerBase:FindFirstChild("SpawnLocation") or 
                            playerBase:FindFirstChild("Spawn") or
                            playerBase:FindFirstChild("Teleporter") or
                            playerBase:FindFirstChild("Base")
            
            if spawnPart and spawnPart:IsA("BasePart") then
                return spawnPart.Position + Vector3.new(0, 3, 0)
            end
            
            -- Si no hay parte específica, usar el centro de la base
            if playerBase.PrimaryPart then
                return playerBase.PrimaryPart.Position + Vector3.new(0, 3, 0)
            end
            
            -- Como último recurso, buscar cualquier parte en la base
            for _, part in pairs(playerBase:GetChildren()) do
                if part:IsA("BasePart") and part.Name:lower():find("floor") then
                    return part.Position + Vector3.new(0, 3, 0)
                end
            end
        end
    end
    
    -- Usar la posición inicial guardada como respaldo
    if playerInitialSpawn then
        return playerInitialSpawn + Vector3.new(0, 3, 0)
    end
    
    -- Si nada funciona, buscar SpawnLocation genérico
    local spawn = workspace:FindFirstChild("SpawnLocation")
    if spawn and spawn:IsA("BasePart") then
        return spawn.Position + Vector3.new(0, 3, 0)
    end
    
    print("No se pudo encontrar la base del jugador")
    return Vector3.new(0, 50, 0)
end

local function hasBrainrotActive()
    local character = player.Character
    if not character then return false end
    
    -- Método 1: Verificar por color del personaje (púrpura)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        local bodyColors = character:FindFirstChild("Body Colors")
        if bodyColors then
            -- Verificar si tiene colores púrpuras
            local headColor = bodyColors.HeadColor3
            local torsoColor = bodyColors.TorsoColor3
            
            if headColor.R < 0.5 and headColor.B > 0.5 and headColor.G < 0.5 then
                return true
            end
            if torsoColor.R < 0.5 and torsoColor.B > 0.5 and torsoColor.G < 0.5 then
                return true
            end
        end
    end
    
    -- Método 2: Verificar por partes del cuerpo púrpuras
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local color = part.Color
            if color.R < 0.5 and color.B > 0.5 and color.G < 0.5 then
                return true
            end
        end
    end
    
    -- Método 3: Verificar por efectos o valores
    local brainrotValue = character:FindFirstChild("Brainrot") or character:FindFirstChild("BrainrotActive")
    if brainrotValue then
        return true
    end
    
    return false
end

local function instantTeleport()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local basePosition = findPlayerBase()
        character.HumanoidRootPart.CFrame = CFrame.new(basePosition)
        print("Teleported to player base with brainrot!")
    end
end

local function isBaseOpen(base)
    -- Buscar puertas, barreras o indicadores de que la base está cerrada
    local barriers = {
        base:FindFirstChild("Barrier"),
        base:FindFirstChild("Door"),
        base:FindFirstChild("Wall"),
        base:FindFirstChild("Protection")
    }
    
    for _, barrier in pairs(barriers) do
        if barrier and barrier:IsA("BasePart") then
            -- Si la barrera es transparente o no colisionable, la base está abierta
            if barrier.Transparency >= 0.9 or not barrier.CanCollide then
                return true
            else
                return false
            end
        end
    end
    
    -- Si no hay barreras detectables, asumir que está abierta
    return true
end

local function updatePlayersEsp()
    if not playersEspEnabled then return end
    
    local myCharacter = player.Character
    if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then return end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local character = otherPlayer.Character
            local humanoidRootPart = character.HumanoidRootPart
            
            -- Calcular distancia
            local distance = math.floor((myCharacter.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude)
            
            -- Determinar color basado en si tiene brainrot
            local color = Color3.fromRGB(0, 255, 0) -- Verde por defecto
            local status = "Normal"
            
            -- Verificar si el jugador tiene brainrot
            local hasPlayerBrainrot = false
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local partColor = part.Color
                    if partColor.R < 0.5 and partColor.B > 0.5 and partColor.G < 0.5 then
                        hasPlayerBrainrot = true
                        break
                    end
                end
            end
            
            if hasPlayerBrainrot then
                color = Color3.fromRGB(128, 0, 128) -- Púrpura
                status = "HAS BRAINROT"
            end
            
            -- Crear ESP si no existe
            local existingEsp = humanoidRootPart:FindFirstChild("ESP_" .. humanoidRootPart.Name)
            if not existingEsp then
                createEspBox(humanoidRootPart, color, otherPlayer.Name .. "\n" .. status, distance)
            end
        end
    end
end

local function updateBasesEsp()
    if not basesEspEnabled then return end
    
    local basesFolder = workspace:FindFirstChild("Bases")
    if not basesFolder then return end
    
    for _, base in pairs(basesFolder:GetChildren()) do
        if base:IsA("Model") then
            local basePart = base.PrimaryPart or base:FindFirstChildOfClass("BasePart")
            if basePart then
                local isOpen = isBaseOpen(base)
                local color = isOpen and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                local status = isOpen and "OPEN" or "CLOSED"
                
                local existingEsp = basePart:FindFirstChild("ESP_" .. basePart.Name)
                if not existingEsp then
                    createEspBox(basePart, color, "Base: " .. base.Name .. "\n" .. status, nil)
                end
            end
        end
    end
end

local function getAllPlayers()
    local allPlayers = {}
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(allPlayers, otherPlayer)
        end
    end
    
    return allPlayers
end

local function findQuantumCloner()
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    -- Buscar en el character primero
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, name in pairs(TOOL_NAMES) do
                    if tool.Name:lower():find(name:lower()) or tool.Name == name then
                        return tool, true -- tool, isEquipped
                    end
                end
            end
        end
    end
    
    -- Buscar en el backpack
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                for _, name in pairs(TOOL_NAMES) do
                    if tool.Name:lower():find(name:lower()) or tool.Name == name then
                        return tool, false -- tool, isEquipped
                    end
                end
            end
        end
    end
    
    return nil, false
end

local function equipQuantumCloner()
    local character = player.Character
    if not character then return false end
    
    local currentTime = tick()
    if currentTime - lastEquipTime < 1 then
        return false
    end
    
    local tool, isEquipped = findQuantumCloner()
    
    if tool and not isEquipped then
        pcall(function()
            character.Humanoid:EquipTool(tool)
        end)
        lastEquipTime = currentTime
        return true
    end
    
    return isEquipped
end

local function hasQuantumClonerEquipped()
    local tool, isEquipped = findQuantumCloner()
    return isEquipped
end

local function fireQuantumCloner(targetPlayer)
    local character = player.Character
    if not character then return end
    
    local tool, isEquipped = findQuantumCloner()
    if not tool or not isEquipped then return end
    
    local target = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not target then return end
    
    -- Método 1: RemoteEvent más común
    for _, child in pairs(tool:GetDescendants()) do
        if child:IsA("RemoteEvent") and (child.Name:lower():find("fire") or child.Name:lower():find("shoot") or child.Name:lower():find("attack")) then
            pcall(function()
                child:FireServer(target)
                child:FireServer(targetPlayer)
                child:FireServer(target.Position)
            end)
        end
    end
    
    -- Método 2: Activar tool
    pcall(function()
        tool:Activate()
    end)
end

local function unlimitedAimbotLoop()
    if not aimbotEnabled then return end
    
    local allPlayers = getAllPlayers()
    
    if #allPlayers > 0 and not hasQuantumClonerEquipped() then
        equipQuantumCloner()
    end
    
    for _, targetPlayer in pairs(allPlayers) do
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            fireQuantumCloner(targetPlayer)
        end
    end
end

local function smartAutoEquip()
    local allPlayers = getAllPlayers()
    
    if #allPlayers > 0 and not hasQuantumClonerEquipped() then
        local currentTime = tick()
        if currentTime - lastEquipTime >= 2 then
            equipQuantumCloner()
        end
    end
end

local function teleportLoop()
    if instantTeleportEnabled and hasBrainrotActive() then
        instantTeleport()
        wait(1)
    end
end

-- Event Connections
teleportButton.MouseButton1Click:Connect(function()
    instantTeleportEnabled = not instantTeleportEnabled
    teleportButton.Text = "🚀 Instant Teleport: " .. (instantTeleportEnabled and "ON" or "OFF")
    
    if instantTeleportEnabled then
        teleportConnection = RunService.Heartbeat:Connect(teleportLoop)
    else
        if teleportConnection then
            teleportConnection:Disconnect()
            teleportConnection = nil
        end
    end
end)

aimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotButton.Text = "🎯 Unlimited Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
    
    if aimbotEnabled then
        aimbotConnection = RunService.Heartbeat:Connect(unlimitedAimbotLoop)
        autoEquipConnection = RunService.Heartbeat:Connect(smartAutoEquip)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
        if autoEquipConnection then
            autoEquipConnection:Disconnect()
            autoEquipConnection = nil
        end
    end
end)

playersEspButton.MouseButton1Click:Connect(function()
    playersEspEnabled = not playersEspEnabled
    playersEspButton.Text = "👥 Players ESP: " .. (playersEspEnabled and "ON" or "OFF")
    
    if playersEspEnabled then
        playersEspConnection = RunService.Heartbeat:Connect(updatePlayersEsp)
    else
        if playersEspConnection then
            playersEspConnection:Disconnect()
            playersEspConnection = nil
        end
        clearEspObjects()
    end
end)

basesEspButton.MouseButton1Click:Connect(function()
    basesEspEnabled = not basesEspEnabled
    basesEspButton.Text = "🏠 Bases ESP: " .. (basesEspEnabled and "ON" or "OFF")
    
    if basesEspEnabled then
        basesEspConnection = RunService.Heartbeat:Connect(updateBasesEsp)
    else
        if basesEspConnection then
            basesEspConnection:Disconnect()
            basesEspConnection = nil
        end
        clearEspObjects()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    panelOpen = false
    local tween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0)}
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        mainFrame.Visible = false
    end)
end)

-- Key Press Detection
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        togglePanel()
    end
end)

-- Guardar posición inicial del jugador para teleport
player.CharacterAdded:Connect(function(character)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    wait(3)
    
    if humanoidRootPart then
        playerInitialSpawn = humanoidRootPart.Position
        print("Base position saved:", playerInitialSpawn)
    end
end)

-- Si ya hay un character al cargar el script
if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
    spawn(function()
        wait(3)
        playerInitialSpawn = player.Character.HumanoidRootPart.Position
        print("Initial base position saved:", playerInitialSpawn)
    end)
end

-- Cleanup function
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        if aimbotConnection then aimbotConnection:Disconnect() end
        if autoEquipConnection then autoEquipConnection:Disconnect() end
        if teleportConnection then teleportConnection:Disconnect() end
        if playersEspConnection then playersEspConnection:Disconnect() end
        if basesEspConnection then basesEspConnection:Disconnect() end
        clearEspObjects()
    end
end)

-- Debug function
spawn(function()
    while true do
        wait(2)
        if hasBrainrotActive() then
            print("🧠 Brainrot detected! Character is purple/stolen")
        end
    end
end)

print("🎮 Instant Chilli v3 Advanced loaded!")
print("✨ FEATURES:")
print("🚀 - Instant Teleport cuando tienes brainrot")
print("🎯 - Smart Aimbot que dispara al más cercano con capa")
print("👥 - Players ESP con detección de brainrot y distancia")
print("🏠 - Bases ESP con estado abierto/cerrado")
print("🧠 - Detección avanzada de brainrot/capa por colores")
print("⌨️ - Press F to open the advanced panel")
print("🎯 Made specifically for Steal a Brainrot!")
