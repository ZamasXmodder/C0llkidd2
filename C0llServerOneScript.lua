-- Instant Chilli v2 Panel - Fixed Brainrot Detection & Clone Swap

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
local aimbotConnection = nil
local autoEquipConnection = nil
local teleportConnection = nil
local lastEquipTime = 0

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
screenGui.Name = "InstantChilliV2"
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.BorderSizePixel = 0
title.Text = "Instant Chilli v2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Instant Teleport Button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0.8, 0, 0, 35)
teleportButton.Position = UDim2.new(0.1, 0, 0, 60)
teleportButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportButton.BorderSizePixel = 0
teleportButton.Text = "Instant Teleport: OFF"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.Gotham
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 5)
teleportCorner.Parent = teleportButton

-- Aimbot Button
local aimbotButton = Instance.new("TextButton")
aimbotButton.Name = "AimbotButton"
aimbotButton.Size = UDim2.new(0.8, 0, 0, 35)
aimbotButton.Position = UDim2.new(0.1, 0, 0, 110)
aimbotButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
aimbotButton.BorderSizePixel = 0
aimbotButton.Text = "Unlimited Aimbot: OFF"
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.TextScaled = true
aimbotButton.Font = Enum.Font.Gotham
aimbotButton.Parent = mainFrame

local aimbotCorner = Instance.new("UICorner")
aimbotCorner.CornerRadius = UDim.new(0, 5)
aimbotCorner.Parent = aimbotButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Functions
local function togglePanel()
    panelOpen = not panelOpen
    mainFrame.Visible = panelOpen
    
    if panelOpen then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Visible = true
        
        local tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 300, 0, 200)}
        )
        tween:Play()
    end
end

local function findSpawnPosition()
    local character = player.Character
    if not character then return Vector3.new(0, 50, 0) end
    
    -- Buscar múltiples tipos de spawn
    local spawnLocations = {
        workspace:FindFirstChild("SpawnLocation"),
        workspace:FindFirstChild("Spawn"),
        workspace:FindFirstChild("PlayerSpawn")
    }
    
    for _, spawn in pairs(spawnLocations) do
        if spawn then
            return spawn.Position + Vector3.new(0, 5, 0)
        end
    end
    
    -- Buscar en carpetas de spawns
    local spawnFolders = {
        workspace:FindFirstChild("Spawns"),
        workspace:FindFirstChild("PlayerSpawns"),
        workspace:FindFirstChild("Bases")
    }
    
    for _, folder in pairs(spawnFolders) do
        if folder then
            local playerSpawn = folder:FindFirstChild(player.Name)
            if playerSpawn then
                return playerSpawn.Position + Vector3.new(0, 5, 0)
            end
            
            -- Si no encuentra por nombre, usar el primero disponible
            local firstSpawn = folder:GetChildren()[1]
            if firstSpawn then
                return firstSpawn.Position + Vector3.new(0, 5, 0)
            end
        end
    end
    
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
    
    -- Método 4: Verificar por GUI activa
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui.Name:lower():find("brainrot") or gui.Name:lower():find("stolen") then
                return true
            end
        end
    end
    
    return false
end

local function instantTeleport()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local spawnPosition = findSpawnPosition()
        character.HumanoidRootPart.CFrame = CFrame.new(spawnPosition)
        print("Teleported to spawn with brainrot!")
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
    -- Evitar equipar muy frecuentemente para no interferir con "Cambia con clon"
    if currentTime - lastEquipTime < 1 then
        return false
    end
    
    local tool, isEquipped = findQuantumCloner()
    
    if tool and not isEquipped then
        character.Humanoid:EquipTool(tool)
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
    
    local target = targetPlayer.Character.HumanoidRootPart
    
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
    
    -- Solo equipar si no tenemos el clonador y hay jugadores
    if #allPlayers > 0 and not hasQuantumClonerEquipped() then
        equipQuantumCloner()
    end
    
    -- Disparar a todos los jugadores
    for _, targetPlayer in pairs(allPlayers) do
        fireQuantumCloner(targetPlayer)
    end
end

local function smartAutoEquip()
    local allPlayers = getAllPlayers()
    
    -- Solo auto-equipar si hay jugadores cerca Y no tenemos el clonador equipado
    if #allPlayers > 0 and not hasQuantumClonerEquipped() then
        local currentTime = tick()
        if currentTime - lastEquipTime >= 2 then -- Cooldown más largo
            equipQuantumCloner()
        end
    end
end

local function teleportLoop()
    if instantTeleportEnabled and hasBrainrotActive() then
        instantTeleport()
        wait(1) -- Cooldown más largo para evitar spam
    end
end

-- Event Connections
teleportButton.MouseButton1Click:Connect(function()
    instantTeleportEnabled = not instantTeleportEnabled
    teleportButton.Text = "Instant Teleport: " .. (instantTeleportEnabled and "ON" or "OFF")
    teleportButton.BackgroundColor3 = instantTeleportEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(70, 70, 70)
    
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
    aimbotButton.Text = "Unlimited Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
    aimbotButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(150, 50, 50) or Color3.fromRGB(70, 70, 70)
    
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

closeButton.MouseButton1Click:Connect(function()
    panelOpen = false
    local tween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In),
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

-- Debug function to help identify brainrot state
spawn(function()
    while true do
        wait(2)
        if hasBrainrotActive() then
            print("Brainrot detected! Character is purple/stolen")
        end
    end
end)

print("Instant Chilli v2 Fixed loaded!")
print("Features:")
print("- Detects brainrot by character color (purple)")
print("- Smart auto-equip (doesn't interfere with clone swap)")
print("- Unlimited aimbot with proper cooldowns")
print("- Instant teleport when brainrot is active")
print("Press F to open panel")
