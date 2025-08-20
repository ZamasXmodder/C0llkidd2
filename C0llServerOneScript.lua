-- La Grande Combinacion Finder Script for Roblox

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LaGrandeCombinacionFinder"
screenGui.Parent = playerGui

-- Floating Button
local floatingButton = Instance.new("TextButton")
floatingButton.Name = "FloatingButton"
floatingButton.Size = UDim2.new(0, 80, 0, 80)
floatingButton.Position = UDim2.new(1, -100, 0.5, -40)
floatingButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
floatingButton.BorderSizePixel = 0
floatingButton.Text = "🏆"
floatingButton.TextSize = 32
floatingButton.Font = Enum.Font.SourceSansBold
floatingButton.TextColor3 = Color3.new(1, 1, 1)
floatingButton.Parent = screenGui

-- Make button round
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5, 0)
corner.Parent = floatingButton

-- Add glow effect
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1.2, 0, 1.2, 0)
shadow.Position = UDim2.new(-0.1, 0, -0.1, 0)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.fromRGB(255, 215, 0)
shadow.ImageTransparency = 0.5
shadow.ZIndex = -1
shadow.Parent = floatingButton

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 200, 0, 30)
statusLabel.Position = UDim2.new(1, -220, 0.5, -80)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusLabel.BackgroundTransparency = 0.3
statusLabel.BorderSizePixel = 0
statusLabel.Text = "Ready to search..."
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextStrokeTransparency = 0
statusLabel.Parent = screenGui

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 5)
statusCorner.Parent = statusLabel

-- ESP System
local espConnections = {}
local espFolder = Instance.new("Folder")
espFolder.Name = "LaGrandeCombinacionESP"
espFolder.Parent = workspace

local function createESP(part, text, color)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_" .. part.Name
    billboardGui.Adornee = part
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = espFolder
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = billboardGui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextSize = 16
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

local function findLaGrandeCombinacion()
    statusLabel.Text = "Searching current server..."
    
    -- Search for La Grande Combinacion with exact name matching
    local found = false
    local searchNames = {
        "La Grande Combinacion",
        "la grande combinacion",
        "LA GRANDE COMBINACION",
        "LaGrandeCombinacion",
        "La_Grande_Combinacion",
        "Grande Combinacion",
        "grande combinacion"
    }
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            -- Check exact name matches
            for _, searchName in pairs(searchNames) do
                if obj.Name == searchName then
                    found = true
                    statusLabel.Text = "LA GRANDE COMBINACION FOUND!"
                    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    
                    -- Create ESP
                    createESP(obj, "🏆 LA GRANDE COMBINACION 🏆", Color3.fromRGB(255, 215, 0))
                    
                    -- Teleport player to the item
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                    end
                    
                    -- Play sound effect
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
                    sound.Volume = 0.5
                    sound.Parent = workspace
                    sound:Play()
                    sound.Ended:Connect(function()
                        sound:Destroy()
                    end)
                    
                    break
                end
            end
            
            -- Also check for StringValue or other value objects that might contain the name
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("StringValue") or child:IsA("ObjectValue") then
                    for _, searchName in pairs(searchNames) do
                        if child.Value == searchName or (type(child.Value) == "string" and child.Value:lower() == searchName:lower()) then
                            found = true
                            statusLabel.Text = "LA GRANDE COMBINACION FOUND!"
                            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                            createESP(obj, "🏆 LA GRANDE COMBINACION 🏆", Color3.fromRGB(255, 215, 0))
                            
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                player.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                            end
                            break
                        end
                    end
                end
            end
            
            if found then break end
        end
    end
    
    if not found then
        statusLabel.Text = "Not found. Searching servers..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        searchOtherServers()
    end
end

local function searchOtherServers()
    local gameId = game.PlaceId
    local attempts = 0
    local maxAttempts = 15
    
    spawn(function()
        while attempts < maxAttempts do
            attempts = attempts + 1
            statusLabel.Text = "Checking server " .. attempts .. "/" .. maxAttempts
            
            -- Try to join a random server
            pcall(function()
                TeleportService:TeleportToPlaceInstance(gameId, game.JobId, player)
            end)
            
            wait(3)
            
            -- Quick check in new server with exact names
            local foundInNewServer = false
            local searchNames = {"La Grande Combinacion", "la grande combinacion", "LA GRANDE COMBINACION"}
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    for _, searchName in pairs(searchNames) do
                        if obj.Name == searchName then
                            foundInNewServer = true
                            break
                        end
                    end
                    if foundInNewServer then break end
                end
            end
            
            if foundInNewServer then
                statusLabel.Text = "Found in new server!"
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                wait(1)
                findLaGrandeCombinacion()
                break
            end
            
            wait(2)
        end
        
        if attempts >= maxAttempts then
            statusLabel.Text = "Search completed. Try again later."
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
end

-- Auto-scan on join
local function autoScanOnJoin()
    wait(5) -- Wait for server to load
    findLaGrandeCombinacion()
end

-- Button click event
local isSearching = false
floatingButton.MouseButton1Click:Connect(function()
    if not isSearching then
        isSearching = true
        clearESP()
        statusLabel.TextColor3 = Color3.new(1, 1, 1)
        findLaGrandeCombinacion()
        
        wait(2)
        isSearching = false
    end
end)

-- Draggable functionality
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
        statusLabel.Position = UDim2.new(floatingButton.Position.X.Scale, floatingButton.Position.X.Offset - 120, floatingButton.Position.Y.Scale, floatingButton.Position.Y.Offset - 40)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Auto-scan when script loads
spawn(autoScanOnJoin)

print("La Grande Combinacion Finder loaded! 🏆")
print("Searching for exact name: 'La Grande Combinacion'")
