-- Instant Chilli v2 Panel for Steal a Brainrot - Fixed Version

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

-- Configuración
local PREFERRED_TOOL_NAME = "Laser" -- Cambia esto por el nombre exacto de tu tool
local DETECTION_RANGE = 50 -- Rango para detectar jugadores

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
aimbotButton.Text = "Aimbot: OFF"
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

local function getSpawnPosition()
    -- Buscar el punto de spawn del jugador
    local spawnLocation = workspace:FindFirstChild("SpawnLocation")
    if spawnLocation then
        return spawnLocation.Position + Vector3.new(0, 5, 0)
    end
    
    -- Buscar spawns alternativos
    local spawns = workspace:FindFirstChild("Spawns")
    if spawns then
        local playerSpawn = spawns:FindFirstChild(player.Name) or spawns:GetChildren()[1]
        if playerSpawn then
            return playerSpawn.Position + Vector3.new(0, 5, 0)
        end
    end
    
    -- Posición por defecto del spawn
    return Vector3.new(0, 50, 0)
end

local function hasBrainrotInHand()
    local character = player.Character
    if not character then return false end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and (tool.Name:lower():find("brainrot") or tool.Name:lower():find("brain")) then
        return true
    end
    
    return false
end

local function instantTeleport()
    if not instantTeleportEnabled then return end
    if not hasBrainrotInHand() then return end
    
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local spawnPosition = getSpawnPosition()
        character.HumanoidRootPart.CFrame = CFrame.new(spawnPosition)
    end
end

local function getNearbyPlayers(range)
    local nearbyPlayers = {}
    local character = player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nearbyPlayers
    end
    
    local playerPosition = character.HumanoidRootPart.Position
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (otherPlayer.Character.HumanoidRootPart.Position - playerPosition).Magnitude
            if distance <= range then
                table.insert(nearbyPlayers, otherPlayer)
            end
        end
    end
    
    return nearbyPlayers
end

local function equipPreferredTool()
    local character = player.Character
    if not character then return end
    
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    -- Buscar la tool preferida en el backpack
    local preferredTool = backpack:FindFirstChild(PREFERRED_TOOL_NAME)
    if preferredTool then
        character.Humanoid:EquipTool(preferredTool)
        return true
    end
    
    return false
end

local function hasPreferredToolEquipped()
    local character = player.Character
    if not character then return false end
    
    local equippedTool = character:FindFirstChild(PREFERRED_TOOL_NAME)
    return equippedTool ~= nil
end

local function autoEquipTool()
    local nearbyPlayers = getNearbyPlayers(DETECTION_RANGE)
    
    if #nearbyPlayers > 0 then
        -- Hay jugadores cerca, asegurar que tenemos la tool equipada
        if not hasPreferredToolEquipped() then
            equipPreferredTool()
        end
    end
end

local function fireLaser(targetPlayer)
    local character = player.Character
    if not character then return end
    
    local tool = character:FindFirstChild(PREFERRED_TOOL_NAME)
    if not tool then return end
    
    -- Buscar RemoteEvent o función de disparo en la tool
    local remoteEvent = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot")
    if remoteEvent and remoteEvent:IsA("RemoteEvent") then
        remoteEvent:FireServer(targetPlayer.Character.HumanoidRootPart)
    end
    
    -- Método alternativo: activar la tool
    if tool:FindFirstChild("Handle") then
        tool:Activate()
    end
end

local function aimbotLoop()
    if not aimbotEnabled then return end
    
    local nearbyPlayers = getNearbyPlayers(DETECTION_RANGE)
    
    for _, targetPlayer in pairs(nearbyPlayers) do
        fireLaser(targetPlayer)
    end
end

-- Event Connections
teleportButton.MouseButton1Click:Connect(function()
    instantTeleportEnabled = not instantTeleportEnabled
    teleportButton.Text = "Instant Teleport: " .. (instantTeleportEnabled and "ON" or "OFF")
    teleportButton.BackgroundColor3 = instantTeleportEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(70, 70, 70)
end)

aimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotButton.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
    aimbotButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(150, 50, 50) or Color3.fromRGB(70, 70, 70)
    
    if aimbotEnabled then
        aimbotConnection = RunService.Heartbeat:Connect(aimbotLoop)
        autoEquipConnection = RunService.Heartbeat:Connect(autoEquipTool)
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

-- Monitor for brainrot in hand for instant teleport
RunService.Heartbeat:Connect(function()
    if instantTeleportEnabled and hasBrainrotInHand() then
        wait(0.1)
        instantTeleport()
    end
end)

print("Instant Chilli v2 Fixed loaded! Press F to open panel.")
print("Make sure to change PREFERRED_TOOL_NAME to your exact tool name!")
