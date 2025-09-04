-- Air Walk Panel Script for Roblox
-- Press F to toggle panel, click "Generate Floor" to create invisible floor under player

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local panel = nil
local isOpen = false
local airWalkEnabled = false
local floorPart = nil
local connection = nil

-- Create the GUI Panel
local function createPanel()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AirWalkPanel"
    screenGui.Parent = playerGui
    
    -- Main Frame (Panel)
    local frame = Instance.new("Frame")
    frame.Name = "MainPanel"
    frame.Size = UDim2.new(0, 250, 0, 150)
    frame.Position = UDim2.new(0.5, -125, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Air Walk Panel"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame
    
    -- Generate Floor Button
    local generateButton = Instance.new("TextButton")
    generateButton.Name = "GenerateButton"
    generateButton.Size = UDim2.new(0.8, 0, 0, 50)
    generateButton.Position = UDim2.new(0.1, 0, 0.4, 0)
    generateButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    generateButton.Text = "Generate Floor"
    generateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    generateButton.TextScaled = true
    generateButton.Font = Enum.Font.SourceSans
    generateButton.Parent = frame
    
    -- Button corner radius
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = generateButton
    
    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.Position = UDim2.new(0, 0, 0.75, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Disabled"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Parent = frame
    
    return screenGui, frame, generateButton, statusLabel
end

-- Create invisible floor under player
local function createFloor()
    if floorPart then
        floorPart:Destroy()
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local rootPart = character.HumanoidRootPart
    
    -- Create invisible part
    floorPart = Instance.new("Part")
    floorPart.Name = "AirWalkFloor"
    floorPart.Size = Vector3.new(10, 1, 10)
    floorPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
    floorPart.Anchored = true
    floorPart.CanCollide = true
    floorPart.Transparency = 1 -- Invisible
    floorPart.Material = Enum.Material.ForceField
    floorPart.Parent = workspace
    
    return floorPart
end

-- Update floor position to follow player
local function updateFloorPosition()
    if not airWalkEnabled or not floorPart then
        return
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local rootPart = character.HumanoidRootPart
    floorPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
end

-- Toggle air walk
local function toggleAirWalk(statusLabel)
    if airWalkEnabled then
        -- Disable air walk
        airWalkEnabled = false
        if floorPart then
            floorPart:Destroy()
            floorPart = nil
        end
        if connection then
            connection:Disconnect()
            connection = nil
        end
        statusLabel.Text = "Status: Disabled"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        -- Enable air walk
        airWalkEnabled = true
        createFloor()
        connection = RunService.Heartbeat:Connect(updateFloorPosition)
        statusLabel.Text = "Status: Enabled"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end

-- Toggle panel visibility
local function togglePanel()
    if panel then
        isOpen = not isOpen
        panel.Visible = isOpen
    end
end

-- Initialize
local function initialize()
    local screenGui, frame, generateButton, statusLabel = createPanel()
    panel = frame
    
    -- Connect button click
    generateButton.MouseButton1Click:Connect(function()
        toggleAirWalk(statusLabel)
    end)
    
    -- Connect F key press
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F then
            togglePanel()
        end
    end)
end

-- Clean up when player leaves
player.CharacterRemoving:Connect(function()
    if floorPart then
        floorPart:Destroy()
        floorPart = nil
    end
    if connection then
        connection:Disconnect()
        connection = nil
    end
end)

-- Start the script
initialize()

print("Air Walk Panel loaded! Press F to toggle panel.")
