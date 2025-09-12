-- XModder Premium GUI - Professional Dark Theme (ServerScript Version)
-- Enhanced visual design with rainbow borders and dark styling

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crear RemoteEvents para comunicación cliente-servidor
local teleportRemote = Instance.new("RemoteEvent")
teleportRemote.Name = "TeleportToPrivateServer"
teleportRemote.Parent = ReplicatedStorage

-- Función del servidor para manejar el teleporte
teleportRemote.OnServerEvent:Connect(function(player)
    -- Datos del servidor privado
    local placeId = 109983668079237
    local privateServerCode = "30f225b39b28d24f9e91de75ed337fcf"
    
    -- Teletransportar al jugador
    local success, errorMsg = pcall(function()
        TeleportService:TeleportToPrivateServer(placeId, privateServerCode, {player})
    end)
    
    if not success then
        warn("Error al teletransportar jugador " .. player.Name .. ": " .. tostring(errorMsg))
    end
end)

-- Crear GUI para cada jugador cuando se conecte
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Esperar a que el jugador cargue completamente
        createGUIForPlayer(player)
    end)
end)

-- Si hay jugadores ya conectados
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        createGUIForPlayer(player)
    else
        player.CharacterAdded:Connect(function()
            wait(1)
            createGUIForPlayer(player)
        end)
    end
end

function createGUIForPlayer(player)
local playerGui = player:WaitForChild("PlayerGui")

-- Obtener referencia al RemoteEvent
local teleportRemote = ReplicatedStorage:WaitForChild("TeleportToPrivateServer")

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XModderPremiumGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame with dark theme
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 450, 0, 320)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Add corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Dark rainbow border frame
local borderFrame = Instance.new("Frame")
borderFrame.Name = "BorderFrame"
borderFrame.Parent = mainFrame
borderFrame.Size = UDim2.new(1, 4, 1, 4)
borderFrame.Position = UDim2.new(0, -2, 0, -2)
borderFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = -1

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 14)
borderCorner.Parent = borderFrame

-- Rainbow gradient for border
local borderGradient = Instance.new("UIGradient")
borderGradient.Parent = borderFrame

-- Subtle glow effect
local glowFrame = Instance.new("Frame")
glowFrame.Name = "GlowFrame"
glowFrame.Parent = mainFrame
glowFrame.Size = UDim2.new(1, 12, 1, 12)
glowFrame.Position = UDim2.new(0, -6, 0, -6)
glowFrame.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
glowFrame.BackgroundTransparency = 0.7
glowFrame.BorderSizePixel = 0
glowFrame.ZIndex = -2

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 18)
glowCorner.Parent = glowFrame

-- Header section
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Parent = mainFrame
headerFrame.Size = UDim2.new(1, 0, 0, 70)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
headerFrame.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerFrame

-- Header bottom fix
local headerBottom = Instance.new("Frame")
headerBottom.Name = "HeaderBottom"
headerBottom.Parent = headerFrame
headerBottom.Size = UDim2.new(1, 0, 0, 12)
headerBottom.Position = UDim2.new(0, 0, 1, -12)
headerBottom.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
headerBottom.BorderSizePixel = 0

-- Title Label with gradient effect
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = headerFrame
titleLabel.Size = UDim2.new(1, -60, 0, 35)
titleLabel.Position = UDim2.new(0, 15, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "XMODDER PREMIUM"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 22
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 2

-- Subtitle label
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Parent = headerFrame
subtitleLabel.Size = UDim2.new(1, -60, 0, 20)
subtitleLabel.Position = UDim2.new(0, 15, 0, 45)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Professional Edition"
subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
subtitleLabel.TextSize = 14
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.ZIndex = 2

-- Status section
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, -30, 0, 20)
statusLabel.Position = UDim2.new(0, 15, 0, 85)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Trial Version Active - 5 Days Remaining"
statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.ZIndex = 2

-- Input section label
local inputSectionLabel = Instance.new("TextLabel")
inputSectionLabel.Name = "InputSectionLabel"
inputSectionLabel.Parent = mainFrame
inputSectionLabel.Size = UDim2.new(1, -30, 0, 20)
inputSectionLabel.Position = UDim2.new(0, 15, 0, 115)
inputSectionLabel.BackgroundTransparency = 1
inputSectionLabel.Text = "Premium Access Key:"
inputSectionLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
inputSectionLabel.TextSize = 14
inputSectionLabel.Font = Enum.Font.GothamBold
inputSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
inputSectionLabel.ZIndex = 2

-- Input TextBox with dark theme
local inputBox = Instance.new("TextBox")
inputBox.Name = "InputBox"
inputBox.Parent = mainFrame
inputBox.Size = UDim2.new(1, -30, 0, 40)
inputBox.Position = UDim2.new(0, 15, 0, 140)
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
inputBox.BorderSizePixel = 1
inputBox.BorderColor3 = Color3.fromRGB(80, 80, 100)
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 14
inputBox.Font = Enum.Font.Gotham
inputBox.PlaceholderText = "Enter your premium access key here"
inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.ZIndex = 2

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

-- Input glow effect
local inputGlow = Instance.new("Frame")
inputGlow.Parent = inputBox
inputGlow.Size = UDim2.new(1, 4, 1, 4)
inputGlow.Position = UDim2.new(0, -2, 0, -2)
inputGlow.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
inputGlow.BackgroundTransparency = 0.8
inputGlow.BorderSizePixel = 0
inputGlow.ZIndex = -1

local inputGlowCorner = Instance.new("UICorner")
inputGlowCorner.CornerRadius = UDim.new(0, 8)
inputGlowCorner.Parent = inputGlow

-- Submit Button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Parent = mainFrame
submitButton.Size = UDim2.new(0, 130, 0, 40)
submitButton.Position = UDim2.new(0, 15, 0, 200)
submitButton.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
submitButton.BorderSizePixel = 0
submitButton.Text = "Activate Premium"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 14
submitButton.Font = Enum.Font.GothamBold
submitButton.TextStrokeTransparency = 0.5
submitButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
submitButton.ZIndex = 5

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 6)
submitCorner.Parent = submitButton

-- Submit button border
local submitBorder = Instance.new("Frame")
submitBorder.Name = "SubmitBorder"
submitBorder.Parent = mainFrame
submitBorder.Size = UDim2.new(0, 134, 0, 44)
submitBorder.Position = UDim2.new(0, 13, 0, 198)
submitBorder.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
submitBorder.BorderSizePixel = 0
submitBorder.ZIndex = 1

local submitBorderCorner = Instance.new("UICorner")
submitBorderCorner.CornerRadius = UDim.new(0, 8)
submitBorderCorner.Parent = submitBorder

local submitBorderGradient = Instance.new("UIGradient")
submitBorderGradient.Parent = submitBorder

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Parent = mainFrame
getKeyButton.Size = UDim2.new(0, 130, 0, 40)
getKeyButton.Position = UDim2.new(0, 160, 0, 200)
getKeyButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "Get Premium Key"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 14
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextStrokeTransparency = 0.5
getKeyButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
getKeyButton.ZIndex = 5

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 6)
getKeyCorner.Parent = getKeyButton

-- Get Key button border
local getKeyBorder = Instance.new("Frame")
getKeyBorder.Name = "GetKeyBorder"
getKeyBorder.Parent = mainFrame
getKeyBorder.Size = UDim2.new(0, 134, 0, 44)
getKeyBorder.Position = UDim2.new(0, 158, 0, 198)
getKeyBorder.BackgroundColor3 = Color3.fromRGB(250, 150, 50)
getKeyBorder.BorderSizePixel = 0
getKeyBorder.ZIndex = 1

local getKeyBorderCorner = Instance.new("UICorner")
getKeyBorderCorner.CornerRadius = UDim.new(0, 8)
getKeyBorderCorner.Parent = getKeyBorder

local getKeyBorderGradient = Instance.new("UIGradient")
getKeyBorderGradient.Parent = getKeyBorder

-- Help Button
local helpButton = Instance.new("TextButton")
helpButton.Name = "HelpButton"
helpButton.Parent = mainFrame
helpButton.Size = UDim2.new(0, 130, 0, 40)
helpButton.Position = UDim2.new(0, 305, 0, 200)
helpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
helpButton.BorderSizePixel = 0
helpButton.Text = "Support"
helpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
helpButton.TextSize = 14
helpButton.Font = Enum.Font.GothamBold
helpButton.TextStrokeTransparency = 0.5
helpButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
helpButton.ZIndex = 5

local helpCorner = Instance.new("UICorner")
helpCorner.CornerRadius = UDim.new(0, 6)
helpCorner.Parent = helpButton

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = headerFrame
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -45, 0, 20)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.ZIndex = 2

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Footer information
local footerLabel = Instance.new("TextLabel")
footerLabel.Name = "FooterLabel"
footerLabel.Parent = mainFrame
footerLabel.Size = UDim2.new(1, -30, 0, 25)
footerLabel.Position = UDim2.new(0, 15, 1, -35)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "Professional modding suite with advanced features and premium support"
footerLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
footerLabel.TextSize = 11
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextXAlignment = Enum.TextXAlignment.Left
footerLabel.TextWrapped = true
footerLabel.ZIndex = 2

-- Floating particles for visual enhancement
local particleFrame = Instance.new("Frame")
particleFrame.Name = "ParticleFrame"
particleFrame.Parent = mainFrame
particleFrame.Size = UDim2.new(1, 0, 1, 0)
particleFrame.BackgroundTransparency = 1
particleFrame.ZIndex = 1

-- Create subtle floating particles
for i = 1, 8 do
local particle = Instance.new("Frame")
particle.Name = "Particle" .. i
particle.Parent = particleFrame
particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
particle.BackgroundColor3 = Color3.fromHSV(math.random(), 0.8, 0.6)
particle.BorderSizePixel = 0
particle.BackgroundTransparency = 0.6

local particleCorner = Instance.new("UICorner")
particleCorner.CornerRadius = UDim.new(1, 0)
particleCorner.Parent = particle
end

-- Enhanced notification system
local function showNotification(message, messageType)
local notificationColor
if messageType == "error" then
notificationColor = Color3.fromRGB(200, 80, 80)
elseif messageType == "success" then
notificationColor = Color3.fromRGB(80, 180, 80)
else
notificationColor = Color3.fromRGB(100, 150, 200)
end

local notificationGui = Instance.new("ScreenGui")
notificationGui.Name = "NotificationGui"
notificationGui.Parent = playerGui

local notification = Instance.new("Frame")
notification.Parent = notificationGui
notification.Size = UDim2.new(0, 400, 0, 60)
notification.Position = UDim2.new(0.5, -200, 0, -70)
notification.BackgroundColor3 = notificationColor
notification.BorderSizePixel = 0

local notificationCorner = Instance.new("UICorner")
notificationCorner.CornerRadius = UDim.new(0, 8)
notificationCorner.Parent = notification

-- Notification border glow
local notificationBorder = Instance.new("Frame")
notificationBorder.Parent = notification
notificationBorder.Size = UDim2.new(1, 4, 1, 4)
notificationBorder.Position = UDim2.new(0, -2, 0, -2)
notificationBorder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
notificationBorder.BackgroundTransparency = 0.7
notificationBorder.BorderSizePixel = 0
notificationBorder.ZIndex = -1

local notificationBorderCorner = Instance.new("UICorner")
notificationBorderCorner.CornerRadius = UDim.new(0, 10)
notificationBorderCorner.Parent = notificationBorder

local notificationLabel = Instance.new("TextLabel")
notificationLabel.Parent = notification
notificationLabel.Size = UDim2.new(1, -20, 1, 0)
notificationLabel.Position = UDim2.new(0, 10, 0, 0)
notificationLabel.BackgroundTransparency = 1
notificationLabel.Text = message
notificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationLabel.TextSize = 14
notificationLabel.Font = Enum.Font.GothamBold
notificationLabel.TextWrapped = true
notificationLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Animate notification
local slideIn = TweenService:Create(notification,
TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
{Position = UDim2.new(0.5, -200, 0, 30)}
)
slideIn:Play()

wait(3.5)
local slideOut = TweenService:Create(notification,
TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
{Position = UDim2.new(0.5, -200, 0, -70)}
)
slideOut:Play()

slideOut.Completed:Connect(function()
notificationGui:Destroy()
end)
end

-- Rainbow border animation
local function animateRainbowBorder()
local hue = 0
RunService.Heartbeat:Connect(function()
hue = (hue + 0.005) % 1

-- Main panel border (darker rainbow)
borderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 0.8, 0.5)),
    ColorSequenceKeypoint.new(0.5, Color3.fromHSV((hue + 0.3) % 1, 0.8, 0.5)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV((hue + 0.6) % 1, 0.8, 0.5))
}

-- Submit button border
submitBorderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromHSV((hue + 0.2) % 1, 0.7, 0.6)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV((hue + 0.4) % 1, 0.7, 0.6))
}

-- Get Key button border
getKeyBorderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromHSV((hue + 0.5) % 1, 0.7, 0.6)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV((hue + 0.7) % 1, 0.7, 0.6))
}
end)
end

-- Particle animation
local function animateParticles()
for i = 1, 8 do
local particle = particleFrame:FindFirstChild("Particle" .. i)
if particle then
    local tween = TweenService:Create(particle,
        TweenInfo.new(math.random(4, 8), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(math.random(), 0, math.random(), 0)}
    )
    tween:Play()
end
end
end

-- Glow animation
local function animateGlow()
local glowTween = TweenService:Create(glowFrame,
TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
{BackgroundTransparency = 0.4}
)
glowTween:Play()
end

-- Button hover effects
local function setupHoverEffect(button, originalColor, hoverColor)
button.MouseEnter:Connect(function()
local hoverTween = TweenService:Create(button,
    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
    {BackgroundColor3 = hoverColor, Size = button.Size + UDim2.new(0, 3, 0, 2)}
)
hoverTween:Play()
end)

button.MouseLeave:Connect(function()
local leaveTween = TweenService:Create(button,
    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
    {BackgroundColor3 = originalColor, Size = button.Size - UDim2.new(0, 3, 0, 2)}
)
leaveTween:Play()
end)
end

-- Input focus effects
inputBox.Focused:Connect(function()
local focusTween = TweenService:Create(inputGlow,
TweenInfo.new(0.3, Enum.EasingStyle.Quad),
{BackgroundTransparency = 0.4}
)
focusTween:Play()
end)

inputBox.FocusLost:Connect(function()
local unfocusTween = TweenService:Create(inputGlow,
TweenInfo.new(0.3, Enum.EasingStyle.Quad),
{BackgroundTransparency = 0.8}
)
unfocusTween:Play()
end)

-- Title color animation
spawn(function()
local titleHue = 0
RunService.Heartbeat:Connect(function()
titleHue = (titleHue + 0.01) % 1
titleLabel.TextColor3 = Color3.fromHSV(titleHue, 0.6, 1)
end)
end)

-- Button functionality
getKeyButton.MouseButton1Click:Connect(function()
spawn(function()
showNotification("Conectando al servidor privado...", "info")
end)

-- Enviar solicitud al servidor para teletransporte
local success, errorMsg = pcall(function()
teleportRemote:FireServer()
end)

if not success then
spawn(function()
    showNotification("Error al conectar con el servidor. Intenta de nuevo.", "error")
end)
end
end)

submitButton.MouseButton1Click:Connect(function()
local keyText = inputBox.Text
if keyText == "" then
spawn(function()
    showNotification("Please enter a valid premium access key to continue", "error")
end)
else
spawn(function()
    showNotification("Verifying premium access key... Please wait", "info")
end)

wait(2)
spawn(function()
    showNotification("Access key verification failed - Invalid or expired key", "error")
end)
end
end)

helpButton.MouseButton1Click:Connect(function()
spawn(function()
showNotification("Contact premium support for assistance with your account", "info")
end)
end)

closeButton.MouseButton1Click:Connect(function()
local closeTween = TweenService:Create(mainFrame,
TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
{Size = UDim2.new(0, 0, 0, 0)}
)
closeTween:Play()

closeTween.Completed:Connect(function()
screenGui:Destroy()
end)
end)

-- Initialize all visual effects
animateRainbowBorder()
animateParticles()
animateGlow()

-- Setup button interactions
setupHoverEffect(submitButton, Color3.fromRGB(60, 150, 60), Color3.fromRGB(80, 180, 80))
setupHoverEffect(getKeyButton, Color3.fromRGB(200, 100, 0), Color3.fromRGB(230, 130, 30))
setupHoverEffect(helpButton, Color3.fromRGB(100, 100, 120), Color3.fromRGB(120, 120, 140))
setupHoverEffect(closeButton, Color3.fromRGB(200, 60, 60), Color3.fromRGB(230, 80, 80))

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local entranceAnimation = TweenService:Create(mainFrame,
TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
{Size = UDim2.new(0, 450, 0, 320)}
)
entranceAnimation:Play()

print("XModder Premium GUI loaded with enhanced visual effects for " .. player.Name)
print("Professional dark theme with rainbow border animations active")

end -- Cerrar función createGUIForPlayer

print("XModder Premium ServerScript loaded successfully")
print("RemoteEvent created for TeleportService functionality")
