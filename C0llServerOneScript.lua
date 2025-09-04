-- Steal a Brainrot Hack v5 (Fixed for SpiderSammy’s game)
-- Executor only (Synapse, KRNL, etc.)
-- Made clean by blo & gpt 😎🔥

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

-- Functions
local function updateStatus()
    local status = string.format([[📊 HACK STATUS:

🚀 Smart TP: %s
🎯 Aimbot: %s  
🏠 Bases ESP: %s

📍 Spawn Saved: %s
🧠 Brainrot in Hand: %s

⌨️ Keys:
• [F] Open/Close Panel
• [V] Teleport to Base (if brainrot)]], 
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
        task.wait(2)
        playerSpawnPosition = character.HumanoidRootPart.CFrame
        print("🏠 Spawn position saved!")
        updateStatus()
    end
end

local function checkIfHasBrainrot()
    local character = player.Character
    if not character then return false end
    -- detect Billboard "STOLEN" above player (game mechanic)
    local head = character:FindFirstChild("Head")
    if head then
        for _, gui in pairs(head:GetChildren()) do
            if gui:IsA("BillboardGui") and gui:FindFirstChildOfClass("TextLabel") then
                local txt = gui:FindFirstChildOfClass("TextLabel").Text:lower()
                if txt:find("stolen") then
                    return true
                end
            end
        end
    end
    return false
end

local function smartTeleport()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") and playerSpawnPosition then
        if hasBrainrotInHand then
            character.HumanoidRootPart.CFrame = playerSpawnPosition
            print("🚀 Teleported back to base with brainrot!")
            hasBrainrotInHand = false
        end
    end
end

-- Loops
local function smartTpLoop()
    if not smartTPEnabled then return end
    hasBrainrotInHand = checkIfHasBrainrot()
    if hasBrainrotInHand then
        smartTeleport()
    end
    updateStatus()
end

-- Connections
smartTpButton.MouseButton1Click:Connect(function()
    smartTPEnabled = not smartTPEnabled
    smartTpButton.Text = "🚀 SMART TELEPORT: " .. (smartTPEnabled and "ON" or "OFF")
    if smartTPEnabled then
        connections.smartTp = RunService.Heartbeat:Connect(smartTpLoop)
    else
        if connections.smartTp then connections.smartTp:Disconnect() end
    end
    updateStatus()
end)

closeButton.MouseButton1Click:Connect(function()
    panelOpen = false
    mainFrame.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        panelOpen = not panelOpen
        mainFrame.Visible = panelOpen
    elseif input.KeyCode == Enum.KeyCode.V then
        smartTeleport()
    end
end)

-- Init
player.CharacterAdded:Connect(saveSpawnPosition)
if player.Character then
    task.spawn(saveSpawnPosition)
end

updateStatus()
print("✅ Steal a Brainrot Hack v5 Loaded (Fixed for SpiderSammy)")
