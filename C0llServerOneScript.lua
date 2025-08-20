-- Advanced Brainrot Server Finder Script for Roblox

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotServerFinder"
screenGui.Parent = playerGui

-- Floating Button
local floatingButton = Instance.new("TextButton")
floatingButton.Name = "FloatingButton"
floatingButton.Size = UDim2.new(0, 70, 0, 70)
floatingButton.Position = UDim2.new(1, -90, 0.5, -35)
floatingButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
floatingButton.BorderSizePixel = 0
floatingButton.Text = "🧠"
floatingButton.TextSize = 28
floatingButton.Font = Enum.Font.SourceSansBold
floatingButton.TextColor3 = Color3.new(1, 1, 1)
floatingButton.Parent = screenGui

-- Make button round with glow
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5, 0)
corner.Parent = floatingButton

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
}
gradient.Rotation = 45
gradient.Parent = floatingButton

-- Main Panel
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 400, 0, 450)
mainPanel.Position = UDim2.new(0.5, -200, 0.5, -225)
mainPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = mainPanel

-- Panel Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
header.BorderSizePixel = 0
header.Parent = mainPanel

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(0.8, 0, 1, 0)
headerTitle.Position = UDim2.new(0.1, 0, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "🧠 BRAINROT SERVER FINDER"
headerTitle.TextSize = 18
headerTitle.Font = Enum.Font.SourceSansBold
headerTitle.TextColor3 = Color3.new(1, 1, 1)
headerTitle.TextStrokeTransparency = 0
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
statusLabel.Text = "🎯 Select a brainrot to find servers"
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextStrokeTransparency = 0
statusLabel.Parent = mainPanel

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- Brainrot Options (CORREGIDO)
local brainrotData = {
    {
        name = "La Grande Combinacion",
        icon = "🏆",
        color = Color3.fromRGB(255, 215, 0),
        searchNames = {"La Grande Combinacion", "la grande combinacion", "LA GRANDE COMBINACION", "LaGrandeCombinacion"}
    },
    {
        name = "Graipussi Medussi",
        icon = "🍇",
        color = Color3.fromRGB(128, 0, 128),
        searchNames = {"Graipussi Medussi", "graipussi medussi", "GRAIPUSSI MEDUSSI", "GraipussiMedussi"}
    },
    {
        name = "La Vaca Saturno Saturnita",
        icon = "🐄",
        color = Color3.fromRGB(255, 105, 180),
        searchNames = {"La Vaca Saturno Saturnita", "la vaca saturno saturnita", "LA VACA SATURNO SATURNITA", "LaVacaSaturnoSaturnita"}
    },
    {
        name = "Garama And Madundung",
        icon = "⚡💎",
        color = Color3.fromRGB(255, 69, 0),
        searchNames = {"Garama And Madundung", "garama and madundung", "GARAMA AND MADUNDUNG", "GaramaAndMadundung", "Garama and Madundung"}
    },
    {
        name = "Tung Tung Tung Sahur",
        icon = "🔔",
        color = Color3.fromRGB(50, 205, 50),
        searchNames = {"Tung Tung Tung Sahur", "tung tung tung sahur", "TUNG TUNG TUNG SAHUR", "TungTungTungSahur"}
    }
}

-- ESP System
local espConnections = {}
local espFolder = Instance.new("Folder")
espFolder.Name = "BrainrotESP"
espFolder.Parent = workspace

local function createESP(part, text, color)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_" .. part.Name
    billboardGui.Adornee = part
    billboardGui.Size = UDim2.new(0, 250, 0, 60)
    billboardGui.StudsOffset = Vector3.new(0, 5, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = espFolder
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = billboardGui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextSize = 18
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = frame
    
    -- Pulsing effect
    local pulseInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local pulseTween = TweenService:Create(frame, pulseInfo, {BackgroundTransparency = 0.5})
    pulseTween:Play()
    
    -- Distance updater
    local connection = RunService.Heartbeat:Connect(function()
        if part.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - part.Position).Magnitude
            textLabel.Text = text .. "\n[" .. math.floor(distance) .. " studs]"
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

-- Search Function
local function searchBrainrot(brainrotInfo)
    clearESP()
    statusLabel.Text = "🔍 Searching for " .. brainrotInfo.name .. "..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local found = false
    
    -- Search in current server first
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            for _, searchName in pairs(brainrotInfo.searchNames) do
                if obj.Name == searchName then
                    found = true
                    statusLabel.Text = "✅ " .. brainrotInfo.name .. " FOUND!"
                    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    
                    -- Create ESP
                    createESP(obj, brainrotInfo.icon .. " " .. brainrotInfo.name .. " " .. brainrotInfo.icon, brainrotInfo.color)
                    
                    -- Teleport to item
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 10, 0)
                    end
                    
                    -- Success sound
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
                    sound.Volume = 0.7
                    sound.Parent = workspace
                    sound:Play()
                    
                    return
                end
            end
            
            -- Check StringValues
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("StringValue") then
                    for _, searchName in pairs(brainrotInfo.searchNames) do
                        if child.Value == searchName then
                            found = true
                            statusLabel.Text = "✅ " .. brainrotInfo.name .. " FOUND!"
                            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                            createESP(obj, brainrotInfo.icon .. " " .. brainrotInfo.name .. " " .. brainrotInfo.icon, brainrotInfo.color)
                            
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                player.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 10, 0)
                            end
                            return
                        end
                    end
                end
            end
        end
    end
    
    if not found then
        statusLabel.Text = "🌐 Searching other servers..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        searchOtherServers(brainrotInfo)
    end
end

local function searchOtherServers(brainrotInfo)
    local gameId = game.PlaceId
    local attempts = 0
    local maxAttempts = 20
    
    spawn(function()
        while attempts < maxAttempts do
            attempts = attempts + 1
            statusLabel.Text = "🔄 Server " .. attempts .. "/" .. maxAttempts .. " - " .. brainrotInfo.name
            
            wait(2)
            
            -- Try teleporting to different server
            pcall(function()
                TeleportService:Teleport(gameId, player)
            end)
            
            wait(5)
            
            -- Quick scan in new server
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    for _, searchName in pairs(brainrotInfo.searchNames) do
                        if obj.Name == searchName then
                            statusLabel.Text = "✅ Found " .. brainrotInfo.name .. " in new server!"
                            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                            wait(1)
                            searchBrainrot(brainrotInfo)
                            return
                        end
                    end
                end
            end
        end
        
        statusLabel.Text = "❌ " .. brainrotInfo.name .. " not found. Try again later."
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end)
end

-- Create Brainrot Buttons
local function createBrainrotButton(brainrotInfo, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 50)
    button.Position = UDim2.new(0.05, 0, 0, position)
    button.BackgroundColor3 = brainrotInfo.color
    button.BorderSizePixel = 0
    button.Text = brainrotInfo.icon .. " " .. brainrotInfo.name
        button.TextSize = 16
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextStrokeTransparency = 0
    button.Parent = mainPanel
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    -- Button gradient
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, brainrotInfo.color),
        ColorSequenceKeypoint.new(1, Color3.new(
            brainrotInfo.color.R * 0.7,
            brainrotInfo.color.G * 0.7,
            brainrotInfo.color.B * 0.7
        ))
    }
    buttonGradient.Rotation = 45
    buttonGradient.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(0.92, 0, 0, 52),
            BackgroundTransparency = 0.1
        })
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(0.9, 0, 0, 50),
            BackgroundTransparency = 0
        })
        leaveTween:Play()
    end)
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        -- Button click animation
        local clickTween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(0.88, 0, 0, 48)
        })
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            local returnTween = TweenService:Create(button, TweenInfo.new(0.1), {
                Size = UDim2.new(0.9, 0, 0, 50)
            })
            returnTween:Play()
        end)
        
        -- Start search
        searchBrainrot(brainrotInfo)
    end)
    
    return button
end

-- Create all brainrot buttons
for i, brainrotInfo in ipairs(brainrotData) do
    createBrainrotButton(brainrotInfo, 110 + (i - 1) * 60)
end

-- Panel Animation Functions
local function openPanel()
    mainPanel.Visible = true
    mainPanel.Size = UDim2.new(0, 0, 0, 0)
    mainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local openTween = TweenService:Create(mainPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 400, 0, 450),
        Position = UDim2.new(0.5, -200, 0.5, -225)
    })
    openTween:Play()
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

-- Button Events
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        floatingButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Auto-scan feature for testing
local function autoScanOnJoin()
    wait(3)
    statusLabel.Text = "🎮 Ready! Click any brainrot to search servers"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- Floating button pulse animation
spawn(function()
    while true do
        local pulseTween = TweenService:Create(floatingButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 75, 0, 75)
        })
        pulseTween:Play()
        
        pulseTween.Completed:Connect(function()
            local returnTween = TweenService:Create(floatingButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 70, 0, 70)
            })
            returnTween:Play()
        end)
        
        wait(2)
    end
end)

-- Initialize
spawn(autoScanOnJoin)

print("🧠 Advanced Brainrot Server Finder Loaded!")
print("📋 Available Brainrots:")
for _, brainrot in ipairs(brainrotData) do
    print("  " .. brainrot.icon .. " " .. brainrot.name)
end
print("🎯 Click the floating button to open the panel!")
