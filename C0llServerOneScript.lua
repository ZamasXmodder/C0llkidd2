-- Live Server Brainrot Detection System
-- Real server hopping with brainrot detection focused on Workspace
-- Press G for panel, H for ESP toggle, J for server hop

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
local serverHoppingActive = false

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

-- Function to perform server hop with retry mechanism
local function performServerHop()
    print("🚀 Attempting to join a different server...")
    
    -- Generate a small random delay to avoid same server rejoining
    local randomDelay = math.random(100, 500) / 1000
    task.wait(randomDelay)
    
    local attempts = 0
    local maxAttempts = 3
    
    while attempts < maxAttempts do
        attempts = attempts + 1
        
        local success, errorMessage = pcall(function()
            -- Use TeleportService with a small delay between attempts
            TeleportService:TeleportAsync(game.PlaceId, {player})
        end)
        
        if success then
            print("✅ Server hop initiated successfully")
            return true
        else
            print("⚠️ Server hop attempt " .. attempts .. " failed: " .. tostring(errorMessage))
            if attempts < maxAttempts then
                print("🔄 Retrying in 2 seconds...")
                task.wait(2)
            end
        end
    end
    
    -- Fallback method
    print("🔄 Trying fallback teleport method...")
    local fallbackSuccess, fallbackError = pcall(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)
    
    if not fallbackSuccess then
        warn("❌ All server hop attempts failed: " .. tostring(fallbackError))
        return false
    end
    
    return true
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
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, -1, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 50)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🎯 LIVE SERVER BRAINROT SCANNER"
    title.TextColor3 = Color3.fromRGB(255, 150, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Info panel
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, -20, 0, 220)
    infoFrame.Position = UDim2.new(0, 10, 0, 70)
    infoFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = mainFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoFrame
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoDisplay"
    infoLabel.Size = UDim2.new(1, -20, 1, -20)
    infoLabel.Position = UDim2.new(0, 10, 0, 10)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "🔄 Initializing server analysis..."
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextSize = 14
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.TextWrapped = true
    infoLabel.Parent = infoFrame
    
    -- Control buttons
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, -20, 0, 80)
    buttonFrame.Position = UDim2.new(0, 10, 0, 300)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = mainFrame
    
    -- ESP Toggle Button
    local espButton = Instance.new("TextButton")
    espButton.Name = "ESPToggle"
    espButton.Size = UDim2.new(0.48, 0, 0.45, 0)
    espButton.Position = UDim2.new(0, 0, 0, 0)
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
    
    -- Server Hop Button
    local hopButton = Instance.new("TextButton")
    hopButton.Size = UDim2.new(0.48, 0, 0.45, 0)
    hopButton.Position = UDim2.new(0.52, 0, 0, 0)
    hopButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    hopButton.BorderSizePixel = 0
    hopButton.Text = "🚀 HOP SERVER"
    hopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    hopButton.TextScaled = true
    hopButton.Font = Enum.Font.GothamBold
    hopButton.Parent = buttonFrame
    
    local hopCorner = Instance.new("UICorner")
    hopCorner.CornerRadius = UDim.new(0, 6)
    hopCorner.Parent = hopButton
    
    -- Scan Button
    local scanButton = Instance.new("TextButton")
    scanButton.Size = UDim2.new(1, 0, 0.45, 0)
    scanButton.Position = UDim2.new(0, 0, 0.55, 0)
    scanButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
    scanButton.BorderSizePixel = 0
    scanButton.Text = "🔍 SCAN CURRENT SERVER"
    scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    scanButton.TextScaled = true
    scanButton.Font = Enum.Font.GothamBold
    scanButton.Parent = buttonFrame
    
    local scanCorner = Instance.new("UICorner")
    scanCorner.CornerRadius = UDim.new(0, 6)
    scanCorner.Parent = scanButton
    
    -- Function to update server information display
    local function updateServerInfo()
        local data = analyzeCurrentServer()
        local brainrotDetails = {}
        
        for i, brainrot in ipairs(data.brainrotsList) do
            table.insert(brainrotDetails, string.format("  %d. %s", i, brainrot.name))
        end
        
        local qualityRating = ""
        if data.score >= 80 then
            qualityRating = "⭐ EXCELLENT SERVER"
        elseif data.score >= 60 then
            qualityRating = "✅ GOOD SERVER"
        elseif data.score >= 40 then
            qualityRating = "⚠️ AVERAGE SERVER"
        else
            qualityRating = "❌ POOR SERVER"
        end
        
        local displayText = string.format([[📊 CURRENT SERVER ANALYSIS

🏆 Server Quality: %s
📊 Score: %d points

🧠 Brainrots in Workspace: %d
👥 Players Online: %d
🆔 Job ID: %s

📋 DETECTED BRAINROTS:
%s

💡 Recommendation: %s

🕒 Last Updated: %s]], 
            qualityRating,
            data.score,
            data.brainrotsFound,
            data.playerCount,
            string.sub(data.jobId, 1, 8) .. "...",
            data.brainrotsFound > 0 and table.concat(brainrotDetails, "\n") or "  No secret brainrots found",
            data.score >= 60 and "Stay in this server!" or "Consider server hopping for better results",
            os.date("%H:%M:%S")
        )
        
        infoLabel.Text = displayText
    end
    
    -- Button event handlers
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
        updateServerInfo()
        
        if currentServerData.score >= 70 then
            print("⚠️ Current server has high score: " .. currentServerData.score)
            print("🤔 Are you sure you want to leave? Press J to force hop.")
        else
            print("🚀 Current server score: " .. currentServerData.score .. " - Hopping to find better server...")
            performServerHop()
        end
    end)
    
    scanButton.MouseButton1Click:Connect(updateServerInfo)
    
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
            local espButton = gui.MainFrame.Frame.ESPToggle
            if espButton then
                espButton.MouseButton1Click:Fire()
            end
        end
    elseif input.KeyCode == Enum.KeyCode.J then
        print("🚀 Force server hop initiated...")
        performServerHop()
    end
end)

-- Cleanup on player removal
Players.PlayerRemoving:Connect(function(playerLeaving)
    if playerLeaving == player then
        clearESP()
    end
end)

-- System initialization messages
print("🎯 Live Server Brainrot Scanner loaded successfully!")
print("📋 System Features:")
print("   • Real server hopping with improved teleport methods")
print("   • ESP system focused on Workspace brainrots only")
print("   • Automatic server quality analysis")
print("🎮 Controls:")
print("   G = Toggle control panel")
print("   H = Toggle ESP on/off") 
print("   J = Force server hop")
print("🔍 Scanning workspace for brainrots...")

-- Initial server analysis
task.spawn(function()
    task.wait(3)
    local initialData = analyzeCurrentServer()
    
    print(string.format("📊 Initial analysis complete:"))
    print(string.format("   🧠 Brainrots found: %d", initialData.brainrotsFound))
    print(string.format("   👥 Players online: %d", initialData.playerCount))
    print(string.format("   🏆 Server score: %d/100", initialData.score))
    
    if initialData.brainrotsFound > 0 then
        print("✨ Secret brainrots detected in workspace:")
        for _, brainrot in ipairs(initialData.brainrotsList) do
            print("   • " .. brainrot.name)
        end
        print("💡 Use H to enable ESP highlighting")
    else
        print("📍 No secret brainrots found in workspace")
        print("💡 Use J to hop to a different server")
    end
end)
