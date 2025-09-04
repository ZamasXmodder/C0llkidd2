-- Steal a Brainrot Hack v5 - OPTIMIZED & FIXED

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local panelOpen = false
local smartTPEnabled = false
local aimbotEnabled = false
local basesEspEnabled = false
local connections = {}
local espObjects = {}
local playerSpawnPosition = nil
local hasBrainrotInHand = false
local lastBrainrotCheck = 0

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealBrainrotHackV5"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 255, 100)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🧠 STEAL A BRAINROT HACK"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0, 12.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Buttons Container
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -20, 1, -80)
buttonsFrame.Position = UDim2.new(0, 10, 0, 70)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

local function createButton(name, text, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0, 45)
    button.Position = UDim2.new(0, 0, 0, yPos)
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = buttonsFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    return button
end

-- Create Buttons
local smartTpButton = createButton("SmartTpButton", "🚀 SMART TELEPORT: OFF", 10, Color3.fromRGB(100, 200, 100))
local aimbotButton = createButton("AimbotButton", "🎯 BRAINROT AIMBOT: OFF", 65, Color3.fromRGB(200, 100, 100))
local basesButton = createButton("BasesButton", "🏠 BASES ESP: OFF", 120, Color3.fromRGB(100, 100, 200))

-- Status Display
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 180)
statusFrame.Position = UDim2.new(0, 0, 0, 180)
statusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = buttonsFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -10, 1, -10)
statusText.Position = UDim2.new(0, 5, 0, 5)
statusText.BackgroundTransparency = 1
statusText.Text = "📊 STATUS: Initializing..."
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.TextSize = 11
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextYAlignment = Enum.TextYAlignment.Top
statusText.TextWrapped = true
statusText.Parent = statusFrame

-- Core Functions

local function updateStatus()
    local status = string.format([[📊 HACK STATUS:

🚀 Smart TP: %s
🎯 Aimbot: %s  
🏠 Bases ESP: %s

📍 Spawn Saved: %s
🧠 Brainrot in Hand: %s

🎮 INSTRUCTIONS:
• Smart TP espera a que agarres brainrot
• Aimbot dispara a brainrots automáticamente
• Bases ESP muestra bases cada 3 segundos
• Presiona F para abrir/cerrar

🔥 Optimizado - Sin lag!]], 
        smartTPEnabled and "ON" or "OFF",
        aimbotEnabled and "ON" or "OFF", 
        basesEspEnabled and "ON" or "OFF",
        playerSpawnPosition and "YES" or "NO",
        hasBrainrotInHand and "YES" or "NO"
    )
    statusText.Text = status
end

local function saveSpawnPosition()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        wait(2) -- Esperar a estar en la base
        playerSpawnPosition = character.HumanoidRootPart.CFrame
        print("🏠 Spawn position saved!")
        updateStatus()
    end
end

local function checkIfHasBrainrot()
    local character = player.Character
    if not character then return false end
    
    -- Verificar si tiene un brainrot en la mano
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name:lower()
            if name:find("brainrot") or name:find("skibidi") or name:find("sigma") or 
               name:find("ohio") or name:find("gyatt") or name:find("rizz") then
                return true
            end
        end
    end
    
    return false
end

local function smartTeleport()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not playerSpawnPosition then 
        return 
    end
    
    -- Solo teleportarse si tiene brainrot en la mano
    if hasBrainrotInHand then
        character.HumanoidRootPart.CFrame = playerSpawnPosition
        print("🚀 Smart teleport with brainrot!")
        
        -- Esperar un poco antes de permitir otro teleport
        wait(2)
        hasBrainrotInHand = false
    end
end

local function findBrainrotsNearby()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return {} end
    
    local brainrots = {}
    local playerPosition = character.HumanoidRootPart.Position
    
    -- Buscar en un radio de 100 studs
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= character then
            local humanoidRootPart = obj:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = (playerPosition - humanoidRootPart.Position).Magnitude
                if distance <= 100 then
                    local name = obj.Name:lower()
                    -- Verificar si es un brainrot por nombre
                    if name:find("brainrot") or name:find("skibidi") or name:find("sigma") or
                       name:find("ohio") or name:find("gyatt") or name:find("rizz") then
                        table.insert(brainrots, obj)
                    else
                        -- Verificar por color púrpura en las partes
                        for _, part in pairs(obj:GetChildren()) do
                            if part:IsA("BasePart") then
                                local color = part.Color
                                if color.R < 0.6 and color.B > 0.4 and color.G < 0.6 then
                                    table.insert(brainrots, obj)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return brainrots
end

local function findCloner()
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    -- Nombres posibles del clonador
    local clonerNames = {"clonador", "cloner", "quantum", "cuántico"}
    
    -- Buscar en character
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                for _, clonerName in pairs(clonerNames) do
                    if name:find(clonerName) then
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
                local name = tool.Name:lower()
                for _, clonerName in pairs(clonerNames) do
                    if name:find(clonerName) then
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
            wait(0.5) -- Esperar a que se equipe
        end)
    end
end

local function shootAtTarget(target)
    local tool, equipped = findCloner()
    if not tool or not equipped then return end
    
    local targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildOfClass("BasePart")
    if not targetPart then return end
    
    -- Intentar disparar
    for _, obj in pairs(tool:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function()
                obj:FireServer(targetPart)
                obj:FireServer(target)
            end)
        end
    end
    
    pcall(function()
        tool:Activate()
    end)
end

local function clearEsp()
    for _, obj in pairs(espObjects) do
        pcall(function() 
            if obj and obj.Parent then
                obj:Destroy() 
            end
        end)
    end
    espObjects = {}
end

local function createSimpleEsp(part, text, color)
    if not part or not part.Parent then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SimpleESP"
    billboard.Parent = part
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundColor3 = color
    label.BackgroundTransparency = 0.3
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = label
    
    table.insert(espObjects, billboard)
end

local function togglePanel()
    panelOpen = not panelOpen
    if panelOpen then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 350, 0, 450)})
        tween:Play()
    else
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)})
        tween:Play()
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end
end

-- Main Loops (Optimized)

local function smartTpLoop()
    if not smartTPEnabled then return end
    
    local currentTime = tick()
    if currentTime - lastBrainrotCheck >= 0.5 then -- Check every 0.5 seconds
        hasBrainrotInHand = checkIfHasBrainrot()
        lastBrainrotCheck = currentTime
        
        if hasBrainrotInHand then
            wait(1) -- Wait 1 second to ensure we have it
            smartTeleport()
        end
    end
    
    updateStatus()
end

local function aimbotLoop()
    if not aimbotEnabled then return end
    
    equipCloner()
    local brainrots = findBrainrotsNearby()
    
    for _, brainrot in pairs(brainrots) do
        shootAtTarget(brainrot)
        wait(0.1) -- Small delay between shots
    end
end

local function basesEspLoop()
    if not basesEspEnabled then return end
    
    clearEsp() -- Clear old ESP
    
    -- Find bases (optimized - only check every few seconds)
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name:lower():find("base") then
            local basePart = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
            if basePart then
                createSimpleEsp(basePart, "🏠 " .. obj.Name, Color3.fromRGB(100, 150, 255))
            end
        end
    end
    
    wait(3) -- Only update ESP every 3 seconds to avoid lag
end

-- Event Connections

smartTpButton.MouseButton1Click:Connect(function()
    smartTPEnabled = not smartTPEnabled
    smartTpButton.Text = "🚀 SMART TELEPORT: " .. (smartTPEnabled and "ON" or "OFF")
    
    if smartTPEnabled then
        connections.smartTp = RunService.Heartbeat:Connect(smartTpLoop)
        print("🚀 Smart Teleport ON - Will teleport when you grab brainrot!")
    else
        if connections.smartTp then connections.smartTp:Disconnect() end
        print("🚀 Smart Teleport OFF")
    end
    updateStatus()
end)

aimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotButton.Text = "🎯 BRAINROT AIMBOT: " .. (aimbotEnabled and "ON" or "OFF")
    
    if aimbotEnabled then
        connections.aimbot = spawn(function()
            while aimbotEnabled do
                aimbotLoop()
                wait(0.5) -- Run every 0.5 seconds
            end
        end)
        print("🎯 Brainrot Aimbot ON!")
    else
        print("🎯 Brainrot Aimbot OFF")
    end
    updateStatus()
end)

basesButton.MouseButton1Click:Connect(function()
    basesEspEnabled = not basesEspEnabled
    basesButton.Text = "🏠 BASES ESP: " .. (basesEspEnabled and "ON" or "OFF")
    
    if basesEspEnabled then
        connections.basesEsp = spawn(function()
            while basesEspEnabled do
                basesEspLoop()
                wait(3) -- Update every 3 seconds
            end
        end)
        print("🏠 Bases ESP ON!")
    else
        clearEsp()
        print("🏠 Bases ESP OFF")
    end
    updateStatus()
end)

closeButton.MouseButton1Click:Connect(function()
    togglePanel()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        togglePanel()
    end
end)

-- Initialize
player.CharacterAdded:Connect(saveSpawnPosition)
if player.Character then
    spawn(saveSpawnPosition)
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

-- Initialize status
updateStatus()

print("🎮 STEAL A BRAINROT HACK v5 LOADED!")
print("🚀 Smart Teleport - Espera a agarrar brainrot antes de teleportarse")
print("🎯 Optimized Aimbot - Dispara a brainrots cercanos sin lag")  
print("🏠 Efficient ESP - Actualiza cada 3 segundos")
print("⌨️ Presiona F para abrir/cerrar")
print("🔥 ¡SIN LAG - OPTIMIZADO!")
