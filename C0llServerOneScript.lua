-- Steal a Brainrot Advanced Hack v4 - Fixed Mechanics

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local panelOpen = false
local aimbotEnabled = false
local forceTPEnabled = false
local brainrotEspEnabled = false
local basesEspEnabled = false
local connections = {}
local espObjects = {}
local playerSpawnPosition = nil
local isPlayerStolen = false
local lastTeleportTime = 0

-- Configuración
local CLONER_NAMES = {
    "Clonador cuántico",
    "Quantum Cloner", 
    "QuantumCloner",
    "Clonador",
    "Cloner"
}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealBrainrotHack"
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 420, 0, 600)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 15, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Glowing border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 100, 255)
stroke.Thickness = 3
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- Animate border glow
spawn(function()
    while true do
        for i = 1, 100 do
            stroke.Transparency = 0.3 + (math.sin(i/10) * 0.2)
            wait(0.05)
        end
    end
end)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 50, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 150))
}
headerGradient.Rotation = 90
headerGradient.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🧠 STEAL A BRAINROT HACK 🧠"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 20)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeButton

-- Buttons Container
local buttonsFrame = Instance.new("ScrollingFrame")
buttonsFrame.Size = UDim2.new(1, -20, 1, -100)
buttonsFrame.Position = UDim2.new(0, 10, 0, 90)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.ScrollBarThickness = 8
buttonsFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
buttonsFrame.Parent = mainFrame

-- Function to create modern buttons
local function createButton(name, text, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -10, 0, 50)
    button.Position = UDim2.new(0, 5, 0, yPos)
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = buttonsFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = button
    
    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, Color3.new(color.R * 0.7, color.G * 0.7, color.B * 0.7))
    }
    btnGradient.Rotation = 90
    btnGradient.Parent = button
    
    return button
end

-- Create buttons
local forceTpButton = createButton("ForceTpButton", "🚀 FORCE TELEPORT: OFF", 20, Color3.fromRGB(255, 50, 100))
local aimbotButton = createButton("AimbotButton", "🎯 BRAINROT AIMBOT: OFF", 80, Color3.fromRGB(100, 255, 100))
local brainrotEspButton = createButton("BrainrotEspButton", "🧠 BRAINROT ESP: OFF", 140, Color3.fromRGB(255, 100, 255))
local basesEspButton = createButton("BasesEspButton", "🏠 BASES ESP: OFF", 200, Color3.fromRGB(100, 200, 255))

-- Status Panel
local statusPanel = Instance.new("Frame")
statusPanel.Size = UDim2.new(1, -10, 0, 300)
statusPanel.Position = UDim2.new(0, 5, 0, 270)
statusPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
statusPanel.BorderSizePixel = 0
statusPanel.Parent = buttonsFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusPanel

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 1, -20)
statusText.Position = UDim2.new(0, 10, 0, 10)
statusText.BackgroundTransparency = 1
statusText.Text = [[🎮 STEAL A BRAINROT HACK - STATUS

📋 FUNCIONES:
• Force TP: Te teleporta FORZOSAMENTE cuando eres robado
• Brainrot Aimbot: Dispara automáticamente a brainrots (púrpuras)
• Brainrot ESP: Muestra todos los brainrots en el mapa
• Bases ESP: Muestra bases y su estado (abiertas/cerradas)

⚡ ESTADO ACTUAL:
• Player Status: NORMAL
• Spawn Saved: NO
• Active Functions: 0

⌨️ Presiona F para abrir/cerrar
🔥 Optimizado para Steal a Brainrot]]
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextYAlignment = Enum.TextYAlignment.Top
statusText.TextWrapped = true
statusText.Parent = statusPanel

-- Functions

local function clearEsp()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then
            pcall(function() obj:Destroy() end)
        end
    end
    espObjects = {}
end

local function createEspBox(part, color, text, extraInfo)
    if not part or not part.Parent then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. part.Name
    billboard.Parent = part
    billboard.Size = UDim2.new(0, 200, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, -10)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. (extraInfo and "\n" .. extraInfo or "")
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextWrapped = true
    label.Parent = frame
    
    table.insert(espObjects, billboard)
    return billboard
end

local function updateStatus()
    local activeFunctions = 0
    if forceTPEnabled then activeFunctions = activeFunctions + 1 end
    if aimbotEnabled then activeFunctions = activeFunctions + 1 end
    if brainrotEspEnabled then activeFunctions = activeFunctions + 1 end
    if basesEspEnabled then activeFunctions = activeFunctions + 1 end
    
    local playerStatus = isPlayerStolen and "🚨 ROBADO" or "✅ NORMAL"
    local spawnStatus = playerSpawnPosition and "✅ SÍ" or "❌ NO"
    
    statusText.Text = string.format([[🎮 STEAL A BRAINROT HACK - STATUS

📋 FUNCIONES:
• Force TP: Te teleporta FORZOSAMENTE cuando eres robado
• Brainrot Aimbot: Dispara automáticamente a brainrots (púrpuras)
• Brainrot ESP: Muestra todos los brainrots en el mapa
• Bases ESP: Muestra bases y su estado (abiertas/cerradas)

⚡ ESTADO ACTUAL:
• Player Status: %s
• Spawn Saved: %s
• Active Functions: %d

⌨️ Presiona F para abrir/cerrar
🔥 Optimizado para Steal a Brainrot]], playerStatus, spawnStatus, activeFunctions)
end

local function savePlayerSpawn()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Esperar un poco para asegurar que el jugador esté en su base
        wait(3)
        playerSpawnPosition = character.HumanoidRootPart.CFrame
        print("🏠 Spawn position saved:", playerSpawnPosition.Position)
        updateStatus()
    end
end

local function detectIfPlayerIsStolen()
    -- Método 1: Verificar si el jugador está en su propia base
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    
    -- Método 2: Verificar por GUI de "STOLEN"
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:FindFirstChild("STOLEN") or gui.Name:lower():find("stolen") then
            return true
        end
    end
    
    -- Método 3: Verificar por cambios en el personaje o efectos
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        -- Si la velocidad está bloqueada o hay efectos extraños
        if humanoid.WalkSpeed <= 0 or humanoid.JumpPower <= 0 then
            return true
        end
    end
    
    -- Método 4: Verificar distancia de la base original
    if playerSpawnPosition then
        local distance = (character.HumanoidRootPart.CFrame.Position - playerSpawnPosition.Position).Magnitude
        if distance > 200 then -- Si está muy lejos de su base
            return true
        end
    end
    
    return false
end

local function forceTeleportToBase()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") and playerSpawnPosition then
        local currentTime = tick()
        if currentTime - lastTeleportTime >= 1 then -- Cooldown de 1 segundo
            character.HumanoidRootPart.CFrame = playerSpawnPosition
            lastTeleportTime = currentTime
            print("🚀 FORCE TELEPORTED to base!")
        end
    end
end

local function getBrainrotsInWorkspace()
    local brainrots = {}
    
    -- Buscar en workspace por NPCs/modelos púrpuras
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = obj.Name:lower()
            -- Detectar brainrots por nombre o características
            if name:find("brainrot") or name:find("skibidi") or name:find("sigma") then
                table.insert(brainrots, obj)
            elseif obj:IsA("BasePart") then
                -- Detectar por color púrpura
                local color = obj.Color
                if color.R < 0.7 and color.B > 0.4 and color.G < 0.7 then
                    table.insert(brainrots, obj)
                end
            end
        end
    end
    
    return brainrots
end

local function findCloner()
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    -- Buscar en character
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, name in pairs(CLONER_NAMES) do
                    if tool.Name:find(name) then
                        return tool, true
                    end
                end
            end
        end
    end
    
    -- Buscar en backpack
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                for _, name in pairs(CLONER_NAMES) do
                    if tool.Name:find(name) then
                        return tool, false
                    end
                end
            end
        end
    end
    
    return nil, false
end

local function equipCloner()
    local character = player.Character
    if not character then return end
    
    local tool, equipped = findCloner()
    if tool and not equipped then
        pcall(function()
            character.Humanoid:EquipTool(tool)
        end)
    end
end

local function shootAtBrainrot(brainrot)
    local tool, equipped = findCloner()
    if not tool or not equipped then return end
    
    -- Intentar disparar usando diferentes métodos
    for _, descendant in pairs(tool:GetDescendants()) do
        if descendant:IsA("RemoteEvent") then
            pcall(function()
                descendant:FireServer(brainrot)
            end)
        end
    end
    
    pcall(function()
        tool:Activate()
    end)
end

local function togglePanel()
    panelOpen = not panelOpen
    mainFrame.Visible = panelOpen
    
    if panelOpen then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Visible = true
        
        local tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 420, 0, 600)}
        )
        tween:Play()
    end
end

-- Main loops
local function forceTPLoop()
    if not forceTPEnabled then return end
    
    isPlayerStolen = detectIfPlayerIsStolen()
    if isPlayerStolen then
        forceTeleportToBase()
    end
    updateStatus()
end

local function aimbotLoop()
    if not aimbotEnabled then return end
    
    equipCloner()
    local brainrots = getBrainrotsInWorkspace()
    
    for _, brainrot in pairs(brainrots) do
        shootAtBrainrot(brainrot)
    end
end

local function brainrotEspLoop()
    if not brainrotEspEnabled then return end
    
    local brainrots = getBrainrotsInWorkspace()
    for _, brainrot in pairs(brainrots) do
        local mainPart = brainrot.PrimaryPart or brainrot:FindFirstChildOfClass("BasePart")
        if mainPart then
            local existingEsp = mainPart:FindFirstChild("ESP_" .. mainPart.Name)
            if not existingEsp then
                createEspBox(mainPart, Color3.fromRGB(255, 0, 255), "🧠 BRAINROT", "Click to steal!")
            end
        end
    end
end

local function basesEspLoop()
    if not basesEspEnabled then return end
    
    -- Buscar bases en workspace
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:find("Base") and obj:IsA("Model") then
            local basePart = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
            if basePart then
                local existingEsp = basePart:FindFirstChild("ESP_" .. basePart.Name)
                if not existingEsp then
                    -- Determinar si está abierta (simplificado)
                    local status = "UNKNOWN"
                    local color = Color3.fromRGB(255, 255, 0)
                    
                    createEspBox(basePart, color, "🏠 " .. obj.Name, status)
                end
            end
        end
    end
end

-- Event Connections
forceTpButton.MouseButton1Click:Connect(function()
    forceTPEnabled = not forceTPEnabled
    forceTpButton.Text = "🚀 FORCE TELEPORT: " .. (forceTPEnabled and "ON" or "OFF")
    
    if forceTPEnabled then
        connections.forceTP = RunService.Heartbeat:Connect(forceTPLoop)
        print("🚀 Force Teleport activated!")
    else
        if connections.forceTP then
            connections.forceTP:Disconnect()
            connections.forceTP = nil
        end
        print("🚀 Force Teleport deactivated!")
    end
    updateStatus()
end)

aimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotButton.Text = "🎯 BRAINROT AIMBOT: " .. (aimbotEnabled and "ON" or "OFF")
    
    if aimbotEnabled then
        connections.aimbot = RunService.Heartbeat:Connect(aimbotLoop)
        print("🎯 Brainrot Aimbot activated!")
    else
        if connections.aimbot then
            connections.aimbot:Disconnect()
            connections.aimbot = nil
        end
        print("🎯 Brainrot Aimbot deactivated!")
    end
    updateStatus()
end)

brainrotEspButton.MouseButton1Click:Connect(function()
    brainrotEspEnabled = not brainrotEspEnabled
    brainrotEspButton.Text = "🧠 BRAINROT ESP: " .. (brainrotEspEnabled and "ON" or "OFF")
    
    if brainrotEspEnabled then
        connections.brainrotEsp = RunService.Heartbeat:Connect(brainrotEspLoop)
        print("🧠 Brainrot ESP activated!")
    else
        if connections.brainrotEsp then
            connections.brainrotEsp:Disconnect()
            connections.brainrotEsp = nil
        end
        clearEsp()
        print("🧠 Brainrot ESP deactivated!")
    end
    updateStatus()
end)

basesEspButton.MouseButton1Click:Connect(function()
    basesEspEnabled = not basesEspEnabled
    basesEspButton.Text = "🏠 BASES ESP: " .. (basesEspEnabled and "ON" or "OFF")
    
    if basesEspEnabled then
        connections.basesEsp = RunService.Heartbeat:Connect(basesEspLoop)
        print("🏠 Bases ESP activated!")
    else
        if connections.basesEsp then
            connections.basesEsp:Disconnect()
            connections.basesEsp = nil
        end
        clearEsp()
        print("🏠 Bases ESP deactivated!")
    end
    updateStatus()
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

-- Initialize spawn position
player.CharacterAdded:Connect(savePlayerSpawn)
if player.Character then
    spawn(savePlayerSpawn)
end

-- Cleanup
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        for _, connection in pairs(connections) do
            if connection then connection:Disconnect() end
        end
        clearEsp()
    end
end)

print("🎮 STEAL A BRAINROT HACK v4 LOADED!")
print("🚀 Force Teleport - Te teleporta cuando eres robado")
print("🎯 Brainrot Aimbot - Dispara a brainrots automáticamente") 
print("🧠 Brainrot ESP - Muestra brainrots en el mapa")
print("🏠 Bases ESP - Muestra bases y estados")
print("⌨️ Presiona F para abrir el panel")
print("🔥 ¡Optimizado específicamente para Steal a Brainrot!")
