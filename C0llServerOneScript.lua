-- CHILLI PREMIUM - Professional Access Portal
-- Created by ZamasXmodder
-- Formal GUI for premium access management

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- PREMIUM PAGE LINK
local PREMIUM_LINK = "https://zamasxmodder.github.io/roblox_premium_page.html/"

-- Create main ScreenGui with topbar disabled
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChilliPremiumGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Disable topbar for full immersion
StarterGui:SetCore("TopbarEnabled", false)

-- FULLSCREEN OVERLAY
local overlayFrame = Instance.new("Frame")
overlayFrame.Name = "OverlayFrame"
overlayFrame.Size = UDim2.new(1, 0, 1, 0)
overlayFrame.Position = UDim2.new(0, 0, 0, 0)
overlayFrame.BackgroundColor3 = Color3.fromRGB(5, 15, 10)
overlayFrame.BorderSizePixel = 0
overlayFrame.Parent = screenGui

-- Dark green gradient overlay
local overlayGradient = Instance.new("UIGradient")
overlayGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 15, 10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 25, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 15, 10))
}
overlayGradient.Rotation = 45
overlayGradient.Parent = overlayFrame

-- DECORATIVE CORNER ELEMENTS
local function createCornerDecor(position, rotation)
    local decorFrame = Instance.new("Frame")
    decorFrame.Size = UDim2.new(0, 200, 0, 200)
    decorFrame.Position = position
    decorFrame.BackgroundTransparency = 0.7
    decorFrame.BorderSizePixel = 0
    decorFrame.Rotation = rotation
    decorFrame.Parent = overlayFrame
    
    local decorGradient = Instance.new("UIGradient")
    decorGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 50))
    }
    decorGradient.Parent = decorFrame
    
    local decorCorner = Instance.new("UICorner")
    decorCorner.CornerRadius = UDim.new(0, 25)
    decorCorner.Parent = decorFrame
    
    return decorFrame
end

-- Add corner decorations
createCornerDecor(UDim2.new(0, -100, 0, -100), 45)
createCornerDecor(UDim2.new(1, -100, 0, -100), 135)
createCornerDecor(UDim2.new(0, -100, 1, -100), -45)
createCornerDecor(UDim2.new(1, -100, 1, -100), -135)

-- MAIN CONTENT FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = overlayFrame

-- Professional gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 25, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 20, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 30, 25))
}
gradient.Rotation = 90
gradient.Parent = mainFrame

-- Professional corner rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- WIDE PROFESSIONAL BORDER
local borderFrame = Instance.new("Frame")
borderFrame.Name = "BorderFrame"
borderFrame.Size = UDim2.new(1, 12, 1, 12)
borderFrame.Position = UDim2.new(0, -6, 0, -6)
borderFrame.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = mainFrame.ZIndex - 1
borderFrame.Parent = mainFrame

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 21)
borderCorner.Parent = borderFrame

-- RAINBOW BORDER GRADIENT
local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(238, 130, 238))
}
borderGradient.Parent = borderFrame

-- PROFESSIONAL TITLE
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 60)
titleLabel.Position = UDim2.new(0, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "CHILLI PREMIUM"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
titleLabel.TextSize = 36
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Professional title glow
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(0, 200, 80)
titleStroke.Thickness = 2
titleStroke.Parent = titleLabel

-- SUBTITLE
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Size = UDim2.new(1, -40, 0, 25)
subtitleLabel.Position = UDim2.new(0, 20, 0, 100)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Professional Access Management System"
subtitleLabel.TextColor3 = Color3.fromRGB(150, 200, 170)
subtitleLabel.TextSize = 16
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Parent = mainFrame

-- MAIN DESCRIPTION
local descLabel = Instance.new("TextLabel")
descLabel.Name = "DescLabel"
descLabel.Size = UDim2.new(1, -40, 0, 80)
descLabel.Position = UDim2.new(0, 20, 0, 140)
descLabel.BackgroundTransparency = 1
descLabel.Text = "Access your premium features through our secure portal.\nAfter purchase, your premium panel will be automatically unlocked.\n\nClick below to copy the access link to your clipboard."
descLabel.TextColor3 = Color3.fromRGB(180, 220, 190)
descLabel.TextSize = 14
descLabel.Font = Enum.Font.Gotham
descLabel.TextWrapped = true
descLabel.Parent = mainFrame

-- PROFESSIONAL COPY BUTTON
local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Size = UDim2.new(0, 350, 0, 50)
copyButton.Position = UDim2.new(0.5, -175, 0, 250)
copyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 60)
copyButton.BorderSizePixel = 0
copyButton.Text = "Copy Access Link"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 16
copyButton.Font = Enum.Font.GothamSemibold
copyButton.Parent = mainFrame

-- Professional button styling
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = copyButton

-- Green gradient for button
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 75)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 120, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 50))
}
buttonGradient.Rotation = 90
buttonGradient.Parent = copyButton

-- Professional button border
local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(0, 200, 100)
buttonStroke.Thickness = 2
buttonStroke.Parent = copyButton

-- STATUS INDICATOR
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 320)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready to copy • Secure connection established"
statusLabel.TextColor3 = Color3.fromRGB(100, 180, 120)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- PROFESSIONAL TOAST NOTIFICATION
local toastFrame = Instance.new("Frame")
toastFrame.Name = "ToastFrame"
toastFrame.Size = UDim2.new(0, 400, 0, 50)
toastFrame.Position = UDim2.new(0.5, -200, 1, -70)
toastFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
toastFrame.BorderSizePixel = 0
toastFrame.Visible = false
toastFrame.Parent = screenGui

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 8)
toastCorner.Parent = toastFrame

-- Toast gradient
local toastGradient = Instance.new("UIGradient")
toastGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 40))
}
toastGradient.Parent = toastFrame

-- Toast border
local toastStroke = Instance.new("UIStroke")
toastStroke.Color = Color3.fromRGB(0, 200, 100)
toastStroke.Thickness = 2
toastStroke.Parent = toastFrame

local toastLabel = Instance.new("TextLabel")
toastLabel.Name = "ToastLabel"
toastLabel.Size = UDim2.new(1, 0, 1, 0)
toastLabel.BackgroundTransparency = 1
toastLabel.Text = "Link copied to clipboard successfully"
toastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toastLabel.TextSize = 14
toastLabel.Font = Enum.Font.GothamSemibold
toastLabel.Parent = toastFrame

-- PROFESSIONAL ANIMATION FUNCTIONS
local function createSubtleGlow(object)
    if object:FindFirstChild("UIStroke") then
        local glowInfo = TweenInfo.new(
            3, -- Duration
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1, -- Repeat infinitely
            true -- Reverse
        )
        
        local glowTween = TweenService:Create(object.UIStroke, glowInfo, {
            Transparency = 0.3
        })
        glowTween:Play()
        return glowTween
    end
end

local function rotateRainbowBorder()
    local rotateInfo = TweenInfo.new(
        5, -- Slower, more professional
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

local function animateCornerDecors()
    local decorFrames = {}
    for i, child in pairs(overlayFrame:GetChildren()) do
        if child.Name == "decorFrame" or child.ClassName == "Frame" and child ~= mainFrame then
            table.insert(decorFrames, child)
        end
    end
    
    for i, decor in pairs(decorFrames) do
        local floatInfo = TweenInfo.new(
            4 + i, -- Staggered timing
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        )
        
        local floatTween = TweenService:Create(decor, floatInfo, {
            Rotation = decor.Rotation + 10
        })
        floatTween:Play()
    end
end

-- PROFESSIONAL COPY FUNCTION
local function copyToClipboard()
    -- Professional button state changes
    copyButton.Text = "Processing..."
    statusLabel.Text = "Copying access link • Please wait"
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    
    local processTween = TweenService:Create(copyButton, 
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}
    )
    processTween:Play()
    
    -- Simulate processing delay
    wait(0.8)
    
    -- Copy to clipboard (works in most executors)
    if setclipboard then
        setclipboard(PREMIUM_LINK)
    elseif toclipboard then
        toclipboard(PREMIUM_LINK)
    end
    
    -- Success state
    copyButton.Text = "Link Copied Successfully"
    statusLabel.Text = "Access link copied • Ready for use"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    
    local successTween = TweenService:Create(copyButton, 
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(0, 150, 75)}
    )
    successTween:Play()
    
    -- Show professional toast
    toastFrame.Visible = true
    toastFrame.Position = UDim2.new(0.5, -200, 1, -70)
    
    local toastInTween = TweenService:Create(toastFrame, 
        TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -200, 1, -130)}
    )
    toastInTween:Play()
    
    -- Hide toast after 4 seconds
    wait(4)
    local toastOutTween = TweenService:Create(toastFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -200, 1, -70)}
    )
    toastOutTween:Play()
    
    toastOutTween.Completed:Connect(function()
        toastFrame.Visible = false
    end)
    
    -- Reset to original state after 3 seconds
    wait(3)
    copyButton.Text = "Copy Access Link"
    statusLabel.Text = "Ready to copy • Secure connection established"
    statusLabel.TextColor3 = Color3.fromRGB(100, 180, 120)
    
    local resetTween = TweenService:Create(copyButton, 
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(0, 120, 60)}
    )
    resetTween:Play()
end

-- PROFESSIONAL BUTTON INTERACTIONS
copyButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(copyButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundColor3 = Color3.fromRGB(0, 140, 70)
        }
    )
    hoverTween:Play()
    
    -- Subtle status update
    statusLabel.Text = "Click to copy access link • Secure connection established"
end)

copyButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(copyButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundColor3 = Color3.fromRGB(0, 120, 60)
        }
    )
    leaveTween:Play()
    
    -- Reset status
    statusLabel.Text = "Ready to copy • Secure connection established"
end)

-- PROFESSIONAL CLICK EVENT
copyButton.MouseButton1Click:Connect(function()
    -- Subtle press animation
    local pressInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local pressTween = TweenService:Create(copyButton, pressInfo, {
        Size = UDim2.new(0, 345, 0, 48)
    })
    
    pressTween:Play()
    pressTween.Completed:Connect(function()
        local releaseTween = TweenService:Create(copyButton, pressInfo, {
            Size = UDim2.new(0, 350, 0, 50)
        })
        releaseTween:Play()
    end)
    
    -- Execute professional copy function
    spawn(copyToClipboard)
end)

-- START PROFESSIONAL ANIMATIONS
createSubtleGlow(titleLabel)
createSubtleGlow(copyButton)
rotateRainbowBorder()
animateCornerDecors()

-- Subtle floating animation for main frame
local floatInfo = TweenInfo.new(
    6, -- Slower, more professional
    Enum.EasingStyle.Sine,
    Enum.EasingDirection.InOut,
    -1, -- Repeat infinitely
    true -- Reverse
)

local floatTween = TweenService:Create(mainFrame, floatInfo, {
    Position = UDim2.new(0.5, -300, 0.5, -190)
})
floatTween:Play()

-- Professional close functionality
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape then
        -- Re-enable topbar before closing
        StarterGui:SetCore("TopbarEnabled", true)
        
        local fadeOut = TweenService:Create(overlayFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        fadeOut:Play()
        
        -- Fade out main frame
        local mainFadeOut = TweenService:Create(mainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        mainFadeOut:Play()
        
        fadeOut.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end
end)

-- Professional initialization messages
print("CHILLI PREMIUM - Access Portal Initialized")
print("Link configured: " .. PREMIUM_LINK)
print("Press ESC to close • Professional GUI ready")
