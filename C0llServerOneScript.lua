-- Professional Application Interface
-- Clean and functional design

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProfessionalInterface"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame with professional styling
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 420, 0, 280)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
mainFrame.Active = true
mainFrame.Draggable = true

-- Add subtle corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Header section
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Parent = mainFrame
headerFrame.Size = UDim2.new(1, 0, 0, 60)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
headerFrame.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = headerFrame

-- Header bottom corners fix
local headerBottom = Instance.new("Frame")
headerBottom.Name = "HeaderBottom"
headerBottom.Parent = headerFrame
headerBottom.Size = UDim2.new(1, 0, 0, 8)
headerBottom.Position = UDim2.new(0, 0, 1, -8)
headerBottom.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
headerBottom.BorderSizePixel = 0

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = headerFrame
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Application Access"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.SourceSans
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 70)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Trial Version Active"
statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Input Section Label
local inputSectionLabel = Instance.new("TextLabel")
inputSectionLabel.Name = "InputSectionLabel"
inputSectionLabel.Parent = mainFrame
inputSectionLabel.Size = UDim2.new(1, -20, 0, 20)
inputSectionLabel.Position = UDim2.new(0, 10, 0, 100)
inputSectionLabel.BackgroundTransparency = 1
inputSectionLabel.Text = "Access Key:"
inputSectionLabel.TextColor3 = Color3.fromRGB(60, 60, 60)
inputSectionLabel.TextSize = 14
inputSectionLabel.Font = Enum.Font.SourceSansBold
inputSectionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Input TextBox
local inputBox = Instance.new("TextBox")
inputBox.Name = "InputBox"
inputBox.Parent = mainFrame
inputBox.Size = UDim2.new(1, -20, 0, 35)
inputBox.Position = UDim2.new(0, 10, 0, 125)
inputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
inputBox.BorderSizePixel = 1
inputBox.BorderColor3 = Color3.fromRGB(180, 180, 180)
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(40, 40, 40)
inputBox.TextSize = 14
inputBox.Font = Enum.Font.SourceSans
inputBox.PlaceholderText = "Enter access key here"
inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
inputBox.TextXAlignment = Enum.TextXAlignment.Left

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = inputBox

-- Submit Button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Parent = mainFrame
submitButton.Size = UDim2.new(0, 120, 0, 35)
submitButton.Position = UDim2.new(0, 10, 0, 180)
submitButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
submitButton.BorderSizePixel = 0
submitButton.Text = "Verify Access"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 14
submitButton.Font = Enum.Font.SourceSansBold
submitButton.ZIndex = 2

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 4)
submitCorner.Parent = submitButton

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Parent = mainFrame
getKeyButton.Size = UDim2.new(0, 120, 0, 35)
getKeyButton.Position = UDim2.new(0, 140, 0, 180)
getKeyButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "Request Key"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 14
getKeyButton.Font = Enum.Font.SourceSansBold
getKeyButton.ZIndex = 2

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 4)
getKeyCorner.Parent = getKeyButton

-- Help Button
local helpButton = Instance.new("TextButton")
helpButton.Name = "HelpButton"
helpButton.Parent = mainFrame
helpButton.Size = UDim2.new(0, 120, 0, 35)
helpButton.Position = UDim2.new(0, 270, 0, 180)
helpButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
helpButton.BorderSizePixel = 0
helpButton.Text = "Help"
helpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
helpButton.TextSize = 14
helpButton.Font = Enum.Font.SourceSansBold
helpButton.ZIndex = 2

local helpCorner = Instance.new("UICorner")
helpCorner.CornerRadius = UDim.new(0, 4)
helpCorner.Parent = helpButton

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = headerFrame
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 15)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.SourceSansBold
closeButton.ZIndex = 2

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Footer text
local footerLabel = Instance.new("TextLabel")
footerLabel.Name = "FooterLabel"
footerLabel.Parent = mainFrame
footerLabel.Size = UDim2.new(1, -20, 0, 20)
footerLabel.Position = UDim2.new(0, 10, 1, -30)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "For support, please contact the system administrator"
footerLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
footerLabel.TextSize = 12
footerLabel.Font = Enum.Font.SourceSans
footerLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Toast notification function
local function showNotification(message, messageType)
    local notificationColor
    if messageType == "error" then
        notificationColor = Color3.fromRGB(220, 80, 80)
    elseif messageType == "success" then
        notificationColor = Color3.fromRGB(80, 180, 80)
    else
        notificationColor = Color3.fromRGB(70, 130, 200)
    end
    
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "NotificationGui"
    notificationGui.Parent = playerGui
    
    local notification = Instance.new("Frame")
    notification.Parent = notificationGui
    notification.Size = UDim2.new(0, 350, 0, 60)
    notification.Position = UDim2.new(0.5, -175, 0, -70)
    notification.BackgroundColor3 = notificationColor
    notification.BorderSizePixel = 0
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 6)
    notificationCorner.Parent = notification
    
    local notificationLabel = Instance.new("TextLabel")
    notificationLabel.Parent = notification
    notificationLabel.Size = UDim2.new(1, -20, 1, 0)
    notificationLabel.Position = UDim2.new(0, 10, 0, 0)
    notificationLabel.BackgroundTransparency = 1
    notificationLabel.Text = message
    notificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    notificationLabel.TextSize = 14
    notificationLabel.Font = Enum.Font.SourceSans
    notificationLabel.TextWrapped = true
    notificationLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Animate notification
    local slideIn = TweenService:Create(notification,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -175, 0, 20)}
    )
    slideIn:Play()
    
    -- Auto-hide after 3 seconds
    wait(3)
    local slideOut = TweenService:Create(notification,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -175, 0, -70)}
    )
    slideOut:Play()
    
    slideOut.Completed:Connect(function()
        notificationGui:Destroy()
    end)
end

-- Button hover effects
local function setupHoverEffect(button, originalColor, hoverColor)
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = hoverColor}
        )
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = originalColor}
        )
        leaveTween:Play()
    end)
end

-- Input focus effects
inputBox.Focused:Connect(function()
    local focusTween = TweenService:Create(inputBox,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        {BorderColor3 = Color3.fromRGB(70, 130, 200)}
    )
    focusTween:Play()
end)

inputBox.FocusLost:Connect(function()
    local unfocusTween = TweenService:Create(inputBox,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        {BorderColor3 = Color3.fromRGB(180, 180, 180)}
    )
    unfocusTween:Play()
end)

-- Button functionality
getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://example.com/request-access-key")
    spawn(function()
        showNotification("Access key request link copied to clipboard", "info")
    end)
end)

submitButton.MouseButton1Click:Connect(function()
    local keyText = inputBox.Text
    if keyText == "" then
        spawn(function()
            showNotification("Please enter an access key", "error")
        end)
    else
        spawn(function()
            showNotification("Verifying access key...", "info")
        end)
        
        -- Simulate key validation
        wait(1.5)
        spawn(function()
            showNotification("Access key verification failed", "error")
        end)
    end
end)

helpButton.MouseButton1Click:Connect(function()
    spawn(function()
        showNotification("For assistance, please visit the help documentation", "info")
    end)
end)

closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0)}
    )
    closeTween:Play()
    
    closeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Setup hover effects
setupHoverEffect(submitButton, Color3.fromRGB(70, 130, 200), Color3.fromRGB(90, 150, 220))
setupHoverEffect(getKeyButton, Color3.fromRGB(90, 90, 90), Color3.fromRGB(110, 110, 110))
setupHoverEffect(helpButton, Color3.fromRGB(150, 150, 150), Color3.fromRGB(170, 170, 170))
setupHoverEffect(closeButton, Color3.fromRGB(220, 80, 80), Color3.fromRGB(240, 100, 100))

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local entranceAnimation = TweenService:Create(mainFrame,
    TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 420, 0, 280)}
)
entranceAnimation:Play()

print("Professional interface loaded successfully")
print("Application ready for user interaction")
