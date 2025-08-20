-- Steal a Brainrot - Advanced Server Finder with Real Server Hopping

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedBrainrotFinder"
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
mainPanel.Size = UDim2.new(0, 500, 0, 600)
mainPanel.Position = UDim2.new(0.5, -250, 0.5, -300)
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
headerTitle.Text = "🧠 ADVANCED BRAINROT FINDER"
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

-- ESP Toggle Button
local espToggleButton = Instance.new("TextButton")
espToggleButton.Size = UDim2.new(0.9, 0, 0, 40)
espToggleButton.Position = UDim2.new(0.05, 0, 0, 140)
espToggleButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
espToggleButton.BorderSizePixel = 0
espToggleButton.Text = "👁️ ESP: ON (Show All Brainrots)"
espToggleButton.TextSize = 14
espToggleButton.Font = Enum.Font.SourceSansBold
espToggleButton.TextColor3 = Color3.new(1, 1, 1)
espToggleButton.Parent = mainPanel

local espToggleCorner = Instance.new("UICorner")
espToggleCorner.CornerRadius = UDim.new(0, 10)
espToggleCorner.Parent = espToggleButton

-- Global variables
local isSearching = false
local targetBrainrot = nil
local serversChecked = 0
local maxServers = 30
local espEnabled = true
local currentJobId = game.JobId

-- ESP System
local espConnections = {}
local espFolder = Instance.new("Folder")
espFolder.Name = "BrainrotESP"
espFolder.Parent = workspace

local function createESP(part, brainrotName, color, isTarget)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_" .. part.Name .. "_" .. tick()
    billboardGui.Adornee = part
    billboardGui.Size = UDim2.new(0, 350, 0, 100)
    billboardGui.StudsOffset = Vector3.new(0, 10, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = espFolder
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = isTarget and 0.05 or 0.2
    frame.BorderSizePixel = isTarget and 4 or 2
    frame.BorderColor3 = isTarget and Color3.new(1, 1, 1) or color
    frame.Parent = billboardGui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 15)
    frameCorner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = (isTarget and "🎯 TARGET: " or "🧠 ") .. brainrotName .. (isTarget and " 🎯" or "")
    textLabel.TextSize = isTarget and 24 or 18
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Parent = frame
    
    -- Special effects for target
    if isTarget then
        spawn(function()
            while billboardGui.Parent do
                for i = 1, 20 do
                    frame.BackgroundTransparency = 0.05 + (math.sin(i * 0.5) * 0.3)
                    frame.BorderColor3 = Color3.fromHSV((tick() * 3) % 1, 1, 1)
                    wait(0.1)
                end
            end
        end)
    end
    
    -- Distance updater
    local connection = RunService.Heartbeat:Connect(function()
        if part.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - part.Position).Magnitude
            textLabel.Text = (isTarget and "🎯 TARGET: " or "🧠 ") .. brainrotName .. "\n[" .. math.floor(distance) .. " studs]"
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

-- Brainrot data with comprehensive search terms
local brainrots = {
    {
        name = "La Grande Combinacion",
        icon = "🏆",
        color = Color3.fromRGB(255, 215, 0),
        searchTerms = {"grande", "combinacion", "lagrandecombinacion", "la grande combinacion", "Grande", "Combinacion", "GRANDE", "COMBINACION"}
    },
    {
        name = "Graipussi Medussi",
        icon = "🍇",
        color = Color3.fromRGB(138, 43, 226),
        searchTerms = {"graipussi", "medussi", "graipussimedussi", "graipussi medussi", "Graipussi", "Medussi", "GRAIPUSSI", "MEDUSSI"}
    },
    {
        name = "La Vaca Saturno Saturnita",
        icon = "🐄",
        color = Color3.fromRGB(255, 105, 180),
        searchTerms = {"vaca", "saturno", "saturnita", "lavacasaturnosaturnita", "la vaca saturno saturnita", "Vaca", "Saturno", "Saturnita", "VACA", "SATURNO"}
    },
    {
        name = "Garama And Madundung",
        icon = "⚡💎",
                color = Color3.fromRGB(255, 69, 0),
        searchTerms = {"garama", "madundung", "garamaandmadundung", "garama and madundung", "Garama", "Madundung", "GARAMA", "MADUNDUNG"}
    },
    {
        name = "Tung Tung Tung Sahur",
        icon = "🔔",
        color = Color3.fromRGB(50, 205, 50),
        searchTerms = {"tung", "sahur", "tungtungtungsahur", "tung tung tung sahur", "Tung", "Sahur", "TUNG", "SAHUR", "tungtung"}
    }
}

-- Enhanced scanning function that finds ALL brainrots
local function scanAllBrainrots()
    local foundBrainrots = {}
    
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
                    
                    -- Check against all brainrots
                    for _, brainrotData in pairs(brainrots) do
                        for _, searchTerm in pairs(brainrotData.searchTerms) do
                            if objName:lower():find(searchTerm:lower()) or objName == searchTerm then
                                table.insert(foundBrainrots, {
                                    object = obj,
                                    brainrot = brainrotData,
                                    isTarget = targetBrainrot and brainrotData.name == targetBrainrot.name
                                })
                                print("🧠 FOUND BRAINROT: " .. brainrotData.name .. " -> " .. obj.Name .. " at " .. obj:GetFullName())
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    
    return foundBrainrots
end

-- ESP All Brainrots function
local function espAllBrainrots()
    if not espEnabled then return end
    
    clearESP()
    local foundBrainrots = scanAllBrainrots()
    
    for _, brainrotInfo in pairs(foundBrainrots) do
        createESP(
            brainrotInfo.object, 
            brainrotInfo.brainrot.name, 
            brainrotInfo.brainrot.color,
            brainrotInfo.isTarget
        )
    end
    
    return foundBrainrots
end

-- Server list fetching function
local function getServerList()
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:GetAsync(url)
    end)
    
    if success then
        local data = HttpService:JSONDecode(result)
        return data.data or {}
    else
        print("❌ Failed to fetch server list: " .. tostring(result))
        return {}
    end
end

-- Advanced server hopping function
local function hopToRandomServer()
    statusLabel.Text = "🌐 Fetching server list..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    
    local servers = getServerList()
    
    if #servers == 0 then
        statusLabel.Text = "❌ No servers found, using basic hop"
        wait(2)
        pcall(function()
            TeleportService:Teleport(game.PlaceId, player)
        end)
        return
    end
    
    -- Filter out current server and full servers
    local availableServers = {}
    for _, server in pairs(servers) do
        if server.id ~= currentJobId and server.playing < server.maxPlayers then
            table.insert(availableServers, server)
        end
    end
    
    if #availableServers == 0 then
        statusLabel.Text = "❌ No available servers, retrying..."
        wait(3)
        hopToRandomServer()
        return
    end
    
    -- Pick random server
    local randomServer = availableServers[math.random(1, #availableServers)]
    
    statusLabel.Text = "🌐 Joining server " .. (serversChecked + 1) .. " (" .. randomServer.playing .. "/" .. randomServer.maxPlayers .. " players)"
    statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    
    serversChecked = serversChecked + 1
    progressLabel.Text = "Servers checked: " .. serversChecked .. "/" .. maxServers
    
    -- Teleport to specific server
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id, player)
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
    serversChecked = 0
    
    statusLabel.Text = "🔍 Scanning current server for " .. brainrotData.name .. "..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    -- Scan current server
    local foundBrainrots = espAllBrainrots()
    local targetFound = false
    
    for _, brainrotInfo in pairs(foundBrainrots) do
        if brainrotInfo.brainrot.name == brainrotData.name then
            targetFound = true
            
            -- Teleport to target
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local teleportPos = brainrotInfo.object.CFrame + Vector3.new(0, 10, 0)
                player.Character.HumanoidRootPart.CFrame = teleportPos
            end
            break
        end
    end
    
    if targetFound then
        statusLabel.Text = "✅ " .. brainrotData.name .. " FOUND in current server!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        progressLabel.Text = "SUCCESS! Found in current server"
        
        -- Success sound
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
        sound.Volume = 1
        sound.Parent = workspace
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
        
        isSearching = false
    else
        statusLabel.Text = "❌ " .. brainrotData.name .. " not in current server"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        progressLabel.Text = "Starting server hop search..."
        
        wait(2)
        hopToRandomServer()
    end
end

-- Auto-scan when joining new server
spawn(function()
    wait(8) -- Wait longer for server to fully load
    
    if isSearching and targetBrainrot then
        statusLabel.Text = "🔍 Scanning new server for " .. targetBrainrot.name .. "..."
        
        local foundBrainrots = espAllBrainrots()
        local targetFound = false
        
        for _, brainrotInfo in pairs(foundBrainrots) do
            if brainrotInfo.brainrot.name == targetBrainrot.name then
                targetFound = true
                
                -- Teleport to target
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    wait(2)
                    local teleportPos = brainrotInfo.object.CFrame + Vector3.new(0, 10, 0)
                    player.Character.HumanoidRootPart.CFrame = teleportPos
                end
                break
            end
        end
        
        if targetFound then
            statusLabel.Text = "✅ " .. targetBrainrot.name .. " FOUND! Server " .. serversChecked
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            progressLabel.Text = "SUCCESS! Found after " .. serversChecked .. " servers"
            
            -- Success sound
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
            sound.Volume = 1
            sound.Parent = workspace
            sound:Play()
            
            isSearching = false
        else
            if serversChecked >= maxServers then
                statusLabel.Text = "❌ Searched " .. maxServers .. " servers. Try again later."
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                isSearching = false
            else
                wait(3)
                if isSearching then
                    hopToRandomServer()
                end
            end
        end
    else
        -- Normal join, show all brainrots
        wait(2)
        local foundBrainrots = espAllBrainrots()
        statusLabel.Text = "🎮 Ready! Found " .. #foundBrainrots .. " brainrots in server"
        progressLabel.Text = "ESP showing all detected brainrots"
    end
end)

-- ESP Toggle functionality
espToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        espToggleButton.Text = "👁️ ESP: ON (Show All Brainrots)"
        espToggleButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        espAllBrainrots()
    else
        espToggleButton.Text = "👁️ ESP: OFF"
        espToggleButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
        clearESP()
    end
end)

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
        
        -- Start hunting
        startBrainrotHunt(brainrotData)
    end)
end

-- Create all buttons
for i, brainrotData in ipairs(brainrots) do
    createBrainrotButton(brainrotData, 190 + (i - 1) * 75)
end

-- Stop Search Button
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0.43, 0, 0, 45)
stopButton.Position = UDim2.new(0.05, 0, 0, 540)
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
    statusLabel.Text = "🛑 Search stopped"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressLabel.Text = "Ready to search"
    
    -- Re-enable ESP for all brainrots
    if espEnabled then
        espAllBrainrots()
    end
end)

-- Manual Server Hop Button
local manualHopButton = Instance.new("TextButton")
manualHopButton.Size = UDim2.new(0.43, 0, 0, 45)
manualHopButton.Position = UDim2.new(0.52, 0, 0, 540)
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
    
    hopToRandomServer()
end)

-- Panel animations
local function openPanel()
    mainPanel.Visible = true
    mainPanel.Size = UDim2.new(0, 0, 0, 0)
    mainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(mainPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 500, 0, 600),
        Position = UDim2.new(0.5, -250, 0.5, -300)
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

-- Auto-refresh ESP every 10 seconds
spawn(function()
    while true do
        wait(10)
        if espEnabled and not isSearching then
            espAllBrainrots()
        end
    end
end)

-- Floating button animations
spawn(function()
    while true do
        if not isSearching then
            -- Normal pulse
            TweenService:Create(floatingButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 85, 0, 85)
            }):Play()
            wait(1)
            TweenService:Create(floatingButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 80, 0, 80)
            }):Play()
            wait(1)
        else
            -- Searching pulse (faster)
            TweenService:Create(floatingButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundColor3 = Color3.fromRGB(255, 100, 100),
                Size = UDim2.new(0, 85, 0, 85)
            }):Play()
            wait(0.5)
            TweenService:Create(floatingButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundColor3 = Color3.fromRGB(255, 20, 147),
                Size = UDim2.new(0, 80, 0, 80)
            }):Play()
            wait(0.5)
        end
    end
end)

-- Notification system
local function showNotification(text, color, duration)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 350, 0, 70)
    notification.Position = UDim2.new(0.5, -175, 0, 50)
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
    notifText.TextWrapped = true
    notifText.Parent = notification
    
    -- Slide in animation
    notification.Position = UDim2.new(0.5, -175, 0, -80)
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -175, 0, 50)
    }):Play()
    
    -- Auto-remove after duration
    spawn(function()
        wait(duration or 4)
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -175, 0, -80),
            BackgroundTransparency = 1
        }):Play()
        wait(0.3)
        notification:Destroy()
    end)
end

-- Error handling for teleport failures
TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if isSearching then
        statusLabel.Text = "⚠️ Teleport failed, retrying..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        
        wait(3)
        if isSearching then
            hopToRandomServer()
        end
    end
end)

-- Initial setup
spawn(function()
    wait(3)
    showNotification("🧠 Advanced Brainrot Finder Loaded!\n👁️ ESP automatically shows all brainrots", Color3.fromRGB(50, 205, 50), 5)
    
    -- Initial ESP scan
    if espEnabled then
        espAllBrainrots()
    end
end)

print("🧠 Advanced Brainrot Finder Loaded!")
print("✨ Features:")
print("  🎯 Real server hopping using Roblox API")
print("  👁️ ESP shows ALL brainrots automatically")
print("  🌐 Searches up to 30 different servers")
print("  📍 Auto-teleports when target found")
print("  🔄 Auto-refreshes ESP every 10 seconds")
print("🚀 Click the pink floating button to start!")
