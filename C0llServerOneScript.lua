-- Panel para Steal a Brainrot - Roblox
-- Advertencia: Usar bajo tu propia responsabilidad

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables principales
local panel = nil
local isVisible = false
local autoStealEnabled = false
local autoStealConnection = nil

-- Función para crear la interfaz
local function createPanel()
    -- ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotPanel"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "🧠 Brainrot Stealer Panel"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleLabel
    
    -- Botón cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    -- Contenedor de botones
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, -20, 1, -60)
    buttonContainer.Position = UDim2.new(0, 10, 0, 50)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = mainFrame
    
    -- Layout para botones
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = buttonContainer
    
    -- Función para crear botones
    local function createButton(text, color, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = color
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.Gotham
        button.Parent = buttonContainer
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 5)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(callback)
        
        return button
    end
    
    -- Botones principales
    local stealAllButton = createButton("🎯 Steal All Brainrots", Color3.fromRGB(50, 150, 50), function()
        stealAllBrainrots()
    end)
    
    local autoStealButton = createButton("🔄 Auto Steal: OFF", Color3.fromRGB(100, 100, 100), function()
        toggleAutoSteal()
        autoStealButton.Text = autoStealEnabled and "🔄 Auto Steal: ON" or "🔄 Auto Steal: OFF"
        autoStealButton.BackgroundColor3 = autoStealEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(100, 100, 100)
    end)
    
    local teleportButton = createButton("📍 Teleport to Brainrots", Color3.fromRGB(50, 100, 200), function()
        teleportToBrainrots()
    end)
    
    local speedButton = createButton("⚡ Speed Boost", Color3.fromRGB(200, 150, 50), function()
        toggleSpeed()
    end)
    
    local jumpButton = createButton("🦘 Jump Boost", Color3.fromRGB(150, 50, 200), function()
        toggleJump()
    end)
    
    local noclipButton = createButton("👻 Noclip", Color3.fromRGB(200, 50, 150), function()
        toggleNoclip()
    end)
    
    local espButton = createButton("👁️ Brainrot ESP", Color3.fromRGB(50, 200, 150), function()
        toggleESP()
    end)
    
    -- Evento del botón cerrar
    closeButton.MouseButton1Click:Connect(function()
        togglePanel()
    end)
    
    return screenGui
end

-- Función para robar todos los brainrots
function stealAllBrainrots()
    local brainrots = workspace:GetChildren()
    for _, obj in pairs(brainrots) do
        if obj.Name:lower():find("brainrot") or obj.Name:lower():find("brain") then
            if obj:FindFirstChild("ClickDetector") then
                fireclickdetector(obj.ClickDetector)
            elseif obj:FindFirstChild("ProximityPrompt") then
                fireproximityprompt(obj.ProximityPrompt)
            end
        end
    end
    print("🧠 Intentando robar todos los brainrots...")
end

-- Función para auto steal
function toggleAutoSteal()
    autoStealEnabled = not autoStealEnabled
    
    if autoStealEnabled then
        autoStealConnection = RunService.Heartbeat:Connect(function()
            stealAllBrainrots()
            wait(1) -- Espera 1 segundo entre intentos
        end)
        print("🔄 Auto steal activado")
    else
        if autoStealConnection then
            autoStealConnection:Disconnect()
            autoStealConnection = nil
        end
        print("🔄 Auto steal desactivado")
    end
end

-- Función para teletransportarse a brainrots
function teleportToBrainrots()
    local brainrots = workspace:GetChildren()
    for _, obj in pairs(brainrots) do
        if obj.Name:lower():find("brainrot") or obj.Name:lower():find("brain") then
            if obj:FindFirstChild("Part") or obj:IsA("Part") then
                local targetPart = obj:IsA("Part") and obj or obj:FindFirstChild("Part")
                if targetPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
                    wait(0.5)
                    break
                end
            end
        end
    end
    print("📍 Teletransportándose al brainrot más cercano...")
end

-- Función para velocidad
local speedEnabled = false
function toggleSpeed()
    speedEnabled = not speedEnabled
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedEnabled and 50 or 16
        print("⚡ Speed boost: " .. (speedEnabled and "ON" or "OFF"))
    end
end

-- Función para salto
local jumpEnabled = false
function toggleJump()
    jumpEnabled = not jumpEnabled
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jumpEnabled and 100 or 50
        print("🦘 Jump boost: " .. (jumpEnabled and "ON" or "OFF"))
    end
end

-- Función para noclip
local noclipEnabled = false
local noclipConnection = nil
function toggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("👻 Noclip: ON")
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        print("👻 Noclip: OFF")
    end
end

-- Función para ESP
local espEnabled = false
local espObjects = {}
function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        local brainrots = workspace:GetChildren()
        for _, obj in pairs(brainrots) do
            if obj.Name:lower():find("brainrot") or obj.Name:lower():find("brain") then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = obj
                table.insert(espObjects, highlight)
            end
        end
        print("👁️ ESP: ON")
    else
        for _, highlight in pairs(espObjects) do
            if highlight and highlight.Parent then
                highlight:Destroy()
            end
        end
        espObjects = {}
        print("👁️ ESP: OFF")
    end
end

-- Función para mostrar/ocultar panel
function togglePanel()
    if panel then
        panel:Destroy()
        panel = nil
        isVisible = false
    else
        panel = createPanel()
        isVisible = true
    end
end

-- Crear panel inicial
panel = createPanel()
isVisible = true

-- Tecla para mostrar/ocultar panel (Insert)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        togglePanel()
    end
end)

print("🧠 Brainrot Stealer Panel cargado!")
print("📋 Presiona INSERT para mostrar/ocultar el panel")
print("⚠️ Usa bajo tu propia responsabilidad")
