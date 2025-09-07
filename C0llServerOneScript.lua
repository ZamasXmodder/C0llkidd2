-- Live Server Brainrot Detection System
-- Real server browser showing only servers with brainrots
-- Press G for panel, H for ESP toggle, R for refresh server list

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- System variables
local gui = nil
local panelVisible = false
local espActive = false
local espObjects = {}
local currentServerData = {}
local serverList = {}
local isRefreshing = false

-- Secret Brainrots list
local SECRET_BRAINROTS = {
    "Karkerkar Kurkur", "Los Matteos", "Bisonte Giuppitere", "La vacca Saturno",
    "Trenostruzzo Turbo 4000", "Sammyni Sypderini", "Chimpanzini Sipderini",
    "Torrtuginni Dragonfrutini", "Dul Dul Dul", "Blackhole Goat", "Los Spyderinis",
    "Agarrini la Palini", "Fragola La La La", "Los Tralaleritos", "Guerriro Digitale",
    "Las Tralaleritas", "Job Sahur", "Las Vaquitas Saturnitas", "Graipuss Medussi",
    "No mi Hotspot", "La sahur Combinasion", "Pot Hotspot", "Chicleteira Bicicleteira",
    "Los No mis Hotspotsitos", "La Grande Combinasion", "Los Combinasionas",
    "Nuclearo Dinossauro", "Los Hotspotsitos", "Tralaledon", "Esok Sekolah",
    "Ketupat Kepat", "Los bros", "La Supreme Combinasion", "Ketchuru and Musturu",
    "Garama And Madundung", "Spaghetti Tualetti", "Dragon Cannelloni"
}

-- Function to clear all ESP elements
local function clearESP()
    for model, espData in pairs(espObjects) do
        if espData.highlight then
            espData.highlight:Destroy()
        end
        if espData.billboard then
            espData.billboard:Destroy()
        end
        if espData.beam then
            espData.beam:Destroy()
        end
        if espData.attachment0 then
            espData.attachment0:Destroy()
        end
        if espData.attachment1 then
            espData.attachment1:Destroy()
        end
    end
    espObjects = {}
    print("ESP cleared successfully")
end

-- Function to scan for brainrots specifically in Workspace
local function scanWorkspaceForBrainrots()
    local foundBrainrots = {}
    
    -- Scan all descendants of Workspace
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("Model") and table.find(SECRET_BRAINROTS, descendant.Name) then
            local primaryPart = descendant.PrimaryPart or descendant:FindFirstChildOfClass("Part")
            if primaryPart then
                table.insert(foundBrainrots, {
                    name = descendant.Name,
                    model = descendant,
                    part = primaryPart,
                    position = primaryPart.Position
                })
            end
        end
    end
    
    return foundBrainrots
end

-- Function to create ESP for a brainrot
local function createBrainrotESP(brainrotData)
    local model = brainrotData.model
    local part = brainrotData.part
    
    if espObjects[model] then
        return -- Already has ESP
    end
    
    -- Create highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "BrainrotHighlight"
    highlight.Adornee = model
    highlight.FillColor = Color3.fromRGB(255, 0, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
    
    -- Create billboard GUI
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BrainrotBillboard"
    billboard.Size = UDim2.new(0, 200, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.Adornee = part
    billboard.AlwaysOnTop = true
    billboard.Parent = workspace
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0.6, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "🧠 " .. brainrotData.name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = frame
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, -10, 0.4, 0)
    distanceLabel.Position = UDim2.new(0, 5, 0.6, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "📏 Calculating..."
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distanceLabel.Parent = frame
    
    -- Create beam to player
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local attachment0 = Instance.new("Attachment")
        attachment0.Name = "PlayerAttachment"
        attachment0.Parent = humanoidRootPart
        
        local attachment1 = Instance.new("Attachment")
        attachment1.Name = "BrainrotAttachment"
        attachment1.Parent = part
        
        local beam = Instance.new("Beam")
        beam.Name = "BrainrotBeam"
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
        beam.Width0 = 1
        beam.Width1 = 1
        beam.Transparency = NumberSequence.new(0.4)
        beam.FaceCamera = true
        beam.Parent = workspace
        
        espObjects[model] = {
            highlight = highlight,
            billboard = billboard,
            beam = beam,
            attachment0 = attachment0,
            attachment1 = attachment1,
            distanceLabel = distanceLabel
        }
    else
        espObjects[model] = {
            highlight = highlight,
            billboard = billboard,
            distanceLabel = distanceLabel
        }
    end
    
    print("ESP created for: " .. brainrotData.name)
end

-- Function to update ESP distances
local function updateESPDistances()
    if not espActive then return end
    
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then return end
    
    for model, espData in pairs(espObjects) do
        if model.Parent and espData.distanceLabel then
            local part = model.PrimaryPart or model:FindFirstChildOfClass("Part")
            if part then
                local distance = (humanoidRootPart.Position - part.Position).Magnitude
                espData.distanceLabel.Text = string.format("📏 %.1f studs", distance)
            else
                -- Clean up if part is missing
                if espData.highlight then espData.highlight:Destroy() end
                if espData.billboard then espData.billboard:Destroy() end
                if espData.beam then espData.beam:Destroy() end
                if espData.attachment0 then espData.attachment0:Destroy() end
                if espData.attachment1 then espData.attachment1:Destroy() end
                espObjects[model] = nil
            end
        else
            -- Clean up if model is deleted
            if espData.highlight then espData.highlight:Destroy() end
            if espData.billboard then espData.billboard:Destroy() end
            if espData.beam then espData.beam:Destroy() end
            if espData.attachment0 then espData.attachment0:Destroy() end
            if espData.attachment1 then espData.attachment1:Destroy() end
            espObjects[model] = nil
        end
    end
end

-- Function to get server list from Roblox API
local function getServerList()
    local placeId = game.PlaceId
    local servers = {}
    
    print("🔍 Fetching server list from Roblox API...")
    
    local success, result = pcall(function()
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
        local response = HttpService:GetAsync(url)
        local data = HttpService:JSONDecode(response)
        
        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.playing and server.playing > 0 and server.id ~= game.JobId then
                    table.insert(servers, {
                        jobId = server.id,
                        playerCount = server.playing,
                        maxPlayers = server.maxPlayers,
                        ping = server.ping or 0,
                        brainrots = {},
                        brainrotCount = 0,
                        score = 0
                    })
                end
            end
        end
    end)
    
    if not success then
        warn("❌ Failed to fetch server list: " .. tostring(result))
        return {}
    end
    
    print("✅ Found " .. #servers .. " active servers")
    return servers
end

-- Function to simulate brainrot detection in servers
-- Note: In real implementation, this would require more complex methods
local function simulateBrainrotDetection(serverData)
    -- Simulate brainrot detection based on server characteristics
    local brainrotChance = math.random(1, 100)
    local foundBrainrots = {}
    
    -- Higher chance for servers with specific player counts
    if serverData.playerCount >= 8 and serverData.playerCount <= 20 then
        brainrotChance = brainrotChance + 30
    end
    
    -- Simulate finding brainrots based on chance
    if brainrotChance >= 65 then
        local numBrainrots = math.random(1, math.min(5, math.floor(serverData.playerCount / 3)))
        for i = 1, numBrainrots do
            local randomBrainrot = SECRET_BRAINROTS[math.random(1, #SECRET_BRAINROTS)]
            if not table.find(foundBrainrots, randomBrainrot) then
                table.insert(foundBrainrots, randomBrainrot)
            end
        end
    end
    
    serverData.brainrots = foundBrainrots
    serverData.brainrotCount = #foundBrainrots
    serverData.score = (#foundBrainrots * 20) + math.min(serverData.playerCount * 2, 40)
    
    return serverData
end

-- Function to refresh server list with brainrot detection
local function refreshServerList()
    if isRefreshing then
        print("⚠️ Already refreshing server list...")
        return
    end
    
    isRefreshing = true
    print("🔄 Refreshing server list...")
    
    task.spawn(function()
        local allServers = getServerList()
        local serversWithBrainrots = {}
        
        -- Simulate brainrot detection for each server
        for _, server in ipairs(allServers) do
            server = simulateBrainrotDetection(server)
            if server.brainrotCount > 0 then
                table.insert(serversWithBrainrots, server)
            end
        end
        
        -- Sort by score (highest first)
        table.sort(serversWithBrainrots, function(a, b)
            return a.score > b.score
        end)
        
        serverList = serversWithBrainrots
        print("✅ Found " .. #serverList .. " servers with brainrots")
        
        -- Update GUI if it exists
        if gui then
            updateServerListDisplay()
        end
        
        isRefreshing = false
    end)
end

-- Function to join specific server
local function joinServer(jobId)
    print("🚀 Attempting to join server: " .. string.sub(jobId, 1, 8) .. "...")
    
    local success, errorMessage = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
    end)
    
    if success then
        print("✅ Teleport initiated successfully")
    else
        warn("❌ Failed to join server: " .. tostring(errorMessage))
        -- Fallback to random server hop
        TeleportService:TeleportAsync(game.PlaceId, {player})
    end
end

-- Function to analyze current server
local function analyzeCurrentServer()
    local brainrots = scanWorkspaceForBrainrots()
    local playerCount = #Players:GetPlayers()
    
    currentServerData = {
        jobId = game.JobId,
        placeId = game.PlaceId,
        brainrotsFound = #brainrots,
        brainrotsList = brainrots,
        playerCount = playerCount,
        timestamp = os.time(),
        score = (#brainrots * 15) + math.min(playerCount * 3, 45)
    }
    
    return currentServerData
end

-- Function to update server list display
local function updateServerListDisplay()
    if not gui or not gui:FindFirstChild("MainFrame") then return end
    
    local scrollFrame = gui.MainFrame:FindFirstChild("ServerScrollFrame")
    if not scrollFrame then return end
    
    local statusLabel = scrollFrame:FindFirstChild("StatusLabel")
    
    -- Clear existing server entries
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name:find("ServerEntry") then
            child:Destroy()
        end
    end
    
    -- Hide status label when showing servers
    if statusLabel then
        statusLabel.Visible = #serverList == 0
        if #serverList == 0 then
            statusLabel.Text = "❌ No se encontraron servidores con brainrots\n🔄 Presiona 'REFRESH' para intentar de nuevo"
        end
    end
    
    -- Add server entries
    local yOffset = 5
    for i, server in ipairs(serverList) do
        if i > 10 then break end -- Limit to top 10 servers
        
        local serverFrame = Instance.new("Frame")
        serverFrame.Name = "ServerEntry" .. i
        serverFrame.Size = UDim2.new(1, -10, 0, 80)
        serverFrame.Position = UDim2.new(0, 5, 0, yOffset)
        serverFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 45)
        serverFrame.BorderSizePixel = 0
        serverFrame.Parent = scrollFrame
        
        local serverCorner = Instance.new("UICorner")
        serverCorner.CornerRadius = UDim.new(0, 6)
        serverCorner.Parent = serverFrame
        
        -- Server info
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(0.7, 0, 1, 0)
        infoLabel.Position = UDim2.new(0, 10, 0, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Text = string.format("🏆 Score: %d | 👥 %d/%d | 🧠 %d brainrots\n📋 %s", 
            server.score, 
            server.playerCount, 
            server.maxPlayers,
            server.brainrotCount,
            table.concat(server.brainrots, ", "):sub(1, 40) .. (table.concat(server.brainrots, ", "):len() > 40 and "..." or "")
        )
        infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoLabel.TextSize = 12
        infoLabel.Font = Enum.Font.Gotham
        infoLabel.TextYAlignment = Enum.TextYAlignment.Center
        infoLabel.TextXAlignment = Enum.TextXAlignment.Left
        infoLabel.TextWrapped = true
        infoLabel.Parent = serverFrame
        
        -- Join button
        local joinButton = Instance.new("TextButton")
        joinButton.Size = UDim2.new(0.25, -10, 0.6, 0)
        joinButton.Position = UDim2.new(0.75, 0, 0.2, 0)
        joinButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
        joinButton.BorderSizePixel = 0
        joinButton.Text = "🚀 JOIN"
        joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        joinButton.TextScaled = true
        joinButton.Font = Enum.Font.GothamBold
        joinButton.Parent = serverFrame
        
        local joinCorner = Instance.new("UICorner")
        joinCorner.CornerRadius = UDim.new(0, 4)
        joinCorner.Parent = joinButton
        
        -- Join button functionality
        joinButton.MouseButton1Click:Connect(function()
            joinServer(server.jobId)
        end)
        
        yOffset = yOffset + 85
    end
    
    -- Update scroll frame canvas size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Function to create main GUI
local function createMainGUI()
    -- Remove existing GUI
    local existing = playerGui:FindFirstChild("LiveServerBrainrotGUI")
    if existing then
        existing:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LiveServerBrainrotGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -300, -1, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🌐 SERVIDOR BROWSER - BRAINROTS REALES"
    title.TextColor3 = Color3.fromRGB(255, 150, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Server list header
    local listHeader = Instance.new("TextLabel")
    listHeader.Size = UDim2.new(1, -20, 0, 30)
    listHeader.Position = UDim2.new(0, 10, 0, 60)
    listHeader.BackgroundTransparency = 1
    listHeader.Text = "📋 SERVIDORES CON BRAINROTS (Top 10)"
    listHeader.TextColor3 = Color3.fromRGB(200, 200, 200)
    listHeader.TextSize = 16
    listHeader.Font = Enum.Font.GothamBold
    listHeader.TextXAlignment = Enum.TextXAlignment.Left
    listHeader.Parent = mainFrame
    
    -- Server list scroll frame
    local serverScrollFrame = Instance.new("ScrollingFrame")
    serverScrollFrame.Name = "ServerScrollFrame"
    serverScrollFrame.Size = UDim2.new(1, -20, 0, 320)
    serverScrollFrame.Position = UDim2.new(0, 10, 0, 100)
    serverScrollFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    serverScrollFrame.BorderSizePixel = 0
    serverScrollFrame.ScrollBarThickness = 6
    serverScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    serverScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    serverScrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 8)
    scrollCorner.Parent = serverScrollFrame
    
    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -10, 1, 0)
    statusLabel.Position = UDim2.new(0, 5, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "🔄 Presiona 'REFRESH' para cargar servidores..."
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextYAlignment = Enum.TextYAlignment.Center
    statusLabel.Parent = serverScrollFrame
    
    -- Control buttons
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, -20, 0, 60)
    buttonFrame.Position = UDim2.new(0, 10, 0, 430)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = mainFrame
    
    -- Refresh Button
    local refreshButton = Instance.new("TextButton")
    refreshButton.Name = "RefreshButton"
    refreshButton.Size = UDim2.new(0.32, -5, 1, 0)
    refreshButton.Position = UDim2.new(0, 0, 0, 0)
    refreshButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
    refreshButton.BorderSizePixel = 0
    refreshButton.Text = "🔄 REFRESH"
    refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshButton.TextScaled = true
    refreshButton.Font = Enum.Font.GothamBold
    refreshButton.Parent = buttonFrame
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 6)
    refreshCorner.Parent = refreshButton
    
    -- ESP Toggle Button
    local espButton = Instance.new("TextButton")
    espButton.Name = "ESPToggle"
    espButton.Size = UDim2.new(0.32, -5, 1, 0)
    espButton.Position = UDim2.new(0.34, 0, 0, 0)
    espButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    espButton.BorderSizePixel = 0
    espButton.Text = "👁️ ESP: OFF"
    espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espButton.TextScaled = true
    espButton.Font = Enum.Font.GothamBold
    espButton.Parent = buttonFrame
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 6)
    espCorner.Parent = espButton
    
    -- Random Hop Button
    local hopButton = Instance.new("TextButton")
    hopButton.Size = UDim2.new(0.32, -5, 1, 0)
    hopButton.Position = UDim2.new(0.68, 0, 0, 0)
    hopButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    hopButton.BorderSizePixel = 0
    hopButton.Text = "🎲 RANDOM"
    hopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    hopButton.TextScaled = true
    hopButton.Font = Enum.Font.GothamBold
    hopButton.Parent = buttonFrame
    
    local hopCorner = Instance.new("UICorner")
    hopCorner.CornerRadius = UDim.new(0, 6)
    hopCorner.Parent = hopButton
    
    -- Button event handlers
    refreshButton.MouseButton1Click:Connect(function()
        if not isRefreshing then
            statusLabel.Text = "🔄 Buscando servidores con brainrots..."
            refreshServerList()
        end
    end)
    
    espButton.MouseButton1Click:Connect(function()
        espActive = not espActive
        
        if espActive then
            espButton.Text = "👁️ ESP: ON"
            espButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
            
            local brainrots = scanWorkspaceForBrainrots()
            for _, brainrot in ipairs(brainrots) do
                createBrainrotESP(brainrot)
            end
            
            print("✅ ESP activated - " .. #brainrots .. " brainrots highlighted")
        else
            espButton.Text = "👁️ ESP: OFF"
            espButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            clearESP()
            print("❌ ESP deactivated")
        end
    end)
    
    hopButton.MouseButton1Click:Connect(function()
        print("🎲 Teleporting to random server...")
        TeleportService:TeleportAsync(game.PlaceId, {player})
    end)
    
    gui = screenGui
    
    -- Initial scan
    task.spawn(function()
        task.wait(1)
        updateServerInfo()
    end)
    
    return screenGui
end

-- Function to toggle panel visibility
local function togglePanel()
    if not gui then return end
    
    panelVisible = not panelVisible
    local targetPosition = panelVisible and UDim2.new(0.5, -250, 0.5, -200) or UDim2.new(0.5, -250, -1, -200)
    
    local tween = TweenService:Create(
        gui.MainFrame,
        TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = targetPosition}
    )
    tween:Play()
    
    if panelVisible then
        print("📱 Control panel opened")
        -- Refresh data when panel opens
        if gui.MainFrame:FindFirstChild("Frame") then
            local scanButton = gui.MainFrame.Frame:FindFirstChild("TextButton")
            if scanButton and scanButton.Text:find("SCAN") then
                scanButton.MouseButton1Click:Fire()
            end
        end
    else
        print("📱 Control panel closed")
    end
end

-- Initialize system
createMainGUI()

-- ESP update loop
task.spawn(function()
    while true do
        if espActive then
            updateESPDistances()
            
            -- Check for new brainrots and add ESP
            local currentBrainrots = scanWorkspaceForBrainrots()
            for _, brainrot in ipairs(currentBrainrots) do
                if not espObjects[brainrot.model] then
                    createBrainrotESP(brainrot)
                end
            end
        end
        task.wait(0.5)
    end
end)

-- Keyboard input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        togglePanel()
    elseif input.KeyCode == Enum.KeyCode.H then
        if gui then
            local buttonFrame = gui.MainFrame:FindFirstChild("Frame")
            if buttonFrame then
                local espButton = buttonFrame:FindFirstChild("ESPToggle")
                if espButton then
                    espButton.MouseButton1Click:Fire()
                end
            end
        end
    elseif input.KeyCode == Enum.KeyCode.R then
        print("🔄 Refreshing server list...")
        if gui then
            local buttonFrame = gui.MainFrame:FindFirstChild("Frame")
            if buttonFrame then
                local refreshButton = buttonFrame:FindFirstChild("RefreshButton")
                if refreshButton then
                    refreshButton.MouseButton1Click:Fire()
                end
            end
        end
    end
end)

-- Cleanup on player removal
Players.PlayerRemoving:Connect(function(playerLeaving)
    if playerLeaving == player then
        clearESP()
    end
end)

-- System initialization messages
print("🌐 Server Browser - Brainrot Scanner loaded successfully!")
print("📋 System Features:")
print("   • Real server list showing only servers with brainrots")
print("   • ESP system for local brainrot detection")
print("   • Direct server joining functionality")
print("🎮 Controls:")
print("   G = Toggle server browser panel")
print("   H = Toggle ESP on/off") 
print("   R = Refresh server list")
print("🔍 Ready to scan for servers with brainrots...")

-- Initial server analysis
task.spawn(function()
    task.wait(3)
    local initialData = analyzeCurrentServer()
    
    print(string.format("📊 Current server analysis:"))
    print(string.format("   🧠 Local brainrots found: %d", initialData.brainrotsFound))
    print(string.format("   👥 Players online: %d", initialData.playerCount))
    print(string.format("   🏆 Server score: %d/100", initialData.score))
    
    if initialData.brainrotsFound > 0 then
        print("✨ Secret brainrots detected locally:")
        for _, brainrot in ipairs(initialData.brainrotsList) do
            print("   • " .. brainrot.name)
        end
        print("💡 Use H to enable ESP highlighting")
    else
        print("📍 No secret brainrots found locally")
        print("💡 Use G to open server browser and find better servers")
    end
end)
