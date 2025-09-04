--// Variables
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Estado
local carryingBrainrot = false
local playerBasePosition = nil

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotHelper"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0, 20, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "🧠 Brainrot Helper"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 25)
statusLabel.Position = UDim2.new(0, 5, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Sin brainrot"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

local baseLabel = Instance.new("TextLabel")
baseLabel.Size = UDim2.new(1, -10, 0, 25)
baseLabel.Position = UDim2.new(0, 5, 0, 65)
baseLabel.BackgroundTransparency = 1
baseLabel.Text = "Base: No registrada"
baseLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
baseLabel.Font = Enum.Font.Gotham
baseLabel.TextSize = 14
baseLabel.TextXAlignment = Enum.TextXAlignment.Left
baseLabel.Parent = frame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 0, 25)
infoLabel.Position = UDim2.new(0, 5, 0, 95)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Presiona V para TP"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 13
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = frame

-- Actualizar GUI
local function updateStatus()
    if carryingBrainrot then
        statusLabel.Text = "Estado: ✅ Brainrot cargado"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        statusLabel.Text = "Estado: Sin brainrot"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end

    if playerBasePosition then
        baseLabel.Text = "Base: Registrada"
        baseLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        baseLabel.Text = "Base: No registrada"
        baseLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- Detectar cuando el jugador carga un brainrot
-- (busca si se parenta un modelo llamado "Brainrot" al character)
player.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(obj)
        if obj:IsA("Model") and obj.Name:lower():find("brainrot") then
            carryingBrainrot = true
            updateStatus()
        end
    end)

    char.ChildRemoved:Connect(function(obj)
        if obj:IsA("Model") and obj.Name:lower():find("brainrot") then
            carryingBrainrot = false
            updateStatus()
        end
    end)
end)

-- Guardar base al tocar la parte
local basePart = Workspace:WaitForChild("BasePart") -- cambia este nombre por el part de tu base
basePart.Touched:Connect(function(hit)
    local character = player.Character
    if character and hit.Parent == character and character:FindFirstChild("HumanoidRootPart") then
        playerBasePosition = character.HumanoidRootPart.CFrame
        print("✅ Base guardada:", tostring(playerBasePosition))
        updateStatus()
    end
end)

-- Smart Teleport
local function smartTeleport()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not playerBasePosition then 
        return 
    end

    if carryingBrainrot then
        wait(0.5)
        character.HumanoidRootPart.CFrame = playerBasePosition
        print("🚀 Teleport a la base con brainrot!")
        carryingBrainrot = false
        updateStatus()
    end
end

-- Input (tecla V)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.V then
        smartTeleport()
    end
end)

-- Inicializar GUI
updateStatus()
