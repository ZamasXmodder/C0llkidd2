-- XModder Script GUI - Dark Rainbow Edition
-- Created for Roblox with full screen coverage and amazing effects

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove existing GUI if present
if playerGui:FindFirstChild("XModderGUI") then
    playerGui.XModderGUI:Destroy()
end

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XModderGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.Parent = playerGui

-- Main background frame (covers entire screen including topbar)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 36) -- Extra height to cover topbar
mainFrame.Position = UDim2.new(0, 0, 0, -36) -- Start above topbar
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Animated gradient background
local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 0, 51)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(51, 0, 102)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 0, 26)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(45, 0, 77)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 0, 51))
}
backgroundGradient.Rotation = 45
backgroundGradient.Parent = mainFrame

-- Rainbow border effect
local rainbowFrame = Instance.new("Frame")
rainbowFrame.Name = "RainbowBorder"
rainbowFrame.Size = UDim2.new(1, 0, 1, 0)
rainbowFrame.Position = UDim2.new(0, 0, 0, 0)
rainbowFrame.BackgroundTransparency = 0
rainbowFrame.BorderSizePixel = 0
rainbowFrame.Parent = mainFrame

local rainbowGradient = Instance.new("UIGradient")
rainbowGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 136, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
}
rainbowGradient.Parent = rainbowFrame

-- Inner content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -6, 1, -6)
contentFrame.Position = UDim2.new(0, 3, 0, 3)
contentFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
contentFrame.BackgroundTransparency = 0.05
contentFrame.BorderSizePixel = 0
contentFrame.Parent = rainbowFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.8, 0, 0, 100)
titleLabel.Position = UDim2.new(0.1, 0, 0.15, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Copy Link to Test 5-Day Trial\nXModderScript Steal a Brainrot"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextStrokeTransparency = 0.5
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.Parent = contentFrame

-- Title rainbow effect
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 100))
}
titleGradient.Parent = titleLabel

-- Input TextBox
local inputBox = Instance.new("TextBox")
inputBox.Name = "InputBox"
inputBox.Size = UDim2.new(0.6, 0, 0, 60)
inputBox.Position = UDim2.new(0.2, 0, 0.45, 0)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
inputBox.BorderSizePixel = 0
inputBox.Text = "Enter your key here..."
inputBox.PlaceholderText = "Enter your key here..."
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
inputBox.TextScaled = true
inputBox.Font = Enum.Font.Gotham
inputBox.Parent = contentFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 15)
inputCorner.Parent = inputBox

local inputStroke = Instance.new("UIStroke")
inputStroke.Thickness = 2
inputStroke.Color = Color3.fromRGB(100, 50, 150)
inputStroke.Parent = inputBox

-- Submit Key Button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(0.25, 0, 0, 50)
submitButton.Position = UDim2.new(0.15, 0, 0.65, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
submitButton.BorderSizePixel = 0
submitButton.Text = "Submit Key"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextScaled = true
submitButton.Font = Enum.Font.GothamBold
submitButton.Parent = contentFrame

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 12)
submitCorner.Parent = submitButton

local submitStroke = Instance.new("UIStroke")
submitStroke.Thickness = 2
submitStroke.Color = Color3.fromRGB(150, 50, 200)
submitStroke.Parent = submitButton

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Size = UDim2.new(0.25, 0, 0, 50)
getKeyButton.Position = UDim2.new(0.6, 0, 0.65, 0)
getKeyButton.BackgroundColor3 = Color3.fromRGB(100, 0, 50)
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "Get Key"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextScaled = true
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.Parent = contentFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 12)
getKeyCorner.Parent = getKeyButton

local getKeyStroke = Instance.new("UIStroke")
getKeyStroke.Thickness = 2
getKeyStroke.Color = Color3.fromRGB(200, 50, 150)
getKeyStroke.Parent = getKeyButton

-- Close button (X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = contentFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 20)
closeCorner.Parent = closeButton

-- Toast notification
local toastFrame = Instance.new("Frame")
toastFrame.Name = "ToastFrame"
toastFrame.Size = UDim2.new(0, 300, 0, 60)
toastFrame.Position = UDim2.new(0.5, -150, 1, 100) -- Start below screen
toastFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
toastFrame.BorderSizePixel = 0
toastFrame.Parent = screenGui

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 15)
toastCorner.Parent = toastFrame

local toastLabel = Instance.new("TextLabel")
toastLabel.Size = UDim2.new(1, 0, 1, 0)
toastLabel.Position = UDim2.new(0, 0, 0, 0)
toastLabel.BackgroundTransparency = 1
toastLabel.Text = "Key Copied!"
toastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toastLabel.TextScaled = true
toastLabel.Font = Enum.Font.GothamBold
toastLabel.Parent = toastFrame

-- Particle effects
local function createParticle()
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(math.random(0, 100)/100, 0, math.random(0, 100)/100, 0)
    particle.BackgroundColor3 = Color3.new(math.random(50, 255)/255, math.random(50, 255)/255, math.random(50, 255)/255)
    particle.BorderSizePixel = 0
    particle.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = particle
    
    -- Animate particle
    local tween = TweenService:Create(particle, TweenInfo.new(3, Enum.EasingStyle.Linear), {
        Position = UDim2.new(math.random(-20, 120)/100, 0, math.random(-20, 120)/100, 0),
        BackgroundTransparency = 1
    })
    tween:Play()
    
    tween.Completed:Connect(function()
        particle:Destroy()
    end)
end

-- Animation functions
local function animateRainbow()
    spawn(function()
        local rotation = 0
        while rainbowFrame.Parent do
            rotation = rotation + 2
            rainbowGradient.Rotation = rotation
            titleGradient.Rotation = rotation * 0.5
            wait(0.1)
        end
    end)
end

local function animateBackground()
    spawn(function()
        local rotation = 45
        while backgroundGradient.Parent do
            rotation = rotation + 0.5
            backgroundGradient.Rotation = rotation
            wait(0.1)
        end
    end)
end

local function createParticleEffect()
    spawn(function()
        while contentFrame.Parent do
            createParticle()
            wait(0.5)
        end
    end)
end

-- Button animations
local function animateButton(button)
    local originalSize = button.Size
    local hoverTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(originalSize.X.Scale * 1.1, originalSize.X.Offset, originalSize.Y.Scale * 1.1, originalSize.Y.Offset)
    })
    local returnTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = originalSize
    })
    
    button.MouseEnter:Connect(function()
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        returnTween:Play()
    end)
end

-- Show toast notification
local function showToast()
    local slideIn = TweenService:Create(toastFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -150, 0.9, 0)
    })
    local slideOut = TweenService:Create(toastFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -150, 1, 100)
    })
    
    slideIn:Play()
    wait(2)
    slideOut:Play()
end

-- Event connections
getKeyButton.MouseButton1Click:Connect(function()
    -- Copy link to clipboard and show toast
    setclipboard("https://zamasxmodder.github.io/Privated/")
    showToast()
    
    -- Button press effect
    local pressEffect = TweenService:Create(getKeyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(150, 0, 75)
    })
    local releaseEffect = TweenService:Create(getKeyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(100, 0, 50)
    })
    pressEffect:Play()
    pressEffect.Completed:Connect(function()
        releaseEffect:Play()
    end)
end)

submitButton.MouseButton1Click:Connect(function()
    local key = inputBox.Text
    if key and key ~= "" and key ~= "Enter your key here..." then
        -- Process the key here
        print("Key submitted:", key)
        
        -- Button press effect
        local pressEffect = TweenService:Create(submitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(75, 0, 150)
        })
        local releaseEffect = TweenService:Create(submitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(50, 0, 100)
        })
        pressEffect:Play()
        pressEffect.Completed:Connect(function()
            releaseEffect:Play()
        end)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    -- Fade out animation
    local fadeOut = TweenService:Create(screenGui, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Enabled = false
    })
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Input box effects
inputBox.Focused:Connect(function()
    if inputBox.Text == "Enter your key here..." then
        inputBox.Text = ""
    end
    local focusEffect = TweenService:Create(inputStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Color = Color3.fromRGB(200, 100, 255)
    })
    focusEffect:Play()
end)

inputBox.FocusLost:Connect(function()
    if inputBox.Text == "" then
        inputBox.Text = "Enter your key here..."
    end
    local unfocusEffect = TweenService:Create(inputStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Color = Color3.fromRGB(100, 50, 150)
    })
    unfocusEffect:Play()
end)

-- Initialize animations
animateButton(submitButton)
animateButton(getKeyButton)
animateButton(closeButton)
animateRainbow()
animateBackground()
createParticleEffect()

-- Entrance animation
mainFrame.BackgroundTransparency = 1
local entranceEffect = TweenService:Create(mainFrame, TweenInfo.new(1, Enum.EasingStyle.Back), {
    BackgroundTransparency = 0
})
entranceEffect:Play()

print("XModder Script GUI loaded successfully!")
print("Dark Rainbow Edition - Full Screen Coverage")
