-- Panel Básico con solo 2 funciones - Versión Corregida

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local noclipEnabled = false
local antiDetectionEnabled = false
local noclipConnection

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimplePanel"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BorderSizePixel = 0
title.Text = "Simple Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.Gotham
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Botón Noclip
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(1, -20, 0, 30)
noclipBtn.Position = UDim2.new(0, 10, 0, 50)
noclipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noclipBtn.BorderSizePixel = 0
noclipBtn.Text = "Noclip: OFF"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.TextScaled = true
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.Parent = mainFrame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 5)
noclipCorner.Parent = noclipBtn

-- Botón Anti-Detection
local antiBtn = Instance.new("TextButton")
antiBtn.Size = UDim2.new(1, -20, 0, 30)
antiBtn.Position = UDim2.new(0, 10, 0, 90)
antiBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
antiBtn.BorderSizePixel = 0
antiBtn.Text = "Anti-Detection: OFF"
antiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
antiBtn.TextScaled = true
antiBtn.Font = Enum.Font.Gotham
antiBtn.Parent = mainFrame

local antiCorner = Instance.new("UICorner")
antiCorner.CornerRadius = UDim.new(0, 5)
antiCorner.Parent = antiBtn

-- Función Noclip
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        noclipBtn.Text = "Noclip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        noclipConnection = RunService.Stepped:Connect(function()
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "Noclip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Función Anti-Detection (Simplificada y Segura)
antiBtn.MouseButton1Click:Connect(function()
    antiDetectionEnabled = not antiDetectionEnabled
    
    if antiDetectionEnabled then
        antiBtn.Text = "Anti-Detection: ON"
        antiBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Anti-kick más simple y seguro
        local oldKick = player.Kick
        player.Kick = function()
            -- Bloquear kicks silenciosamente
            return
        end
        
        -- Proteger contra teleports forzados
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local originalCFrame = player.Character.HumanoidRootPart.CFrame
            player.Character.HumanoidRootPart.Changed:Connect(function(property)
                if property == "CFrame" and antiDetectionEnabled then
                    -- Evitar teleports sospechosos
                    local newPos = player.Character.HumanoidRootPart.Position
                    if newPos.Y < -1000 then
                        player.Character.HumanoidRootPart.CFrame = originalCFrame
                    end
                end
            end)
        end
        
    else
        antiBtn.Text = "Anti-Detection: OFF"
        antiBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        -- Restaurar función original si es posible
        pcall(function()
            player.Kick = Players.LocalPlayer.Kick
        end)
    end
end)

-- Toggle panel con Insert
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Restaurar noclip al respawnear
player.CharacterAdded:Connect(function()
    if noclipEnabled then
        wait(1)
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        noclipConnection = RunService.Stepped:Connect(function()
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

print("Panel cargado - Presiona INSERT para abrir/cerrar")
