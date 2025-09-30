-- Matrix Japanese Theme Login Panel
-- By Zamas 2025
-- Violence Edition - Steal a Brainrot
-- Enhanced Visual Version

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Screen size detection
local camera = workspace.CurrentCamera
local screenSize = camera.ViewportSize
local isMobile = screenSize.X < 800

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MatrixLoginPanel"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Background Overlay
local backgroundOverlay = Instance.new("Frame")
backgroundOverlay.Name = "BackgroundOverlay"
backgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
backgroundOverlay.Position = UDim2.new(0, 0, 0, 0)
backgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backgroundOverlay.BackgroundTransparency = 0.5
backgroundOverlay.Parent = screenGui
backgroundOverlay.ZIndex = 0

-- Main Panel Frame (Responsive)
local panelWidth = isMobile and 0.9 or 0.35
local panelHeight = isMobile and 0.8 or 0.7

local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(panelWidth, 0, panelHeight, 0)
mainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
mainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
mainPanel.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
mainPanel.BorderSizePixel = 0
mainPanel.Parent = screenGui
mainPanel.ZIndex = 2

-- Red Border Effect
local borderGlow = Instance.new("UIStroke")
borderGlow.Color = Color3.fromRGB(255, 0, 0)
borderGlow.Thickness = isMobile and 2 or 3
borderGlow.Transparency = 0
borderGlow.Parent = mainPanel

-- Corner Rounding
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, isMobile and 8 or 12)
uiCorner.Parent = mainPanel

-- Gradient Background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 0, 0))
}
gradient.Rotation = 90
gradient.Parent = mainPanel

-- Matrix Rain Effect Background
local matrixBg = Instance.new("Frame")
matrixBg.Name = "MatrixBg"
matrixBg.Size = UDim2.new(1, 0, 1, 0)
matrixBg.BackgroundTransparency = 1
matrixBg.Parent = mainPanel
matrixBg.ZIndex = 1
matrixBg.ClipsDescendants = true

-- Title Frame
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, isMobile and 80 or 120)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundTransparency = 1
titleFrame.Parent = mainPanel
titleFrame.ZIndex = 2

-- Main Title
local mainTitle = Instance.new("TextLabel")
mainTitle.Text = "LENON X ZAMAS"
mainTitle.Size = UDim2.new(1, 0, 0, isMobile and 30 or 50)
mainTitle.Position = UDim2.new(0, 0, 0, isMobile and 15 or 20)
mainTitle.BackgroundTransparency = 1
mainTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
mainTitle.TextScaled = true
mainTitle.Font = Enum.Font.SciFi
mainTitle.Parent = titleFrame
mainTitle.ZIndex = 3

-- Add text stroke to title
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(150, 0, 0)
titleStroke.Thickness = isMobile and 1 or 2
titleStroke.Parent = mainTitle

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Text = "Violence Edition - Steal a Brainrot"
subtitle.Size = UDim2.new(1, 0, 0, isMobile and 20 or 25)
subtitle.Position = UDim2.new(0, 0, 0, isMobile and 50 or 75)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(200, 0, 0)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Code
subtitle.Parent = titleFrame
subtitle.ZIndex = 3

-- Close Button (X)
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, isMobile and 25 or 35, 0, isMobile and 25 or 35)
closeButton.Position = UDim2.new(1, isMobile and -35 or -45, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextScaled = true
closeButton.Parent = mainPanel
closeButton.ZIndex = 4

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, isMobile and 6 or 8)
closeCorner.Parent = closeButton

-- Info Button
local infoButton = Instance.new("TextButton")
infoButton.Text = "ℹ"
infoButton.Size = UDim2.new(0, isMobile and 25 or 35, 0, isMobile and 25 or 35)
infoButton.Position = UDim2.new(0, 10, 0, 10)
infoButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
infoButton.TextColor3 = Color3.fromRGB(0, 0, 0)
infoButton.Font = Enum.Font.SourceSansBold
infoButton.TextScaled = true
infoButton.Parent = mainPanel
infoButton.ZIndex = 4

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, isMobile and 6 or 8)
infoCorner.Parent = infoButton

-- Password Input Container
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(0.85, 0, 0, isMobile and 50 or 60)
inputContainer.Position = UDim2.new(0.075, 0, isMobile and 0.3 or 0.35, 0)
inputContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
inputContainer.Parent = mainPanel
inputContainer.ZIndex = 2

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(255, 0, 0)
inputStroke.Thickness = 2
inputStroke.Parent = inputContainer

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputContainer

-- Password Label
local passwordLabel = Instance.new("TextLabel")
passwordLabel.Text = "PASSWORD"
passwordLabel.Size = UDim2.new(1, 0, 0, isMobile and 15 or 20)
passwordLabel.Position = UDim2.new(0, 0, 0, isMobile and -20 or -25)
passwordLabel.BackgroundTransparency = 1
passwordLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
passwordLabel.Font = Enum.Font.Code
passwordLabel.TextScaled = true
passwordLabel.Parent = inputContainer
passwordLabel.ZIndex = 3

-- Password TextBox
local passwordInput = Instance.new("TextBox")
passwordInput.Text = ""
passwordInput.PlaceholderText = "Enter premium key..."
passwordInput.Size = UDim2.new(0.95, 0, 0.8, 0)
passwordInput.Position = UDim2.new(0.025, 0, 0.1, 0)
passwordInput.BackgroundTransparency = 1
passwordInput.TextColor3 = Color3.fromRGB(255, 0, 0)
passwordInput.PlaceholderColor3 = Color3.fromRGB(100, 0, 0)
passwordInput.Font = Enum.Font.Code
passwordInput.TextScaled = true
passwordInput.Parent = inputContainer
passwordInput.ZIndex = 3

-- Button Container
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(0.85, 0, 0, isMobile and 80 or 120)
buttonContainer.Position = UDim2.new(0.075, 0, isMobile and 0.5 or 0.55, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainPanel
buttonContainer.ZIndex = 2

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Text = "GET KEY"
getKeyButton.Size = UDim2.new(0.45, 0, 0, isMobile and 35 or 50)
getKeyButton.Position = UDim2.new(0, 0, 0, 0)
getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
getKeyButton.TextColor3 = Color3.fromRGB(255, 0, 0)
getKeyButton.Font = Enum.Font.SciFi
getKeyButton.TextScaled = true
getKeyButton.Parent = buttonContainer
getKeyButton.ZIndex = 3

local getKeyStroke = Instance.new("UIStroke")
getKeyStroke.Color = Color3.fromRGB(255, 0, 0)
getKeyStroke.Thickness = 2
getKeyStroke.Parent = getKeyButton

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

-- Submit Button
local submitButton = Instance.new("TextButton")
submitButton.Text = "SUBMIT"
submitButton.Size = UDim2.new(0.45, 0, 0, isMobile and 35 or 50)
submitButton.Position = UDim2.new(0.55, 0, 0, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
submitButton.TextColor3 = Color3.fromRGB(255, 0, 0)
submitButton.Font = Enum.Font.SciFi
submitButton.TextScaled = true
submitButton.Parent = buttonContainer
submitButton.ZIndex = 3

local submitStroke = Instance.new("UIStroke")
submitStroke.Color = Color3.fromRGB(255, 0, 0)
submitStroke.Thickness = 2
submitStroke.Parent = submitButton

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 8)
submitCorner.Parent = submitButton

-- Japanese Decorative Text
local japaneseText1 = Instance.new("TextLabel")
japaneseText1.Text = "マトリックス"
japaneseText1.Size = UDim2.new(0, isMobile and 80 or 100, 0, isMobile and 25 or 30)
japaneseText1.Position = UDim2.new(0.5, isMobile and -40 or -50, isMobile and 0.8 or 0.85, 0)
japaneseText1.BackgroundTransparency = 1
japaneseText1.TextColor3 = Color3.fromRGB(100, 0, 0)
japaneseText1.Font = Enum.Font.Code
japaneseText1.TextScaled = true
japaneseText1.TextTransparency = 0.7
japaneseText1.Parent = mainPanel
japaneseText1.ZIndex = 2

-- Toast Notification Frame
local toastFrame = Instance.new("Frame")
toastFrame.Size = UDim2.new(isMobile and 0.8 or 0, isMobile and 0 or 350, 0, isMobile and 50 or 60)
toastFrame.Position = UDim2.new(0.5, 0, 0, -70)
toastFrame.AnchorPoint = Vector2.new(0.5, 0)
toastFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toastFrame.Visible = false
toastFrame.Parent = screenGui
toastFrame.ZIndex = 10

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 8)
toastCorner.Parent = toastFrame

local toastText = Instance.new("TextLabel")
toastText.Text = "Key link copied (Use GOOGLE CHROME)"
toastText.Size = UDim2.new(1, 0, 1, 0)
toastText.BackgroundTransparency = 1
toastText.TextColor3 = Color3.fromRGB(0, 0, 0)
toastText.Font = Enum.Font.SourceSansBold
toastText.TextScaled = true
toastText.Parent = toastFrame

-- Info Panel
local infoPanel = Instance.new("Frame")
infoPanel.Size = UDim2.new(isMobile and 0.9 or 0, isMobile and 0 or 350, isMobile and 0.8 or 0, isMobile and 0 or 400)
infoPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
infoPanel.AnchorPoint = Vector2.new(0.5, 0.5)
infoPanel.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
infoPanel.Visible = false
infoPanel.Parent = screenGui
infoPanel.ZIndex = 15

local infoPanelStroke = Instance.new("UIStroke")
infoPanelStroke.Color = Color3.fromRGB(255, 0, 0)
infoPanelStroke.Thickness = 3
infoPanelStroke.Parent = infoPanel

local infoPanelCorner = Instance.new("UICorner")
infoPanelCorner.CornerRadius = UDim.new(0, 12)
infoPanelCorner.Parent = infoPanel

-- Player Avatar
local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(0, isMobile and 80 or 100, 0, isMobile and 80 or 100)
avatarImage.Position = UDim2.new(0.5, 0, 0, 20)
avatarImage.AnchorPoint = Vector2.new(0.5, 0)
avatarImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
avatarImage.Image = "rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=420&h=420"
avatarImage.Parent = infoPanel

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImage

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = Color3.fromRGB(255, 0, 0)
avatarStroke.Thickness = 2
avatarStroke.Parent = avatarImage

-- Player Info
local infoYStart = isMobile and 120 or 140
local infoSpacing = isMobile and 35 or 40

local playerName = Instance.new("TextLabel")
playerName.Text = "USER: "..player.Name
playerName.Size = UDim2.new(1, -20, 0, isMobile and 25 or 30)
playerName.Position = UDim2.new(0, 10, 0, infoYStart)
playerName.BackgroundTransparency = 1
playerName.TextColor3 = Color3.fromRGB(255, 0, 0)
playerName.Font = Enum.Font.Code
playerName.TextScaled = true
playerName.Parent = infoPanel

local playerId = Instance.new("TextLabel")
playerId.Text = "ID: "..player.UserId
playerId.Size = UDim2.new(1, -20, 0, isMobile and 25 or 30)
playerId.Position = UDim2.new(0, 10, 0, infoYStart + infoSpacing)
playerId.BackgroundTransparency = 1
playerId.TextColor3 = Color3.fromRGB(200, 0, 0)
playerId.Font = Enum.Font.Code
playerId.TextScaled = true
playerId.Parent = infoPanel

local accountAge = Instance.new("TextLabel")
accountAge.Text = "ACCOUNT AGE: "..player.AccountAge.." days"
accountAge.Size = UDim2.new(1, -20, 0, isMobile and 25 or 30)
accountAge.Position = UDim2.new(0, 10, 0, infoYStart + infoSpacing * 2)
accountAge.BackgroundTransparency = 1
accountAge.TextColor3 = Color3.fromRGB(200, 0, 0)
accountAge.Font = Enum.Font.Code
accountAge.TextScaled = true
accountAge.Parent = infoPanel

local scriptInfo = Instance.new("TextLabel")
scriptInfo.Text = "MATRIX SYSTEM v2.0"
scriptInfo.Size = UDim2.new(1, -20, 0, isMobile and 25 or 30)
scriptInfo.Position = UDim2.new(0, 10, 0, infoYStart + infoSpacing * 3)
scriptInfo.BackgroundTransparency = 1
scriptInfo.TextColor3 = Color3.fromRGB(150, 0, 0)
scriptInfo.Font = Enum.Font.Code
scriptInfo.TextScaled = true
scriptInfo.Parent = infoPanel

local creatorInfo = Instance.new("TextLabel")
creatorInfo.Text = "© 2025 ZAMAS"
creatorInfo.Size = UDim2.new(1, -20, 0, isMobile and 25 or 30)
creatorInfo.Position = UDim2.new(0, 10, 0, infoYStart + infoSpacing * 4)
creatorInfo.BackgroundTransparency = 1
creatorInfo.TextColor3 = Color3.fromRGB(150, 0, 0)
creatorInfo.Font = Enum.Font.Code
creatorInfo.TextScaled = true
creatorInfo.Parent = infoPanel

-- Close Info Panel Button
local closeInfoButton = Instance.new("TextButton")
closeInfoButton.Text = "CLOSE"
closeInfoButton.Size = UDim2.new(0.5, 0, 0, isMobile and 30 or 35)
closeInfoButton.Position = UDim2.new(0.25, 0, 1, isMobile and -40 or -45)
closeInfoButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeInfoButton.TextColor3 = Color3.fromRGB(0, 0, 0)
closeInfoButton.Font = Enum.Font.SourceSansBold
closeInfoButton.TextScaled = true
closeInfoButton.Parent = infoPanel

local closeInfoCorner = Instance.new("UICorner")
closeInfoCorner.CornerRadius = UDim.new(0, 8)
closeInfoCorner.Parent = closeInfoButton

-- Animation Functions
local function animateButton(button)
    local originalSize = button.Size
    local tween = TweenService:Create(button, 
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = originalSize - UDim2.new(0.02, 0, 0, 5)}
    )
    tween:Play()
    wait(0.1)
    local tween2 = TweenService:Create(button, 
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = originalSize}
    )
    tween2:Play()
end

local function showToast()
    toastFrame.Visible = true
    toastFrame.Position = UDim2.new(0.5, 0, 0, -70)
    
    local tween = TweenService:Create(toastFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, 0, 20)}
    )
    tween:Play()
    
    wait(3)
    
    local tweenOut = TweenService:Create(toastFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, 0, 0, -70)}
    )
    tweenOut:Play()
    wait(0.5)
    toastFrame.Visible = false
end

-- Create Matrix Rain Effect
local function createMatrixRain()
    local characters = {"侍", "忍", "武", "士", "道", "戦", "闘", "力", "魂", "血"}
    
    for i = 1, (isMobile and 3 or 5) do
        local column = Instance.new("TextLabel")
        column.Size = UDim2.new(0, isMobile and 15 or 20, 1.5, 0)
        column.Position = UDim2.new(math.random() * 0.8 + 0.1, 0, -0.5, 0)
        column.BackgroundTransparency = 1
        column.Text = table.concat({characters[math.random(#characters)] for j = 1, 15}, "\n")
        column.TextColor3 = Color3.fromRGB(math.random(30, 80), 0, 0)
        column.Font = Enum.Font.Code
        column.TextSize = isMobile and 8 or 12
        column.TextTransparency = math.random(60, 90) / 100
        column.Parent = matrixBg
        column.ZIndex = 1
        
        -- Animate falling
        spawn(function()
            local speed = math.random(15, 30) / 1000
            while column.Parent do
                for y = -0.5, 1.2, speed do
                    if not column.Parent then break end
                    column.Position = UDim2.new(column.Position.X.Scale, 0, y, 0)
                    wait(0.03)
                end
                -- Reset position
                column.Position = UDim2.new(math.random() * 0.8 + 0.1, 0, -0.5, 0)
                column.Text = table.concat({characters[math.random(#characters)] for j = 1, 15}, "\n")
                column.TextColor3 = Color3.fromRGB(math.random(30, 80), 0, 0)
            end
        end)
    end
end

-- Glowing Border Animation
spawn(function()
    while mainPanel.Parent do
        for i = 0, 0.5, 0.01 do
            borderGlow.Transparency = i
            wait(0.02)
        end
        for i = 0.5, 0, -0.01 do
            borderGlow.Transparency = i
            wait(0.02)
        end
    end
end)

-- Button Connections
getKeyButton.MouseButton1Click:Connect(function()
    animateButton(getKeyButton)
    setclipboard("https://zamasxmodder.github.io/RedMatrixStealAbrainrotPREMIUMScript/")
    spawn(showToast)
end)

submitButton.MouseButton1Click:Connect(function()
    animateButton(submitButton)
    local key = passwordInput.Text
    if key ~= "" then
        print("Key submitted: "..key)
        -- Add your key validation logic here
    else
        -- Flash red if empty
        passwordInput.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(0.2)
        passwordInput.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    animateButton(closeButton)
    screenGui:Destroy()
end)

infoButton.MouseButton1Click:Connect(function()
    animateButton(infoButton)
    infoPanel.Visible = true
    mainPanel.Visible = false
end)

closeInfoButton.MouseButton1Click:Connect(function()
    animateButton(closeInfoButton)
    infoPanel.Visible = false
    mainPanel.Visible = true
end)

-- Hover Effects
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, 
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = Color3.fromRGB(255, 0, 0), TextColor3 = Color3.fromRGB(0, 0, 0)}
        ):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, 
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = Color3.fromRGB(0, 0, 0), TextColor3 = Color3.fromRGB(255, 0, 0)}
        ):Play()
    end)
end

addHoverEffect(getKeyButton)
addHoverEffect(submitButton)

-- Initialize Matrix Rain
createMatrixRain()

-- Make panel draggable
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainPanel.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainPanel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

print("Matrix Login Panel Loaded - By Zamas 2025")
print("Mobile Optimized: " .. tostring(isMobile))
