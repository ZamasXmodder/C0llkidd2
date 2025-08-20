-- Steal a Brainrot Server Finder Script

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealBrainrotFinder"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Floating Button
local floatingButton = Instance.new("TextButton")
floatingButton.Name = "FloatingButton"
floatingButton.Size = UDim2.new(0, 80, 0, 80)
floatingButton.Position = UDim2.new(1, -100, 0.5, -40)
floatingButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
floatingButton.BorderSizePixel = 0
floatingButton.Text = "🧠"
floatingButton.TextSize = 32
floatingButton.Font = Enum.Font.SourceSansBold
floatingButton.TextColor3 = Color3.new(1, 1, 1)
floatingButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5, 0)
corner.Parent = floatingButton

-- Main Panel
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 450, 0, 500)
mainPanel.Position = UDim2.new(0.5, -225, 0.5, -250)
mainPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = mainPanel

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
header.BorderSizePixel = 0
header.Parent = mainPanel

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(0.8, 0, 1, 0)
headerTitle.Position = UDim2.new(0.1, 0, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "🧠 STEAL A BRAINROT FINDER"
headerTitle.TextSize = 18
headerTitle.Font = Enum.Font.SourceSansBold
headerTitle.TextColor3 = Color3.new(1, 1, 1)
headerTitle.Parent = header

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextSize = 20
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0, 70)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusLabel.BorderSizePixel = 0
statusLabel.Text = "🎯 Select a brainrot to hunt"
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Parent = mainPanel

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- ESP System
local espConnections = {}
local espFolder = Instance.new("Folder")
espFolder.Name = "BrainrotESP"
espFolder.Parent = workspace

local function createESP(part, brainrotName, color)
    -- Remove existing ESP for this part
    for _, child in pairs(espFolder:GetChildren()) do
        if child.Name == "ESP_" .. part.Name then
            child:Destroy()
        end
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_" .. part.Name
    billboardGui.Adornee = part
    billboardGui.Size = UDim2.new(0, 300, 0, 80)
    billboardGui.StudsOffset = Vector3.new(0, 8, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = espFolder
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.new(1, 1, 1)
    frame.Parent = billboardGui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "🎯 " .. brainrotName .. " 🎯"
    textLabel.TextSize = 20
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Parent = frame
    
    -- Pulsing animation
    spawn(function()
        while billboardGui.Parent do
            for i = 1, 10 do
                frame.BackgroundTransparency = 0.1 + (i * 0.05)
                wait(0.1)
            end
            for i = 10, 1, -1 do
                frame.BackgroundTransparency = 0.1 + (i * 0.05)
                wait(0.1)
            end
        end
    end)
    
    -- Distance updater
    local connection = RunService.Heartbeat:Connect(function()
        if part.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - part.Position).Magnitude
            textLabel.Text = "🎯 " .. brainrotName .. " 🎯\n[" .. math.floor(distance) .. " studs]"
        end
    end)
    
    table.insert(espConnections, connection)
    return billboardGui
end

local function clearESP()
    for _, connection in pairs(espConnections) do
        connection:Disconnect()
    end
    espConnections = {}
    espFolder:ClearAllChildren()
end

-- Brainrot search function for Steal a Brainrot game
local function findBrainrotInGame(brainrotName, searchTerms, color)
    clearESP()
    statusLabel.Text = "🔍 Hunting " .. brainrotName .. "..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local found = false
    local foundCount = 0
    
    -- Search in workspace for brainrot items
    local function searchArea(container, areaName)
        for _, obj in pairs(container:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                local objName = obj.Name:lower()
                
                for _, searchTerm in pairs(searchTerms) do
                    if objName:find(searchTerm:lower()) or objName == searchTerm:lower() then
                        found = true
                        foundCount = foundCount + 1
                        
                        -- Create ESP
                        createESP(obj, brainrotName, color)
                        
                        -- Teleport to first found item
                        if foundCount == 1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local teleportPos = obj.CFrame + Vector3.new(0, 10, 0)
                            player.Character.HumanoidRootPart.CFrame = teleportPos
                            
                            -- Success notification
                            statusLabel.Text = "✅ Found " .. brainrotName .. " in " .. areaName .. "!"
                            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                            
                            -- Play sound
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
                            sound.Volume = 0.8
                            sound.Parent = workspace
                            sound:Play()
                            sound.Ended:Connect(function() sound:Destroy() end)
                        end
                        
                        print("🎯 Found " .. brainrotName .. " at: " .. obj:GetFullName())
                        break
                    end
                end
            end
        end
    end
    
    -- Search in different areas
    searchArea(workspace, "Workspace")
    
    -- Also check ReplicatedStorage for any brainrot data
    if game.ReplicatedStorage then
        searchArea(game.ReplicatedStorage, "ReplicatedStorage")
    end
    
    if found then
        statusLabel.Text = "✅ Found " .. foundCount .. "x " .. brainrotName .. "!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        statusLabel.Text = "❌ " .. brainrotName .. " not in this server"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Try server hopping after 3 seconds
        wait(3)
        statusLabel.Text = "🌐 Searching new server..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        
        pcall(function()
            TeleportService:Teleport(game.PlaceId, player)
        end)
    end
end

-- Brainrot data for Steal a Brainrot game
local brainrots = {
    {
        name = "La Grande Combinacion",
        icon = "🏆",
        color = Color3.fromRGB(255, 215, 0),
        searchTerms = {"grande", "combinacion", "lagrandecombinacion", "la grande combinacion"}
    },
    {
        name = "Graipussi Medussi",
        icon = "🍇",
        color = Color3.fromRGB(138, 43, 226),
        searchTerms = {"graipussi", "medussi", "graipussimedussi", "graipussi medussi"}
    },
    {
                name = "La Vaca Saturno Saturnita",
        icon = "🐄",
        color = Color3.fromRGB(255, 105, 180),
        searchTerms = {"vaca", "saturno", "saturnita", "lavacasaturnosaturnita", "la vaca saturno saturnita"}
    },
    {
        name = "Garama And Madundung",
        icon = "⚡💎",
        color = Color3.fromRGB(255, 69, 0),
        searchTerms = {"garama", "madundung", "garamaandmadundung", "garama and madundung"}
    },
    {
        name = "Tung Tung Tung Sahur",
        icon = "🔔",
        color = Color3.fromRGB(50, 205, 50),
        searchTerms = {"tung", "sahur", "tungtungtungsahur", "tung tung tung sahur", "tungtung"}
    }
}

-- Create brainrot buttons
local function createBrainrotButton(brainrotData, yPosition)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 55)
    button.Position = UDim2.new(0.05, 0, 0, yPosition)
    button.BackgroundColor3 = brainrotData.color
    button.BorderSizePixel = 0
    button.Text = brainrotData.icon .. " " .. brainrotData.name
    button.TextSize = 16
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextStrokeTransparency = 0
    button.Parent = mainPanel
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 12)
    buttonCorner.Parent = button
    
    -- Gradient effect
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, brainrotData.color),
        ColorSequenceKeypoint.new(1, Color3.new(
            brainrotData.color.R * 0.6,
            brainrotData.color.G * 0.6,
            brainrotData.color.B * 0.6
        ))
    }
    gradient.Rotation = 45
    gradient.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(0.92, 0, 0, 58),
            BackgroundTransparency = 0.1
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(0.9, 0, 0, 55),
            BackgroundTransparency = 0
        }):Play()
    end)
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        -- Click animation
        local clickTween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(0.88, 0, 0, 52)
        })
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {
                Size = UDim2.new(0.9, 0, 0, 55)
            }):Play()
        end)
        
        -- Start hunting
        findBrainrotInGame(brainrotData.name, brainrotData.searchTerms, brainrotData.color)
    end)
end

-- Create all buttons
for i, brainrotData in ipairs(brainrots) do
    createBrainrotButton(brainrotData, 110 + (i - 1) * 70)
end

-- Server hop button
local serverHopButton = Instance.new("TextButton")
serverHopButton.Size = UDim2.new(0.9, 0, 0, 45)
serverHopButton.Position = UDim2.new(0.05, 0, 0, 460)
serverHopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
serverHopButton.BorderSizePixel = 0
serverHopButton.Text = "🌐 Server Hop"
serverHopButton.TextSize = 16
serverHopButton.Font = Enum.Font.SourceSansBold
serverHopButton.TextColor3 = Color3.new(1, 1, 1)
serverHopButton.Parent = mainPanel

local hopCorner = Instance.new("UICorner")
hopCorner.CornerRadius = UDim.new(0, 10)
hopCorner.Parent = serverHopButton

serverHopButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "🌐 Hopping to new server..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    
    pcall(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)
end)

-- Panel animations
local function openPanel()
    mainPanel.Visible = true
    mainPanel.Size = UDim2.new(0, 0, 0, 0)
    mainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(mainPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 450, 0, 520),
        Position = UDim2.new(0.5, -225, 0.5, -260)
    }):Play()
end

local function closePanel()
    local closeTween = TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    
    closeTween.Completed:Connect(function()
        mainPanel.Visible = false
    end)
end

-- Button events
floatingButton.MouseButton1Click:Connect(function()
    if mainPanel.Visible then
        closePanel()
    else
        openPanel()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    closePanel()
end)

-- Draggable floating button
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart = nil
local startPos = nil

floatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = floatingButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        floatingButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Auto-scan on join
spawn(function()
    wait(3)
    statusLabel.Text = "🎮 Ready to hunt brainrots!"
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    
    -- Quick scan to see what's available
    local itemsFound = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            for _, brainrot in pairs(brainrots) do
                for _, term in pairs(brainrot.searchTerms) do
                    if name:find(term:lower()) then
                        table.insert(itemsFound, brainrot.name)
                        break
                    end
                end
            end
        end
    end
    
    if #itemsFound > 0 then
        statusLabel.Text = "🎯 Found: " .. table.concat(itemsFound, ", ")
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end)

-- Floating button pulse
spawn(function()
    while true do
        TweenService:Create(floatingButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 85, 0, 85)
        }):Play()
        wait(1)
        TweenService:Create(floatingButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 80, 0, 80)
        }):Play()
        wait(1)
    end
end)

print("🧠 Steal a Brainrot Finder Loaded!")
print("🎯 Available brainrots to hunt:")
for _, brainrot in pairs(brainrots) do
    print("  " .. brainrot.icon .. " " .. brainrot.name)
end
print("🚀 Click the pink floating button to start hunting!")
