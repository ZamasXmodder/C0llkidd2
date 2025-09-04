local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables de estado
local logs = {}
local preview = "Vista previa (simulada)"
local toggles = {}
local isOpen = true

local buttons = {
    "Aimbot Laser",
    "TP Chilli", 
    "ESP Brainrot",
    "Fly Jump",
    "AntiKick",
    "ESP Player"
}

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrutalPanel"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Botón toggle (esquina superior derecha)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(1, -140, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
toggleButton.Text = "Cerrar Panel"
toggleButton.TextColor3 = Color3.white
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

-- Esquinas redondeadas para el botón
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleButton

-- Gradiente para el botón
local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 38, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(249, 115, 22))
}
toggleGradient.Parent = toggleButton

-- Panel principal
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 440, 0, 280)
mainPanel.Position = UDim2.new(0.5, -220, 0.5, -140)
mainPanel.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
mainPanel.BackgroundTransparency = 0.85
mainPanel.BorderSizePixel = 0
mainPanel.Active = true
mainPanel.Draggable = true
mainPanel.Parent = screenGui

-- Esquinas redondeadas para el panel
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 16)
panelCorner.Parent = mainPanel

-- Borde sutil
local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(255, 255, 255)
panelStroke.Transparency = 0.9
panelStroke.Thickness = 1
panelStroke.Parent = mainPanel

-- Lado izquierdo (contenedor principal)
local leftSide = Instance.new("Frame")
leftSide.Name = "LeftSide"
leftSide.Size = UDim2.new(0, 300, 1, 0)
leftSide.Position = UDim2.new(0, 20, 0, 0)
leftSide.BackgroundTransparency = 1
leftSide.Parent = mainPanel

-- Header con logo y título
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 20)
header.BackgroundTransparency = 1
header.Parent = leftSide

-- Logo
local logo = Instance.new("TextLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 48, 0, 48)
logo.Position = UDim2.new(0, 0, 0, 0)
logo.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
logo.Text = "BP"
logo.TextColor3 = Color3.white
logo.TextScaled = true
logo.Font = Enum.Font.GothamBold
logo.BorderSizePixel = 0
logo.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 12)
logoCorner.Parent = logo

local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(239, 68, 68)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(251, 146, 60))
}
logoGradient.Parent = logo

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 60, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BRUTAL PANEL"
title.TextColor3 = Color3.fromRGB(241, 245, 249)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(0, 200, 0, 15)
subtitle.Position = UDim2.new(0, 60, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Demo visual"
subtitle.TextColor3 = Color3.fromRGB(148, 163, 184)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- Contenedor de botones
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, 0, 0, 140)
buttonContainer.Position = UDim2.new(0, 0, 0, 90)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = leftSide

local buttonLayout = Instance.new("UIGridLayout")
buttonLayout.CellSize = UDim2.new(0, 140, 0, 40)
buttonLayout.CellPadding = UDim2.new(0, 8, 0, 8)
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Parent = buttonContainer

-- Lado derecho
local rightSide = Instance.new("Frame")
rightSide.Name = "RightSide"
rightSide.Size = UDim2.new(0, 100, 1, 0)
rightSide.Position = UDim2.new(1, -120, 0, 0)
rightSide.BackgroundTransparency = 1
rightSide.Parent = mainPanel

-- Preview box
local previewBox = Instance.new("TextLabel")
previewBox.Name = "PreviewBox"
previewBox.Size = UDim2.new(1, 0, 0, 120)
previewBox.Position = UDim2.new(0, 0, 0, 20)
previewBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
previewBox.BackgroundTransparency = 0.6
previewBox.Text = preview
previewBox.TextColor3 = Color3.fromRGB(125, 211, 252)
previewBox.TextScaled = true
previewBox.Font = Enum.Font.Gotham
previewBox.TextWrapped = true
previewBox.BorderSizePixel = 0
previewBox.Parent = rightSide

local previewCorner = Instance.new("UICorner")
previewCorner.CornerRadius = UDim.new(0, 12)
previewCorner.Parent = previewBox

local previewStroke = Instance.new("UIStroke")
previewStroke.Color = Color3.fromRGB(255, 255, 255)
previewStroke.Transparency = 0.92
previewStroke.Thickness = 1
previewStroke.Parent = previewBox

-- Logs box
local logsBox = Instance.new("ScrollingFrame")
logsBox.Name = "LogsBox"
logsBox.Size = UDim2.new(1, 0, 0, 90)
logsBox.Position = UDim2.new(0, 0, 0, 150)
logsBox.BackgroundColor3 = Color3.fromRGB(6, 16, 23)
logsBox.BorderSizePixel = 0
logsBox.ScrollBarThickness = 4
logsBox.ScrollBarImageColor3 = Color3.fromRGB(125, 211, 252)
logsBox.Parent = rightSide

local logsCorner = Instance.new("UICorner")
logsCorner.CornerRadius = UDim.new(0, 8)
logsCorner.Parent = logsBox

local logsLayout = Instance.new("UIListLayout")
logsLayout.SortOrder = Enum.SortOrder.LayoutOrder
logsLayout.Padding = UDim.new(0, 2)
logsLayout.Parent = logsBox

-- Texto inicial de logs
local initialLog = Instance.new("TextLabel")
initialLog.Name = "InitialLog"
initialLog.Size = UDim2.new(1, -8, 0, 20)
initialLog.BackgroundTransparency = 1
initialLog.Text = "Logs:"
initialLog.TextColor3 = Color3.fromRGB(125, 211, 252)
initialLog.TextScaled = true
initialLog.Font = Enum.Font.Gotham
initialLog.TextXAlignment = Enum.TextXAlignment.Left
initialLog.Parent = logsBox

-- Funciones
local function createButton(name, index)
    local button = Instance.new("TextButton")
    button.Name = name
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    button.BackgroundTransparency = 0.6
    button.Text = ""
    button.BorderSizePixel = 0
    button.LayoutOrder = index
    button.Parent = buttonContainer
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Transparency = 0.92
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    -- Texto del botón
    local buttonText = Instance.new("TextLabel")
    buttonText.Name = "ButtonText"
    buttonText.Size = UDim2.new(1, -30, 1, 0)
    buttonText.Position = UDim2.new(0, 5, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = name
    buttonText.TextColor3 = Color3.fromRGB(226, 232, 240)
    buttonText.TextScaled = true
    buttonText.Font = Enum.Font.Gotham
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.Parent = button
    
    -- Indicador ON/OFF
    local indicator = Instance.new("TextLabel")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = UDim2.new(1, -25, 0.5, -10)
    indicator.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    indicator.BackgroundTransparency = 0.6
    indicator.Text = "OFF"
    indicator.TextColor3 = Color3.fromRGB(156, 163, 175)
    indicator.TextScaled = true
    indicator.Font = Enum.Font.GothamBold
    indicator.BorderSizePixel = 0
    indicator.Parent = button
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    return button, buttonText, indicator
end

local function press(name, button, buttonText, indicator)
    preview = "Activado: " .. name
    previewBox.Text = preview
    
    -- Agregar log
    local timestamp = os.date("%H:%M:%S")
    local logText = timestamp .. " — " .. name .. " toggled"
    table.insert(logs, 1, logText)
    
    -- Toggle estado
    toggles[name] = not toggles[name]
    
    -- Actualizar apariencia del botón
    if toggles[name] then
        button.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        button.BackgroundTransparency = 0
        buttonText.TextColor3 = Color3.white
        indicator.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        indicator.Text = "ON"
        indicator.TextColor3 = Color3.white
        
        -- Crear gradiente
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(239, 68, 68)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(251, 146, 60))
        }
        gradient.Parent = button
    else
        button.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        button.BackgroundTransparency = 0.6
        buttonText.TextColor3 = Color3.fromRGB(226, 232, 240)
        indicator.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        indicator.Text = "OFF"
        indicator.TextColor3 = Color3.fromRGB(156, 163, 175)
        
        -- Remover gradiente
        local gradient = button:FindFirstChild("UIGradient")
        if gradient then gradient:Destroy() end
    end
    
    -- Actualizar logs
    for i, child in pairs(logsBox:GetChildren()) do
        if child:IsA("TextLabel") and child.Name ~= "InitialLog" then
                    child:Destroy()
    end
    
    -- Recrear logs
    for i, log in ipairs(logs) do
        if i <= 10 then -- Máximo 10 logs
            local logLabel = Instance.new("TextLabel")
            logLabel.Name = "Log" .. i
            logLabel.Size = UDim2.new(1, -8, 0, 15)
            logLabel.BackgroundTransparency = 1
            logLabel.Text = log
            logLabel.TextColor3 = Color3.fromRGB(125, 211, 252)
            logLabel.TextSize = 10
            logLabel.Font = Enum.Font.Gotham
            logLabel.TextXAlignment = Enum.TextXAlignment.Left
            logLabel.TextYAlignment = Enum.TextYAlignment.Top
            logLabel.LayoutOrder = i + 1
            logLabel.Parent = logsBox
        end
    end
    
    -- Actualizar tamaño del scroll
    logsBox.CanvasSize = UDim2.new(0, 0, 0, (#logs + 1) * 17)
    
    -- Animación de click
    local clickTween = TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {Size = UDim2.new(0, 135, 0, 38)}
    )
    local returnTween = TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {Size = UDim2.new(0, 140, 0, 40)}
    )
    
    clickTween:Play()
    clickTween.Completed:Connect(function()
        returnTween:Play()
    end)
end

-- Crear todos los botones
for i, buttonName in ipairs(buttons) do
    local button, buttonText, indicator = createButton(buttonName, i)
    
    button.MouseButton1Click:Connect(function()
        press(buttonName, button, buttonText, indicator)
    end)
    
    -- Efecto hover
    button.MouseEnter:Connect(function()
        if not toggles[buttonName] then
            local hoverTween = TweenService:Create(
                button,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.4}
            )
            hoverTween:Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not toggles[buttonName] then
            local unhoverTween = TweenService:Create(
                button,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.6}
            )
            unhoverTween:Play()
        end
    end)
end

-- Función para toggle del panel
local function togglePanel()
    isOpen = not isOpen
    
    if isOpen then
        toggleButton.Text = "Cerrar Panel"
        
        -- Animación de entrada
        mainPanel.Position = UDim2.new(0.5, -220, 0.5, -170)
        mainPanel.Size = UDim2.new(0, 400, 0, 250)
        mainPanel.Visible = true
        
        local enterTween = TweenService:Create(
            mainPanel,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {
                Position = UDim2.new(0.5, -220, 0.5, -140),
                Size = UDim2.new(0, 440, 0, 280)
            }
        )
        enterTween:Play()
        
    else
        toggleButton.Text = "Abrir Panel"
        
        -- Animación de salida
        local exitTween = TweenService:Create(
            mainPanel,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {
                Position = UDim2.new(0.5, -220, 0.5, -170),
                Size = UDim2.new(0, 400, 0, 250)
            }
        )
        exitTween:Play()
        
        exitTween.Completed:Connect(function()
            mainPanel.Visible = false
        end)
    end
end

-- Conectar botón toggle
toggleButton.MouseButton1Click:Connect(togglePanel)

-- Efecto hover para botón toggle
toggleButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(
        toggleButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {
            Size = UDim2.new(0, 125, 0, 42),
            Rotation = 1
        }
    )
    hoverTween:Play()
end)

toggleButton.MouseLeave:Connect(function()
    local unhoverTween = TweenService:Create(
        toggleButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {
            Size = UDim2.new(0, 120, 0, 40),
            Rotation = 0
        }
    )
    unhoverTween:Play()
end)

-- Animación del logo (pulso)
local function animateLogo()
    local pulseTween = TweenService:Create(
        logo,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundTransparency = 0.3}
    )
    pulseTween:Play()
end

animateLogo()

-- Tecla para toggle rápido (Insert)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        togglePanel()
    end
end)

print("Brutal Panel cargado exitosamente!")
print("Presiona INSERT para abrir/cerrar el panel")
