-- Script unificado Anti-Hit para Steal a Brainrot
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- Buscar el RemoteEvent existente del juego
local function findAntiHitRemote()
    for _, obj in pairs(RS:GetDescendants()) do
        if obj:IsA("RemoteEvent") and (
            obj.Name:lower():find("antihit") or 
            obj.Name:lower():find("invulner") or
            obj.Name:lower():find("protect")
        ) then
            return obj
        end
    end
    return nil
end

local Remote = findAntiHitRemote()

if not Remote then
    warn("No se encontró RemoteEvent de Anti-Hit en el juego")
    return
end

-- GUI
local sg = Instance.new("ScreenGui")
sg.Name = "AntiHitExploit"
sg.ResetOnSpawn = false
sg.Parent = plr:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 48)
btn.Position = UDim2.new(0.5, -100, 0.85, 0)
btn.Text = "Anti-Hit Exploit"
btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
btn.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = btn

local busy = false

btn.MouseButton1Click:Connect(function()
    if busy then return end
    busy = true
    
    -- Activar anti-hit
    pcall(function()
        Remote:FireServer()
    end)
    
    btn.Text = "Activado!"
    btn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    
    wait(2)
    
    btn.Text = "Anti-Hit Exploit"
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    busy = false
end)

print("Anti-Hit Exploit cargado para Steal a Brainrot")
