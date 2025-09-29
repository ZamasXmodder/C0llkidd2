-- Steal A Brainrot - Enhanced Sakura Panel GUI for Roblox
-- Este script debe ir en StarterPlayerScripts o ejecutarse con loadstring

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SakuraBrainrotPanel"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true -- Para cubrir completamente la pantalla incluyendo topbar
screenGui.Parent = playerGui

-- Frame de fondo completo (cubre absolutamente toda la pantalla)
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Name = "Background"
backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
backgroundFrame.BackgroundColor3 = Color3.fromRGB(255, 238, 248)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.Parent = screenGui

-- Gradiente de fondo animado
local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 238, 248)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(248, 215, 218)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 179, 217)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(230, 179, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(212, 197, 249)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 240, 255))
}
backgroundGradient.Rotation = 135
backgroundGradient.Parent = backgroundFrame

-- Animar rotación del gradiente
local gradientTween = TweenService:Create(backgroundGradient,
    TweenInfo.new(20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Rotation = 495}
)
gradientTween:Play()

-- Container para pétalos
local sakuraContainer = Instance.new("Frame")
sakuraContainer.Name = "SakuraContainer"
sakuraContainer.Size = UDim2.new(1, 0, 1, 0)
sakuraContainer.Position = UDim2.new(0, 0, 0, 0)
sakuraContainer.BackgroundTransparency = 1
sakuraContainer.ClipsDescendants = false
sakuraContainer.Parent = backgroundFrame

-- Decoraciones sakura flotantes (esquinas)
local function createFloatingSakura(position, emoji)
    local sakura = Instance.new("TextLabel")
    sakura.Size = UDim2.new(0, 40, 0, 40)
    sakura.Position = position
    sakura.BackgroundTransparency = 1
    sakura.Text = emoji
    sakura.TextScaled = true
    sakura.Font = Enum.Font.Gotham
    sakura.Parent = backgroundFrame
    
    -- Animación flotante
    local floatTween = TweenService:Create(sakura,
        TweenInfo.new(math.random(4, 8), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {
            Position = UDim2.new(position.X.Scale, position.X.Offset + math.random(-30, 30), 
                               position.Y.Scale, position.Y.Offset + math.random(-30, 30)),
            Rotation = math.random(-45, 45)
        }
    )
    floatTween:Play()
    
    return sakura
end

-- Crear decoraciones sakura en las esquinas
createFloatingSakura(UDim2.new(0.05, 0, 0.1, 0), "🌸")
createFloatingSakura(UDim2.new(0.9, 0, 0.15, 0), "🌺")
createFloatingSakura(UDim2.new(0.1, 0, 0.8, 0), "🌸")
createFloatingSakura(UDim2.new(0.85, 0, 0.75, 0), "🌺")
createFloatingSakura(UDim2.new(0.15, 0, 0.3, 0), "🌸")
createFloatingSakura(UDim2.new(0.8, 0, 0.4, 0), "🌺")

-- Panel de status (lado izquierdo)
local statusPanel = Instance.new("Frame")
statusPanel.Name = "StatusPanel"
statusPanel.Size = UDim2.new(0, 280, 0, 420)
statusPanel.Position = UDim2.new(0, 30, 0.5, -210)
statusPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
statusPanel.BackgroundTransparency = 0.85
statusPanel.BorderSizePixel = 0
statusPanel.Parent = screenGui

-- Corner radius para el panel de status
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 20)
statusCorner.Parent = statusPanel

-- Borde del panel de status
local statusStroke = Instance.new("UIStroke")
statusStroke.Color = Color3.fromRGB(186, 85, 211)
statusStroke.Thickness = 2
statusStroke.Transparency = 0.6
statusStroke.Parent = statusPanel

-- Gradiente en el borde del status
local statusStrokeGradient = Instance.new("UIGradient")
statusStrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 85, 211)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 112, 219))
}
statusStrokeGradient.Parent = statusStroke

-- Título del panel de status
local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(1, -20, 0, 50)
statusTitle.Position = UDim2.new(0, 10, 0, 15)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "STATUS ONLINE CLIENTS"
statusTitle.TextColor3 = Color3.fromRGB(147, 112, 219)
statusTitle.TextScaled = true
statusTitle.Font = Enum.Font.GothamBold
statusTitle.Parent = statusPanel

-- Gradiente del título de status
local statusTitleGradient = Instance.new("UIGradient")
statusTitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(147, 112, 219)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(186, 85, 211)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
}
statusTitleGradient.Rotation = 45
statusTitleGradient.Parent = statusTitle

-- ScrollingFrame para la lista de jugadores
local playersScrollFrame = Instance.new("ScrollingFrame")
playersScrollFrame.Name = "PlayersScrollFrame"
playersScrollFrame.Size = UDim2.new(1, -20, 1, -80)
playersScrollFrame.Position = UDim2.new(0, 10, 0, 70)
playersScrollFrame.BackgroundTransparency = 1
playersScrollFrame.ScrollBarThickness = 6
playersScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(186, 85, 211)
playersScrollFrame.ScrollBarImageTransparency = 0.3
playersScrollFrame.BorderSizePixel = 0
playersScrollFrame.Parent = statusPanel

-- Layout para organizar los jugadores
local playersLayout = Instance.new("UIListLayout")
playersLayout.SortOrder = Enum.SortOrder.LayoutOrder
playersLayout.Padding = UDim.new(0, 8)
playersLayout.Parent = playersScrollFrame

-- Lista completa de nombres de usuarios
local allUsernames = {
    "xJuanitoPro123", "SofiGamer_07", "DarkNinjaXD", "MariKawaii22", "ElPanDeAyer_44",
    "ProMaxiYT", "CamilitaUwU", "Andresito_2009", "FerchoCrack21", "Luisa_Lolita12",
    "KevinNoob_01", "DaniMasterX", "ValenCute25", "SebasYT_777", "LinaJuegaXD",
    "Oscarito_09", "MrPapasLocas", "Pau_GirlxX", "xd_TomasGamer", "LauryPink_15",
    "ElBananero_300", "AngelDark47", "SantiUwUPro", "Chloe_xX_Star", "PablitoXD_22",
    "DianaCute_14", "GokuFan_999", "XimenaLove09", "CarlitosProXD", "Juana_0707",
    "Nacho_elCrack", "SofiaLindaa23", "BrianUwU_04", "Andreita_xX", "EpicNoob_302",
    "ValeGamerzzz", "PipeMaster77", "LauCuteUwU", "Jorgito_108", "MeliGamer_15",
    "CrackXD_Samu", "FerxxoUwU88", "JuampiElNoob"
}

-- Función para crear un elemento de jugador
local function createPlayerElement(username, isOnline)
    local playerFrame = Instance.new("Frame")
    playerFrame.Name = username
    playerFrame.Size = UDim2.new(1, -10, 0, 35)
    playerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    playerFrame.BackgroundTransparency = 0.9
    playerFrame.BorderSizePixel = 0
    playerFrame.Parent = playersScrollFrame
    
    local playerCorner = Instance.new("UICorner")
    playerCorner.CornerRadius = UDim.new(0, 8)
    playerCorner.Parent = playerFrame
    
    -- Indicador de estado (círculo)
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Size = UDim2.new(0, 12, 0, 12)
    statusIndicator.Position = UDim2.new(0, 10, 0.5, -6)
    statusIndicator.BackgroundColor3 = isOnline and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Parent = playerFrame
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0.5, 0)
    indicatorCorner.Parent = statusIndicator
    
    -- Efecto de pulso para jugadores online
    if isOnline then
        local pulseTween = TweenService:Create(statusIndicator,
            TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {BackgroundColor3 = Color3.fromRGB(39, 174, 96)}
        )
        pulseTween:Play()
    end
    
    -- Nombre del jugador
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "UsernameLabel"
    usernameLabel.Size = UDim2.new(1, -80, 1, 0)
    usernameLabel.Position = UDim2.new(0, 30, 0, 0)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Text = username
    usernameLabel.TextColor3 = Color3.fromRGB(139, 90, 140)
    usernameLabel.TextScaled = true
    usernameLabel.Font = Enum.Font.Gotham
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.Parent = playerFrame
    
    -- Estado del jugador
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0, 50, 1, 0)
    statusLabel.Position = UDim2.new(1, -55, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = isOnline and "Online" or "Offline"
    statusLabel.TextColor3 = isOnline and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.Parent = playerFrame
    
    -- Animación de entrada
    playerFrame.Size = UDim2.new(0, 0, 0, 35)
    playerFrame.BackgroundTransparency = 1
    
    local enterTween = TweenService:Create(playerFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -10, 0, 35), BackgroundTransparency = 0.9}
    )
    enterTween:Play()
    
    return playerFrame
end

-- Función para actualizar la lista de jugadores
local function updatePlayersList()
    -- Limpiar lista actual
    for _, child in pairs(playersScrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "UIListLayout" then
            local exitTween = TweenService:Create(child,
                TweenInfo.new(0.3, Enum.EasingStyle.Back),
                {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}
            )
            exitTween:Play()
            exitTween.Completed:Connect(function()
                child:Destroy()
            end)
        end
    end
    
    -- Esperar a que se limpie
    task.wait(0.4)
    
    -- Seleccionar 7 jugadores aleatorios
    local selectedUsers = {}
    local usedIndices = {}
    
    for i = 1, math.min(7, #allUsernames) do
        local randomIndex
        repeat
            randomIndex = math.random(1, #allUsernames)
        until not usedIndices[randomIndex]
        
        usedIndices[randomIndex] = true
        selectedUsers[i] = allUsernames[randomIndex]
    end
    
    -- Crear elementos de jugadores con delay
    for i, username in ipairs(selectedUsers) do
        task.spawn(function()
            task.wait(i * 0.1) -- Delay escalonado para efecto visual
            local isOnline = math.random() > 0.3 -- 70% probabilidad de estar online
            createPlayerElement(username, isOnline)
        end)
    end
    
    -- Actualizar tamaño del scroll
    task.wait(1)
    playersScrollFrame.CanvasSize = UDim2.new(0, 0, 0, playersLayout.AbsoluteContentSize.Y + 10)
end

-- Panel principal con escalado automático (ajustado para dejar espacio al panel de status)
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 450, 0, 480)
mainPanel.Position = UDim2.new(0.5, -100, 0.5, -240) -- Movido un poco a la derecha
mainPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainPanel.BackgroundTransparency = 0.82
mainPanel.BorderSizePixel = 0
mainPanel.Parent = screenGui

-- Constraint para escalado automático
local aspectRatio = Instance.new("UIAspectRatioConstraint")
aspectRatio.AspectRatio = 450/480
aspectRatio.Parent = mainPanel

-- Hacer el panel responsive
local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(300, 320)
sizeConstraint.MaxSize = Vector2.new(600, 640)
sizeConstraint.Parent = mainPanel

-- Corner radius para el panel
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 25)
panelCorner.Parent = mainPanel

-- Borde brillante del panel con múltiples efectos
local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(255, 105, 180)
panelStroke.Thickness = 3
panelStroke.Transparency = 0.6
panelStroke.Parent = mainPanel

-- Gradiente en el borde
local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(218, 112, 214))
}
strokeGradient.Parent = panelStroke

-- Efectos de brillo en el borde
local strokeTween = TweenService:Create(panelStroke, 
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Transparency = 0.1, Thickness = 5}
)
strokeTween:Play()

-- Decoración sakura en el panel
local panelSakura = Instance.new("TextLabel")
panelSakura.Size = UDim2.new(0, 50, 0, 50)
panelSakura.Position = UDim2.new(1, -60, 0, -15)
panelSakura.BackgroundTransparency = 1
panelSakura.Text = "🌸"
panelSakura.TextScaled = true
panelSakura.Font = Enum.Font.Gotham
panelSakura.Parent = mainPanel

-- Animación de la decoración del panel
local panelSakuraTween = TweenService:Create(panelSakura,
    TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Rotation = 15, Position = UDim2.new(1, -60, 0, -25)}
)
panelSakuraTween:Play()

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -40, 0, 60)
titleLabel.Position = UDim2.new(0, 20, 0, 25)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Steal A brainrot"
titleLabel.TextColor3 = Color3.fromRGB(255, 20, 147)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainPanel

-- Gradiente animado del título
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(218, 112, 214)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
}
titleGradient.Rotation = 45
titleGradient.Parent = titleLabel

-- Animar gradiente del título
local titleGradientTween = TweenService:Create(titleGradient,
    TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Rotation = 405}
)
titleGradientTween:Play()

-- Subtítulo
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(1, -40, 0, 30)
subtitleLabel.Position = UDim2.new(0, 20, 0, 90)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "FREEMIUM - PREMIUM PANEL"
subtitleLabel.TextColor3 = Color3.fromRGB(139, 90, 140)
subtitleLabel.TextScaled = true
subtitleLabel.Font = Enum.Font.GothamMedium
subtitleLabel.Parent = mainPanel

-- Botón Get Key
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Size = UDim2.new(1, -40, 0, 45)
getKeyButton.Position = UDim2.new(0, 20, 0, 150)
getKeyButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "Get Key!"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextScaled = true
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.Parent = mainPanel

-- Corner radius para el botón Get Key
local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 12)
getKeyCorner.Parent = getKeyButton

-- Gradiente del botón Get Key
local getKeyGradient = Instance.new("UIGradient")
getKeyGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(186, 85, 211)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 112, 219))
}
getKeyGradient.Rotation = 45
getKeyGradient.Parent = getKeyButton

-- Label del input
local inputLabel = Instance.new("TextLabel")
inputLabel.Name = "InputLabel"
inputLabel.Size = UDim2.new(1, -40, 0, 25)
inputLabel.Position = UDim2.new(0, 20, 0, 220)
inputLabel.BackgroundTransparency = 1
inputLabel.Text = "🔑 Submit Key"
inputLabel.TextColor3 = Color3.fromRGB(139, 90, 140)
inputLabel.TextScaled = true
inputLabel.Font = Enum.Font.GothamMedium
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Parent = mainPanel

-- Input de la clave
local keyInput = Instance.new("TextBox")
keyInput.Name = "KeyInput"
keyInput.Size = UDim2.new(1, -40, 0, 50)
keyInput.Position = UDim2.new(0, 20, 0, 255)
keyInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keyInput.BackgroundTransparency = 0.05
keyInput.BorderSizePixel = 0
keyInput.Text = ""
keyInput.PlaceholderText = "put your key here..."
keyInput.TextColor3 = Color3.fromRGB(139, 90, 140)
keyInput.PlaceholderColor3 = Color3.fromRGB(180, 150, 180)
keyInput.TextScaled = true
keyInput.Font = Enum.Font.Gotham
keyInput.Parent = mainPanel

-- Corner radius para el input
local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 15)
inputCorner.Parent = keyInput

-- Padding del input
local inputPadding = Instance.new("UIPadding")
inputPadding.PaddingLeft = UDim.new(0, 15)
inputPadding.PaddingRight = UDim.new(0, 15)
inputPadding.Parent = keyInput

-- Borde del input
local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(255, 182, 193)
inputStroke.Thickness = 2
inputStroke.Transparency = 0.7
inputStroke.Parent = keyInput

-- Botón Submit
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(1, -40, 0, 55)
submitButton.Position = UDim2.new(0, 20, 0, 330)
submitButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
submitButton.BorderSizePixel = 0
submitButton.Text = "🌸 SUBMIT KEY 🌸"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextScaled = true
submitButton.Font = Enum.Font.GothamBold
submitButton.Parent = mainPanel

-- Corner radius para el botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 15)
buttonCorner.Parent = submitButton

-- Gradiente del botón
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(218, 112, 214)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(186, 85, 211))
}
buttonGradient.Rotation = 135
buttonGradient.Parent = submitButton

-- Toast para Get Key
local getKeyToast = Instance.new("Frame")
getKeyToast.Name = "GetKeyToast"
getKeyToast.Size = UDim2.new(0, 400, 0, 90)
getKeyToast.Position = UDim2.new(0.5, -200, 0, -100)
getKeyToast.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
getKeyToast.BorderSizePixel = 0
getKeyToast.Visible = false
getKeyToast.Parent = screenGui

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 20)
toastCorner.Parent = getKeyToast

local toastStroke = Instance.new("UIStroke")
toastStroke.Color = Color3.fromRGB(255, 182, 193)
toastStroke.Thickness = 2
toastStroke.Parent = getKeyToast

local toastLabel = Instance.new("TextLabel")
toastLabel.Size = UDim2.new(1, -20, 1, -20)
toastLabel.Position = UDim2.new(0, 10, 0, 10)
toastLabel.BackgroundTransparency = 1
toastLabel.Text = "🔗 Link has been copied!\nPaste it in your preferred browser... 🌸"
toastLabel.TextColor3 = Color3.fromRGB(139, 90, 140)
toastLabel.TextScaled = true
toastLabel.Font = Enum.Font.GothamMedium
toastLabel.Parent = getKeyToast

-- Mensaje de éxito
local successMessage = Instance.new("Frame")
successMessage.Name = "SuccessMessage"
successMessage.Size = UDim2.new(0, 380, 0, 90)
successMessage.Position = UDim2.new(0.5, -190, 0.5, -45)
successMessage.BackgroundColor3 = Color3.fromRGB(144, 238, 144)
successMessage.BorderSizePixel = 0
successMessage.Visible = false
successMessage.Parent = screenGui

local successCorner = Instance.new("UICorner")
successCorner.CornerRadius = UDim.new(0, 20)
successCorner.Parent = successMessage

local successStroke = Instance.new("UIStroke")
successStroke.Color = Color3.fromRGB(34, 139, 34)
successStroke.Thickness = 2
successStroke.Parent = successMessage

local successLabel = Instance.new("TextLabel")
successLabel.Size = UDim2.new(1, -20, 1, -20)
successLabel.Position = UDim2.new(0, 10, 0, 10)
successLabel.BackgroundTransparency = 1
successLabel.Text = "🎉 Key activated successfully! 🌸"
successLabel.TextColor3 = Color3.fromRGB(45, 90, 45)
successLabel.TextScaled = true
successLabel.Font = Enum.Font.GothamBold
successLabel.Parent = successMessage

-- Función para crear pétalos de sakura más detallados
local function createSakuraPetal()
    local petal = Instance.new("Frame")
    petal.Name = "SakuraPetal"
    petal.Size = UDim2.new(0, math.random(8, 16), 0, math.random(8, 16))
    petal.Position = UDim2.new(math.random(), 0, 0, math.random(-50, -20))
    petal.BackgroundColor3 = Color3.fromRGB(255, 179, 217)
    petal.BorderSizePixel = 0
    petal.Rotation = math.random(0, 360)
    petal.Parent = sakuraContainer
    
    -- Corner para hacer el pétalo con forma especial
    local petalCorner = Instance.new("UICorner")
    petalCorner.CornerRadius = UDim.new(0, math.random(3, 8))
    petalCorner.Parent = petal
    
    -- Colores aleatorios más variados para los pétalos
    local colors = {
        Color3.fromRGB(255, 179, 217), -- Rosa sakura clásico
        Color3.fromRGB(255, 192, 203), -- Rosa claro
        Color3.fromRGB(255, 182, 193), -- Rosa medio
        Color3.fromRGB(221, 160, 221), -- Lavanda
        Color3.fromRGB(240, 230, 140), -- Amarillo suave
        Color3.fromRGB(255, 218, 185), -- Durazno
        Color3.fromRGB(230, 230, 250), -- Lavanda muy claro
        Color3.fromRGB(255, 240, 245)  -- Blanco rosado
    }
    petal.BackgroundColor3 = colors[math.random(1, #colors)]
    
    -- Gradiente aleatorio en algunos pétalos
    if math.random() > 0.5 then
        local petalGradient = Instance.new("UIGradient")
        petalGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, petal.BackgroundColor3),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }
        petalGradient.Rotation = math.random(0, 360)
        petalGradient.Parent = petal
    end
    
    -- Animación de caída con rotación y movimiento lateral
    local fallTime = math.random(8, 15)
    local fallTween = TweenService:Create(petal,
        TweenInfo.new(fallTime, Enum.EasingStyle.Linear),
        {
            Position = UDim2.new(petal.Position.X.Scale + math.random(-30, 30)/100, 0, 1.3, 0),
            Rotation = petal.Rotation + math.random(360, 720),
            BackgroundTransparency = 1
        }
    )
    
    -- Movimiento lateral durante la caída
    local swayTween = TweenService:Create(petal,
        TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, math.floor(fallTime/3), true),
        {Position = UDim2.new(petal.Position.X.Scale + math.random(-10, 10)/100, 0, petal.Position.Y.Scale, 0)}
    )
    
    fallTween:Play()
    swayTween:Play()
    
    -- Eliminar pétalo después de la animación
    fallTween.Completed:Connect(function()
        petal:Destroy()
    end)
end

-- Función para crear efectos especiales mejorados
local function createSpecialEffect()
    -- Crear explosión de pétalos
    for i = 1, 35 do
        task.spawn(function()
            task.wait(i * 0.03)
            createSakuraPetal()
        end)
    end
    
    -- Efecto de brillo en el fondo
    local brightTween = TweenService:Create(backgroundGradient,
        TweenInfo.new(0.8, Enum.EasingStyle.Sine),
        {Transparency = 0.3}
    )
    brightTween:Play()
    
    brightTween.Completed:Connect(function()
        local normalTween = TweenService:Create(backgroundGradient,
            TweenInfo.new(1.2, Enum.EasingStyle.Sine),
            {Transparency = 0}
        )
        normalTween:Play()
    end)
end

-- Animación flotante del panel
local function animatePanel()
    local floatTween = TweenService:Create(mainPanel,
        TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {
            Position = UDim2.new(0.5, -225, 0.5, -250),
            Rotation = math.random(-2, 2)
        }
    )
    floatTween:Play()
end

-- Generar pétalos continuamente con mayor frecuencia
local petalConnection
petalConnection = RunService.Heartbeat:Connect(function()
    if math.random() > 0.94 then -- Mayor frecuencia de pétalos
        createSakuraPetal()
    end
end)

-- Efectos del Get Key Button
getKeyButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(getKeyButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {
            Size = UDim2.new(1, -30, 0, 50),
            BackgroundColor3 = Color3.fromRGB(128, 0, 128)
        }
    )
    hoverTween:Play()
end)

getKeyButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(getKeyButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {
            Size = UDim2.new(1, -40, 0, 45),
            BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        }
    )
    leaveTween:Play()
end)

-- Función del botón Get Key
getKeyButton.MouseButton1Click:Connect(function()
    -- Copiar enlace al portapapeles
    setclipboard("https://zamasxmodder.github.io/SakurasCriptTRAIL/")
    
    -- Efecto de click
    local clickTween = TweenService:Create(getKeyButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -50, 0, 40)}
    )
    clickTween:Play()
    
    clickTween.Completed:Connect(function()
        local releaseTween = TweenService:Create(getKeyButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Back),
            {Size = UDim2.new(1, -40, 0, 45)}
        )
        releaseTween:Play()
    end)
    
    -- Mostrar toast
    getKeyToast.Visible = true
    getKeyToast.Position = UDim2.new(0.5, -200, 0, -100)
    
    local showToastTween = TweenService:Create(getKeyToast,
        TweenInfo.new(0.5, Enum.EasingStyle.Back),
        {Position = UDim2.new(0.5, -200, 0, 50)}
    )
    showToastTween:Play()
    
    -- Crear algunos pétalos especiales
    for i = 1, 8 do
        task.wait(0.1)
        createSakuraPetal()
    end
    
    -- Ocultar toast después de 4 segundos
    task.wait(4)
    local hideToastTween = TweenService:Create(getKeyToast,
        TweenInfo.new(0.5, Enum.EasingStyle.Back),
        {Position = UDim2.new(0.5, -200, 0, -100)}
    )
    hideToastTween:Play()
    
    hideToastTween.Completed:Connect(function()
        getKeyToast.Visible = false
    end)
end)

-- Efectos del input
keyInput.Focused:Connect(function()
    local focusTween = TweenService:Create(keyInput,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -30, 0, 55)}
    )
    local strokeTween = TweenService:Create(inputStroke,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Thickness = 3, Transparency = 0.3}
    )
    focusTween:Play()
    strokeTween:Play()
end)

keyInput.FocusLost:Connect(function()
    local unfocusTween = TweenService:Create(keyInput,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -40, 0, 50)}
    )
    local strokeTween = TweenService:Create(inputStroke,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Thickness = 2, Transparency = 0.7}
    )
    unfocusTween:Play()
    strokeTween:Play()
end)

-- Crear pétalos al escribir
keyInput:GetPropertyChangedSignal("Text"):Connect(function()
    if #keyInput.Text > 0 and math.random() > 0.6 then
        createSakuraPetal()
    end
end)

-- Efectos del botón Submit
submitButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(submitButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {
            Size = UDim2.new(1, -30, 0, 60),
            BackgroundColor3 = Color3.fromRGB(255, 0, 128)
        }
    )
    hoverTween:Play()
end)

submitButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(submitButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {
            Size = UDim2.new(1, -40, 0, 55),
            BackgroundColor3 = Color3.fromRGB(255, 20, 147)
        }
    )
    leaveTween:Play()
end)

-- Función del botón submit
submitButton.MouseButton1Click:Connect(function()
    local key = keyInput.Text:match("^%s*(.-)%s*$") -- Trim whitespace
    
    if key and key ~= "" then
        -- Efecto de click
        local clickTween = TweenService:Create(submitButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Back),
            {Size = UDim2.new(1, -50, 0, 50)}
        )
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            local releaseTween = TweenService:Create(submitButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Back),
                {Size = UDim2.new(1, -40, 0, 55)}
            )
            releaseTween:Play()
        end)
        
        -- Crear efecto especial
        createSpecialEffect()
        
        -- Mostrar mensaje de éxito
        successMessage.Visible = true
        successMessage.Size = UDim2.new(0, 0, 0, 0)
        
        local showTween = TweenService:Create(successMessage,
            TweenInfo.new(0.5, Enum.EasingStyle.Back),
            {Size = UDim2.new(0, 380, 0, 90)}
        )
        showTween:Play()
        
        -- Limpiar input
        task.wait(0.3)
        keyInput.Text = ""
        keyInput.PlaceholderText = '"' .. key .. '" - Key registered! ✨'
        
        -- Ocultar mensaje después de 3 segundos
        task.wait(3)
        local hideTween = TweenService:Create(successMessage,
            TweenInfo.new(0.5, Enum.EasingStyle.Back),
            {Size = UDim2.new(0, 0, 0, 0)}
        )
        hideTween:Play()
        
        hideTween.Completed:Connect(function()
            successMessage.Visible = false
            keyInput.PlaceholderText = "put your key here..."
        end)
        
        -- Log de la clave (puedes cambiar esto por tu lógica)
        print("🌸 Key submitted:", key)
        
        -- Aquí puedes agregar tu lógica para manejar la clave
        -- Por ejemplo: enviar a un webhook, validar, etc.
    end
end)

-- Hacer el panel responsive para diferentes tamaños de pantalla
local function updatePanelSize()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local scale = math.min(screenSize.X / 1920, screenSize.Y / 1080)
    scale = math.clamp(scale, 0.5, 1.2)
    
    -- Panel principal
    mainPanel.Size = UDim2.new(0, 450 * scale, 0, 480 * scale)
    mainPanel.Position = UDim2.new(0.5, -100 * scale, 0.5, -240 * scale)
    
    -- Panel de status
    statusPanel.Size = UDim2.new(0, 280 * scale, 0, 420 * scale)
    statusPanel.Position = UDim2.new(0, 30 * scale, 0.5, -210 * scale)
end

-- Conectar el redimensionamiento
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updatePanelSize)
updatePanelSize() -- Aplicar al inicio

-- Iniciar animaciones
animatePanel()

-- Actualizar lista de jugadores al inicio
updatePlayersList()

-- Actualizar lista cada 5 minutos (300 segundos)
local statusUpdateConnection
statusUpdateConnection = task.spawn(function()
    while screenGui.Parent do
        task.wait(300) -- 5 minutos
        if screenGui.Parent then
            updatePlayersList()
        end
    end
end)

-- Animación flotante del panel de status
local function animateStatusPanel()
    local floatTween = TweenService:Create(statusPanel,
        TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {
            Position = UDim2.new(0, 30, 0.5, -220),
            Rotation = math.random(-1, 1)
        }
    )
    floatTween:Play()
end

-- Iniciar animación del panel de status
animateStatusPanel()

-- Crear pétalos iniciales más densos
for i = 1, 25 do
    task.spawn(function()
        task.wait(i * 0.15)
        createSakuraPetal()
    end)
end

-- Función para limpiar la GUI (opcional)
local function cleanup()
    if petalConnection then
        petalConnection:Disconnect()
    end
    if statusUpdateConnection then
        task.cancel(statusUpdateConnection)
    end
    screenGui:Destroy()
end

-- Función para alternar visibilidad de la GUI
local function toggleGUI()
    screenGui.Enabled = not screenGui.Enabled
end

-- Detectar tecla para ocultar/mostrar (opcional - Tecla F)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        toggleGUI()
    end
end)

-- Sistema de partículas sakura adicional para momentos especiales
local function createSakuraExplosion(centerPosition)
    for i = 1, 50 do
        task.spawn(function()
            local petal = Instance.new("Frame")
            petal.Name = "ExplosionPetal"
            petal.Size = UDim2.new(0, math.random(6, 14), 0, math.random(6, 14))
            petal.Position = centerPosition
            petal.BackgroundColor3 = Color3.fromRGB(255, 192, 203)
            petal.BorderSizePixel = 0
            petal.Parent = sakuraContainer
            
            local petalCorner = Instance.new("UICorner")
            petalCorner.CornerRadius = UDim.new(0.5, 0)
            petalCorner.Parent = petal
            
            -- Movimiento radial desde el centro
            local angle = math.rad(i * (360 / 50))
            local distance = math.random(100, 300)
            local targetX = centerPosition.X.Scale + (math.cos(angle) * distance / workspace.CurrentCamera.ViewportSize.X)
            local targetY = centerPosition.Y.Scale + (math.sin(angle) * distance / workspace.CurrentCamera.ViewportSize.Y)
            
            local explosionTween = TweenService:Create(petal,
                TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(targetX, 0, targetY, 0),
                    Rotation = math.random(0, 720),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 4, 0, 4)
                }
            )
            explosionTween:Play()
            
            explosionTween.Completed:Connect(function()
                petal:Destroy()
            end)
        end)
    end
end

-- Efecto especial al hacer hover sobre el título
titleLabel.MouseEnter:Connect(function()
    createSakuraExplosion(UDim2.new(0.5, 0, 0.2, 0))
end)

-- Retornar tabla con funciones útiles
return {
    GUI = screenGui,
    Cleanup = cleanup,
    CreatePetal = createSakuraPetal,
    SpecialEffect = createSpecialEffect,
    ToggleGUI = toggleGUI,
    SakuraExplosion = createSakuraExplosion,
    UpdatePlayersList = updatePlayersList,
    StatusPanel = statusPanel
}
