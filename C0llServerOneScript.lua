-- Fixed Advanced Brainrot Server Finder Script for Roblox

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

-- Debug Label
local debugLabel = Instance.new("TextLabel")
debugLabel.Size = UDim2.new(0.9, 0, 0, 20)
debugLabel.Position = UDim2.new(0.05, 0, 0, 105)
debugLabel.BackgroundTransparency = 1
debugLabel.Text = "Debug: Ready"
debugLabel.TextSize = 12
debugLabel.Font = Enum.Font.SourceSans
debugLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
debugLabel.Parent = mainPanel

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

-- Improved Search Function with better detection
local function searchBrainrot(brainrotName, searchTerms)
    clearESP()
    statusLabel.Text = "🔍 Searching for " .. brainrotName .. "..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    debugLabel.Text = "Debug: Scanning workspace..."
    
    local found = false
    local itemsFound = 0
    
    -- More comprehensive search
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- Check object name with multiple variations
            for _, searchTerm in pairs(searchTerms) do
                if obj.Name:lower():find(searchTerm:lower()) or obj.Name == searchTerm then
                    found = true
                    itemsFound = itemsFound + 1
                    
                    statusLabel.Text = "✅ " .. brainrotName .. " FOUND! (" .. itemsFound .. ")"
                    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    debugLabel.Text = "Debug: Found at " .. obj:GetFullName()
                    
                    -- Create ESP
                    local espText = "🎯 " .. brainrotName .. " 🎯"
                    if brainrotName == "Tung Tung Tung Sahur" then
                        createESP(obj, "🔔 " .. brainrotName .. " 🔔", Color3.fromRGB(50, 205, 50))
                    elseif brainrotName == "La Grande Combinacion" then
                        createESP(obj, "🏆 " .. brainrotName .. " 🏆", Color3.fromRGB(255, 215, 0))
                    else
                        createESP(obj, espText, Color3.fromRGB(255, 100, 100))
                    end
                    
                    -- Teleport to first found item
                    if itemsFound == 1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 10, 0)
                    end
                    
                    break
                end
            end
            
            -- Check all children for StringValues or other value objects
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("StringValue") or child:IsA("ObjectValue") then
                    for _, searchTerm in pairs(searchTerms) do
                        if tostring(child.Value):lower():find(searchTerm:lower()) then
                            found = true
                            itemsFound = itemsFound + 1
                            statusLabel.Text = "✅ " .. brainrotName .. " FOUND in StringValue!"
                            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                            createESP(obj, "🎯 " .. brainrotName .. " 🎯", Color3.fromRGB(255, 100, 100))
                            break
                        end
                    end
                end
            end
        end
    end
    
    if found then
        -- Play success sound
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
        sound.Volume = 0.7
        sound.Parent = workspace
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    else
        statusLabel.Text = "❌ " .. brainrotName .. " not found in current server"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        debugLabel.Text = "Debug: No matches found. Trying server hop..."
        
        -- Try server hopping
        wait(2)
        statusLabel.Text = "🌐 Attempting to find new server..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        
        pcall(function()
            TeleportService:Teleport(game.PlaceId, player)
        end)
    end
end

-- Brainrot data with comprehensive search terms
local brainrotOptions = {
    {
        name = "La Grande Combinacion",
        icon = "🏆",
        color = Color3.fromRGB(255, 215, 0),
                searchTerms = {"la grande combinacion", "grande combinacion", "combinacion", "lagrandecombinacion"}
    },
    {
        name = "Graipussi Medussi",
        icon = "🍇",
        color = Color3.fromRGB(128, 0, 128),
        searchTerms = {"graipussi medussi", "graipussi", "medussi", "graipussimedussi"}
    },
    {
        name = "La Vaca Saturno Saturnita",
        icon = "🐄",
        color = Color3.fromRGB(255, 105, 180),
        searchTerms = {"la vaca saturno saturnita", "vaca saturno", "saturnita", "lavacasaturnosaturnita"}
    },
    {
        name = "Garama And Madundung",
        icon = "⚡💎",
        color = Color3.fromRGB(255, 69, 0),
        searchTerms = {"garama and madundung", "garama", "madundung", "garamaandmadundung"}
    },
    {
        name = "Tung Tung Tung Sahur",
        icon = "🔔",
        color = Color3.fromRGB(50, 205, 50),
        searchTerms = {"tung tung tung sahur", "tung tung", "sahur", "tungtungtungsahur", "tung"}
    }
}

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
        debugLabel.Text = "Debug: Starting search for " .. brainrotInfo.name
        searchBrainrot(brainrotInfo.name, brainrotInfo.searchTerms)
    end)
    
    return button
end

-- Create all brainrot buttons
for i, brainrotInfo in ipairs(brainrotOptions) do
    createBrainrotButton(brainrotInfo, 130 + (i - 1) * 60)
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

-- Auto-scan all items on load for debugging
local function debugScanWorkspace()
    wait(2)
    debugLabel.Text = "Debug: Scanning all items..."
    
    local itemCount = 0
    local foundItems = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            itemCount = itemCount + 1
            local name = obj.Name:lower()
            
            -- Check for any brainrot-related terms
            if name:find("tung") or name:find("sahur") or name:find("grande") or name:find("combinacion") or 
               name:find("graipussi") or name:find("medussi") or name:find("vaca") or name:find("saturno") or
               name:find("garama") or name:find("madundung") then
                table.insert(foundItems, obj.Name .. " at " .. obj:GetFullName())
            end
        end
    end
    
    debugLabel.Text = "Debug: Scanned " .. itemCount .. " items. Found " .. #foundItems .. " potential matches"
    
    if #foundItems > 0 then
        print("🔍 POTENTIAL BRAINROT ITEMS FOUND:")
        for _, item in pairs(foundItems) do
            print("  - " .. item)
        end
    end
    
    statusLabel.Text = "🎮 Ready! Found " .. #foundItems .. " potential items"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- Initialize
spawn(debugScanWorkspace)

print("🧠 Fixed Brainrot Server Finder Loaded!")
print("🔧 Debug mode enabled - check console for item detection")
print("📋 Available Brainrots:")
for _, brainrot in ipairs(brainrotOptions) do
    print("  " .. brainrot.icon .. " " .. brainrot.name)
    print("    Search terms: " .. table.concat(brainrot.searchTerms, ", "))
end
print("🎯 Click the floating button to open the panel!")
