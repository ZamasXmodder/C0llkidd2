-- XModder Premium (Steal a brainrot) GUI Script
-- Ultra Professional Roblox GUI with Rainbow Effects and Animations

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XModderPremiumGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame Container
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 450, 0, 400)
mainContainer.Position = UDim2.new(0.5, -225, 0.5, -200)
mainContainer.BackgroundTransparency = 1
mainContainer.Parent = screenGui

-- Rainbow Border Frame (Outer)
local rainbowBorder = Instance.new("Frame")
rainbowBorder.Name = "RainbowBorder"
rainbowBorder.Size = UDim2.new(1, 6, 1, 6)
rainbowBorder.Position = UDim2.new(0, -3, 0, -3)
rainbowBorder.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
rainbowBorder.BorderSizePixel = 0
rainbowBorder.ZIndex = 1
rainbowBorder.Parent = mainContainer

local rainbowCorner = Instance.new("UICorner")
rainbowCorner.CornerRadius = UDim.new(0, 20)
rainbowCorner.Parent = rainbowBorder

-- Rainbow Gradient
local rainbowGradient = Instance.new("UIGradient")
rainbowGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 0, 255))
}
rainbowGradient.Rotation = 0
rainbowGradient.Parent = rainbowBorder

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, -6, 1, -6)
mainFrame.Position = UDim2.new(0, 3, 0, 3)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 2
mainFrame.Parent = mainContainer

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 17)
mainCorner.Parent = mainFrame

-- Dark Gradient Background
local darkGradient = Instance.new("UIGradient")
darkGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(8, 8, 15)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(12, 8, 20)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(8, 8, 15))
}
darkGradient.Rotation = 135
darkGradient.Parent = mainFrame

-- Floating Particles Background
local particlesFrame = Instance.new("Frame")
particlesFrame.Name = "ParticlesFrame"
particlesFrame.Size = UDim2.new(1, 0, 1, 0)
particlesFrame.BackgroundTransparency = 1
particlesFrame.ZIndex = 3
particlesFrame.Parent = mainFrame

-- Create floating particles
for i = 1, 15 do
    local particle = Instance.new("Frame")
    particle.Name = "Particle" .. i
    particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
    particle.BorderSizePixel = 0
    particle.BackgroundTransparency = math.random(30, 70) / 100
    particle.Parent = particlesFrame
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
end

-- Title Container
local titleContainer = Instance.new("Frame")
titleContainer.Name = "TitleContainer"
titleContainer.Size = UDim2.new(1, -20, 0, 90)
titleContainer.Position = UDim2.new(0, 10, 0, 10)
titleContainer.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
titleContainer.BorderSizePixel = 0
titleContainer.ZIndex = 4
titleContainer.Parent = mainFrame

local titleContainerCorner = Instance.new("UICorner")
titleContainerCorner.CornerRadius = UDim.new(0, 15)
titleContainerCorner.Parent = titleContainer

-- Title Rainbow Border
local titleBorder = Instance.new("UIStroke")
titleBorder.Thickness = 2
titleBorder.Color = Color3.fromRGB(255, 0, 0)
titleBorder.Transparency = 0.3
titleBorder.Parent = titleContainer

-- Main Title with Rainbow Text
local mainTitle = Instance.new("TextLabel")
mainTitle.Name = "MainTitle"
mainTitle.Size = UDim2.new(1, -20, 0, 45)
mainTitle.Position = UDim2.new(0, 10, 0, 8)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "XMODDER PREMIUM"
mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTitle.TextScaled = true
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextStrokeTransparency = 0.5
mainTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
mainTitle.ZIndex = 5
mainTitle.Parent = titleContainer

-- Title Rainbow Gradient
local titleRainbow = Instance.new("UIGradient")
titleRainbow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 50, 150)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(150, 50, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 150, 255)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(50, 255, 150)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 150, 50))
}
titleRainbow.Rotation = 0
titleRainbow.Parent = mainTitle

-- Subtitle with Dark Rainbow
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, -20, 0, 25)
subtitle.Position = UDim2.new(0, 10, 0, 55)
subtitle.BackgroundTransparency = 1
subtitle.Text = "(Steal a brainrot)"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextStrokeTransparency = 0.7
subtitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
subtitle.ZIndex = 5
subtitle.Parent = titleContainer

local subtitleRainbow = Instance.new("UIGradient")
subtitleRainbow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(120, 30, 80)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(80, 30, 120)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(30, 80, 120)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(120, 80, 30))
}
subtitleRainbow.Rotation = 90
subtitleRainbow.Parent = subtitle

-- Trial Info Container
local trialContainer = Instance.new("Frame")
trialContainer.Name = "TrialContainer"
trialContainer.Size = UDim2.new(1, -20, 0, 35)
trialContainer.Position = UDim2.new(0, 10, 0, 110)
trialContainer.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
trialContainer.BorderSizePixel = 0
trialContainer.ZIndex = 4
trialContainer.Parent = mainFrame

local trialCorner = Instance.new("UICorner")
trialCorner.CornerRadius = UDim.new(0, 10)
trialCorner.Parent = trialContainer

local trialBorder = Instance.new("UIStroke")
trialBorder.Thickness = 1.5
trialBorder.Color = Color3.fromRGB(100, 100, 100)
trialBorder.Transparency = 0.5
trialBorder.Parent = trialContainer

-- Trial Info Label
local trialInfo = Instance.new("TextLabel")
trialInfo.Name = "TrialInfo"
trialInfo.Size = UDim2.new(1, -16, 1, 0)
trialInfo.Position = UDim2.new(0, 8, 0, 0)
trialInfo.BackgroundTransparency = 1
trialInfo.Text = "This script is a 5-day trial version. Get premium access for unlimited features."
trialInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
trialInfo.TextSize = 11
trialInfo.TextWrapped = true
trialInfo.Font = Enum.Font.Gotham
trialInfo.TextStrokeTransparency = 0.8
trialInfo.ZIndex = 5
trialInfo.Parent = trialContainer

local trialRainbow = Instance.new("UIGradient")
trialRainbow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(90, 90, 120)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 90, 90)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(90, 120, 90))
}
trialRainbow.Rotation = 45
trialRainbow.Parent = trialInfo

-- Input Container
local inputContainer = Instance.new("Frame")
inputContainer.Name = "InputContainer"
inputContainer.Size = UDim2.new(1, -20, 0, 75)
inputContainer.Position = UDim2.new(0, 10, 0, 155)
inputContainer.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
inputContainer.BorderSizePixel = 0
inputContainer.ZIndex = 4
inputContainer.Parent = mainFrame

local inputContainerCorner = Instance.new("UICorner")
inputContainerCorner.CornerRadius = UDim.new(0, 12)
inputContainerCorner.Parent = inputContainer

local inputContainerBorder = Instance.new("UIStroke")
inputContainerBorder.Thickness = 2
inputContainerBorder.Color = Color3.fromRGB(255, 0, 0)
inputContainerBorder.Transparency = 0.4
inputContainerBorder.Parent = inputContainer

-- Input Label
local inputLabel = Instance.new("TextLabel")
inputLabel.Name = "InputLabel"
inputLabel.Size = UDim2.new(1, -16, 0, 20)
inputLabel.Position = UDim2.new(0, 8, 0, 5)
inputLabel.BackgroundTransparency = 1
inputLabel.Text = "Enter License Key:"
inputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
inputLabel.TextSize = 12
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Font = Enum.Font.GothamBold
inputLabel.TextStrokeTransparency = 0.6
inputLabel.ZIndex = 5
inputLabel.Parent = inputContainer

local inputLabelRainbow = Instance.new("UIGradient")
inputLabelRainbow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 100, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 150, 255)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(150, 255, 100))
}
inputLabelRainbow.Rotation = 0
inputLabelRainbow.Parent = inputLabel

-- Text Box Container
local textBoxContainer = Instance.new("Frame")
textBoxContainer.Name = "TextBoxContainer"
textBoxContainer.Size = UDim2.new(1, -16, 0, 40)
textBoxContainer.Position = UDim2.new(0, 8, 0, 28)
textBoxContainer.BackgroundColor3 = Color3.fromRGB(2, 2, 8)
textBoxContainer.BorderSizePixel = 0
textBoxContainer.ZIndex = 5
textBoxContainer.Parent = inputContainer

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 8)
textBoxCorner.Parent = textBoxContainer

local textBoxBorder = Instance.new("UIStroke")
textBoxBorder.Thickness = 1.5
textBoxBorder.Color = Color3.fromRGB(150, 150, 150)
textBoxBorder.Transparency = 0.3
textBoxBorder.Parent = textBoxContainer

-- Text Box
local textBox = Instance.new("TextBox")
textBox.Name = "KeyTextBox"
textBox.Size = UDim2.new(1, -12, 1, -8)
textBox.Position = UDim2.new(0, 6, 0, 4)
textBox.BackgroundTransparency = 1
textBox.Text = ""
textBox.PlaceholderText = "Paste your premium key here..."
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textBox.TextSize = 13
textBox.Font = Enum.Font.Gotham
textBox.ClearTextOnFocus = false
textBox.TextStrokeTransparency = 0.8
textBox.ZIndex = 6
textBox.Parent = textBoxContainer

-- Buttons Container
local buttonsContainer = Instance.new("Frame")
buttonsContainer.Name = "ButtonsContainer"
buttonsContainer.Size = UDim2.new(1, -20, 0, 70)
buttonsContainer.Position = UDim2.new(0, 10, 0, 240)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.ZIndex = 4
buttonsContainer.Parent = mainFrame

-- Submit Button Container
local submitContainer = Instance.new("Frame")
submitContainer.Name = "SubmitContainer"
submitContainer.Size = UDim2.new(0.48, 0, 1, 0)
submitContainer.Position = UDim2.new(0, 0, 0, 0)
submitContainer.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
submitContainer.BorderSizePixel = 0
submitContainer.ZIndex = 5
submitContainer.Parent = buttonsContainer

local submitContainerCorner = Instance.new("UICorner")
submitContainerCorner.CornerRadius = UDim.new(0, 15)
submitContainerCorner.Parent = submitContainer

local submitContainerBorder = Instance.new("UIStroke")
submitContainerBorder.Thickness = 2
submitContainerBorder.Color = Color3.fromRGB(0, 255, 150)
submitContainerBorder.Transparency = 0.3
submitContainerBorder.Parent = submitContainer

-- Submit Button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(1, -8, 1, -8)
submitButton.Position = UDim2.new(0, 4, 0, 4)
submitButton.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
submitButton.BorderSizePixel = 0
submitButton.Text = "SUBMIT"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 16
submitButton.Font = Enum.Font.GothamBold
submitButton.TextStrokeTransparency = 0.5
submitButton.ZIndex = 6
submitButton.Parent = submitContainer

local submitButtonCorner = Instance.new("UICorner")
submitButtonCorner.CornerRadius = UDim.new(0, 12)
submitButtonCorner.Parent = submitButton

local submitButtonRainbow = Instance.new("UIGradient")
submitButtonRainbow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 150)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(150, 0, 255))
}
submitButtonRainbow.Rotation = 45
submitButtonRainbow.Parent = submitButton

-- Get Key Button Container
local getKeyContainer = Instance.new("Frame")
getKeyContainer.Name = "GetKeyContainer"
getKeyContainer.Size = UDim2.new(0.48, 0, 1, 0)
getKeyContainer.Position = UDim2.new(0.52, 0, 0, 0)
getKeyContainer.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
getKeyContainer.BorderSizePixel = 0
getKeyContainer.ZIndex = 5
getKeyContainer.Parent = buttonsContainer

local getKeyContainerCorner = Instance.new("UICorner")
getKeyContainerCorner.CornerRadius = UDim.new(0, 15)
getKeyContainerCorner.Parent = getKeyContainer

local getKeyContainerBorder = Instance.new("UIStroke")
getKeyContainerBorder.Thickness = 2
getKeyContainerBorder.Color = Color3.fromRGB(255, 100, 0)
getKeyContainerBorder.Transparency = 0.3
getKeyContainerBorder.Parent = getKeyContainer

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Size = UDim2.new(1, -8, 1, -8)
getKeyButton.Position = UDim2.new(0, 4, 0, 4)
getKeyButton.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "GET KEY"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 16
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextStrokeTransparency = 0.5
getKeyButton.ZIndex = 6
getKeyButton.Parent = getKeyContainer

local getKeyButtonCorner = Instance.new("UICorner")
getKeyButtonCorner.CornerRadius = UDim.new(0, 12)
getKeyButtonCorner.Parent = getKeyButton

local getKeyButtonRainbow = Instance.new("UIGradient")
getKeyButtonRainbow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 100, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 100)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(100, 255, 0))
}
getKeyButtonRainbow.Rotation = 45
getKeyButtonRainbow.Parent = getKeyButton

-- Toast Notification
local toastContainer = Instance.new("Frame")
toastContainer.Name = "ToastContainer"
toastContainer.Size = UDim2.new(0, 350, 0, 70)
toastContainer.Position = UDim2.new(0.5, -175, 1, 100)
toastContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toastContainer.BorderSizePixel = 0
toastContainer.ZIndex = 10
toastContainer.Parent = screenGui

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 20)
toastCorner.Parent = toastContainer

local toastBorder = Instance.new("UIStroke")
toastBorder.Thickness = 3
toastBorder.Color = Color3.fromRGB(0, 255, 0)
toastBorder.Transparency = 0.2
toastBorder.Parent = toastContainer

local toastGradient = Instance.new("UIGradient")
toastGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(5, 5, 15)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 20, 0)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(5, 5, 15))
}
toastGradient.Rotation = 90
toastGradient.Parent = toastContainer

local toastLabel = Instance.new("TextLabel")
toastLabel.Name = "ToastLabel"
toastLabel.Size = UDim2.new(1, -20, 1, 0)
toastLabel.Position = UDim2.new(0, 10, 0, 0)
toastLabel.BackgroundTransparency = 1
toastLabel.Text = "Key link copied!"
toastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toastLabel.TextSize = 18
toastLabel.Font = Enum.Font.GothamBold
toastLabel.TextXAlignment = Enum.TextXAlignment.Center
toastLabel.TextStrokeTransparency = 0.5
toastLabel.ZIndex = 11
toastLabel.Parent = toastContainer

local toastLabelRainbow = Instance.new("UIGradient")
toastLabelRainbow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 255, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 0)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 255, 100))
}
toastLabelRainbow.Rotation = 0
toastLabelRainbow.Parent = toastLabel

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24
closeButton.Font = Enum.Font.GothamBold
closeButton.TextStrokeTransparency = 0.5
closeButton.ZIndex = 6
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

local closeBorder = Instance.new("UIStroke")
closeBorder.Thickness = 2
closeBorder.Color = Color3.fromRGB(255, 50, 50)
closeBorder.Transparency = 0.3
closeBorder.Parent = closeButton

-- Animation Functions
local function createTweenInfo(duration, style, direction)
    return TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
end

-- Rainbow Animation
local function animateRainbow()
    spawn(function()
        while rainbowBorder.Parent do
            for i = 0, 360, 3 do
                if rainbowBorder.Parent then
                    rainbowGradient.Rotation = i
                    titleRainbow.Rotation = i * 0.5
                    subtitleRainbow.Rotation = i * 0.3
                    trialRainbow.Rotation = i * 0.2
                    inputLabelRainbow.Rotation = i * 0.4
                    submitButtonRainbow.Rotation = 45 + i * 0.3
                    getKeyButtonRainbow.Rotation = 45 + i * 0.3
                    toastLabelRainbow.Rotation = i * 0.6
                    
                    -- Animate border colors
                    titleBorder.Color = Color3.fromHSV((i / 360) % 1, 1, 1)
                    inputContainerBorder.Color = Color3.fromHSV(((i + 120) / 360) % 1, 1, 1)
                    submitContainerBorder.Color = Color3.fromHSV(((i + 240) / 360) % 1, 1, 1)
                    getKeyContainerBorder.Color = Color3.fromHSV(((i + 60) / 360) % 1, 1, 1)
                    toastBorder.Color = Color3.fromHSV(((i + 180) / 360) % 1, 1, 1)
                    closeBorder.Color = Color3.fromHSV(((i + 300) / 360) % 1, 1, 1)
                    
                    wait(0.03)
                else
                    break
                end
            end
        end
    end)
end

-- Particle Animation
local function animateParticles()
    spawn(function()
        while particlesFrame.Parent do
            for _, particle in pairs(particlesFrame:GetChildren()) do
                if particle.Name:match("Particle") then
                    local randomX = math.random(-50, 50) / 1000
                    local randomY = math.random(-50, 50) / 1000
                    local newPos = particle.Position + UDim2.new(randomX, 0, randomY, 0)
                    
                    -- Keep particles within bounds
                    if newPos.X.Scale < 0 then newPos = UDim2.new(1, 0, newPos.Y.Scale, 0) end
                    if newPos.X.Scale > 1 then newPos = UDim2.new(0, 0, newPos.Y.Scale, 0) end
                    if newPos.Y.Scale < 0 then newPos = UDim2.new(newPos.X.Scale, 0, 1, 0) end
                    if newPos.Y.Scale > 1 then newPos = UDim2.new(newPos.X.Scale, 0, 0, 0) end
                    
                    local moveTween = TweenService:Create(particle, createTweenInfo(0.5), {Position = newPos})
                    moveTween:Play()
                    
                    -- Color change
                    particle.BackgroundColor3 = Color3.fromHSV(math.random(), 0.8, 1)
                end
            end
            wait(0.5)
        end
    end)
end

-- Entrance Animation
local function playEntranceAnimation()
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local sizeTween = TweenService:Create(mainContainer, createTweenInfo(0.8, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 450, 0, 400)
    })
    
    local positionTween = TweenService:Create(mainContainer, createTweenInfo(0.8, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -225, 0.5, -200)
    })
    
    sizeTween:Play()
    positionTween:Play()
end

-- Button Hover Effects
local function createAdvancedHoverEffect(button, container)
    local originalSize = button.Size
    local originalContainerSize = container.Size
    
    button.MouseEnter:Connect(function()
        local scaleTween = TweenService:Create(button, createTweenInfo(0.2), {
            Size = originalSize + UDim2.new(0, 8, 0, 4)
        })
        local containerScaleTween = TweenService:Create(container, createTweenInfo(0.2), {
            Size = originalContainerSize + UDim2.new(0, 10, 0, 5)
        })
        
        scaleTween:Play()
        containerScaleTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local scaleTween = TweenService:Create(button, createTweenInfo(0.2), {
            Size = originalSize
        })
        local containerScaleTween = TweenService:Create(container, createTweenInfo(0.2), {
            Size = originalContainerSize
        })
        
        scaleTween:Play()
        containerScaleTween:Play()
    end)
end

-- Apply advanced hover effects
createAdvancedHoverEffect(submitButton, submitContainer)
createAdvancedHoverEffect(getKeyButton, getKeyContainer)

-- Toast Animation with Rainbow Effect
local function showToast()
    toastContainer.Position = UDim2.new(0.5, -175, 1, 100)
    
    local slideUpTween = TweenService:Create(toastContainer, createTweenInfo(0.6, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -175, 1, -90)
    })
    
    slideUpTween:Play()
    
    -- Toast rainbow effect
    spawn(function()
        for i = 1, 60 do
            if toastContainer.Parent then
                toastBorder.Color = Color3.fromHSV((i * 6) / 360, 1, 1)
                wait(0.05)
            end
        end
    end)
    
    slideUpTween.Completed:Connect(function()
        wait(3)
        local slideDownTween = TweenService:Create(toastContainer, createTweenInfo(0.5), {
            Position = UDim2.new(0.5, -175, 1, 100)
        })
        slideDownTween:Play()
    end)
end

-- Text Box Focus Effects
textBox.Focused:Connect(function()
    local focusTween = TweenService:Create(textBoxBorder, createTweenInfo(0.3), {
        Thickness = 2.5,
        Transparency = 0.1
    })
    focusTween:Play()
    
    spawn(function()
        while textBox:IsFocused() do
            textBoxBorder.Color = Color3.fromHSV(tick() % 1, 1, 1)
            wait(0.05)
        end
    end)
end)

textBox.FocusLost:Connect(function()
    local unfocusTween = TweenService:Create(textBoxBorder, createTweenInfo(0.3), {
        Thickness = 1.5,
        Transparency = 0.3,
        Color = Color3.fromRGB(150, 150, 150)
    })
    unfocusTween:Play()
end)

-- Button Click Effects
local function createClickEffect(button)
    button.MouseButton1Down:Connect(function()
        local clickTween = TweenService:Create(button, createTweenInfo(0.1), {
            Size = button.Size - UDim2.new(0, 4, 0, 2)
        })
        clickTween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local releaseTween = TweenService:Create(button, createTweenInfo(0.1), {
            Size = button.Size + UDim2.new(0, 4, 0, 2)
        })
        releaseTween:Play()
    end)
end

createClickEffect(submitButton)
createClickEffect(getKeyButton)
createClickEffect(closeButton)

-- Glitch Effect for Title
local function createGlitchEffect()
    spawn(function()
        while mainTitle.Parent do
            wait(math.random(3, 8))
            if mainTitle.Parent then
                -- Glitch position
                local originalPos = mainTitle.Position
                for i = 1, 5 do
                    mainTitle.Position = originalPos + UDim2.new(0, math.random(-2, 2), 0, math.random(-1, 1))
                    mainTitle.TextColor3 = Color3.fromHSV(math.random(), 1, 1)
                    wait(0.05)
                end
                mainTitle.Position = originalPos
                mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end)
end

-- Pulsing Effects
local function createPulseEffect(object, property, fromValue, toValue, duration)
    spawn(function()
        while object.Parent do
            local pulseTween1 = TweenService:Create(object, createTweenInfo(duration), {[property] = toValue})
            local pulseTween2 = TweenService:Create(object, createTweenInfo(duration), {[property] = fromValue})
            
            pulseTween1:Play()
            pulseTween1.Completed:Wait()
            pulseTween2:Play()
            pulseTween2.Completed:Wait()
        end
    end)
end

-- Apply pulsing effects
createPulseEffect(titleBorder, "Transparency", 0.3, 0.1, 1.5)
createPulseEffect(inputContainerBorder, "Transparency", 0.4, 0.2, 2)

-- Button Functions
submitButton.MouseButton1Click:Connect(function()
    local key = textBox.Text
    if key ~= "" then
        print("Key submitted:", key)
        
        -- Success animation
        local successTween = TweenService:Create(submitButton, createTweenInfo(0.3), {
            BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        })
        successTween:Play()
        
        wait(0.5)
        
        local resetTween = TweenService:Create(submitButton, createTweenInfo(0.3), {
            BackgroundColor3 = Color3.fromRGB(10, 10, 20)
        })
        resetTween:Play()
    else
        -- Error animation
        local errorTween1 = TweenService:Create(inputContainerBorder, createTweenInfo(0.1), {
            Color = Color3.fromRGB(255, 50, 50),
            Thickness = 3
        })
        errorTween1:Play()
        
        errorTween1.Completed:Connect(function()
            wait(1)
            local resetTween = TweenService:Create(inputContainerBorder, createTweenInfo(0.3), {
                Color = Color3.fromRGB(150, 150, 150),
                Thickness = 2
            })
            resetTween:Play()
        end)
        
        print("Please enter a key!")
    end
end)

getKeyButton.MouseButton1Click:Connect(function()
    -- Copy link to clipboard (simulate)
    local linkToCopy = "https://zamasxmodder.github.io/roblox_premium_page.html/"
    
    print("Link to copy:", linkToCopy)
    
    -- Button success animation
    local successTween = TweenService:Create(getKeyButton, createTweenInfo(0.3), {
        BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    })
    successTween:Play()
    
    showToast()
    
    wait(0.5)
    
    local resetTween = TweenService:Create(getKeyButton, createTweenInfo(0.3), {
        BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    })
    resetTween:Play()
end)

closeButton.MouseButton1Click:Connect(function()
    -- Close animation with rainbow effect
    spawn(function()
        for i = 1, 20 do
            if mainContainer.Parent then
                rainbowBorder.BackgroundColor3 = Color3.fromHSV((i * 18) / 360, 1, 1)
                wait(0.02)
            end
        end
    end)
    
    local closeTween1 = TweenService:Create(mainContainer, createTweenInfo(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    
    local fadeTween = TweenService:Create(mainFrame, createTweenInfo(0.4), {
        BackgroundTransparency = 1
    })
    
    closeTween1:Play()
    fadeTween:Play()
    
    closeTween1.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Advanced Dragging functionality with smooth movement
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        
        -- Smooth dragging with tween
        local dragTween = TweenService:Create(mainContainer, createTweenInfo(0.1, Enum.EasingStyle.Quart), {
            Position = newPosition
        })
        dragTween:Play()
    end
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainContainer.Position
        
        -- Dragging visual effect
        local dragTween = TweenService:Create(rainbowBorder, createTweenInfo(0.2), {
            Size = UDim2.new(1, 10, 1, 10),
            Position = UDim2.new(0, -5, 0, -5)
        })
        dragTween:Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        
        -- Reset dragging visual effect
        local resetTween = TweenService:Create(rainbowBorder, createTweenInfo(0.2), {
            Size = UDim2.new(1, 6, 1, 6),
            Position = UDim2.new(0, -3, 0, -3)
        })
        resetTween:Play()
    end
end)

-- Breathing effect for the main frame
local function createBreathingEffect()
    spawn(function()
        while mainFrame.Parent do
            local breatheOut = TweenService:Create(mainFrame, createTweenInfo(3), {
                Size = UDim2.new(1, -4, 1, -4),
                Position = UDim2.new(0, 2, 0, 2)
            })
            breatheOut:Play()
            breatheOut.Completed:Wait()
            
            local breatheIn = TweenService:Create(mainFrame, createTweenInfo(3), {
                Size = UDim2.new(1, -6, 1, -6),
                Position = UDim2.new(0, 3, 0, 3)
            })
            breatheIn:Play()
            breatheIn.Completed:Wait()
        end
    end)
end

-- Start all animations
wait(0.1)
playEntranceAnimation()
animateRainbow()
animateParticles()
createGlitchEffect()
createBreathingEffect()

-- Welcome message with effects
spawn(function()
    wait(1)
    print("🌈 XModder Premium GUI Loaded Successfully! 🌈")
    print("💎 Ultra Professional Design with Rainbow Effects 💎")
    print("⚡ Enjoy the premium experience! ⚡")
end)
