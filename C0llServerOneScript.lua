-- // LaserCape Aimbot Panel Script
-- Hecho para ejecutor (LocalScript)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cargar Net
local Net = require(ReplicatedStorage:WaitForChild("Packages").Net)
local LaserEvent = Net:RemoteEvent("UseItem")

-- Estado
local aimbotEnabled = false
local multiAimbotEnabled = false

-- Funcion: jugador mas cercano
local function getClosestPlayer(maxDistance)
    local closest, distance = nil, maxDistance or 1000
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if mag < distance then
                closest, distance = player, mag
            end
        end
    end
    return closest
end

-- Funcion: disparar laser
local function shootAt(target)
    if target and target:FindFirstChild("HumanoidRootPart") then
        LaserEvent:FireServer(target.HumanoidRootPart.Position, target.HumanoidRootPart)
    end
end

-- Loop de aimbot
task.spawn(function()
    while task.wait(0.2) do
        if aimbotEnabled then
            local target = getClosestPlayer(150)
            if target then
                shootAt(target.Character)
            end
        elseif multiAimbotEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 150 then
                        shootAt(player.Character)
                    end
                end
            end
        end
    end
end)

-- // GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "LaserCapePanel"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.35, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = false

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Boton 1: Aimbot
local BtnAimbot = Instance.new("TextButton", Frame)
BtnAimbot.Size = UDim2.new(0, 160, 0, 30)
BtnAimbot.Text = "Toggle Aimbot"
BtnAimbot.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BtnAimbot.TextColor3 = Color3.fromRGB(255, 255, 255)

BtnAimbot.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    multiAimbotEnabled = false
    BtnAimbot.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

-- Boton 2: Multi-Aimbot
local BtnMulti = Instance.new("TextButton", Frame)
BtnMulti.Size = UDim2.new(0, 160, 0, 30)
BtnMulti.Text = "Toggle Multi-Aimbot"
BtnMulti.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BtnMulti.TextColor3 = Color3.fromRGB(255, 255, 255)

BtnMulti.MouseButton1Click:Connect(function()
    multiAimbotEnabled = not multiAimbotEnabled
    aimbotEnabled = false
    BtnMulti.Text = multiAimbotEnabled and "Multi-Aimbot: ON" or "Multi-Aimbot: OFF"
end)

-- Boton 3: Cerrar panel
local BtnClose = Instance.new("TextButton", Frame)
BtnClose.Size = UDim2.new(0, 160, 0, 30)
BtnClose.Text = "Cerrar Panel"
BtnClose.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
BtnClose.TextColor3 = Color3.fromRGB(255, 255, 255)

BtnClose.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

-- Toggle con la tecla F
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F then
        Frame.Visible = not Frame.Visible
    end
end)
