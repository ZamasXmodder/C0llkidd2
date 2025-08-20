-- Steal a Brainrot - Line ESP + Real Global Server Search

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotLineESPFinder"
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
headerTitle.Text = "🧠 GLOBAL BRAINROT HUNTER"
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
statusLabel.Text = "🎯 Select a brainrot for global server search"
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
progressLabel.Text = "Ready for global search"
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
espToggleButton.Text = "📍 LINE ESP: ON"
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
local maxServers = 50
local espEnabled = true
local currentJobId = game.JobId

-- Line ESP System
local espConnections = {}
local espLines = {}

local function createLineESP(part, brainrotName, color, isTarget)
    -- Create line from player to brainrot
    local line = Drawing.new("Line")
    line.Visible = true
    line.Color = isTarget and Color3.new(1, 1, 0) or color
    line.Thickness = isTarget and 4 or 2
    line.Transparency = 0.8
    
    -- Create text label
    local text = Drawing.new("Text")
    text.Visible = true
    text.Color = isTarget and Color3.new(1, 1, 0) or color
    text.Size = isTarget and 20 or 16
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.new(0, 0, 0)
    text.Font = Drawing.Fonts.Plex
    text.Text = (isTarget and "🎯 TARGET: " or "🧠 ") .. brainrotName
    
    -- Create distance text
    local distanceText = Drawing.new("Text")
    distanceText.Visible = true
    distanceText.Color = Color3.new(1, 1, 1)
    distanceText.Size = 14
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.OutlineColor = Color3.new(0, 0, 0)
    distanceText.Font = Drawing.Fonts.Plex
    
    -- Store ESP elements
    local espData = {
        line = line,
        text = text,
        distanceText = distanceText,
        part = part,
        isTarget = isTarget
    }
    
    table.insert(espLines, espData)
    
    -- Update connection
    local connection = RunService.Heartbeat:Connect(function()
        if part.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPos = player.Character.HumanoidRootPart.Position
            local partPos = part.Position
            local distance = (playerPos - partPos).Magnitude
            
            -- Update line
            local screenPos, onScreen = camera:WorldToViewportPoint(partPos)
            local playerScreenPos = camera:WorldToViewportPoint(playerPos)
            
            if onScreen then
                line.From = Vector2.new(playerScreenPos.X, playerScreenPos.Y)
                line.To = Vector2.new(screenPos.X, screenPos.Y)
                line.Visible = true
                
                -- Update text position
                text.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
                text.Visible = true
                
                -- Update distance
                distanceText.Text = math.floor(distance) .. "m"
                distanceText.Position = Vector2.new(screenPos.X, screenPos.Y - 10)
                distanceText.Visible = true
                
                -- Special effects for target
                if isTarget then
                    line.Color = Color3.fromHSV((tick() * 2) % 1, 1, 1)
                    text.Color = Color3.fromHSV((tick() * 2) % 1, 1, 1)
                end
            else
                line.Visible = false
                text.Visible = false
                distanceText.Visible = false
            end
        else
            line.Visible = false
            text.Visible = false
            distanceText.Visible = false
        end
    end)
    
    table.insert(espConnections, connection)
    return espData
end

local function clearLineESP()
    for _, connection in pairs(espConnections) do
        connection:Disconnect()
    end
    espConnections = {}
    
    for _, espData in pairs(espLines) do
        espData.line:Remove()
        espData.text:Remove()
        espData.distanceText:Remove()
    end
    espLines = {}
end

-- Brainrot data
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

-- Enhanced scanning function
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
        workspace:FindFirstChild("Models"),
        workspace:FindFirstChild("Folder")
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
                                print("🧠 FOUND BRAINROT: " .. brainrotData.name .. " -> " .. obj.Name)
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

-- Line ESP All Brainrots function
local function lineESPAllBrainrots()
    if not espEnabled then return end
    
    clearLineESP()
    local foundBrainrots = scanAllBrainrots()
    
    for _, brainrotInfo in pairs(foundBrainrots) do
        createLineESP(
            brainrotInfo.object, 
            brainrotInfo.brainrot.name, 
            brainrotInfo.brainrot.color,
            brainrotInfo.isTarget
        )
    end
    
    return foundBrainrots
end

-- Advanced server fetching with multiple attempts
local function getServerList()
    local attempts = 0
    local maxAttempts = 3
    
    while attempts < maxAttempts do
        attempts = attempts + 1
        
        local success, result = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            return HttpService:GetAsync(url)
        end)
        
        if success then
            local data = HttpService:JSONDecode(result)
            if data and data.data then
                print("✅ Successfully fetched " .. #data.data .. " servers")
                return data.data
            end
        else
            print("❌ Attempt " .. attempts .. " failed: " .. tostring(result))
            if attempts < maxAttempts then
                wait(2)
            end
        end
    end
    
    print("❌ Failed to fetch servers after " .. maxAttempts .. " attempts")
    return {}
end

-- Real server hopping function
local function hopToNextServer()
    statusLabel.Text = "🌐 Fetching available servers..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    
    local servers = getServerList()
    
    if #servers == 0 then
        statusLabel.Text = "❌ No servers available, using fallback method"
        wait(3)
        
        -- Fallback: Use basic teleport with random delay
        local randomDelay = math.random(1, 5)
        wait(randomDelay)
        
        pcall(function()
            TeleportService:Teleport(game.PlaceId, player)
        end)
        return
    end
    
    -- Filter servers (exclude current, full servers, and very empty servers)
    local availableServers = {}
    for _, server in pairs(servers) do
        if server.id ~= currentJobId and 
           server.playing < server.maxPlayers and 
           server.playing > 1 then -- Avoid empty servers
            table.insert(availableServers, server)
        end
    end
    
    if #availableServers == 0 then
        statusLabel.Text = "❌ No suitable servers found, retrying..."
        wait(3)
        if isSearching then
            hopToNextServer()
        end
        return
    end
    
    -- Sort by player count (prefer servers with more players)
    table.sort(availableServers, function(a, b)
        return a.playing > b.playing
    end)
    
    -- Pick from top servers randomly
    local topServers = {}
    for i = 1, math.min(10, #availableServers) do
        table.insert(topServers, availableServers[i])
    end
    
    local selectedServer = topServers[math.random(1, #topServers)]
    
    serversChecked = serversChecked + 1
    statusLabel.Text = "🌐 Joining server " .. serversChecked .. " (" .. selectedServer.playing .. "/" .. selectedServer.maxPlayers .. " players)"
    statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    progressLabel.Text = "Global search: " .. serversChecked .. "/" .. maxServers .. " servers checked"
    
    print("🌐 Attempting to join server: " .. selectedServer.id)
    
    -- Teleport to specific server
    local success, error = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, selectedServer.id, player)
    end)
    
    if not success then
        print("❌ Teleport failed: " .. tostring(error))
        statusLabel.Text = "⚠️ Teleport failed, trying next server..."
        wait(2)
        if isSearching then
            hopToNextServer()
        end
    end
end

-- Main global search function
local function startGlobalBrainrotHunt(brainrotData)
    if isSearching then
        statusLabel.Text = "⚠️ Already searching globally! Please wait..."
        return
    end
    
    isSearching = true
    targetBrainrot = brainrotData
    serversChecked = 0
    
    statusLabel.Text = "🔍 Starting global search for " .. brainrotData.name .. "..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    progressLabel.Text = "Scanning current server first..."
    
    -- First scan current server
    local foundBrainrots = lineESPAllBrainrots()
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
        progressLabel.Text = "SUCCESS! Target found in current server"
        
        -- Success notification
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
        sound.Volume = 1
        sound.Parent = workspace
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
        
        isSearching = false
    else
        statusLabel.Text = "❌ " .. brainrotData.name .. " not found here"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        progressLabel.Text = "Starting global server search..."
        
        wait(3)
        hopToNextServer()
    end
end

-- Auto-scan when joining new server (CRITICAL FOR GLOBAL SEARCH)
spawn(function()
    wait(10) -- Wait longer for server to fully load
    
    if isSearching and targetBrainrot then
        statusLabel.Text = "🔍 Scanning new server for " .. targetBrainrot.name .. "..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        
        local foundBrainrots = lineESPAllBrainrots()
        local targetFound = false
        
        for _, brainrotInfo in pairs(foundBrainrots) do
            if brainrotInfo.brainrot.name == targetBrainrot.name then
                targetFound = true
                
                -- Teleport to target
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    wait(3) -- Wait a bit more for character to load
                    local teleportPos = brainrotInfo.object.CFrame + Vector3.new(0, 10, 0)
                    player.Character.HumanoidRootPart.CFrame = teleportPos
                end
                break
            end
        end
        
        if targetFound then
            statusLabel.Text = "🎯 " .. targetBrainrot.name .. " FOUND! Server " .. serversChecked
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            progressLabel.Text = "SUCCESS! Found after checking " .. serversChecked .. " servers"
            
            -- Success sound and notification
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
            sound.Volume = 1
            sound.Parent = workspace
            sound:Play()
            
            -- Show success notification
            showNotification("🎯 " .. targetBrainrot.name .. " FOUND!\nServer " .. serversChecked, Color3.fromRGB(0, 255, 0), 8)
            
            isSearching = false
        else
            if serversChecked >= maxServers then
                statusLabel.Text = "❌ Searched " .. maxServers .. " servers. Target not found."
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                progressLabel.Text = "Search completed. Try again later."
                isSearching = false
            else
                statusLabel.Text = "❌ Not found. Continuing search..."
                                progressLabel.Text = "Searching... " .. serversChecked .. "/" .. maxServers .. " servers"
                wait(5) -- Wait before next hop
                if isSearching then
                    hopToNextServer()
                end
            end
        end
    else
        -- Normal join, show all brainrots with line ESP
        wait(3)
        local foundBrainrots = lineESPAllBrainrots()
        statusLabel.Text = "🎮 Ready! Found " .. #foundBrainrots .. " brainrots in server"
        progressLabel.Text = "Line ESP showing all detected brainrots"
    end
end)

-- ESP Toggle functionality
espToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        espToggleButton.Text = "📍 LINE ESP: ON"
        espToggleButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        lineESPAllBrainrots()
    else
        espToggleButton.Text = "📍 LINE ESP: OFF"
        espToggleButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
        clearLineESP()
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
    
    -- Click event for GLOBAL SEARCH
    button.MouseButton1Click:Connect(function()
        if isSearching then
            statusLabel.Text = "⚠️ Global search in progress! Please wait..."
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
        
        -- Start GLOBAL hunting
        startGlobalBrainrotHunt(brainrotData)
    end)
end

-- Create all buttons
for i, brainrotData in ipairs(brainrots) do
    createBrainrotButton(brainrotData, 190 + (i - 1) * 75)
end

-- Stop Global Search Button
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0.43, 0, 0, 45)
stopButton.Position = UDim2.new(0.05, 0, 0, 540)
stopButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
stopButton.BorderSizePixel = 0
stopButton.Text = "⏹️ Stop Global Search"
stopButton.TextSize = 12
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
    statusLabel.Text = "🛑 Global search stopped"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressLabel.Text = "Ready for new global search"
    
    -- Re-enable ESP for all brainrots
    if espEnabled then
        lineESPAllBrainrots()
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
    
    hopToNextServer()
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

-- Auto-refresh ESP every 15 seconds
spawn(function()
    while true do
        wait(15)
        if espEnabled and not isSearching then
            lineESPAllBrainrots()
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
            -- Global searching pulse (faster + color change)
            TweenService:Create(floatingButton, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundColor3 = Color3.fromRGB(255, 100, 100),
                Size = UDim2.new(0, 90, 0, 90)
            }):Play()
            wait(0.3)
            TweenService:Create(floatingButton, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundColor3 = Color3.fromRGB(255, 20, 147),
                Size = UDim2.new(0, 80, 0, 80)
            }):Play()
            wait(0.3)
        end
    end
end)

-- Notification system
function showNotification(text, color, duration)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 400, 0, 80)
    notification.Position = UDim2.new(0.5, -200, 0, 50)
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
    notification.Position = UDim2.new(0.5, -200, 0, -90)
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -200, 0, 50)
    }):Play()
    
    -- Auto-remove after duration
    spawn(function()
        wait(duration or 5)
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -200, 0, -90),
            BackgroundTransparency = 1
        }):Play()
        wait(0.3)
        notification:Destroy()
    end)
end

-- Enhanced error handling for teleport failures
TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if isSearching then
        print("❌ Teleport failed: " .. tostring(errorMessage))
        statusLabel.Text = "⚠️ Teleport failed, trying next server..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        
        wait(3)
        if isSearching then
            hopToNextServer()
        end
    end
end)

-- Handle player leaving (cleanup)
local function onPlayerRemoving()
    isSearching = false
    clearLineESP()
end

Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Handle character respawning
player.CharacterAdded:Connect(function()
    wait(3)
    if espEnabled then
        lineESPAllBrainrots()
    end
end)

-- Debug function for troubleshooting
local function debugServerInfo()
    print("🔍 DEBUG INFO:")
    print("  Current Job ID: " .. currentJobId)
    print("  Place ID: " .. game.PlaceId)
    print("  Players in server: " .. #Players:GetPlayers())
    print("  Is searching: " .. tostring(isSearching))
    print("  Target brainrot: " .. (targetBrainrot and targetBrainrot.name or "None"))
    print("  Servers checked: " .. serversChecked)
end

-- Add debug command
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F9 then
        debugServerInfo()
    end
end)

-- Initial setup and welcome
spawn(function()
    wait(5)
    showNotification("🧠 Global Brainrot Hunter Loaded!\n📍 Line ESP shows all brainrots\n🌐 Real global server search", Color3.fromRGB(50, 205, 50), 6)
    
    -- Initial ESP scan
    if espEnabled then
        lineESPAllBrainrots()
    end
    
    -- Show initial status
    local foundBrainrots = scanAllBrainrots()
    statusLabel.Text = "🎮 Ready for global search! Found " .. #foundBrainrots .. " brainrots here"
    progressLabel.Text = "Click any brainrot to start global search"
end)

-- Periodic server list refresh (helps with API reliability)
spawn(function()
    while true do
        wait(300) -- Every 5 minutes
        if not isSearching then
            pcall(function()
                getServerList() -- Pre-fetch to keep API warm
            end)
        end
    end
end)

-- Enhanced search retry logic
local function enhancedRetryLogic()
    if isSearching and serversChecked < maxServers then
        local retryDelay = math.min(5 + (serversChecked * 0.5), 15) -- Increasing delay
        statusLabel.Text = "🔄 Retrying in " .. math.floor(retryDelay) .. " seconds..."
        
        for i = math.floor(retryDelay), 1, -1 do
            if not isSearching then break end
            statusLabel.Text = "🔄 Retrying in " .. i .. " seconds..."
            wait(1)
        end
        
        if isSearching then
            hopToNextServer()
        end
    end
end

-- Connection cleanup on script end
local function cleanup()
    clearLineESP()
    if screenGui then
        screenGui:Destroy()
    end
end

-- Register cleanup
game:BindToClose(cleanup)

print("🧠 GLOBAL BRAINROT HUNTER LOADED!")
print("✨ NEW FEATURES:")
print("  📍 Line ESP with distance tracking")
print("  🌐 TRUE global server search (up to 50 servers)")
print("  🎯 Auto-teleport when target found")
print("  🔄 Enhanced retry logic")
print("  ⚡ Real-time server API integration")
print("  🎮 Press F9 for debug info")
print("🚀 Click the pink button and select a brainrot for GLOBAL HUNT!")
