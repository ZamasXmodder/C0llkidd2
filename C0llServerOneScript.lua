local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear el GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XMStealAbrainrotGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- GUI de fondo decorativo que cubre toda la pantalla
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Name = "BackgroundFrame"
backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
backgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backgroundFrame.BackgroundTransparency = 0.3
backgroundFrame.BorderSizePixel = 0
backgroundFrame.Parent = screenGui

-- Decoraciones en las esquinas
local function createCornerDecoration(parent, position)
    local decoration = Instance.new("Frame")
    decoration.Size = UDim2.new(0, 80, 0, 80)
    decoration.Position = position
    decoration.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    decoration.BorderSizePixel = 0
    decoration.Rotation = 45
    decoration.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = decoration
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 127)
    stroke.Thickness = 2
    stroke.Parent = decoration
    
    return decoration
end

-- Crear decoraciones en las esquinas
createCornerDecoration(backgroundFrame, UDim2.new(0, -40, 0, -40))
createCornerDecoration(backgroundFrame, UDim2.new(1, -40, 0, -40))
createCornerDecoration(backgroundFrame, UDim2.new(0, -40, 1, -40))
createCornerDecoration(backgroundFrame, UDim2.new(1, -40, 1, -40))

-- Decoraciones adicionales en los bordes
local function createEdgeDecoration(parent, size, position)
    local decoration = Instance.new("Frame")
    decoration.Size = size
    decoration.Position = position
    decoration.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    decoration.BackgroundTransparency = 0.7
    decoration.BorderSizePixel = 0
    decoration.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = decoration
end

-- Decoraciones en los bordes
createEdgeDecoration(backgroundFrame, UDim2.new(0, 200, 0, 20), UDim2.new(0.5, -100, 0, 0))
createEdgeDecoration(backgroundFrame, UDim2.new(0, 200, 0, 20), UDim2.new(0.5, -100, 1, -20))
createEdgeDecoration(backgroundFrame, UDim2.new(0, 20, 0, 200), UDim2.new(0, 0, 0.5, -100))
createEdgeDecoration(backgroundFrame, UDim2.new(0, 20, 0, 200), UDim2.new(1, -20, 0.5, -100))

-- Panel principal
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 400, 0, 500)
mainPanel.Position = UDim2.new(0.5, -200, 0.5, -250)
mainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainPanel.BorderSizePixel = 0
mainPanel.Parent = screenGui

-- Esquinas redondeadas para el panel principal
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainPanel

-- Borde neon verde para el panel principal
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 255, 127)
mainStroke.Thickness = 3
mainStroke.Parent = mainPanel

-- Sección de datos del jugador
local playerSection = Instance.new("Frame")
playerSection.Name = "PlayerSection"
playerSection.Size = UDim2.new(1, -20, 0, 120)
playerSection.Position = UDim2.new(0, 10, 0, 10)
playerSection.BackgroundTransparency = 1
playerSection.Parent = mainPanel

-- Avatar del jugador
local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "AvatarImage"
avatarImage.Size = UDim2.new(0, 80, 0, 80)
avatarImage.Position = UDim2.new(0, 10, 0, 10)
avatarImage.BackgroundTransparency = 1
avatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
avatarImage.Parent = playerSection

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(0, 10)
avatarCorner.Parent = avatarImage

-- Información del jugador
local playerName = Instance.new("TextLabel")
playerName.Name = "PlayerName"
playerName.Size = UDim2.new(0, 280, 0, 25)
playerName.Position = UDim2.new(0, 100, 0, 10)
playerName.BackgroundTransparency = 1
playerName.Text = player.DisplayName
playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
playerName.TextScaled = true
playerName.Font = Enum.Font.GothamBold
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.Parent = playerSection

local playerUsername = Instance.new("TextLabel")
playerUsername.Name = "PlayerUsername"
playerUsername.Size = UDim2.new(0, 280, 0, 20)
playerUsername.Position = UDim2.new(0, 100, 0, 35)
playerUsername.BackgroundTransparency = 1
playerUsername.Text = "@" .. player.Name
playerUsername.TextColor3 = Color3.fromRGB(150, 150, 150)
playerUsername.TextScaled = true
playerUsername.Font = Enum.Font.Gotham
playerUsername.TextXAlignment = Enum.TextXAlignment.Left
playerUsername.Parent = playerSection

local playerCountry = Instance.new("TextLabel")
playerCountry.Name = "PlayerCountry"
playerCountry.Size = UDim2.new(0, 280, 0, 20)
playerCountry.Position = UDim2.new(0, 100, 0, 55)
playerCountry.BackgroundTransparency = 1
playerCountry.Text = "Country: Unknown"
playerCountry.TextColor3 = Color3.fromRGB(0, 255, 127)
playerCountry.TextScaled = true
playerCountry.Font = Enum.Font.Gotham
playerCountry.TextXAlignment = Enum.TextXAlignment.Left
playerCountry.Parent = playerSection

local playerStatus = Instance.new("TextLabel")
playerStatus.Name = "PlayerStatus"
playerStatus.Size = UDim2.new(0, 280, 0, 20)
playerStatus.Position = UDim2.new(0, 100, 0, 75)
playerStatus.BackgroundTransparency = 1
playerStatus.Text = "Status: Online"
playerStatus.TextColor3 = Color3.fromRGB(0, 255, 127)
playerStatus.TextScaled = true
playerStatus.Font = Enum.Font.Gotham
playerStatus.TextXAlignment = Enum.TextXAlignment.Left
playerStatus.Parent = playerSection

-- Título principal
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 140)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "XM StealAbrainrot MX"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainPanel

-- Subtítulo
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Size = UDim2.new(1, -20, 0, 20)
subtitleLabel.Position = UDim2.new(0, 10, 0, 180)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "(Trial panel 3 days)"
subtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
subtitleLabel.TextScaled = true
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Parent = mainPanel

-- Campo de texto para la key
local keyTextBox = Instance.new("TextBox")
keyTextBox.Name = "KeyTextBox"
keyTextBox.Size = UDim2.new(1, -40, 0, 50)
keyTextBox.Position = UDim2.new(0, 20, 0, 220)
keyTextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyTextBox.BorderSizePixel = 0
keyTextBox.Text = ""
keyTextBox.PlaceholderText = "Place your key here..."
keyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
keyTextBox.TextScaled = true
keyTextBox.Font = Enum.Font.Gotham
keyTextBox.Parent = mainPanel

local keyTextBoxCorner = Instance.new("UICorner")
keyTextBoxCorner.CornerRadius = UDim.new(0, 10)
keyTextBoxCorner.Parent = keyTextBox

local keyTextBoxStroke = Instance.new("UIStroke")
keyTextBoxStroke.Color = Color3.fromRGB(0, 255, 127)
keyTextBoxStroke.Thickness = 2
keyTextBoxStroke.Parent = keyTextBox

-- Función para crear botones
local function createButton(name, text, position, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 160, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(0, 255, 127)
    buttonStroke.Thickness = 2
    buttonStroke.Parent = button
    
    return button
end

-- Botones
local getKeyButton = createButton("GetKeyButton", "Get Key", UDim2.new(0, 20, 0, 290), mainPanel)
local submitButton = createButton("SubmitButton", "Submit", UDim2.new(0, 200, 0, 290), mainPanel)

-- Función para crear toast
local function showToast(message)
    local toast = Instance.new("Frame")
    toast.Name = "Toast"
    toast.Size = UDim2.new(0, 350, 0, 60)
    toast.Position = UDim2.new(0.5, -175, 1, -150)
    toast.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    toast.BorderSizePixel = 0
    toast.Parent = screenGui
    
    local toastCorner = Instance.new("UICorner")
    toastCorner.CornerRadius = UDim.new(0, 10)
    toastCorner.Parent = toast
    
    local toastStroke = Instance.new("UIStroke")
    toastStroke.Color = Color3.fromRGB(0, 255, 127)
    toastStroke.Thickness = 2
    toastStroke.Parent = toast
    
    local toastLabel = Instance.new("TextLabel")
    toastLabel.Size = UDim2.new(1, -20, 1, -10)
    toastLabel.Position = UDim2.new(0, 10, 0, 5)
    toastLabel.BackgroundTransparency = 1
    toastLabel.Text = message
    toastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toastLabel.TextScaled = true
    toastLabel.Font = Enum.Font.Gotham
    toastLabel.TextWrapped = true
    toastLabel.Parent = toast
    
    -- Animación de entrada
    toast.Position = UDim2.new(0.5, -175, 1, 0)
    local tweenIn = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -175, 1, -150)
    })
    tweenIn:Play()
    
    -- Animación de salida después de 3 segundos
    wait(3)
    local tweenOut = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -175, 1, 0)
    })
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        toast:Destroy()
    end)
end

-- Funcionalidad del botón Get Key
getKeyButton.MouseButton1Click:Connect(function()
    -- Copiar al portapapeles (simulado)
    setclipboard("https://zamasxmodder.github.io/PageFreeTrial3DaysKey/")
    
    -- Mostrar toast
    spawn(function()
        showToast("Your key has been copied! Go and paste it in your preferred browser...")
    end)
    
    -- Efecto visual del botón
    local originalColor = getKeyButton.BackgroundColor3
    getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    wait(0.1)
    getKeyButton.BackgroundColor3 = originalColor
end)

-- Funcionalidad del botón Submit
submitButton.MouseButton1Click:Connect(function()
    local keyText = keyTextBox.Text
    
    if keyText == "" then
        spawn(function()
            showToast("Please enter a key before submitting!")
        end)
        return
    end
    
    -- Efecto visual del botón
    local originalColor = submitButton.BackgroundColor3
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    wait(0.1)
    submitButton.BackgroundColor3 = originalColor
    
    -- Aquí puedes agregar la lógica para validar la key
    spawn(function()
        showToast("Key submitted successfully! Validating...")
    end)
    
    -- Simular validación
    wait(2)
    spawn(function()
        showToast("Key validated! Welcome to XM StealAbrainrot MX!")
    end)
end)

-- Efectos hover para los botones
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        })
        tween:Play()
    end)
end

addHoverEffect(getKeyButton)
addHoverEffect(submitButton)

-- Efecto hover para el textbox
keyTextBox.MouseEnter:Connect(function()
    local tween = TweenService:Create(keyTextBox, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    })
    tween:Play()
end)

keyTextBox.MouseLeave:Connect(function()
    local tween = TweenService:Create(keyTextBox, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    })
    tween:Play()
end)

-- Animación de entrada del panel principal
mainPanel.Position = UDim2.new(0.5, -200, -1, 0)
local panelTween = TweenService:Create(mainPanel, TweenInfo.new(0.8, Enum.EasingStyle.Back), {
    Position = UDim2.new(0.5, -200, 0.5, -250)
})
panelTween:Play()

-- Animación de las decoraciones
local decorations = {}
for _, child in pairs(backgroundFrame:GetChildren()) do
    if child:IsA("Frame") and child.Name ~= "MainPanel" then
        table.insert(decorations, child)
    end
end

for i, decoration in pairs(decorations) do
    spawn(function()
        wait(i * 0.1)
        decoration.BackgroundTransparency = 1
        local tween = TweenService:Create(decoration, TweenInfo.new(0.5), {
            BackgroundTransparency = 0
        })
        tween:Play()
    end)
end

-- Efecto de respiración para el borde del panel principal
spawn(function()
    while mainPanel.Parent do
        local tween1 = TweenService:Create(mainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {
            Transparency = 0.3
        })
        tween1:Play()
        tween1.Completed:Wait()
        
        local tween2 = TweenService:Create(mainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {
            Transparency = 0
        })
        tween2:Play()
        tween2.Completed:Wait()
    end
end)

-- Función para cerrar el GUI (opcional, puedes agregar un botón X)
local function closeGUI()
    local closeTween = TweenService:Create(mainPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -200, -1, 0)
    })
    closeTween:Play()
    
    local fadeTween = TweenService:Create(backgroundFrame, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    })
    fadeTween:Play()
    
    closeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- Botón de cerrar (opcional)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainPanel

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(1, 0)
closeButtonCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(closeGUI)

-- Efecto hover para el botón de cerrar
closeButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    })
    tween:Play()
end)

closeButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    })
    tween:Play()
end)

print("XM StealAbrainrot MX GUI loaded successfully!")
