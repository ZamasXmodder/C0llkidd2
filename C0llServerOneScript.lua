local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotPanel"
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Text = "🧠 Brainrot Stealer Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Variables para las funciones
local originalWalkSpeed = 16
local originalJumpPower = 50
local speedEnabled = false
local jumpEnabled = false

-- Función para crear sliders
local function createSlider(parent, name, position, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    sliderFrame.Position = position
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 20)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.Parent = sliderFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 10)
    fillCorner.Parent = sliderFill
    
    local currentValue = defaultVal
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = UserInputService.InputChanged:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseMovement then
                    local mouse = Players.LocalPlayer:GetMouse()
                    local relativeX = math.clamp((mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    currentValue = math.floor(minVal + (maxVal - minVal) * relativeX)
                    
                    sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    label.Text = name .. ": " .. currentValue
                    
                    if callback then
                        callback(currentValue)
                    end
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input3)
                if input3.UserInputType == Enum.UserInputType.MouseButton1 then
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    return currentValue
end

-- Función para crear botones
local function createButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Speed Slider
local speedValue = 16
createSlider(mainFrame, "Speed", UDim2.new(0.05, 0, 0, 60), 16, 200, 16, function(value)
    speedValue = value
    if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

-- Jump Power Slider
local jumpValue = 50
createSlider(mainFrame, "Jump Power", UDim2.new(0.05, 0, 0, 130), 50, 300, 50, function(value)
    jumpValue = value
    if jumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

-- Speed Toggle Button
local speedButton = createButton(mainFrame, "Enable Speed", UDim2.new(0.05, 0, 0, 200), UDim2.new(0.4, 0, 0, 35), function()
    speedEnabled = not speedEnabled
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if speedEnabled then
            player.Character.Humanoid.WalkSpeed = speedValue
            speedButton.Text = "Disable Speed"
            speedButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        else
            player.Character.Humanoid.WalkSpeed = originalWalkSpeed
            speedButton.Text = "Enable Speed"
            speedButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        end
    end
end)

-- Jump Toggle Button
local jumpButton = createButton(mainFrame, "Enable Jump", UDim2.new(0.55, 0, 0, 200), UDim2.new(0.4, 0, 0, 35), function()
    jumpEnabled = not jumpEnabled
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if jumpEnabled then
            player.Character.Humanoid.JumpPower = jumpValue
            jumpButton.Text = "Disable Jump"
            jumpButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        else
            player.Character.Humanoid.JumpPower = originalJumpPower
            jumpButton.Text = "Enable Jump"
            jumpButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        end
    end
end)

-- Rich Server Finder
local richServerButton = createButton(mainFrame, "🤑 Find Rich Server", UDim2.new(0.05, 0, 0, 250), UDim2.new(0.9, 0, 0, 40), function()
    richServerButton.Text = "Searching..."
    richServerButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    
    spawn(function()
        local success, servers = pcall(function()
            return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        
        if success and servers.data then
            local bestServer = nil
            local highestMoney = 0
            
            for _, server in pairs(servers.data) do
                if server.playing and server.playing > 5 then
                    -- Simular búsqueda de dinero (esto dependería del juego específico)
                    local estimatedMoney = server.playing * math.random(1000000, 10000000000)
                    if estimatedMoney > highestMoney then
                        highestMoney = estimatedMoney
                        bestServer = server
                    end
                end
            end
            
            if bestServer then
                richServerButton.Text = "Joining Rich Server..."
                wait(1)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, bestServer.id, player)
            else
                richServerButton.Text = "No Rich Servers Found"
                richServerButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                wait(2)
                richServerButton.Text = "🤑 Find Rich Server"
                richServerButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            end
        else
            richServerButton.Text = "Search Failed"
            richServerButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            wait(2)
            richServerButton.Text = "🤑 Find Rich Server"
            richServerButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        end
    end)
end)

-- Auto-steal function (ejemplo básico)
local autoStealEnabled = false
local autoStealButton = createButton(mainFrame, "Auto Steal: OFF", UDim2.new(0.05, 0, 0, 300), UDim2.new(0.9, 0, 0, 40), function()
    autoStealEnabled = not autoStealEnabled
    if autoStealEnabled then
        autoStealButton.Text = "Auto Steal: ON"
        autoStealButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        
        spawn(function()
            while autoStealEnabled do
                -- Aquí iría la lógica específica del juego para robar
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character then
                        -- Lógica de robo automático
                        -- Esto dependería de cómo funcione el juego específicamente
                    end
                end
                wait(0.1)
            end
        end)
    else
        autoStealButton.Text = "Auto Steal: OFF"
        autoStealButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    end
end)

-- Botón de cerrar
local closeButton = createButton(mainFrame, "X", UDim2.new(0.9, 0, 0, 5), UDim2.new(0, 30, 0, 30), function()
    screenGui:Destroy()
end)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

-- Hacer el panel arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Mantener las funciones activas cuando el personaje respawnea
player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    if speedEnabled then
        humanoid.WalkSpeed = speedValue
    end
    
    if jumpEnabled then
        humanoid.JumpPower = jumpValue
    end
end)

print("🧠 Brainrot Stealer Panel loaded successfully!")
