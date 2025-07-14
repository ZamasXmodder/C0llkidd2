-- Panel Bypass para Steal a Brainrot - Speed & Jump Forzados

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear el GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotBypass"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 280, 0, 220)
mainFrame.Position = UDim2.new(0, 20, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "🚀 BRAINROT BYPASS 🚀"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Speed Slider
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 25)
speedLabel.Position = UDim2.new(0.05, 0, 0.22, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0.85, 0, 0, 20)
speedSlider.Position = UDim2.new(0.075, 0, 0.35, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedSlider.BorderSizePixel = 0
speedSlider.Parent = mainFrame

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 10)
speedSliderCorner.Parent = speedSlider

local speedHandle = Instance.new("TextButton")
speedHandle.Size = UDim2.new(0, 20, 1, 0)
speedHandle.Position = UDim2.new(0, 0, 0, 0)
speedHandle.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
speedHandle.BorderSizePixel = 0
speedHandle.Text = ""
speedHandle.Parent = speedSlider

local speedHandleCorner = Instance.new("UICorner")
speedHandleCorner.CornerRadius = UDim.new(0, 10)
speedHandleCorner.Parent = speedHandle

-- Jump Power Slider
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0.9, 0, 0, 25)
jumpLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Jump Power: 50"
jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpLabel.TextScaled = true
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.Parent = mainFrame

local jumpSlider = Instance.new("Frame")
jumpSlider.Size = UDim2.new(0.85, 0, 0, 20)
jumpSlider.Position = UDim2.new(0.075, 0, 0.63, 0)
jumpSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
jumpSlider.BorderSizePixel = 0
jumpSlider.Parent = mainFrame

local jumpSliderCorner = Instance.new("UICorner")
jumpSliderCorner.CornerRadius = UDim.new(0, 10)
jumpSliderCorner.Parent = jumpSlider

local jumpHandle = Instance.new("TextButton")
jumpHandle.Size = UDim2.new(0, 20, 1, 0)
jumpHandle.Position = UDim2.new(0, 0, 0, 0)
jumpHandle.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
jumpHandle.BorderSizePixel = 0
jumpHandle.Text = ""
jumpHandle.Parent = jumpSlider

local jumpHandleCorner = Instance.new("UICorner")
jumpHandleCorner.CornerRadius = UDim.new(0, 10)
jumpHandleCorner.Parent = jumpHandle

-- Botón de Infinite Jump
local infJumpButton = Instance.new("TextButton")
infJumpButton.Size = UDim2.new(0.85, 0, 0, 30)
infJumpButton.Position = UDim2.new(0.075, 0, 0.78, 0)
infJumpButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
infJumpButton.BorderSizePixel = 0
infJumpButton.Text = "∞ INFINITE JUMP: OFF"
infJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infJumpButton.TextScaled = true
infJumpButton.Font = Enum.Font.GothamBold
infJumpButton.Parent = mainFrame

local infJumpCorner = Instance.new("UICorner")
infJumpCorner.CornerRadius = UDim.new(0, 6)
infJumpCorner.Parent = infJumpButton

-- Botón de cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeButton

-- Variables
local currentSpeed = 16
local currentJumpPower = 50
local infiniteJumpEnabled = false
local speedConnection
local jumpConnection
local infJumpConnection

-- Función para obtener el humanoid
local function getHumanoid()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        return player.Character.Humanoid
    end
    return nil
end

-- Función para forzar velocidad constantemente
local function forceSpeed()
    if speedConnection then
        speedConnection:Disconnect()
    end
    
    speedConnection = RunService.Heartbeat:Connect(function()
        local humanoid = getHumanoid()
        if humanoid then
            if humanoid.WalkSpeed ~= currentSpeed then
                humanoid.WalkSpeed = currentSpeed
            end
        end
    end)
end

-- Función para forzar jump power constantemente
local function forceJumpPower()
    if jumpConnection then
        jumpConnection:Disconnect()
    end
    
    jumpConnection = RunService.Heartbeat:Connect(function()
        local humanoid = getHumanoid()
        if humanoid then
            if humanoid.JumpPower ~= currentJumpPower then
                humanoid.JumpPower = currentJumpPower
            end
        end
    end)
end

-- Función de infinite jump
local function toggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        infJumpButton.Text = "∞ INFINITE JUMP: ON"
        infJumpButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        
        if infJumpConnection then
            infJumpConnection:Disconnect()
        end
        
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            local humanoid = getHumanoid()
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        infJumpButton.Text = "∞ INFINITE JUMP: OFF"
        infJumpButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
        
        if infJumpConnection then
            infJumpConnection:Disconnect()
            infJumpConnection = nil
        end
    end
end

-- Slider de velocidad
local speedDragging = false
speedHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if speedDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderPos = speedSlider.AbsolutePosition.X
        local sliderSize = speedSlider.AbsoluteSize.X
        local mouseX = input.Position.X
        
        local relativeX = math.clamp(mouseX - sliderPos, 0, sliderSize)
        local percentage = relativeX / sliderSize
        
        speedHandle.Position = UDim2.new(percentage, -10, 0, 0)
        currentSpeed = math.floor(16 + (percentage * 184)) -- 16 a 200
        speedLabel.Text = "Speed: " .. currentSpeed
        
        forceSpeed()
    end
end)

-- Slider de jump power
local jumpDragging = false
jumpHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        jumpDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if jumpDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderPos = jumpSlider.AbsolutePosition.X
        local sliderSize = jumpSlider.AbsoluteSize.X
        local mouseX = input.Position.X
        
        local relativeX = math.clamp(mouseX - sliderPos, 0, sliderSize)
        local percentage = relativeX / sliderSize
        
        jumpHandle.Position = UDim2.new(percentage, -10, 0, 0)
        currentJumpPower = math.floor(50 + (percentage * 150)) -- 50 a 200
        jumpLabel.Text = "Jump Power: " .. currentJumpPower
        
        forceJumpPower()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        jumpDragging = false
    end
end)

-- Función para hacer el panel arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleLabel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging then
            local delta = input.Position - dragStart
            local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            mainFrame.Position = position
        end
    end
end)

-- Conectar eventos
infJumpButton.MouseButton1Click:Connect(toggleInfiniteJump)

closeButton.MouseButton1Click:Connect(function()
    if speedConnection then speedConnection:Disconnect() end
    if jumpConnection then jumpConnection:Disconnect() end
    if infJumpConnection then infJumpConnection:Disconnect() end
    screenGui:Destroy()
end)

-- Mantener activo cuando respawnea
player.CharacterAdded:Connect(function()
    wait(1)
    forceSpeed()
    forceJumpPower()
    if infiniteJumpEnabled then
        toggleInfiniteJump()
        toggleInfiniteJump() -- Doble toggle para reactivar
    end
end)

-- Inicializar
forceSpeed()
forceJumpPower()

-- Animación de entrada
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 280, 0, 220)}
)
openTween:Play()

print("🚀 Brainrot Bypass Panel loaded! 🚀")
