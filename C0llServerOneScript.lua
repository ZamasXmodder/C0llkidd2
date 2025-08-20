local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotHack"
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 400)
main.Position = UDim2.new(0.5, -150, 0.5, -200)
main.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.new(0, 0.6, 1)
main.Active = true
main.Draggable = true
main.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0, 0.6, 1)
title.Text = "🧠 BRAINROT STEALER"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = main

-- Variables
local speedHack = false
local jumpHack = false
local currentSpeed = 16
local currentJump = 50

-- Speed Control
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. currentSpeed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextScaled = true
speedLabel.Parent = main

local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0.6, 0, 0, 25)
speedSlider.Position = UDim2.new(0, 10, 0, 70)
speedSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
speedSlider.BorderColor3 = Color3.new(0, 0.6, 1)
speedSlider.Text = "16"
speedSlider.TextColor3 = Color3.new(1, 1, 1)
speedSlider.TextScaled = true
speedSlider.Parent = main

local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.35, -5, 0, 25)
speedBtn.Position = UDim2.new(0.65, 0, 0, 70)
speedBtn.BackgroundColor3 = Color3.new(0, 0.6, 1)
speedBtn.Text = "Enable Speed"
speedBtn.TextColor3 = Color3.new(1, 1, 1)
speedBtn.TextScaled = true
speedBtn.Parent = main

-- Jump Control
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(1, -20, 0, 25)
jumpLabel.Position = UDim2.new(0, 10, 0, 105)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Jump Power: " .. currentJump
jumpLabel.TextColor3 = Color3.new(1, 1, 1)
jumpLabel.TextScaled = true
jumpLabel.Parent = main

local jumpSlider = Instance.new("TextBox")
jumpSlider.Size = UDim2.new(0.6, 0, 0, 25)
jumpSlider.Position = UDim2.new(0, 10, 0, 135)
jumpSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
jumpSlider.BorderColor3 = Color3.new(0, 0.6, 1)
jumpSlider.Text = "50"
jumpSlider.TextColor3 = Color3.new(1, 1, 1)
jumpSlider.TextScaled = true
jumpSlider.Parent = main

local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0.35, -5, 0, 25)
jumpBtn.Position = UDim2.new(0.65, 0, 0, 135)
jumpBtn.BackgroundColor3 = Color3.new(0, 0.6, 1)
jumpBtn.Text = "Enable Jump"
jumpBtn.TextColor3 = Color3.new(1, 1, 1)
jumpBtn.TextScaled = true
jumpBtn.Parent = main

-- Server Hop Button
local serverBtn = Instance.new("TextButton")
serverBtn.Size = UDim2.new(0.9, 0, 0, 35)
serverBtn.Position = UDim2.new(0.05, 0, 0, 175)
serverBtn.BackgroundColor3 = Color3.new(0, 0.8, 0)
serverBtn.Text = "🤑 Find Rich Players"
serverBtn.TextColor3 = Color3.new(1, 1, 1)
serverBtn.TextScaled = true
serverBtn.Font = Enum.Font.SourceSansBold
serverBtn.Parent = main

-- Auto Farm Button
local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(0.9, 0, 0, 35)
farmBtn.Position = UDim2.new(0.05, 0, 0, 220)
farmBtn.BackgroundColor3 = Color3.new(0.8, 0, 0.8)
farmBtn.Text = "Auto Farm: OFF"
farmBtn.TextColor3 = Color3.new(1, 1, 1)
farmBtn.TextScaled = true
farmBtn.Font = Enum.Font.SourceSansBold
farmBtn.Parent = main

-- Teleport to Players
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 35)
tpBtn.Position = UDim2.new(0.05, 0, 0, 265)
tpBtn.BackgroundColor3 = Color3.new(0.8, 0.4, 0)
tpBtn.Text = "TP to Richest Player"
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.TextScaled = true
tpBtn.Font = Enum.Font.SourceSansBold
tpBtn.Parent = main

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.new(1, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextScaled = true
closeBtn.Parent = main

-- Funciones
local function updateCharacter()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        
        if speedHack then
            humanoid.WalkSpeed = currentSpeed
        end
        
        if jumpHack then
            humanoid.JumpPower = currentJump
        end
    end
end

-- Speed Events
speedSlider.FocusLost:Connect(function()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed and newSpeed >= 1 and newSpeed <= 500 then
        currentSpeed = newSpeed
        speedLabel.Text = "Speed: " .. currentSpeed
        updateCharacter()
    else
        speedSlider.Text = tostring(currentSpeed)
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    speedHack = not speedHack
    if speedHack then
        speedBtn.Text = "Disable Speed"
        speedBtn.BackgroundColor3 = Color3.new(1, 0, 0)
    else
        speedBtn.Text = "Enable Speed"
        speedBtn.BackgroundColor3 = Color3.new(0, 0.6, 1)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
    updateCharacter()
end)

-- Jump Events
jumpSlider.FocusLost:Connect(function()
    local newJump = tonumber(jumpSlider.Text)
    if newJump and newJump >= 1 and newJump <= 1000 then
        currentJump = newJump
        jumpLabel.Text = "Jump Power: " .. currentJump
        updateCharacter()
    else
        jumpSlider.Text = tostring(currentJump)
    end
end)

jumpBtn.MouseButton1Click:Connect(function()
    jumpHack = not jumpHack
    if jumpHack then
        jumpBtn.Text = "Disable Jump"
        jumpBtn.BackgroundColor3 = Color3.new(1, 0, 0)
    else
        jumpBtn.Text = "Enable Jump"
        jumpBtn.BackgroundColor3 = Color3.new(0, 0.6, 1)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 50
        end
    end
    updateCharacter()
end)

-- Server Hop
serverBtn.MouseButton1Click:Connect(function()
    serverBtn.Text = "Searching..."
    
    local success, result = pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        
        for i, server in pairs(servers.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers - 1 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                break
            end
        end
    end)
    
    if not success then
        serverBtn.Text = "Error - Try Again"
        wait(2)
        serverBtn.Text = "🤑 Find Rich Players"
    end
end)

-- Auto Farm
local autoFarm = false
farmBtn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    if autoFarm then
        farmBtn.Text = "Auto Farm: ON"
        farmBtn.BackgroundColor3 = Color3.new(0, 1, 0)
    else
        farmBtn.Text = "Auto Farm: OFF"
        farmBtn.BackgroundColor3 = Color3.new(0.8, 0, 0.8)
    end
end)

-- TP to Richest Player
tpBtn.MouseButton1Click:Connect(function()
    local richestPlayer = nil
    local highestMoney = 0
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Buscar leaderstats
            if otherPlayer:FindFirstChild("leaderstats") then
                for _, stat in pairs(otherPlayer.leaderstats:GetChildren()) do
                    if stat.Name:lower():find("money") or stat.Name:lower():find("cash") or stat.Name:lower():find("coins") then
                        local money = tonumber(stat.Value) or 0
                        if money > highestMoney then
                            highestMoney = money
                            richestPlayer = otherPlayer
                        end
                    end
                end
            end
        end
    end
    
    if richestPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = richestPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
        tpBtn.Text = "Teleported to " .. richestPlayer.Name
        wait(2)
        tpBtn.Text = "TP to Richest Player"
    else
        tpBtn.Text = "No Rich Players Found"
        wait(2)
        tpBtn.Text = "TP to Richest Player"
    end
end)

-- Close Button
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Mantener activo cuando respawnea
player.CharacterAdded:Connect(function()
    wait(1)
    updateCharacter()
end)

-- Auto Farm Loop
spawn(function()
    while gui.Parent do
        if autoFarm and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Aquí puedes agregar lógica específica del juego
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name:find("Money") or obj.Name:find("Cash") or obj.Name:find("Coin") then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                    end
                end
            end
        end
        wait(0.1)
    end
end)

print("✅ Brainrot Panel Loaded!")
