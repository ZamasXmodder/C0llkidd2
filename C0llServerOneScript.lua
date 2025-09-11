-- XModder Premium GUI (Steal a brainrot)
-- Created with love and dark rainbow effects

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XModderPremiumGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame with dark theme and rainbow border
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 450, 0, 320)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Add corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Rainbow border frame
local borderFrame = Instance.new("Frame")
borderFrame.Name = "BorderFrame"
borderFrame.Parent = mainFrame
borderFrame.Size = UDim2.new(1, 6, 1, 6)
borderFrame.Position = UDim2.new(0, -3, 0, -3)
borderFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = -1

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 18)
borderCorner.Parent = borderFrame

-- Rainbow gradient for border
local borderGradient = Instance.new("UIGradient")
borderGradient.Parent = borderFrame

-- Glow effect
local glowFrame = Instance.new("Frame")
glowFrame.Name = "GlowFrame"
glowFrame.Parent = mainFrame
glowFrame.Size = UDim2.new(1, 20, 1, 20)
glowFrame.Position = UDim2.new(0, -10, 0, -10)
glowFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 255)
glowFrame.BackgroundTransparency = 0.8
glowFrame.BorderSizePixel = 0
glowFrame.ZIndex = -2

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 25)
glowCorner.Parent = glowFrame

-- Title Label with gradient effect
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 60)
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "XMODDER PREMIUM"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- Subtitle with brainrot text
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Parent = mainFrame
subtitleLabel.Size = UDim2.new(1, 0, 0, 25)
subtitleLabel.Position = UDim2.new(0, 0, 0, 65)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "(Steal a brainrot)"
subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitleLabel.TextScaled = true
subtitleLabel.Font = Enum.Font.Gotham

-- Trial info label
local trialLabel = Instance.new("TextLabel")
trialLabel.Name = "TrialLabel"
trialLabel.Parent = mainFrame
trialLabel.Size = UDim2.new(1, -20, 0, 20)
trialLabel.Position = UDim2.new(0, 10, 1, -30)
trialLabel.BackgroundTransparency = 1
trialLabel.Text = "This script is a trial version - 5 days remaining. Get full version with premium key!"
trialLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
trialLabel.TextSize = 12
trialLabel.Font = Enum.Font.Gotham
trialLabel.TextWrapped = true

-- Input TextBox with dark theme
local inputBox = Instance.new("TextBox")
inputBox.Name = "InputBox"
inputBox.Parent = mainFrame
inputBox.Size = UDim2.new(1, -40, 0, 45)
inputBox.Position = UDim2.new(0, 20, 0, 110)
inputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
inputBox.BorderSizePixel = 0
inputBox.Text = "Enter your premium key here..."
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 16
inputBox.Font = Enum.Font.Gotham
inputBox.PlaceholderText = "Premium Key Required"
inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputBox

-- Input box glow effect
local inputGlow = Instance.new("Frame")
inputGlow.Parent = inputBox
inputGlow.Size = UDim2.new(1, 4, 1, 4)
inputGlow.Position = UDim2.new(0, -2, 0, -2)
inputGlow.BackgroundColor3 = Color3.fromRGB(100, 0, 255)
inputGlow.BackgroundTransparency = 0.7
inputGlow.BorderSizePixel = 0
inputGlow.ZIndex = -1

local inputGlowCorner = Instance.new("UICorner")
inputGlowCorner.CornerRadius = UDim.new(0, 10)
inputGlowCorner.Parent = inputGlow

-- Submit Button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Parent = mainFrame
submitButton.Size = UDim2.new(0, 180, 0, 45)
submitButton.Position = UDim2.new(0, 30, 0, 180)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
submitButton.BorderSizePixel = 0
submitButton.Text = "SUBMIT KEY"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 16
submitButton.Font = Enum.Font.GothamBold

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 8)
submitCorner.Parent = submitButton

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Parent = mainFrame
getKeyButton.Size = UDim2.new(0, 180, 0, 45)
getKeyButton.Position = UDim2.new(0, 240, 0, 180)
getKeyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "GET KEY"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 16
getKeyButton.Font = Enum.Font.GothamBold

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

-- Button glow effects
local submitGlow = Instance.new("Frame")
submitGlow.Parent = submitButton
submitGlow.Size = UDim2.new(1, 4, 1, 4)
submitGlow.Position = UDim2.new(0, -2, 0, -2)
submitGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
submitGlow.BackgroundTransparency = 0.8
submitGlow.BorderSizePixel = 0
submitGlow.ZIndex = -1

local submitGlowCorner = Instance.new("UICorner")
submitGlowCorner.CornerRadius = UDim.new(0, 10)
submitGlowCorner.Parent = submitGlow

local getKeyGlow = Instance.new("Frame")
getKeyGlow.Parent = getKeyButton
getKeyGlow.Size = UDim2.new(1, 4, 1, 4)
getKeyGlow.Position = UDim2.new(0, -2, 0, -2)
getKeyGlow.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
getKeyGlow.BackgroundTransparency = 0.8
getKeyGlow.BorderSizePixel = 0
getKeyGlow.ZIndex = -1

local getKeyGlowCorner = Instance.new("UICorner")
getKeyGlowCorner.CornerRadius = UDim.new(0, 10)
getKeyGlowCorner.Parent = getKeyGlow

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton

-- Particle effects
local particleFrame = Instance.new("Frame")
particleFrame.Name = "ParticleFrame"
particleFrame.Parent = mainFrame
particleFrame.Size = UDim2.new(1, 0, 1, 0)
particleFrame.BackgroundTransparency = 1

-- Create floating particles
for i = 1, 15 do
    local particle = Instance.new("Frame")
    particle.Name = "Particle" .. i
    particle.Parent = particleFrame
    particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
    particle.BorderSizePixel = 0
    particle.BackgroundTransparency = 0.3
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
end

-- Functions and Animations

-- Rainbow border animation
local function animateRainbowBorder()
    local hue = 0
    RunService.Heartbeat:Connect(function()
        hue = (hue + 0.01) % 1
        borderGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV((hue + 0.3) % 1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV((hue + 0.6) % 1, 1, 1))
        }
    end)
end

-- Floating particles animation
local function animateParticles()
    for i = 1, 15 do
        local particle = particleFrame:FindFirstChild("Particle" .. i)
        if particle then
            local tween = TweenService:Create(particle, 
                TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Position = UDim2.new(math.random(), 0, math.random(), 0)}
            )
            tween:Play()
        end
    end
end

-- Glow pulse animation
local function animateGlow()
    local glowTween = TweenService:Create(glowFrame,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundTransparency = 0.5}
    )
    glowTween:Play()
end

-- Button hover effects
local function setupButtonEffects(button, originalColor, hoverColor)
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = hoverColor, Size = button.Size + UDim2.new(0, 5, 0, 2)}
        )
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = originalColor, Size = button.Size - UDim2.new(0, 5, 0, 2)}
        )
        leaveTween:Play()
    end)
end

-- Toast notification function
local function showToast(message, color)
    local toastGui = Instance.new("ScreenGui")
    toastGui.Parent = playerGui
    
    local toast = Instance.new("Frame")
    toast.Parent = toastGui
    toast.Size = UDim2.new(0, 300, 0, 60)
    toast.Position = UDim2.new(0.5, -150, 0, -70)
    toast.BackgroundColor3 = color or Color3.fromRGB(0, 200, 0)
    toast.BorderSizePixel = 0
    
    local toastCorner = Instance.new("UICorner")
    toastCorner.CornerRadius = UDim.new(0, 10)
    toastCorner.Parent = toast
    
    local toastLabel = Instance.new("TextLabel")
    toastLabel.Parent = toast
    toastLabel.Size = UDim2.new(1, -20, 1, 0)
    toastLabel.Position = UDim2.new(0, 10, 0, 0)
    toastLabel.BackgroundTransparency = 1
    toastLabel.Text = message
    toastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toastLabel.TextScaled = true
    toastLabel.Font = Enum.Font.GothamBold
    
    -- Animate toast in
    local slideIn = TweenService:Create(toast,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -150, 0, 20)}
    )
    slideIn:Play()
    
    -- Wait and slide out
    wait(3)
    local slideOut = TweenService:Create(toast,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -150, 0, -70)}
    )
    slideOut:Play()
    
    slideOut.Completed:Connect(function()
        toastGui:Destroy()
    end)
end

-- Input box focus effects
inputBox.Focused:Connect(function()
    if inputBox.Text == "Enter your premium key here..." then
        inputBox.Text = ""
    end
    local focusTween = TweenService:Create(inputGlow,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 0.3}
    )
    focusTween:Play()
end)

inputBox.FocusLost:Connect(function()
    if inputBox.Text == "" then
        inputBox.Text = "Enter your premium key here..."
    end
    local unfocusTween = TweenService:Create(inputGlow,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 0.7}
    )
    unfocusTween:Play()
end)

-- Button functionality
getKeyButton.MouseButton1Click:Connect(function()
    -- Copy link to clipboard
    setclipboard("https://zamasxmodder.github.io/roblox_premium_page.html/")
    
    -- Show toast notification
    spawn(function()
        showToast("🔑 Key link copied to clipboard!", Color3.fromRGB(100, 0, 255))
    end)
    
    -- Button press animation
    local pressAnim = TweenService:Create(getKeyButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad),
        {Size = getKeyButton.Size - UDim2.new(0, 5, 0, 3)}
    )
    pressAnim:Play()
    
    pressAnim.Completed:Connect(function()
        local releaseAnim = TweenService:Create(getKeyButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad),
            {Size = getKeyButton.Size + UDim2.new(0, 5, 0, 3)}
        )
        releaseAnim:Play()
    end)
end)

submitButton.MouseButton1Click:Connect(function()
    local keyText = inputBox.Text
    if keyText == "" or keyText == "Enter your premium key here..." then
        spawn(function()
            showToast("❌ Please enter a valid key!", Color3.fromRGB(200, 0, 0))
        end)
    else
        spawn(function()
            showToast("🔍 Validating key... Please wait!", Color3.fromRGB(255, 165, 0))
        end)
        
        -- Simulate key validation
        wait(2)
        spawn(function()
            showToast("❌ Invalid key! Get a new one.", Color3.fromRGB(200, 0, 0))
        end)
    end
    
    -- Button press animation
    local pressAnim = TweenService:Create(submitButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad),
        {Size = submitButton.Size - UDim2.new(0, 5, 0, 3)}
    )
    pressAnim:Play()
    
    pressAnim.Completed:Connect(function()
        local releaseAnim = TweenService:Create(submitButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad),
            {Size = submitButton.Size + UDim2.new(0, 5, 0, 3)}
        )
        releaseAnim:Play()
    end)
end)

closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0)}
    )
    closeTween:Play()
    
    closeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Initialize animations and effects
animateRainbowBorder()
animateParticles()
animateGlow()

-- Setup button hover effects
setupButtonEffects(submitButton, Color3.fromRGB(0, 150, 0), Color3.fromRGB(0, 200, 0))
setupButtonEffects(getKeyButton, Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 150, 50))
setupButtonEffects(closeButton, Color3.fromRGB(200, 0, 0), Color3.fromRGB(255, 0, 0))

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local entranceAnim = TweenService:Create(mainFrame,
    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 450, 0, 320)}
)
entranceAnim:Play()

-- Title text gradient animation
spawn(function()
    local hue = 0
    RunService.Heartbeat:Connect(function()
        hue = (hue + 0.02) % 1
        titleLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end)
end)

print("🚀 XModder Premium GUI loaded successfully!")
print("💎 Dark rainbow theme activated!")
print("✨ All animations and effects ready!")
