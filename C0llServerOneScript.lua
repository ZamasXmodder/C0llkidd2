-- Script funcional para Steal a Brainrot

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- Crear GUI simple que funcione
local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotHack"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 350)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.Text = "BRAINROT HACK"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Variables globales
_G.SpeedEnabled = false
_G.JumpEnabled = false
_G.CurrentSpeed = 50
_G.CurrentJump = 120

-- Speed
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. _G.CurrentSpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 12
speedLabel.Parent = frame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.6, 0, 0, 25)
speedBox.Position = UDim2.new(0, 10, 0, 65)
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.Text = tostring(_G.CurrentSpeed)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 12
speedBox.Parent = frame

local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.35, 0, 0, 25)
speedBtn.Position = UDim2.new(0.65, 0, 0, 65)
speedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
speedBtn.Text = "ON"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextSize = 12
speedBtn.Parent = frame

-- Jump
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(1, 0, 0, 20)
jumpLabel.Position = UDim2.new(0, 0, 0, 100)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Jump: " .. _G.CurrentJump
jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpLabel.TextSize = 12
jumpLabel.Parent = frame

local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0.6, 0, 0, 25)
jumpBox.Position = UDim2.new(0, 10, 0, 125)
jumpBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpBox.Text = tostring(_G.CurrentJump)
jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBox.TextSize = 12
jumpBox.Parent = frame

local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0.35, 0, 0, 25)
jumpBtn.Position = UDim2.new(0.65, 0, 0, 125)
jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
jumpBtn.Text = "ON"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.TextSize = 12
jumpBtn.Parent = frame

-- Server Hop
local serverBtn = Instance.new("TextButton")
serverBtn.Size = UDim2.new(0.9, 0, 0, 30)
serverBtn.Position = UDim2.new(0.05, 0, 0, 160)
serverBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
serverBtn.Text = "BUSCAR SERVER RICO"
serverBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
serverBtn.TextSize = 11
serverBtn.Font = Enum.Font.SourceSansBold
serverBtn.Parent = frame

-- TP to Rich Player
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 30)
tpBtn.Position = UDim2.new(0.05, 0, 0, 200)
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
tpBtn.Text = "TP AL MAS RICO"
tpBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
tpBtn.TextSize = 11
tpBtn.Font = Enum.Font.SourceSansBold
tpBtn.Parent = frame

-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Parent = frame

-- FUNCIONES QUE SÍ FUNCIONAN

-- Función para aplicar speed
local function applySpeed()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if _G.SpeedEnabled then
            player.Character.Humanoid.WalkSpeed = _G.CurrentSpeed
        else
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end

-- Función para aplicar jump
local function applyJump()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if _G.JumpEnabled then
            player.Character.Humanoid.JumpPower = _G.CurrentJump
        else
            player.Character.Humanoid.JumpPower = 50
        end
    end
end

-- Speed Events
speedBox.FocusLost:Connect(function()
    local newSpeed = tonumber(speedBox.Text)
    if newSpeed and newSpeed > 0 and newSpeed <= 1000 then
        _G.CurrentSpeed = newSpeed
        speedLabel.Text = "Speed: " .. _G.CurrentSpeed
        applySpeed()
    else
        speedBox.Text = tostring(_G.CurrentSpeed)
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    if _G.SpeedEnabled then
        speedBtn.Text = "ON"
        speedBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        speedBtn.Text = "OFF"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
    applySpeed()
end)

-- Jump Events
jumpBox.FocusLost:Connect(function()
    local newJump = tonumber(jumpBox.Text)
    if newJump and newJump > 0 and newJump <= 1000 then
        _G.CurrentJump = newJump
        jumpLabel.Text = "Jump: " .. _G.CurrentJump
        applyJump()
    else
        jumpBox.Text = tostring(_G.CurrentJump)
    end
end)

jumpBtn.MouseButton1Click:Connect(function()
    _G.JumpEnabled = not _G.JumpEnabled
    if _G.JumpEnabled then
        jumpBtn.Text = "ON"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        jumpBtn.Text = "OFF"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
    applyJump()
end)

-- Server Hop que funciona
serverBtn.MouseButton1Click:Connect(function()
    serverBtn.Text = "BUSCANDO..."
    
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)
        
        local servers = {}
        for _, server in pairs(data.data) do
            if server.id ~= game.JobId and server.playing > 5 and server.playing < server.maxPlayers then
                table.insert(servers, server)
            end
        end
        
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id, player)
        else
            serverBtn.Text = "NO HAY SERVERS"
            wait(2)
            serverBtn.Text = "BUSCAR SERVER RICO"
        end
    end)
    
    if not success then
        serverBtn.Text = "ERROR"
        wait(2)
        serverBtn.Text = "BUSCAR SERVER RICO"
    end
end)

-- TP to richest player
tpBtn.MouseButton1Click:Connect(function()
    local richestPlayer = nil
    local highestMoney = 0
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local leaderstats = otherPlayer:FindFirstChild("leaderstats")
            if leaderstats then
                for _, stat in pairs(leaderstats:GetChildren()) do
                    if stat.Name:lower():match("money") or stat.Name:lower():match("cash") or 
                       stat.Name:lower():match("coins") or stat.Name:lower():match("dollars") then
                        local value = tonumber(stat.Value) or 0
                        if value > highestMoney then
                            highestMoney = value
                            richestPlayer = otherPlayer
                        end
                    end
                end
            end
        end
    end
    
    if richestPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = richestPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
        tpBtn.Text = "TP A " .. richestPlayer.Name:upper()
        wait(2)
        tpBtn.Text = "TP AL MAS RICO"
    else
        tpBtn.Text = "NO HAY RICOS"
        wait(2)
        tpBtn.Text = "TP AL MAS RICO"
    end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Mantener activo cuando respawnea
player.CharacterAdded:Connect(function(character)
    wait(1)
    applySpeed()
    applyJump()
end)

-- Loop para mantener los valores
spawn(function()
    while gui.Parent do
        wait(0.5)
        applySpeed()
        applyJump()
    end
end)

print("✅ BRAINROT HACK CARGADO - Todo funcional!")
