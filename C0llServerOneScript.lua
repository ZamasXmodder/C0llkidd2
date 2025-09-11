-- XModder Premium (Steal a brainrot) GUI Script
-- Professional Roblox GUI with animations and effects

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

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 350)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Main Frame Corner
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Main Frame Gradient
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(20, 20, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 45)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(15, 15, 25))
}
mainGradient.Rotation = 45
mainGradient.Parent = mainFrame

-- Border Glow Effect
local borderGlow = Instance.new("Frame")
borderGlow.Name = "BorderGlow"
borderGlow.Size = UDim2.new(1, 4, 1, 4)
borderGlow.Position = UDim2.new(0, -2, 0, -2)
borderGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
borderGlow.BackgroundTransparency = 0.7
borderGlow.BorderSizePixel = 0
borderGlow.ZIndex = -1
borderGlow.Parent = mainFrame

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 17)
borderCorner.Parent = borderGlow

-- Title Frame
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 80)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
titleFrame.BackgroundTransparency = 0.3
titleFrame.BorderSizePixel = 0
titleFrame.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleFrame

-- Title Gradient
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 136)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 150, 255))
}
titleGradient.Rotation = 90
titleGradient.Parent = titleFrame

-- Main Title
local mainTitle = Instance.new("TextLabel")
mainTitle.Name = "MainTitle"
mainTitle.Size = UDim2.new(1, 0, 0.7, 0)
mainTitle.Position = UDim2.new(0, 0, 0, 5)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "XMODDER PREMIUM"
mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTitle.TextScaled = true
mainTitle.Font = Enum.Font.GothamBold
mainTitle.Parent = titleFrame

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0.3, 0)
subtitle.Position = UDim2.new(0, 0, 0.7, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "(Steal a brainrot)"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = titleFrame

-- Trial Info Label
local trialInfo = Instance.new("TextLabel")
trialInfo.Name = "TrialInfo"
trialInfo.Size = UDim2.new(1, -20, 0, 25)
trialInfo.Position = UDim2.new(0, 10, 0, 90)
trialInfo.BackgroundTransparency = 1
trialInfo.Text = "This script is a 5-day trial version. Get premium access for unlimited features."
trialInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
trialInfo.TextSize = 12
trialInfo.TextWrapped = true
trialInfo.Font = Enum.Font.Gotham
trialInfo.Parent = mainFrame

-- Input Frame
local inputFrame = Instance.new("Frame")
inputFrame.Name = "InputFrame"
inputFrame.Size = UDim2.new(1, -40, 0, 60)
inputFrame.Position = UDim2.new(0, 20, 0, 130)
inputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = inputFrame

-- Input Label
local inputLabel = Instance.new("TextLabel")
inputLabel.Name = "InputLabel"
inputLabel.Size = UDim2.new(1, -10, 0, 20)
inputLabel.Position = UDim2.new(0, 5, 0, 5)
inputLabel.BackgroundTransparency = 1
inputLabel.Text = "Enter License Key:"
inputLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
inputLabel.TextSize = 14
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Font = Enum.Font.GothamMedium
inputLabel.Parent = inputFrame

-- Text Box
local textBox = Instance.new("TextBox")
textBox.Name = "KeyTextBox"
textBox.Size = UDim2.new(1, -10, 0, 30)
textBox.Position = UDim2.new(0, 5, 0, 25)
textBox.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
textBox.BorderSizePixel = 0
textBox.Text = ""
textBox.PlaceholderText = "Paste your premium key here..."
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textBox.TextSize = 14
textBox.Font = Enum.Font.Gotham
textBox.ClearTextOnFocus = false
textBox.Parent = inputFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 8)
textBoxCorner.Parent = textBox

-- Buttons Frame
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(1, -40, 0, 60)
buttonsFrame.Position = UDim2.new(0, 20, 0, 210)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

-- Submit Button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(0.48, 0, 1, 0)
submitButton.Position = UDim2.new(0, 0, 0, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
submitButton.BorderSizePixel = 0
submitButton.Text = "SUBMIT"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 16
submitButton.Font = Enum.Font.GothamBold
submitButton.Parent = buttonsFrame

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 12)
submitCorner.Parent = submitButton

local submitGradient = Instance.new("UIGradient")
submitGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 100, 200))
}
submitGradient.Rotation = 90
submitGradient.Parent = submitButton

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Size = UDim2.new(0.48, 0, 1, 0)
getKeyButton.Position = UDim2.new(0.52, 0, 0, 0)
getKeyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "GET KEY"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 16
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.Parent = buttonsFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 12)
getKeyCorner.Parent = getKeyButton

local getKeyGradient = Instance.new("UIGradient")
getKeyGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 100, 0)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 50, 0))
}
getKeyGradient.Rotation = 90
getKeyGradient.Parent = getKeyButton

-- Toast Notification
local toastFrame = Instance.new("Frame")
toastFrame.Name = "ToastFrame"
toastFrame.Size = UDim2.new(0, 300, 0, 60)
toastFrame.Position = UDim2.new(0.5, -150, 1, 100)
toastFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
toastFrame.BorderSizePixel = 0
toastFrame.Parent = screenGui

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 15)
toastCorner.Parent = toastFrame

local toastLabel = Instance.new("TextLabel")
toastLabel.Name = "ToastLabel"
toastLabel.Size = UDim2.new(1, -20, 1, 0)
toastLabel.Position = UDim2.new(0, 10, 0, 0)
toastLabel.BackgroundTransparency = 1
toastLabel.Text = "Key link copied!"
toastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toastLabel.TextSize = 16
toastLabel.Font = Enum.Font.GothamBold
toastLabel.TextXAlignment = Enum.TextXAlignment.Center
toastLabel.Parent = toastFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton

-- Animations
local function createTweenInfo(duration, style, direction)
    return TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
end

-- Entrance Animation
local function playEntranceAnimation()
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local sizeTween = TweenService:Create(mainFrame, createTweenInfo(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 350)
    })
    
    local positionTween = TweenService:Create(mainFrame, createTweenInfo(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -200, 0.5, -175)
    })
    
    sizeTween:Play()
    positionTween:Play()
end

-- Button Hover Effects
local function createHoverEffect(button, normalColor, hoverColor)
    local normalTween = TweenService:Create(button, createTweenInfo(0.2), {BackgroundColor3 = normalColor})
    local hoverTween = TweenService:Create(button, createTweenInfo(0.2), {BackgroundColor3 = hoverColor})
    local scaleUpTween = TweenService:Create(button, createTweenInfo(0.2), {Size = button.Size + UDim2.new(0, 5, 0, 2)})
    local scaleDownTween = TweenService:Create(button, createTweenInfo(0.2), {Size = button.Size})
    
    button.MouseEnter:Connect(function()
        hoverTween:Play()
        scaleUpTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        normalTween:Play()
        scaleDownTween:Play()
    end)
end

-- Apply hover effects
createHoverEffect(submitButton, Color3.fromRGB(0, 150, 255), Color3.fromRGB(0, 180, 255))
createHoverEffect(getKeyButton, Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 130, 30))

-- Toast Animation
local function showToast()
    toastFrame.Position = UDim2.new(0.5, -150, 1, 100)
    
    local slideUpTween = TweenService:Create(toastFrame, createTweenInfo(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -150, 1, -80)
    })
    
    slideUpTween:Play()
    
    slideUpTween.Completed:Connect(function()
        wait(2)
        local slideDownTween = TweenService:Create(toastFrame, createTweenInfo(0.5), {
            Position = UDim2.new(0.5, -150, 1, 100)
        })
        slideDownTween:Play()
    end)
end

-- Glowing border animation
local function animateBorder()
    local glowTween1 = TweenService:Create(borderGlow, createTweenInfo(2), {BackgroundTransparency = 0.3})
    local glowTween2 = TweenService:Create(borderGlow, createTweenInfo(2), {BackgroundTransparency = 0.8})
    
    glowTween1:Play()
    glowTween1.Completed:Connect(function()
        glowTween2:Play()
        glowTween2.Completed:Connect(function()
            animateBorder()
        end)
    end)
end

-- Button Functions
submitButton.MouseButton1Click:Connect(function()
    local key = textBox.Text
    if key ~= "" then
        print("Key submitted:", key)
        -- Add your key validation logic here
    else
        print("Please enter a key!")
    end
end)

getKeyButton.MouseButton1Click:Connect(function()
    -- Copy link to clipboard (simulate)
    local linkToCopy = "https://zamasxmodder.github.io/roblox_premium_page.html/"
    
    -- Since we can't actually copy to clipboard in Roblox, we'll just show the toast
    -- In a real implementation, you might want to display the link for users to copy manually
    print("Link to copy:", linkToCopy)
    
    showToast()
end)

closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(mainFrame, createTweenInfo(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Dragging functionality
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Start animations
wait(0.1)
playEntranceAnimation()
animateBorder()

-- Gradient animation for title
spawn(function()
    while titleFrame.Parent do
        for i = 0, 360, 2 do
            if titleFrame.Parent then
                titleGradient.Rotation = i
                wait(0.05)
            else
                break
            end
        end
    end
end)
