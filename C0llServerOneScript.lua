-- XModder Script GUI - Professional Dark Rainbow Edition
-- Responsive design that adapts to any screen size

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove existing GUI if present
if playerGui:FindFirstChild("XModderGUI") then
    playerGui.XModderGUI:Destroy()
end

-- Get screen size for responsive design
local screenSize = workspace.CurrentCamera.ViewportSize

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XModderGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.Parent = playerGui

-- Background overlay (semi-transparent) - visible immediately
local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.Position = UDim2.new(0, 0, 0, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.4
overlay.BorderSizePixel = 0
overlay.Visible = true
overlay.Parent = screenGui

-- Main GUI Frame (responsive size)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, math.min(450, screenSize.X * 0.8), 0, math.min(550, screenSize.Y * 0.7))
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Rainbow border effect
local rainbowBorder = Instance.new("Frame")
rainbowBorder.Name = "RainbowBorder"
rainbowBorder.Size = UDim2.new(1, 0, 1, 0)
rainbowBorder.Position = UDim2.new(0, 0, 0, 0)
rainbowBorder.BackgroundTransparency = 0
rainbowBorder.BorderSizePixel = 0
rainbowBorder.Parent = mainFrame

local rainbowGradient = Instance.new("UIGradient")
rainbowGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 127)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 102, 0)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 127)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 127, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(127, 0, 255))
}
rainbowGradient.Parent = rainbowBorder

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 15)
borderCorner.Parent = rainbowBorder

-- Inner content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -4, 1, -4)
contentFrame.Position = UDim2.new(0, 2, 0, 2)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = rainbowBorder

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 13)
contentCorner.Parent = contentFrame

-- Dark gradient overlay
local darkGradient = Instance.new("UIGradient")
darkGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 10, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 5, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 10, 40))
}
darkGradient.Rotation = 135
darkGradient.Parent = contentFrame

-- Header Section
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, -20, 0, 80)
headerFrame.Position = UDim2.new(0, 10, 0, 10)
headerFrame.BackgroundColor3 = Color3.fromRGB(25, 15, 45)
headerFrame.BackgroundTransparency = 0.3
headerFrame.BorderSizePixel = 0
headerFrame.Parent = contentFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = headerFrame

local headerStroke = Instance.new("UIStroke")
headerStroke.Thickness = 1
headerStroke.Color = Color3.fromRGB(100, 50, 150)
headerStroke.Transparency = 0.5
headerStroke.Parent = headerFrame

-- Logo/Brand text
local logoLabel = Instance.new("TextLabel")
logoLabel.Name = "LogoLabel"
logoLabel.Size = UDim2.new(1, -10, 0, 25)
logoLabel.Position = UDim2.new(0, 5, 0, 5)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "★ XMODDER SCRIPT ★"
logoLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
logoLabel.TextSize = 16
logoLabel.Font = Enum.Font.GothamBold
logoLabel.TextStrokeTransparency = 0.5
logoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
logoLabel.Parent = headerFrame

-- Subtitle
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Size = UDim2.new(1, -10, 0, 20)
subtitleLabel.Position = UDim2.new(0, 5, 0, 30)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "STEAL A BRAINROT - PREMIUM EDITION"
subtitleLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
subtitleLabel.TextSize = 12
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Parent = headerFrame

-- Trial info
local trialLabel = Instance.new("TextLabel")
trialLabel.Name = "TrialLabel"
trialLabel.Size = UDim2.new(1, -10, 0, 18)
trialLabel.Position = UDim2.new(0, 5, 0, 55)
trialLabel.BackgroundTransparency = 1
trialLabel.Text = "• Get Your 5-Day FREE Trial Access Key •"
trialLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
trialLabel.TextSize = 10
trialLabel.Font = Enum.Font.GothamMedium
trialLabel.Parent = headerFrame

-- Info Panel
local infoFrame = Instance.new("Frame")
infoFrame.Name = "InfoFrame"
infoFrame.Size = UDim2.new(1, -20, 0, 120)
infoFrame.Position = UDim2.new(0, 10, 0, 100)
infoFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
infoFrame.BackgroundTransparency = 0.2
infoFrame.BorderSizePixel = 0
infoFrame.Parent = contentFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

local infoStroke = Instance.new("UIStroke")
infoStroke.Thickness = 1
infoStroke.Color = Color3.fromRGB(75, 25, 125)
infoStroke.Transparency = 0.3
infoStroke.Parent = infoFrame

-- Features list
local featuresLabel = Instance.new("TextLabel")
featuresLabel.Name = "FeaturesLabel"
featuresLabel.Size = UDim2.new(1, -20, 1, -10)
featuresLabel.Position = UDim2.new(0, 10, 0, 5)
featuresLabel.BackgroundTransparency = 1
featuresLabel.Text = [[✓ Advanced Script Injection
✓ Undetectable Anti-Cheat Bypass  
✓ Real-time Game Modification
✓ Premium Support & Updates
✓ Works on All Devices & Executors]]
featuresLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
featuresLabel.TextSize = 11
featuresLabel.Font = Enum.Font.Gotham
featuresLabel.TextYAlignment = Enum.TextYAlignment.Top
featuresLabel.TextXAlignment = Enum.TextXAlignment.Left
featuresLabel.Parent = infoFrame

-- Key Input Section
local keyFrame = Instance.new("Frame")
keyFrame.Name = "KeyFrame"
keyFrame.Size = UDim2.new(1, -20, 0, 90)
keyFrame.Position = UDim2.new(0, 10, 0, 230)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 15, 45)
keyFrame.BackgroundTransparency = 0.1
keyFrame.BorderSizePixel = 0
keyFrame.Parent = contentFrame

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyFrame

-- Key input label
local keyLabel = Instance.new("TextLabel")
keyLabel.Name = "KeyLabel"
keyLabel.Size = UDim2.new(1, -10, 0, 20)
keyLabel.Position = UDim2.new(0, 5, 0, 5)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "LICENSE KEY ACTIVATION"
keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyLabel.TextSize = 12
keyLabel.Font = Enum.Font.GothamBold
keyLabel.Parent = keyFrame

-- Input TextBox
local inputBox = Instance.new("TextBox")
inputBox.Name = "InputBox"
inputBox.Size = UDim2.new(1, -20, 0, 35)
inputBox.Position = UDim2.new(0, 10, 0, 25)
inputBox.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
inputBox.BorderSizePixel = 0
inputBox.Text = ""
inputBox.PlaceholderText = "Enter your license key here..."
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
inputBox.TextSize = 11
inputBox.Font = Enum.Font.Gotham
inputBox.ClearTextOnFocus = false
inputBox.Parent = keyFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

local inputStroke = Instance.new("UIStroke")
inputStroke.Thickness = 1
inputStroke.Color = Color3.fromRGB(80, 40, 120)
inputStroke.Parent = inputBox

-- Button Container
local buttonFrame = Instance.new("Frame")
buttonFrame.Name = "ButtonFrame"
buttonFrame.Size = UDim2.new(1, -20, 0, 100)
buttonFrame.Position = UDim2.new(0, 10, 0, 330)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = contentFrame

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Size = UDim2.new(1, -10, 0, 40)
getKeyButton.Position = UDim2.new(0, 5, 0, 5)
getKeyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "🔑 GET FREE TRIAL KEY"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 12
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.Parent = buttonFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

local getKeyStroke = Instance.new("UIStroke")
getKeyStroke.Thickness = 2
getKeyStroke.Color = Color3.fromRGB(100, 200, 100)
getKeyStroke.Parent = getKeyButton

-- Submit Key Button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(1, -10, 0, 40)
submitButton.Position = UDim2.new(0, 5, 0, 50)
submitButton.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
submitButton.BorderSizePixel = 0
submitButton.Text = "🚀 ACTIVATE LICENSE"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 12
submitButton.Font = Enum.Font.GothamBold
submitButton.Parent = buttonFrame

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 8)
submitCorner.Parent = submitButton

local submitStroke = Instance.new("UIStroke")
submitStroke.Thickness = 2
submitStroke.Color = Color3.fromRGB(200, 100, 200)
submitStroke.Parent = submitButton

-- Footer info
local footerFrame = Instance.new("Frame")
footerFrame.Name = "FooterFrame"
footerFrame.Size = UDim2.new(1, -20, 0, 60)
footerFrame.Position = UDim2.new(0, 10, 0, 440)
footerFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
footerFrame.BackgroundTransparency = 0.3
footerFrame.BorderSizePixel = 0
footerFrame.Parent = contentFrame

local footerCorner = Instance.new("UICorner")
footerCorner.CornerRadius = UDim.new(0, 8)
footerCorner.Parent = footerFrame

local footerLabel = Instance.new("TextLabel")
footerLabel.Name = "FooterLabel"
footerLabel.Size = UDim2.new(1, -10, 1, -5)
footerLabel.Position = UDim2.new(0, 5, 0, 2)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = [[⚡ Powered by XModder Technology
🔒 Secure & Encrypted Connection
💎 Premium Quality Guaranteed]]
footerLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
footerLabel.TextSize = 9
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextYAlignment = Enum.TextYAlignment.Top
footerLabel.Parent = footerFrame

-- Close button (X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = contentFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton

-- Status indicator
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(0, 12, 0, 12)
statusFrame.Position = UDim2.new(0, 10, 0, 10)
statusFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 80, 0, 12)
statusLabel.Position = UDim2.new(0, 25, 0, 10)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "ONLINE"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextSize = 9
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentFrame

-- Toast notification
local toastFrame = Instance.new("Frame")
toastFrame.Name = "ToastFrame"
toastFrame.Size = UDim2.new(0, 250, 0, 50)
toastFrame.Position = UDim2.new(0.5, -125, 1, 100)
toastFrame.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
toastFrame.BorderSizePixel = 0
toastFrame.Parent = screenGui

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 10)
toastCorner.Parent = toastFrame

local toastStroke = Instance.new("UIStroke")
toastStroke.Thickness = 2
toastStroke.Color = Color3.fromRGB(100, 200, 100)
toastStroke.Parent = toastFrame

local toastLabel = Instance.new("TextLabel")
toastLabel.Size = UDim2.new(1, 0, 1, 0)
toastLabel.BackgroundTransparency = 1
toastLabel.Text = "🔑 Key Copied to Clipboard!"
toastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toastLabel.TextSize = 12
toastLabel.Font = Enum.Font.GothamBold
toastLabel.Parent = toastFrame

-- Animation functions
local function animateRainbow()
    spawn(function()
        local rotation = 0
        while rainbowBorder.Parent do
            rotation = rotation + 1
            rainbowGradient.Rotation = rotation
            wait(0.05)
        end
    end)
end

local function animateStatus()
    spawn(function()
        while statusFrame.Parent do
            local pulse = TweenService:Create(statusFrame, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                BackgroundTransparency = 0.5
            })
            pulse:Play()
            wait(2)
        end
    end)
end

-- Button animations
local function setupButtonAnimation(button, originalColor, hoverColor)
    local originalSize = button.Size
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor,
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, originalSize.Y.Scale + 0.05, originalSize.Y.Offset)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor,
            Size = originalSize
        }):Play()
    end)
end

-- Toast animation
local function showToast(message)
    toastLabel.Text = message or "🔑 Key Copied to Clipboard!"
    
    local slideIn = TweenService:Create(toastFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -125, 0.85, 0)
    })
    
    slideIn:Play()
    
    wait(2.5)
    
    local slideOut = TweenService:Create(toastFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -125, 1, 100)
    })
    slideOut:Play()
end

-- Event connections
getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://zamasxmodder.github.io/Maintenanse/")
    spawn(function()
        showToast("🔑 Key Link Copied!")
    end)
end)

submitButton.MouseButton1Click:Connect(function()
    local key = inputBox.Text
    if key and key ~= "" then
        spawn(function()
            showToast("🚀 License Activated!")
        end)
        print("License Key Submitted:", key)
    else
        spawn(function()
            showToast("❌ Please Enter Valid Key")
        end)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    local fadeOut = TweenService:Create(screenGui, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Enabled = false
    })
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Input focus effects
inputBox.Focused:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.3), {
        Color = Color3.fromRGB(150, 100, 200),
        Thickness = 2
    }):Play()
end)

inputBox.FocusLost:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.3), {
        Color = Color3.fromRGB(80, 40, 120),
        Thickness = 1
    }):Play()
end)

-- Initialize animations and effects
setupButtonAnimation(getKeyButton, Color3.fromRGB(50, 150, 50), Color3.fromRGB(70, 180, 70))
setupButtonAnimation(submitButton, Color3.fromRGB(150, 50, 150), Color3.fromRGB(180, 70, 180))
setupButtonAnimation(closeButton, Color3.fromRGB(200, 50, 50), Color3.fromRGB(220, 70, 70))

animateRainbow()
animateStatus()

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local entranceEffect = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, math.min(450, screenSize.X * 0.8), 0, math.min(550, screenSize.Y * 0.7))
})
entranceEffect:Play()

-- Handle screen resize
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local newSize = workspace.CurrentCamera.ViewportSize
    mainFrame.Size = UDim2.new(0, math.min(450, newSize.X * 0.8), 0, math.min(550, newSize.Y * 0.7))
end)

print("XModder Script GUI - Professional Edition Loaded!")
print("Responsive Design | Dark Rainbow Theme | Premium Features")
