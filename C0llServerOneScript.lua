-- Panel con Teletransporte para Steal a Brainbot - Corregido

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local antiDetectionEnabled = false
local autoCollectEnabled = false
local autoCollectConnection
local savedPosition = nil

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportPanel"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 220)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.BorderSizePixel = 0
title.Text = "🤖 Brainbot Teleport"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Función para crear botones
local function createButton(text, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 25)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Función de teletransporte seguro
local function safeTeleport(position)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Botón para guardar posición
local saveBtn = createButton("💾 Save Position", 45, function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.Position
        saveBtn.Text = "💾 Position Saved!"
        saveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        spawn(function()
            wait(1)
            saveBtn.Text = "💾 Save Position"
            saveBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    end
end)

-- Botón para volver a posición guardada
local returnBtn = createButton("🏠 Return to Saved", 75, function()
    if savedPosition then
        safeTeleport(savedPosition)
        returnBtn.Text = "🏠 Teleported!"
        returnBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        spawn(function()
            wait(1)
            returnBtn.Text = "🏠 Return to Saved"
            returnBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    else
        returnBtn.Text = "❌ No Position Saved"
        returnBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        
        spawn(function()
            wait(1)
            returnBtn.Text = "🏠 Return to Saved"
            returnBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    end
end)

-- Botón para teleportarse a brainbots
local botBtn = createButton("🤖 TP to Brainbot", 105, function()
    local nearestBot = nil
    local shortestDistance = math.huge
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("brainbot") or obj.Name:lower():find("bot")) then
            local humanoidRootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
            if humanoidRootPart then
                local distance = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestBot = humanoidRootPart
                end
            end
        end
    end
    
    if nearestBot then
        safeTeleport(nearestBot.Position + Vector3.new(0, 5, 0))
        botBtn.Text = "🤖 Teleported!"
        botBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        spawn(function()
            wait(1)
            botBtn.Text = "🤖 TP to Brainbot"
            botBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    else
        botBtn.Text = "❌ No Brainbot Found"
        botBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        
        spawn(function()
            wait(1)
            botBtn.Text = "🤖 TP to Brainbot"
            botBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    end
end)

-- Botón auto-collect
local collectBtn = createButton("🔄 Auto Collect: OFF", 135, function()
    autoCollectEnabled = not autoCollectEnabled
    
    if autoCollectEnabled then
        collectBtn.Text = "🔄 Auto Collect: ON"
        collectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        autoCollectConnection = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:lower():find("brainbot") or obj.Name:lower():find("bot")) then
                    local humanoidRootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                    if humanoidRootPart then
                        local distance = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                        if distance < 50 then
                            safeTeleport(humanoidRootPart.Position)
                            wait(0.1)
                        end
                    end
                end
            end
        end)
    else
        collectBtn.Text = "🔄 Auto Collect: OFF"
        collectBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        
        if autoCollectConnection then
            autoCollectConnection:Disconnect()
            autoCollectConnection = nil
        end
    end
end)

-- Botón Anti-Detection (Corregido)
local antiBtn = createButton("🛡️ Anti-Detection: OFF", 165, function()
    antiDetectionEnabled = not antiDetectionEnabled
    
    if antiDetectionEnabled then
        antiBtn.Text = "🛡️ Anti-Detection: ON"
        antiBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Protección básica
        pcall(function()
            player.Kick = function() end
        end)
        
    else
        antiBtn.Text = "🛡️ Anti-Detection: OFF"
        antiBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

-- Botón de reset
local resetBtn = createButton("🔄 Reset All", 195, function()
    autoCollectEnabled = false
    antiDetectionEnabled = false
    savedPosition = nil
    
    if autoCollectConnection then
        autoCollectConnection:Disconnect()
        autoCollectConnection = nil
    end
    
    collectBtn.Text = "🔄 Auto Collect: OFF"
    collectBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    
    antiBtn.Text = "🛡️ Anti-Detection: OFF"
    antiBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    
    saveBtn.Text = "💾 Save Position"
    saveBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end)

-- Toggle panel con Insert
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Teletransporte rápido con teclas
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        local nearestBot = nil
        local shortestDistance = math.huge
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("brainbot") or obj.Name:lower():find("bot")) then
                local humanoidRootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                if humanoidRootPart then
                    local distance = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestBot = humanoidRootPart
                    end
                end
            end
        end
        
        if nearestBot then
            safeTeleport(nearestBot.Position + Vector3.new(0, 5, 0))
        end
    elseif input.KeyCode == Enum.KeyCode.R then
        if savedPosition then
            safeTeleport(savedPosition)
        end
    end
end)

print("Panel de Teletransporte cargado!")
print("INSERT - Abrir/cerrar panel")
print("T - Teleportarse al brainbot más cercano")
print("R - Volver a posición guardada")
