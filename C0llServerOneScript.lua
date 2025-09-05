local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables principales
local floatPart = nil
local isFloatActive = false
local panelOpen = false
local connection = nil

-- Configuración por defecto
local config = {
    floatSpeed = 16,
    jumpPower = 50,
    walkSpeed = 16,
    partSize = Vector3.new(8, 1, 8),
    partColor = Color3.fromRGB(0, 162, 255),
    partTransparency = 0.3
}

-- Crear la GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatPartPanel"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.Text = "Float Part Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botón de activar/desactivar float
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleFloat"
toggleButton.Size = UDim2.new(0.8, 0, 0, 40)
toggleButton.Position = UDim2.new(0.1, 0, 0, 70)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
toggleButton.Text = "Activar Float Part"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.Gotham
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5)
toggleCorner.Parent = toggleButton

-- Función para crear sliders
local function createSlider(name, yPos, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Frame"
    sliderFrame.Size = UDim2.new(0.8, 0, 0, 60)
    sliderFrame.Position = UDim2.new(0.1, 0, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = mainFrame
    
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
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.Parent = sliderFrame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 10)
    sliderBgCorner.Parent = sliderBg
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 1, 0)
    sliderButton.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -10, 0, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(1, 0)
    sliderButtonCorner.Parent = sliderButton
    
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = Players.LocalPlayer:GetMouse()
            local relativeX = mouse.X - sliderBg.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
            
            sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
            
            local value = math.floor(minVal + (maxVal - minVal) * percentage)
            label.Text = name .. ": " .. value
            callback(value)
        end
    end)
end

-- Crear sliders
createSlider("Velocidad Float", 130, 1, 50, config.floatSpeed, function(value)
    config.floatSpeed = value
end)

createSlider("Poder de Salto", 200, 10, 150, config.jumpPower, function(value)
    config.jumpPower = value
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

createSlider("Velocidad Caminar", 270, 1, 100, config.walkSpeed, function(value)
    config.walkSpeed = value
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

-- Función para crear la part flotante
local function createFloatPart()
    if floatPart then
        floatPart:Destroy()
    end
    
    floatPart = Instance.new("Part")
    floatPart.Name = "FloatPart"
    floatPart.Size = config.partSize
    floatPart.Material = Enum.Material.Neon
    floatPart.Color = config.partColor
    floatPart.Transparency = config.partTransparency
    floatPart.Anchored = true
    floatPart.CanCollide = true
    floatPart.Parent = workspace
    
    -- Efecto visual
    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Adornee = floatPart
    selectionBox.Color3 = config.partColor
    selectionBox.LineThickness = 0.2
    selectionBox.Transparency = 0.5
    selectionBox.Parent = floatPart
end

-- Función para actualizar la posición de la part
local function updateFloatPart()
    if not isFloatActive or not floatPart or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local targetPosition = humanoidRootPart.Position - Vector3.new(0, 4, 0)
        floatPart.Position = floatPart.Position:Lerp(targetPosition, config.floatSpeed * 0.01)
    end
end

-- Función para activar/desactivar float part
local function toggleFloatPart()
    isFloatActive = not isFloatActive
    
    if isFloatActive then
        createFloatPart()
        toggleButton.Text = "Desactivar Float Part"
        toggleButton.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
        
        connection = RunService.Heartbeat:Connect(updateFloatPart)
        
        -- Aplicar configuraciones al personaje
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = config.jumpPower
            player.Character.Humanoid.WalkSpeed = config.walkSpeed
        end
    else
        if floatPart then
            floatPart:Destroy()
            floatPart = nil
        end
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
        
        toggleButton.Text = "Activar Float Part"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    end
end

-- Función para mostrar/ocultar panel
local function togglePanel()
    panelOpen = not panelOpen
    
    if panelOpen then
        mainFrame.Visible = true
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(mainFrame, tweenInfo, {
            Size = UDim2.new(0, 300, 0, 400),
            Position = UDim2.new(0.5, -150, 0.5, -200)
        })
        tween:Play()
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tween = TweenService:Create(mainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end
end

-- Eventos
toggleButton.MouseButton1Click:Connect(toggleFloatPart)

-- Input para abrir/cerrar con F
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        togglePanel()
    end
end)

-- Limpiar al salir del juego
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        if floatPart then
            floatPart:Destroy()
        end
        if connection then
            connection:Disconnect()
        end
    end
end)
