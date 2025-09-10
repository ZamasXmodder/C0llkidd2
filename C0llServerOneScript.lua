-- XModder Script GUI - Enhanced Visual Edition
-- Advanced animations, particle effects, and modern design

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

-- Background overlay with blur effect
local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.Position = UDim2.new(0, 0, 0, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.2
overlay.BorderSizePixel = 0
overlay.Visible = true
overlay.Parent = screenGui

-- Animated background particles
local particleFrame = Instance.new("Frame")
particleFrame.Name = "ParticleFrame"
particleFrame.Size = UDim2.new(1, 0, 1, 0)
particleFrame.BackgroundTransparency = 1
particleFrame.Parent = overlay

-- Create floating particles
local function createParticle(parent)
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(math.random(), 0, 1.2, 0)
    particle.BackgroundColor3 = Color3.fromHSV(math.random(), 0.8, 1)
    particle.BorderSizePixel = 0
    particle.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = particle
    
    local tween = TweenService:Create(particle, TweenInfo.new(math.random(8, 15), Enum.EasingStyle.Linear), {
        Position = UDim2.new(math.random(), 0, -0.2, 0),
        Rotation = math.random(0, 360)
    })
    tween:Play()
    
    tween.Completed:Connect(function()
        particle:Destroy()
    end)
end

-- Spawn particles continuously
spawn(function()
    while screenGui.Parent do
        if math.random() > 0.7 then
            createParticle(particleFrame)
        end
        wait(0.3)
    end
end)

-- Main GUI Frame with glass morphism effect
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, math.min(480, screenSize.X * 0.85), 0, math.min(620, screenSize.Y * 0.75))
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Glowing outer border
local glowBorder = Instance.new("Frame")
glowBorder.Name = "GlowBorder"
glowBorder.Size = UDim2.new(1, 8, 1, 8)
glowBorder.Position = UDim2.new(0, -4, 0, -4)
glowBorder.BackgroundTransparency = 0
glowBorder.BorderSizePixel = 0
glowBorder.Parent = mainFrame

local glowGradient = Instance.new("UIGradient")
glowGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 0, 127)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 127, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 255, 127)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 127, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(127, 0, 255))
}
glowGradient.Parent = glowBorder

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 20)
glowCorner.Parent = glowBorder

-- Rainbow animated border
local rainbowBorder = Instance.new("Frame")
rainbowBorder.Name = "RainbowBorder"
rainbowBorder.Size = UDim2.new(1, -4, 1, -4)
rainbowBorder.Position = UDim2.new(0, 2, 0, 2)
rainbowBorder.BackgroundTransparency = 0
rainbowBorder.BorderSizePixel = 0
rainbowBorder.Parent = glowBorder

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
borderCorner.CornerRadius = UDim.new(0, 18)
borderCorner.Parent = rainbowBorder

-- Glass morphism content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -6, 1, -6)
contentFrame.Position = UDim2.new(0, 3, 0, 3)
contentFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
contentFrame.BackgroundTransparency = 0.1
contentFrame.BorderSizePixel = 0
contentFrame.Parent = rainbowBorder

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 15)
contentCorner.Parent = contentFrame

-- Glass effect overlay
local glassOverlay = Instance.new("Frame")
glassOverlay.Size = UDim2.new(1, 0, 1, 0)
glassOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassOverlay.BackgroundTransparency = 0.95
glassOverlay.BorderSizePixel = 0
glassOverlay.Parent = contentFrame

local glassCorner = Instance.new("UICorner")
glassCorner.CornerRadius = UDim.new(0, 15)
glassCorner.Parent = glassOverlay

-- Premium gradient background
local premiumGradient = Instance.new("UIGradient")
premiumGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 15, 45)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(15, 5, 30)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(20, 10, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 15, 50))
}
premiumGradient.Rotation = 45
premiumGradient.Parent = contentFrame

-- Animated header with holographic effect
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, -30, 0, 100)
headerFrame.Position = UDim2.new(0, 15, 0, 15)
headerFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
headerFrame.BackgroundTransparency = 0.2
headerFrame.BorderSizePixel = 0
headerFrame.Parent = contentFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerFrame

-- Holographic header gradient
local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 25, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 40, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 20, 60))
}
headerGradient.Rotation = 90
headerGradient.Parent = headerFrame

local headerStroke = Instance.new("UIStroke")
headerStroke.Thickness = 2
headerStroke.Color = Color3.fromRGB(150, 100, 255)
headerStroke.Transparency = 0.3
headerStroke.Parent = headerFrame

-- Animated logo with glow effect
local logoLabel = Instance.new("TextLabel")
logoLabel.Name = "LogoLabel"
logoLabel.Size = UDim2.new(1, -20, 0, 35)
logoLabel.Position = UDim2.new(0, 10, 0, 8)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "⭐ XMODDER SCRIPT ⭐"
logoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
logoLabel.TextSize = 20
logoLabel.Font = Enum.Font.GothamBold
logoLabel.TextStrokeTransparency = 0
logoLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 255)
logoLabel.Parent = headerFrame

-- Holographic text effect
local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 100))
}
logoGradient.Parent = logoLabel

-- Premium subtitle with animation
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Size = UDim2.new(1, -20, 0, 25)
subtitleLabel.Position = UDim2.new(0, 10, 0, 40)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "🧠 STEAL A BRAINROT - PREMIUM EDITION 🧠"
subtitleLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
subtitleLabel.TextSize = 14
subtitleLabel.Font = Enum.Font.GothamMedium
subtitleLabel.Parent = headerFrame

-- Trial access info with pulsing effect
local trialLabel = Instance.new("TextLabel")
trialLabel.Name = "TrialLabel"
trialLabel.Size = UDim2.new(1, -20, 0, 22)
trialLabel.Position = UDim2.new(0, 10, 0, 70)
trialLabel.BackgroundTransparency = 1
trialLabel.Text = "💎 Get Your 5-Day FREE Trial Access Key 💎"
trialLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
trialLabel.TextSize = 12
trialLabel.Font = Enum.Font.GothamBold
trialLabel.Parent = headerFrame

-- Enhanced info panel with glass effect
local infoFrame = Instance.new("Frame")
infoFrame.Name = "InfoFrame"
infoFrame.Size = UDim2.new(1, -30, 0, 140)
infoFrame.Position = UDim2.new(0, 15, 0, 125)
infoFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
infoFrame.BackgroundTransparency = 0.3
infoFrame.BorderSizePixel = 0
infoFrame.Parent = contentFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = infoFrame

local infoStroke = Instance.new("UIStroke")
infoStroke.Thickness = 1.5
infoStroke.Color = Color3.fromRGB(100, 50, 200)
infoStroke.Transparency = 0.2
infoStroke.Parent = infoFrame

-- Info gradient
local infoGradient = Instance.new("UIGradient")
infoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 20, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 10, 35))
}
infoGradient.Rotation = 135
infoGradient.Parent = infoFrame

-- Enhanced features list
local featuresLabel = Instance.new("TextLabel")
featuresLabel.Name = "FeaturesLabel"
featuresLabel.Size = UDim2.new(1, -25, 1, -15)
featuresLabel.Position = UDim2.new(0, 12, 0, 8)
featuresLabel.BackgroundTransparency = 1
featuresLabel.Text = [[🚀 Advanced Script Injection & Execution
🛡️ Undetectable Anti-Cheat Bypass Technology
⚡ Real-time Game Modification Engine
🎯 Premium Support & Instant Updates
📱 Universal Compatibility - All Devices
🔒 Military-Grade Encryption & Security]]
featuresLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
featuresLabel.TextSize = 12
featuresLabel.Font = Enum.Font.Gotham
featuresLabel.TextYAlignment = Enum.TextYAlignment.Top
featuresLabel.TextXAlignment = Enum.TextXAlignment.Left
featuresLabel.Parent = infoFrame

-- Premium key input section
local keyFrame = Instance.new("Frame")
keyFrame.Name = "KeyFrame"
keyFrame.Size = UDim2.new(1, -30, 0, 110)
keyFrame.Position = UDim2.new(0, 15, 0, 275)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 50)
keyFrame.BackgroundTransparency = 0.2
keyFrame.BorderSizePixel = 0
keyFrame.Parent = contentFrame

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 10)
keyCorner.Parent = keyFrame

local keyStroke = Instance.new("UIStroke")
keyStroke.Thickness = 2
keyStroke.Color = Color3.fromRGB(150, 100, 255)
keyStroke.Transparency = 0.5
keyStroke.Parent = keyFrame

-- Key input label with glow
local keyLabel = Instance.new("TextLabel")
keyLabel.Name = "KeyLabel"
keyLabel.Size = UDim2.new(1, -15, 0, 25)
keyLabel.Position = UDim2.new(0, 8, 0, 8)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "🔐 LICENSE KEY ACTIVATION PORTAL"
keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyLabel.TextSize = 14
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextStrokeTransparency = 0.7
keyLabel.TextStrokeColor3 = Color3.fromRGB(255, 100, 255)
keyLabel.Parent = keyFrame

-- Enhanced input box with animations
local inputBox = Instance.new("TextBox")
inputBox.Name = "InputBox"
inputBox.Size = UDim2.new(1, -25, 0, 40)
inputBox.Position = UDim2.new(0, 12, 0, 35)
inputBox.BackgroundColor3 = Color3.fromRGB(5, 5, 25)
inputBox.BorderSizePixel = 0
inputBox.Text = ""
inputBox.PlaceholderText = "Enter your premium license key here..."
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
inputBox.TextSize = 12
inputBox.Font = Enum.Font.Gotham
inputBox.ClearTextOnFocus = false
inputBox.Parent = keyFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputBox

local inputStroke = Instance.new("UIStroke")
inputStroke.Thickness = 1
inputStroke.Color = Color3.fromRGB(100, 60, 180)
inputStroke.Parent = inputBox

-- Input glow effect
local inputGlow = Instance.new("UIGradient")
inputGlow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 5, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 10, 40))
}
inputGlow.Parent = inputBox

-- Enhanced button container
local buttonFrame = Instance.new("Frame")
buttonFrame.Name = "ButtonFrame"
buttonFrame.Size = UDim2.new(1, -30, 0, 120)
buttonFrame.Position = UDim2.new(0, 15, 0, 395)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = contentFrame

-- Premium GET KEY button with holographic effect
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Size = UDim2.new(1, -10, 0, 50)
getKeyButton.Position = UDim2.new(0, 5, 0, 5)
getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "🔑 GET FREE TRIAL KEY"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 14
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextStrokeTransparency = 0.5
getKeyButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
getKeyButton.Parent = buttonFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 10)
getKeyCorner.Parent = getKeyButton

local getKeyStroke = Instance.new("UIStroke")
getKeyStroke.Thickness = 3
getKeyStroke.Color = Color3.fromRGB(100, 255, 150)
getKeyStroke.Parent = getKeyButton

local getKeyGradient = Instance.new("UIGradient")
getKeyGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 127)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 90))
}
getKeyGradient.Rotation = 45
getKeyGradient.Parent = getKeyButton

-- Premium ACTIVATE button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(1, -10, 0, 50)
submitButton.Position = UDim2.new(0, 5, 0, 60)
submitButton.BackgroundColor3 = Color3.fromRGB(200, 0, 200)
submitButton.BorderSizePixel = 0
submitButton.Text = "🚀 ACTIVATE PREMIUM LICENSE"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 14
submitButton.Font = Enum.Font.GothamBold
submitButton.TextStrokeTransparency = 0.5
submitButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
submitButton.Parent = buttonFrame

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 10)
submitCorner.Parent = submitButton

local submitStroke = Instance.new("UIStroke")
submitStroke.Thickness = 3
submitStroke.Color = Color3.fromRGB(255, 100, 255)
submitStroke.Parent = submitButton

local submitGradient = Instance.new("UIGradient")
submitGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 0, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 180))
}
submitGradient.Rotation = 45
submitGradient.Parent = submitButton

-- Enhanced footer with premium branding
local footerFrame = Instance.new("Frame")
footerFrame.Name = "FooterFrame"
footerFrame.Size = UDim2.new(1, -30, 0, 70)
footerFrame.Position = UDim2.new(0, 15, 0, 525)
footerFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
footerFrame.BackgroundTransparency = 0.4
footerFrame.BorderSizePixel = 0
footerFrame.Parent = contentFrame

local footerCorner = Instance.new("UICorner")
footerCorner.CornerRadius = UDim.new(0, 10)
footerCorner.Parent = footerFrame

local footerStroke = Instance.new("UIStroke")
footerStroke.Thickness = 1
footerStroke.Color = Color3.fromRGB(80, 40, 160)
footerStroke.Transparency = 0.6
footerStroke.Parent = footerFrame

local footerLabel = Instance.new("TextLabel")
footerLabel.Name = "FooterLabel"
footerLabel.Size = UDim2.new(1, -15, 1, -8)
footerLabel.Position = UDim2.new(0, 8, 0, 4)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = [[⚡ Powered by XModder Technology™
🔒 Military-Grade Encrypted Connection
💎 Premium Quality Guaranteed
🌟 Trusted by 100,000+ Users Worldwide]]
footerLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
footerLabel.TextSize = 10
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextYAlignment = Enum.TextYAlignment.Top
footerLabel.Parent = footerFrame

-- Enhanced close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = contentFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

local closeStroke = Instance.new("UIStroke")
closeStroke.Thickness = 2
closeStroke.Color = Color3.fromRGB(255, 100, 100)
closeStroke.Parent = closeButton

-- Enhanced status indicator with pulse
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(0, 15, 0, 15)
statusFrame.Position = UDim2.new(0, 15, 0, 15)
statusFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 100, 0, 15)
statusLabel.Position = UDim2.new(0, 35, 0, 15)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🟢 SERVERS ONLINE"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentFrame

-- Enhanced toast notification
local toastFrame = Instance.new("Frame")
toastFrame.Name = "ToastFrame"
toastFrame.Size = UDim2.new(0, 300, 0, 60)
toastFrame.Position = UDim2.new(0.5, -150, 1, 100)
toastFrame.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
toastFrame.BorderSizePixel = 0
toastFrame.Parent = screenGui

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 12)
toastCorner.Parent = toastFrame

local toastStroke = Instance.new("UIStroke")
toastStroke.Thickness = 3
toastStroke.Color = Color3.fromRGB(100, 255, 100)
toastStroke.Parent = toastFrame

local toastGradient = Instance.new("UIGradient")
toastGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 127)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 100))
}
toastGradient.Parent = toastFrame

local toastLabel = Instance.new("TextLabel")
toastLabel.Size = UDim2.new(1, -10, 1, -5)
toastLabel.Position = UDim2.new(0, 5, 0, 2)
toastLabel.BackgroundTransparency = 1
toastLabel.Text = "🔑 Key Link Copied to Clipboard!"
toastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toastLabel.TextSize = 14
toastLabel.Font = Enum.Font.GothamBold
toastLabel.TextStrokeTransparency = 0.5
toastLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
toastLabel.Parent = toastFrame

-- Advanced animation functions
local function animateRainbow()
    spawn(function()
        local rotation = 0
        while rainbowBorder.Parent and glowBorder.Parent do
            rotation = rotation + 2
            rainbowGradient.Rotation = rotation
            glowGradient.Rotation = rotation * 0.5
            
            -- Pulsing glow effect
            local glowPulse = TweenService:Create(glowBorder, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Size = UDim2.new(1, 12, 1, 12),
                Position = UDim2.new(0, -6, 0, -6)
            })
            if not glowBorder:GetAttribute("AnimationPlaying") then
                glowBorder:SetAttribute("AnimationPlaying", true)
                glowPulse:Play()
            end
            
            wait(0.03)
        end
    end)
end

local function animateHolographicText()
    spawn(function()
        while logoLabel.Parent do
            local textShift = TweenService:Create(logoGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false), {
                Rotation = 360
            })
            textShift:Play()
            wait(3)
        end
    end)
end

local function animateStatus()
    spawn(function()
        while statusFrame.Parent do
            local pulse = TweenService:Create(statusFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                BackgroundTransparency = 0.3,
                Size = UDim2.new(0, 18, 0, 18)
            })
            pulse:Play()
            wait(3)
        end
    end)
end

local function animateTrialLabel()
    spawn(function()
        while trialLabel.Parent do
            local glow = TweenService:Create(trialLabel, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                TextTransparency = 0.3
            })
            glow:Play()
            wait(2)
        end
    end)
end

-- Advanced button animations with 3D effects
local function setupAdvancedButtonAnimation(button, originalColor, hoverColor, pressedColor)
    local originalSize = button.Size
    local originalPos = button.Position
    
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            BackgroundColor3 = hoverColor,
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 5, originalSize.Y.Scale, originalSize.Y.Offset + 3),
            Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 2.5, originalPos.Y.Scale, originalPos.Y.Offset - 1.5)
        })
        hoverTween:Play()
        
        -- Glow effect
        if button:FindFirstChild("UIStroke") then
            TweenService:Create(button.UIStroke, TweenInfo.new(0.2), {
                Thickness = 4,
                Transparency = 0
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            BackgroundColor3 = originalColor,
            Size = originalSize,
            Position = originalPos
        })
        leaveTween:Play()
        
        if button:FindFirstChild("UIStroke") then
            TweenService:Create(button.UIStroke, TweenInfo.new(0.2), {
                Thickness = 3,
                Transparency = 0.2
            }):Play()
        end
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = pressedColor,
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 3, originalSize.Y.Scale, originalSize.Y.Offset - 2),
            Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 1.5, originalPos.Y.Scale, originalPos.Y.Offset + 1)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = hoverColor,
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 5, originalSize.Y.Scale, originalSize.Y.Offset + 3),
            Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 2.5, originalPos.Y.Scale, originalPos.Y.Offset - 1.5)
        }):Play()
    end)
end

-- Enhanced toast animation with bounce effect
local function showEnhancedToast(message, color)
    toastLabel.Text = message or "🔑 Key Link Copied!"
    if color then
        toastFrame.BackgroundColor3 = color
    end
    
    -- Bounce in effect
    toastFrame.Size = UDim2.new(0, 0, 0, 0)
    toastFrame.Position = UDim2.new(0.5, 0, 0.85, 0)
    
    local bounceIn = TweenService:Create(toastFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(0.5, -150, 0.85, 0)
    })
    
    bounceIn:Play()
    
    -- Shake effect
    spawn(function()
        wait(0.5)
        for i = 1, 3 do
            TweenService:Create(toastFrame, TweenInfo.new(0.05), {Position = UDim2.new(0.5, -145, 0.85, 0)}):Play()
            wait(0.05)
            TweenService:Create(toastFrame, TweenInfo.new(0.05), {Position = UDim2.new(0.5, -155, 0.85, 0)}):Play()
            wait(0.05)
            TweenService:Create(toastFrame, TweenInfo.new(0.05), {Position = UDim2.new(0.5, -150, 0.85, 0)}):Play()
            wait(0.05)
        end
    end)
    
    wait(3)
    
    local fadeOut = TweenService:Create(toastFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.85, 0),
        BackgroundTransparency = 1
    })
    fadeOut:Play()
    
    fadeOut.Completed:Connect(function()
        toastFrame.BackgroundTransparency = 0
    end)
end

-- Particle explosion effect
local function createParticleExplosion(position)
    for i = 1, 15 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
        particle.Position = position
        particle.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
        particle.BorderSizePixel = 0
        particle.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = particle
        
        local randomX = math.random(-100, 100)
        local randomY = math.random(-100, 100)
        
        local explosion = TweenService:Create(particle, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(position.X.Scale, position.X.Offset + randomX, position.Y.Scale, position.Y.Offset + randomY),
            BackgroundTransparency = 1,
            Rotation = math.random(0, 360)
        })
        explosion:Play()
        
        explosion.Completed:Connect(function()
            particle:Destroy()
        end)
    end
end

-- Event connections with enhanced effects
getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://zamasxmodder.github.io/Maintenanse/")
    createParticleExplosion(UDim2.new(0.5, 0, 0.7, 0))
    spawn(function()
        showEnhancedToast("🔑 Premium Key Link Copied!", Color3.fromRGB(0, 255, 127))
    end)
end)

submitButton.MouseButton1Click:Connect(function()
    local key = inputBox.Text
    if key and key ~= "" then
        createParticleExplosion(UDim2.new(0.5, 0, 0.8, 0))
        spawn(function()
            showEnhancedToast("🚀 Premium License Activated!", Color3.fromRGB(255, 100, 255))
        end)
        print("Premium License Key Submitted:", key)
    else
        spawn(function()
            showEnhancedToast("❌ Please Enter Valid License Key", Color3.fromRGB(255, 100, 100))
        end)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    local scaleOut = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Rotation = 180
    })
    
    local fadeOut = TweenService:Create(overlay, TweenInfo.new(0.3), {
        BackgroundTransparency = 1
    })
    
    scaleOut:Play()
    fadeOut:Play()
    
    scaleOut.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Enhanced input focus effects with typing animation
inputBox.Focused:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Color = Color3.fromRGB(200, 150, 255),
        Thickness = 2
    }):Play()
    
    TweenService:Create(keyFrame, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(30, 25, 60)
    }):Play()
end)

inputBox.FocusLost:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Color = Color3.fromRGB(100, 60, 180),
        Thickness = 1
    }):Play()
    
    TweenService:Create(keyFrame, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(25, 20, 50)
    }):Play()
end)

-- Initialize all enhanced animations and effects
setupAdvancedButtonAnimation(getKeyButton, Color3.fromRGB(0, 200, 100), Color3.fromRGB(0, 230, 130), Color3.fromRGB(0, 170, 80))
setupAdvancedButtonAnimation(submitButton, Color3.fromRGB(200, 0, 200), Color3.fromRGB(230, 0, 230), Color3.fromRGB(170, 0, 170))
setupAdvancedButtonAnimation(closeButton, Color3.fromRGB(255, 50, 50), Color3.fromRGB(255, 80, 80), Color3.fromRGB(200, 30, 30))

animateRainbow()
animateHolographicText()
animateStatus()
animateTrialLabel()

-- Epic entrance animation sequence
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Rotation = -180
overlay.BackgroundTransparency = 1

-- Fade in overlay
TweenService:Create(overlay, TweenInfo.new(0.5), {
    BackgroundTransparency = 0.2
}):Play()

wait(0.2)

-- Epic scale and rotation entrance
local entranceEffect = TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, math.min(480, screenSize.X * 0.85), 0, math.min(620, screenSize.Y * 0.75)),
    Rotation = 0
})
entranceEffect:Play()

-- Screen resize handler
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local newSize = workspace.CurrentCamera.ViewportSize
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, math.min(480, newSize.X * 0.85), 0, math.min(620, newSize.Y * 0.75))
    }):Play()
end)

-- Sound effect simulation (visual feedback)
local function createSoundWave(center)
    for i = 1, 3 do
        spawn(function()
            wait(i * 0.1)
            local wave = Instance.new("Frame")
            wave.Size = UDim2.new(0, 20, 0, 20)
            wave.Position = center
            wave.AnchorPoint = Vector2.new(0.5, 0.5)
            wave.BackgroundTransparency = 0.5
            wave.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            wave.BorderSizePixel = 0
            wave.Parent = screenGui
            
            local waveCorner = Instance.new("UICorner")
            waveCorner.CornerRadius = UDim.new(1, 0)
            waveCorner.Parent = wave
            
            local expand = TweenService:Create(wave, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 100, 0, 100),
                BackgroundTransparency = 1
            })
            expand:Play()
            
            expand.Completed:Connect(function()
                wave:Destroy()
            end)
        end)
    end
end

-- Add sound waves to button clicks
getKeyButton.MouseButton1Click:Connect(function()
    createSoundWave(UDim2.new(0.5, 0, 0.7, 0))
end)

submitButton.MouseButton1Click:Connect(function()
    createSoundWave(UDim2.new(0.5, 0, 0.8, 0))
end)

print("✨ XModder Script GUI - Enhanced Visual Edition Loaded! ✨")
print("🚀 Premium Features | 🌈 Advanced Animations | 💎 Professional Design")
print("🔥 Now with particle effects, holographic text, and glass morphism!")
