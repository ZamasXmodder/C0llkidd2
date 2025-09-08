-- 🔥 ULTRA PRO COPY PAGE LINK GUI 🔥
-- Created by ZamasXmodder
-- Professional GUI for copying premium page link

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🚀 PREMIUM PAGE LINK
local PREMIUM_LINK = "https://zamasxmodder.github.io/roblox_premium_page.html/"

-- 🎨 Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopyLinkGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- 🌟 Main Frame (Center Container)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 280)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- 🔥 Gradient Background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 15, 30))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- ✨ Corner Rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = mainFrame

-- 🌈 Animated Border
local borderFrame = Instance.new("Frame")
borderFrame.Name = "BorderFrame"
borderFrame.Size = UDim2.new(1, 6, 1, 6)
borderFrame.Position = UDim2.new(0, -3, 0, -3)
borderFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = mainFrame.ZIndex - 1
borderFrame.Parent = mainFrame

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 23)
borderCorner.Parent = borderFrame

local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 100)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(128, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 100, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 100))
}
borderGradient.Parent = borderFrame

-- 🎯 Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔑 COPY PREMIUM PAGE 🔑"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- ✨ Title Glow Effect
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(255, 0, 100)
titleStroke.Thickness = 2
titleStroke.Parent = titleLabel

-- 📝 Description Label
local descLabel = Instance.new("TextLabel")
descLabel.Name = "DescLabel"
descLabel.Size = UDim2.new(1, -40, 0, 60)
descLabel.Position = UDim2.new(0, 20, 0, 80)
descLabel.BackgroundTransparency = 1
descLabel.Text = "🚀 Get instant access to premium features!\n💎 Click below to copy the link"
descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
descLabel.TextScaled = true
descLabel.Font = Enum.Font.Gotham
descLabel.TextWrapped = true
descLabel.Parent = mainFrame

-- 🎮 Copy Button
local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Size = UDim2.new(0, 300, 0, 60)
copyButton.Position = UDim2.new(0.5, -150, 0, 160)
copyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
copyButton.BorderSizePixel = 0
copyButton.Text = "📋 COPY LINK NOW!"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextScaled = true
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = mainFrame

-- 🌟 Button Corner
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 15)
buttonCorner.Parent = copyButton

-- ✨ Button Gradient
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 100))
}
buttonGradient.Rotation = 45
buttonGradient.Parent = copyButton

-- 🎯 Button Stroke
local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 255, 255)
buttonStroke.Thickness = 2
buttonStroke.Transparency = 0.5
buttonStroke.Parent = copyButton

-- 🔔 Toast Notification Frame
local toastFrame = Instance.new("Frame")
toastFrame.Name = "ToastFrame"
toastFrame.Size = UDim2.new(0, 300, 0, 60)
toastFrame.Position = UDim2.new(0.5, -150, 1, -80)
toastFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
toastFrame.BorderSizePixel = 0
toastFrame.Visible = false
toastFrame.Parent = screenGui

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 15)
toastCorner.Parent = toastFrame

local toastLabel = Instance.new("TextLabel")
toastLabel.Name = "ToastLabel"
toastLabel.Size = UDim2.new(1, 0, 1, 0)
toastLabel.BackgroundTransparency = 1
toastLabel.Text = "✅ LINK COPIED TO CLIPBOARD!"
toastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toastLabel.TextScaled = true
toastLabel.Font = Enum.Font.GothamBold
toastLabel.Parent = toastFrame

-- 🌟 ANIMATION FUNCTIONS
local function createPulseAnimation(object)
    local pulseInfo = TweenInfo.new(
        1.5, -- Duration
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1, -- Repeat infinitely
        true -- Reverse
    )
    
    local pulseTween = TweenService:Create(object, pulseInfo, {
        Size = object.Size + UDim2.new(0, 10, 0, 5)
    })
    
    pulseTween:Play()
    return pulseTween
end

local function createGlowAnimation(object)
    local glowInfo = TweenInfo.new(
        2, -- Duration
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1, -- Repeat infinitely
        true -- Reverse
    )
    
    if object:FindFirstChild("UIStroke") then
        local glowTween = TweenService:Create(object.UIStroke, glowInfo, {
            Transparency = 0
        })
        glowTween:Play()
        return glowTween
    end
end

local function rotateBorder()
    local rotateInfo = TweenInfo.new(
        3, -- Duration
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut,
        -1 -- Repeat infinitely
    )
    
    local rotateTween = TweenService:Create(borderGradient, rotateInfo, {
        Rotation = 360
    })
    
    rotateTween:Play()
    return rotateTween
end

-- 🎯 COPY FUNCTION
local function copyToClipboard()
    -- Change button appearance
    copyButton.Text = "⏳ COPYING..."
    copyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    -- Simulate copy delay
    wait(0.5)
    
    -- Copy to clipboard (this works in some executors)
    if setclipboard then
        setclipboard(PREMIUM_LINK)
    elseif toclipboard then
        toclipboard(PREMIUM_LINK)
    end
    
    -- Reset button
    copyButton.Text = "✅ COPIED!"
    copyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    
    -- Show toast notification
    toastFrame.Visible = true
    toastFrame.Position = UDim2.new(0.5, -150, 1, -80)
    
    -- Animate toast in
    local toastInTween = TweenService:Create(toastFrame, 
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -150, 1, -140)}
    )
    toastInTween:Play()
    
    -- Hide toast after 3 seconds
    wait(3)
    local toastOutTween = TweenService:Create(toastFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -150, 1, -80)}
    )
    toastOutTween:Play()
    
    toastOutTween.Completed:Connect(function()
        toastFrame.Visible = false
    end)
    
    -- Reset button after 2 seconds
    wait(2)
    copyButton.Text = "📋 COPY LINK NOW!"
    copyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
end

-- 🎮 BUTTON HOVER EFFECTS
copyButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(copyButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 320, 0, 65),
            BackgroundColor3 = Color3.fromRGB(255, 50, 120)
        }
    )
    hoverTween:Play()
end)

copyButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(copyButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 300, 0, 60),
            BackgroundColor3 = Color3.fromRGB(255, 0, 100)
        }
    )
    leaveTween:Play()
end)

-- 🎯 BUTTON CLICK EVENT
copyButton.MouseButton1Click:Connect(function()
    -- Button press animation
    local pressInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local pressTween = TweenService:Create(copyButton, pressInfo, {
        Size = UDim2.new(0, 290, 0, 55)
    })
    
    pressTween:Play()
    pressTween.Completed:Connect(function()
        local releaseTween = TweenService:Create(copyButton, pressInfo, {
            Size = UDim2.new(0, 300, 0, 60)
        })
        releaseTween:Play()
    end)
    
    -- Execute copy function
    spawn(copyToClipboard)
end)

-- 🌟 START ANIMATIONS
createPulseAnimation(mainFrame)
createGlowAnimation(titleLabel)
createGlowAnimation(copyButton)
rotateBorder()

-- 💫 Floating animation for main frame
local floatInfo = TweenInfo.new(
    4, -- Duration
    Enum.EasingStyle.Sine,
    Enum.EasingDirection.InOut,
    -1, -- Repeat infinitely
    true -- Reverse
)

local floatTween = TweenService:Create(mainFrame, floatInfo, {
    Position = UDim2.new(0.5, -225, 0.5, -130)
})
floatTween:Play()

-- 🎯 Close GUI with ESC key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape then
        local fadeOut = TweenService:Create(screenGui,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Enabled = false}
        )
        fadeOut:Play()
        
        fadeOut.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end
end)

print("🔥 ULTRA PRO COPY LINK GUI LOADED! 🔥")
print("📋 Link ready to copy: " .. PREMIUM_LINK)
print("⌨️ Press ESC to close GUI")
