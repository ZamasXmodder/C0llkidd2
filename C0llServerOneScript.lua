-- Steal a Brainrot - Multi-Server Finder

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealBrainrotHopper"
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
mainPanel.Size = UDim2.new(0, 450, 0, 550)
mainPanel.Position = UDim2.new(0.5, -225, 0.5, -275)
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
headerTitle.Text = "🧠 BRAINROT SERVER HOPPER"
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
statusLabel.Size = UDim2.new(0.9, 0, 0, 35)
statusLabel.Position = UDim2.new(0.05, 0, 0, 70)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusLabel.BorderSizePixel = 0
statusLabel.Text = "🎯 Select a brainrot to hunt across servers"
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Parent = mainPanel

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- Progress Label
local progressLabel = Instance.new("TextLabel")
progressLabel.Size = UDim2.new(0.9, 0, 0, 25)
progressLabel.Position = UDim2.new(0.05, 0, 0, 110)
progressLabel.BackgroundTransparency = 1
progressLabel.Text = "Ready to search"
progressLabel.TextSize = 12
progressLabel.Font = Enum.Font.SourceSans
progressLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
progressLabel.Parent = mainPanel

-- Global variables for server hopping
local isSearching = false
local targetBrainrot = nil
local serversChecked = 0
local maxServers = 50

-- ESP System
local espConnections = {}
local espFolder = Instance.new("Folder")
espFolder.Name = "BrainrotESP"
espFolder.Parent = workspace

local function createESP(part, brainrotName, color)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_" .. part.Name
    billboardGui.Adornee = part
    billboardGui.Size = UDim2.new(0, 300, 0, 100)
    billboardGui.StudsOffset = Vector3.new(0, 10, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = espFolder
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.new(1, 1, 1)
    frame.Parent = billboardGui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 15)
    frameCorner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "🎯 " .. brainrotName .. " FOUND! 🎯"
    textLabel.TextSize = 22
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Parent = frame
    
    -- Rainbow pulsing effect
    spawn(function()
        while billboardGui.Parent do
            for i = 1, 20 do
                frame.BackgroundTransparency = 0.1 + (math.sin(i * 0.3) * 0.3)
                frame.BorderColor3 = Color3.fromHSV((tick() * 2) % 1, 1, 1)
                wait(0.1)
            end
        end
    end)
    
    return billboardGui
end

local function clearESP()
    for _, connection in pairs(espConnections) do
        connection:Disconnect()
    end
    espConnections = {}
    espFolder:ClearAllChildren()
end

-- Comprehensive brainrot search function
local function scanCurrentServer(brainrotData)
    local found = false
    local foundItems = {}
    
    -- Search all possible locations where brainrots might spawn
    local searchAreas = {
        workspace,
        workspace:FindFirstChild("Map"),
        workspace:FindFirstChild("Items"),
        workspace:FindFirstChild("Brainrots"),
        workspace:FindFirstChild("Spawns")
    }
    
    for _, area in pairs(searchAreas) do
        if area then
            for _, obj in pairs(area:GetDescendants()) do
                if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Model") then
                    local objName = obj.Name:lower()
                    
                    -- Check all search terms
                    for _, searchTerm in pairs(brainrotData.searchTerms) do
                        if objName:find(searchTerm:lower()) or objName == searchTerm:lower() then
                            found = true
                            table.insert(foundItems, obj)
                            
                            -- Create ESP
                            createESP(obj, brainrotData.name, brainrotData.color)
                            
                            print("🎯 FOUND: " .. brainrotData.name .. " at " .. obj:GetFullName())
                            break
                        end
                    end
                    
                    -- Also check if the object has any StringValues or other identifiers
                    for _, child in pairs(obj:GetChildren()) do
                        if child:IsA("StringValue") or child:IsA("ObjectValue") then
                            for _, searchTerm in pairs(brainrotData.searchTerms) do
                                if tostring(child.Value):lower():find(searchTerm:lower()) then
                                    found = true
                                    table.insert(foundItems, obj)
                                    createESP(obj, brainrotData.name, brainrotData.color)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return found, foundItems
end

-- Server hopping function
local function hopToNextServer()
    serversChecked = serversChecked + 1
    progressLabel.Text = "Servers checked: " .. serversChecked .. "/" .. maxServers
    
    if serversChecked >= maxServers then
        statusLabel.Text = "❌ Searched " .. maxServers .. " servers. Try again later."
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        isSearching = false
        return
    end
    
    statusLabel.Text = "🌐 Hopping to server " .. (serversChecked + 1) .. "..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    
    wait(1)
    
    pcall(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)
end

-- Main search function
local function startBrainrotHunt(brainrotData)
    if isSearching then
        statusLabel.Text = "⚠️ Already searching! Please wait..."
        return
    end
    
    isSearching = true
    targetBrainrot = brainrotData
    clearESP()
    
    statusLabel.Text = "🔍 Scanning current server for " .. brainrotData.name .. "..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    -- Quick scan of current server
    local found, foundItems = scanCurrentServer(brainrotData)
    
    if found and #foundItems > 0 then
        -- SUCCESS! Found in current server
        statusLabel.Text = "✅ " .. brainrotData.name .. " FOUND! (" .. #foundItems .. " items)"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        progressLabel.Text = "Success! Found in current server"
        
        -- Teleport to first item
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local teleportPos = foundItems[1].CFrame + Vector3.new(0, 10, 0)
            player.Character.HumanoidRootPart.CFrame = teleportPos
        end
        
        -- Play success sound
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
        sound.Volume = 1
        sound.Parent = workspace
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
        
        isSearching = false
    else
        -- Not found, start server hopping
        statusLabel.Text = "🌐 " .. brainrotData.name .. " not here. Starting server hop..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        progressLabel.Text = "Starting multi-server search..."
        
        wait(2)
        hopToNextServer()
    end
end

-- Auto-scan when joining new server (for server hopping)
spawn(function()
    wait(5) -- Wait for server to fully load
    
    if isSearching and targetBrainrot then
        -- We're in a new server, scan for target brainrot
        local found, foundItems = scanCurrentServer(targetBrainrot)
        
        if found and #foundItems > 0 then
            -- SUCCESS!
            statusLabel.Text = "✅ " .. targetBrainrot.name .. " FOUND! Server " .. serversChecked
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            progressLabel.Text = "SUCCESS! Found after " .. serversChecked .. " servers"
            
            -- Teleport to item
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                wait(1)
                local teleportPos = foundItems[1].CFrame + Vector3.new(0, 10, 0)
                player.Character.HumanoidRootPart.CFrame = teleportPos
            end
            
            -- Success sound
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
            sound.Volume = 1
            sound.Parent = workspace
            sound:Play()
            
            isSearching = false
        else
            -- Not found, continue hopping
            wait(3)
            if isSearching then
                hopToNextServer()
            end
        end
    else
        -- Normal join, just show ready status
        statusLabel.Text = "🎮 Ready to hunt brainrots!"
        progressLabel.Text = "Select a brainrot to start hunting"
    end
end)

-- Brainrot data

local brainrots = {
    {
        name = "La Grande Combinacion",
        icon = "🏆",
        color = Color3.fromRGB(255, 215, 0),
        searchTerms = {"grande", "combinacion", "lagrandecombinacion", "la grande combinacion", "Grande", "Combinacion"}
    },
    {
        name = "Graipussi Medussi",
        icon = "🍇",
        color = Color3.fromRGB(138, 43, 226),
        searchTerms = {"graipussi", "medussi", "graipussimedussi", "graipussi medussi", "Graipussi", "Medussi"}
    },
    {
        name = "La Vaca Saturno Saturnita",
        icon = "🐄",
        color = Color3.fromRGB(255, 105, 180),
        searchTerms = {"vaca", "saturno", "saturnita", "lavacasaturnosaturnita", "la vaca saturno saturnita", "Vaca", "Saturno", "Saturnita"}
    },
    {
        name = "Garama And Madundung",
        icon = "⚡💎",
        color = Color3.fromRGB(255, 69, 0),
        searchTerms = {"garama", "madundung", "garamaandmadundung", "garama and madundung", "Garama", "Madundung"}
    },
    {
        name = "Tung Tung Tung Sahur",
        icon = "🔔",
        color = Color3.fromRGB(50, 205, 50),
        searchTerms = {"tung", "sahur", "tungtungtungsahur", "tung tung tung sahur", "Tung", "Sahur", "tungtung"}
    }
}

-- Create brainrot buttons
local function createBrainrotButton(brainrotData, yPosition)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 60)
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
        if not isSearching then
            TweenService:Create(button, TweenInfo.new(0.2), {
                Size = UDim2.new(0.92, 0, 0, 63),
                BackgroundTransparency = 0.1
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isSearching then
            TweenService:Create(button, TweenInfo.new(0.2), {
                Size = UDim2.new(0.9, 0, 0, 60),
                BackgroundTransparency = 0
            }):Play()
        end
    end)
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        if isSearching then
            statusLabel.Text = "⚠️ Already searching! Please wait..."
            return
        end
        
        -- Click animation
        local clickTween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(0.88, 0, 0, 57)
        })
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {
                Size = UDim2.new(0.9, 0, 0, 60)
            }):Play()
        end)
        
        -- Reset counters
        serversChecked = 0
        
        -- Start hunting
        startBrainrotHunt(brainrotData)
    end)
end

-- Create all buttons
for i, brainrotData in ipairs(brainrots) do
    createBrainrotButton(brainrotData, 140 + (i - 1) * 75)
end

-- Stop Search Button
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0.43, 0, 0, 45)
stopButton.Position = UDim2.new(0.05, 0, 0, 490)
stopButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
stopButton.BorderSizePixel = 0
stopButton.Text = "⏹️ Stop Search"
stopButton.TextSize = 14
stopButton.Font = Enum.Font.SourceSansBold
stopButton.TextColor3 = Color3.new(1, 1, 1)
stopButton.Parent = mainPanel

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 10)
stopCorner.Parent = stopButton

stopButton.MouseButton1Click:Connect(function()
    isSearching = false
    targetBrainrot = nil
    serversChecked = 0
    clearESP()
    statusLabel.Text = "🛑 Search stopped"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressLabel.Text = "Ready to search"
end)

-- Manual Server Hop Button
local manualHopButton = Instance.new("TextButton")
manualHopButton.Size = UDim2.new(0.43, 0, 0, 45)
manualHopButton.Position = UDim2.new(0.52, 0, 0, 490)
manualHopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
manualHopButton.BorderSizePixel = 0
manualHopButton.Text = "🌐 Manual Hop"
manualHopButton.TextSize = 14
manualHopButton.Font = Enum.Font.SourceSansBold
manualHopButton.TextColor3 = Color3.new(1, 1, 1)
manualHopButton.Parent = mainPanel

local manualHopCorner = Instance.new("UICorner")
manualHopCorner.CornerRadius = UDim.new(0, 10)
manualHopCorner.Parent = manualHopButton

manualHopButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "🌐 Manual server hop..."
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
        Size = UDim2.new(0, 450, 0, 550),
        Position = UDim2.new(0.5, -225, 0.5, -275)
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

-- Floating button pulse animation
spawn(function()
    while true do
        if not isSearching then
            TweenService:Create(floatingButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 85, 0, 85)
            }):Play()
            wait(1)
            TweenService:Create(floatingButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 80, 0, 80)
            }):Play()
            wait(1)
        else
            -- Faster pulse when searching
            TweenService:Create(floatingButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            }):Play()
            wait(0.5)
            TweenService:Create(floatingButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundColor3 = Color3.fromRGB(255, 20, 147)
            }):Play()
            wait(0.5)
        end
    end
end)

print("🧠 Steal a Brainrot - Multi-Server Finder Loaded!")
print("🎯 Available brainrots to hunt across servers:")
for _, brainrot in pairs(brainrots) do
        print("  " .. brainrot.icon .. " " .. brainrot.name)
end
print("🚀 Click the pink floating button to start hunting!")
print("⚠️  This script will automatically hop servers until it finds your target brainrot!")

-- Additional safety features
local function onPlayerRemoving()
    isSearching = false
    clearESP()
end

Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Auto-reconnect if teleport fails
local function setupTeleportFailHandler()
    TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
        if isSearching then
            statusLabel.Text = "⚠️ Teleport failed, retrying..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            
            wait(3)
            if isSearching then
                hopToNextServer()
            end
        end
    end)
end

setupTeleportFailHandler()

-- Debug function to list all items in current server
local function debugListAllItems()
    print("🔍 DEBUG: Listing all items in current server:")
    local itemCount = 0
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Model") then
            itemCount = itemCount + 1
            local name = obj.Name:lower()
            
            -- Check if it might be a brainrot
            if name:find("tung") or name:find("sahur") or name:find("grande") or 
               name:find("combinacion") or name:find("graipussi") or name:find("medussi") or 
               name:find("vaca") or name:find("saturno") or name:find("garama") or 
               name:find("madundung") then
                print("  🎯 POTENTIAL BRAINROT: " .. obj.Name .. " at " .. obj:GetFullName())
            end
        end
    end
    
    print("📊 Total items scanned: " .. itemCount)
end

-- Call debug function on join
spawn(function()
    wait(5)
    debugListAllItems()
end)

-- Enhanced search with better detection patterns
local function enhancedScan(brainrotData)
    local found = false
    local foundItems = {}
    
    -- More comprehensive search patterns
    local searchPatterns = {}
    for _, term in pairs(brainrotData.searchTerms) do
        table.insert(searchPatterns, term:lower())
        table.insert(searchPatterns, term:upper())
        table.insert(searchPatterns, term:gsub(" ", ""):lower()) -- Remove spaces
        table.insert(searchPatterns, term:gsub(" ", ""):upper())
    end
    
    -- Search in all possible containers
    local containers = {
        workspace,
        workspace:FindFirstChild("Map"),
        workspace:FindFirstChild("Items"),
        workspace:FindFirstChild("Brainrots"),
        workspace:FindFirstChild("Spawns"),
        workspace:FindFirstChild("Parts"),
        workspace:FindFirstChild("Models")
    }
    
    for _, container in pairs(containers) do
        if container then
            for _, obj in pairs(container:GetDescendants()) do
                if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Model") then
                    local objName = obj.Name
                    
                    -- Check exact matches and partial matches
                    for _, pattern in pairs(searchPatterns) do
                        if objName:lower():find(pattern) or objName == pattern then
                            found = true
                            table.insert(foundItems, obj)
                            print("🎯 ENHANCED SCAN FOUND: " .. brainrotData.name .. " -> " .. obj.Name .. " at " .. obj:GetFullName())
                            break
                        end
                    end
                    
                    -- Check children for additional identifiers
                    for _, child in pairs(obj:GetChildren()) do
                        if child:IsA("StringValue") or child:IsA("ObjectValue") or child:IsA("BoolValue") then
                            for _, pattern in pairs(searchPatterns) do
                                if tostring(child.Value):lower():find(pattern) then
                                    found = true
                                    table.insert(foundItems, obj)
                                    print("🎯 FOUND IN CHILD VALUE: " .. brainrotData.name .. " -> " .. child.Name .. " = " .. tostring(child.Value))
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return found, foundItems
end

-- Update the main scan function to use enhanced scanning
local originalScanCurrentServer = scanCurrentServer
scanCurrentServer = function(brainrotData)
    -- Try original scan first
    local found1, items1 = originalScanCurrentServer(brainrotData)
    
    -- Try enhanced scan
    local found2, items2 = enhancedScan(brainrotData)
    
    -- Combine results
    local allItems = {}
    for _, item in pairs(items1) do
        table.insert(allItems, item)
    end
    for _, item in pairs(items2) do
        -- Avoid duplicates
        local isDuplicate = false
        for _, existingItem in pairs(allItems) do
            if existingItem == item then
                isDuplicate = true
                break
            end
        end
        if not isDuplicate then
            table.insert(allItems, item)
        end
    end
    
    return (found1 or found2), allItems
end

-- Notification system for better user feedback
local function showNotification(text, color, duration)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(0.5, -150, 0, 50)
    notification.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, 0, 1, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextSize = 16
    notifText.Font = Enum.Font.SourceSansBold
    notifText.TextColor3 = Color3.new(1, 1, 1)
    notifText.TextStrokeTransparency = 0
    notifText.Parent = notification
    
    -- Slide in animation
    notification.Position = UDim2.new(0.5, -150, 0, -70)
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0, 50)
    }):Play()
    
    -- Auto-remove after duration
    spawn(function()
        wait(duration or 3)
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -150, 0, -70),
            BackgroundTransparency = 1
        }):Play()
        wait(0.3)
        notification:Destroy()
    end)
end

-- Show welcome notification
spawn(function()
    wait(2)
    showNotification("🧠 Brainrot Hunter Ready!", Color3.fromRGB(50, 205, 50), 4)
end)
