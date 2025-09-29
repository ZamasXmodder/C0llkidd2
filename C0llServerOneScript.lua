-- Steal A Brainrot - Enhanced Sakura Panel GUI for Roblox
-- Este script debe ir en StarterPlayerScripts o ejecutarse con loadstring

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Verificar edad de la cuenta (5 días mínimo)
local function checkAccountAge()
    return player.AccountAge >= 5
end

-- Función para obtener información del país
local function getPlayerCountry()
    local success, result = pcall(function()
        return LocalizationService:GetCountryRegionForPlayerAsync(player)
    end)
    return success and result or "Unknown"
end

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SakuraBrainrotPanel"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Verificar acceso antes de mostrar la GUI completa
if not checkAccountAge() then
    -- Crear mensaje de acceso denegado
    local deniedFrame = Instance.new("Frame")
    deniedFrame.Name = "AccessDenied"
    deniedFrame.Size = UDim2.new(1, 0, 1, 0)
    deniedFrame.Position = UDim2.new(0, 0, 0, 0)
    deniedFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    deniedFrame.BorderSizePixel = 0
    deniedFrame.Parent = screenGui
    
    local deniedLabel = Instance.new("TextLabel")
    deniedLabel.Size = UDim2.new(0, 600, 0, 200)
    deniedLabel.Position = UDim2.new(0.5, -300, 0.5, -100)
    deniedLabel.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    deniedLabel.BorderSizePixel = 0
    deniedLabel.Text = "🚫 NO TIENES ACCESO AUTORIZADO\n(ACCOUNT NOT AUTHORIZED) 🚫"
    deniedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    deniedLabel.TextScaled = true
    deniedLabel.Font = Enum.Font.GothamBold
    deniedLabel.Parent = deniedFrame
    
    local deniedCorner = Instance.new("UICorner")
    deniedCorner.CornerRadius = UDim.new(0, 20)
    deniedCorner.Parent = deniedLabel
    
    -- Efecto parpadeante
    local blinkTween = TweenService:Create(deniedLabel,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}
    )
    blinkTween:Play()
    
    return -- Terminar el script aquí
end

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

-- Panel de información del jugador (lado derecho) - VERSIÓN MEJORADA
local playerInfoPanel = Instance.new("Frame")
playerInfoPanel.Name = "PlayerInfoPanel"
playerInfoPanel.Size = UDim2.new(0, 280, 0, 420) -- Mismo tamaño que el panel de status
playerInfoPanel.Position = UDim2.new(1, -310, 0.5, -210) -- Mejor posicionamiento
playerInfoPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
playerInfoPanel.BackgroundTransparency = 0.85
playerInfoPanel.BorderSizePixel = 0
playerInfoPanel.Parent = screenGui

-- Corner radius para el panel de info
local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 20)
infoCorner.Parent = playerInfoPanel

-- Borde del panel de info (mismo estilo que el panel de status)
local infoStroke = Instance.new("UIStroke")
infoStroke.Color = Color3.fromRGB(186, 85, 211)
infoStroke.Thickness = 2
infoStroke.Transparency = 0.6
infoStroke.Parent = playerInfoPanel

-- Gradiente en el borde del info (mismo que status panel)
local infoStrokeGradient = Instance.new("UIGradient")
infoStrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 85, 211)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 112, 219))
}
infoStrokeGradient.Parent = infoStroke

-- Título del panel de info (mismo estilo que status)
local infoTitle = Instance.new("TextLabel")
infoTitle.Name = "InfoTitle"
infoTitle.Size = UDim2.new(1, -20, 0, 50)
infoTitle.Position = UDim2.new(0, 10, 0, 15)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "PLAYER INFORMATION"
infoTitle.TextColor3 = Color3.fromRGB(147, 112, 219)
infoTitle.TextScaled = true
infoTitle.Font = Enum.Font.GothamBold
infoTitle.Parent = playerInfoPanel

-- Gradiente del título de info (mismo que status)
local infoTitleGradient = Instance.new("UIGradient")
infoTitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(147, 112, 219)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(186, 85, 211)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
}
infoTitleGradient.Rotation = 45
infoTitleGradient.Parent = infoTitle

-- Container para el contenido del panel
local infoContent = Instance.new("Frame")
infoContent.Name = "InfoContent"
infoContent.Size = UDim2.new(1, -20, 1, -80)
infoContent.Position = UDim2.new(0, 10, 0, 70)
infoContent.BackgroundTransparency = 1
infoContent.Parent = playerInfoPanel

-- Avatar del jugador (más pequeño y mejor posicionado)
local avatarFrame = Instance.new("Frame")
avatarFrame.Name = "AvatarFrame"
avatarFrame.Size = UDim2.new(0, 80, 0, 80)
avatarFrame.Position = UDim2.new(0.5, -40, 0, 10)
avatarFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
avatarFrame.BackgroundTransparency = 0.9
avatarFrame.BorderSizePixel = 0
avatarFrame.Parent = infoContent

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(0, 12)
avatarCorner.Parent = avatarFrame

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = Color3.fromRGB(186, 85, 211)
avatarStroke.Thickness = 2
avatarStroke.Transparency = 0.6
avatarStroke.Parent = avatarFrame

-- Imagen del avatar (headshot)
local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "AvatarImage"
avatarImage.Size = UDim2.new(1, -4, 1, -4)
avatarImage.Position = UDim2.new(0, 2, 0, 2)
avatarImage.BackgroundTransparency = 1
avatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
avatarImage.Parent = avatarFrame

local avatarImageCorner = Instance.new("UICorner")
avatarImageCorner.CornerRadius = UDim.new(0, 10)
avatarImageCorner.Parent = avatarImage

-- ScrollingFrame para la información (mismo estilo que el panel de status)
local infoScrollFrame = Instance.new("ScrollingFrame")
infoScrollFrame.Name = "InfoScrollFrame"
infoScrollFrame.Size = UDim2.new(1, 0, 1, -100)
infoScrollFrame.Position = UDim2.new(0, 0, 0, 100)
infoScrollFrame.BackgroundTransparency = 1
infoScrollFrame.ScrollBarThickness = 6
infoScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(186, 85, 211)
infoScrollFrame.ScrollBarImageTransparency = 0.3
infoScrollFrame.BorderSizePixel = 0
infoScrollFrame.Parent = infoContent

-- Layout para organizar la información
local infoLayout = Instance.new("UIListLayout")
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
infoLayout.Padding = UDim.new(0, 8)
infoLayout.Parent = infoScrollFrame

-- Función para crear elementos de información (mismo estilo que los jugadores)
local function createInfoElement(icon, label, value, layoutOrder)
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = label
    infoFrame.Size = UDim2.new(1, -10, 0, 35)
    infoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    infoFrame.BackgroundTransparency = 0.9
    infoFrame.BorderSizePixel = 0
    infoFrame.LayoutOrder = layoutOrder
    infoFrame.Parent = infoScrollFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoFrame
    
    -- Icono
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "IconLabel"
    iconLabel.Size = UDim2.new(0, 25, 1, 0)
    iconLabel.Position = UDim2.new(0, 5, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(147, 112, 219)
    iconLabel.TextScaled = true
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.Parent = infoFrame
    
    -- Label
    local labelText = Instance.new("TextLabel")
    labelText.Name = "LabelText"
    labelText.Size = UDim2.new(0, 70, 1, 0)
    labelText.Position = UDim2.new(0, 35, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label .. ":"
    labelText.TextColor3 = Color3.fromRGB(139, 90, 140)
    labelText.TextScaled = true
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = infoFrame
    
    -- Valor
    local valueText = Instance.new("TextLabel")
    valueText.Name = "ValueText"
    valueText.Size = UDim2.new(1, -110, 1, 0)
    valueText.Position = UDim2.new(0, 110, 0, 0)
    valueText.BackgroundTransparency = 1
    valueText.Text = value
    valueText.TextColor3 = Color3.fromRGB(186, 85, 211)
    valueText.TextScaled = true
    valueText.Font = Enum.Font.Gotham
    valueText.TextXAlignment = Enum.TextXAlignment.Left
    valueText.Parent = infoFrame
    
    -- Animación de entrada (mismo estilo que los jugadores)
    infoFrame.Size = UDim2.new(0, 0, 0, 35)
    infoFrame.BackgroundTransparency = 1
    
    local enterTween = TweenService:Create(infoFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -10, 0, 35), BackgroundTransparency = 0.9}
    )
    enterTween:Play()
    
    return infoFrame
end

-- Panel principal (centro)
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 450, 0, 480)
mainPanel.Position = UDim2.new(0.5, -225, 0.5, -240)
mainPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainPanel.BackgroundTransparency = 0.1
mainPanel.BorderSizePixel = 0
mainPanel.Parent = screenGui

-- Corner radius para el panel principal
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 25)
mainCorner.Parent = mainPanel

-- Borde del panel principal
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 182, 193)
mainStroke.Thickness = 3
mainStroke.Transparency = 0.3
mainStroke.Parent = mainPanel

-- Gradiente del panel principal
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 245)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 228, 225)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 218, 185)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 240, 245))
}
mainGradient.Rotation = 90
mainGradient.Parent = mainPanel

-- Título principal
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -40, 0, 70)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🌸 STEAL A BRAINROT 🌸"
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

-- Toast de Get Key copiado
local getKeyToast = Instance.new("Frame")
getKeyToast.Name = "GetKeyToast"
getKeyToast.Size = UDim2.new(0, 400, 0, 80)
getKeyToast.Position = UDim2.new(0.5, -200, 0, -100)
getKeyToast.BackgroundColor3 = Color3.fromRGB(72, 201, 176)
getKeyToast.BorderSizePixel = 0
getKeyToast.Visible = false
getKeyToast.Parent = screenGui

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 15)
toastCorner.Parent = getKeyToast

local toastLabel = Instance.new("TextLabel")
toastLabel.Size = UDim2.new(1, -20, 1, -20)
toastLabel.Position = UDim2.new(0, 10, 0, 10)
toastLabel.BackgroundTransparency = 1
toastLabel.Text = "🔗 Link copied to clipboard! 🌸"
toastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toastLabel.TextScaled = true
toastLabel.Font = Enum.Font.GothamBold
toastLabel.Parent = getKeyToast

-- Mensaje de éxito
local successMessage = Instance.new("Frame")
successMessage.Name = "SuccessMessage"
successMessage.Size = UDim2.new(0, 0, 0, 0)
successMessage.Position = UDim2.new(0.5, 0, 0.5, 0)
successMessage.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
successMessage.BorderSizePixel = 0
successMessage.Visible = false
successMessage.Parent = screenGui

local successCorner = Instance.new("UICorner")
successCorner.CornerRadius = UDim.new(0, 20)
successCorner.Parent = successMessage

local successLabel = Instance.new("TextLabel")
successLabel.Size = UDim2.new(1, -20, 1, -20)
successLabel.Position = UDim2.new(0, 10, 0, 10)
successLabel.BackgroundTransparency = 1
successLabel.Text = "🌸 KEY SUBMITTED SUCCESSFULLY! 🌸"
successLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
successLabel.TextScaled = true
successLabel.Font = Enum.Font.GothamBold
successLabel.Parent = successMessage

-- Función para crear pétalos de sakura animados
local function createSakuraPetal()
    local petal = Instance.new("TextLabel")
    petal.Name = "SakuraPetal"
    petal.Size = UDim2.new(0, math.random(15, 30), 0, math.random(15, 30))
    petal.Position = UDim2.new(math.random(), 0, -0.1, 0)
    petal.BackgroundTransparency = 1
    petal.Text = math.random() > 0.5 and "🌸" or "🌺"
    petal.TextScaled = true
    petal.Font = Enum.Font.Gotham
    petal.TextTransparency = math.random(0, 30) / 100
    petal.Parent = sakuraContainer
    
    -- Animación de caída
    local fallTween = TweenService:Create(petal,
        TweenInfo.new(math.random(8, 15), Enum.EasingStyle.Linear),
        {
            Position = UDim2.new(petal.Position.X.Scale + math.random(-50, 50)/100, 0, 1.2, 0),
            Rotation = math.random(0, 720),
            TextTransparency = 1
        }
    )
    fallTween:Play()
    
    -- Movimiento lateral suave
    local swayTween = TweenService:Create(petal,
        TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(petal.Position.X.Scale + math.random(-10, 10)/100, 0, petal.Position.Y.Scale, 0)}
    )
    swayTween:Play()
    
    -- Eliminar pétalo después de la animación
    fallTween.Completed:Connect(function()
        swayTween:Cancel()
        petal:Destroy()
    end)
end

-- Función para crear efecto especial
local function createSpecialEffect()
    for i = 1, 15 do
        task.spawn(function()
            task.wait(i * 0.05)
            createSakuraPetal()
        end)
    end
end

-- Animación flotante del panel principal
local function animateMainPanel()
    local floatTween = TweenService:Create(mainPanel,
        TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {
            Position = UDim2.new(0.5, -235, 0.5, -250),
            Rotation = math.random(-2, 2)
        }
    )
    floatTween:Play()
end

-- Animación flotante del panel de status
local function animateStatusPanel()
    local floatTween = TweenService:Create(statusPanel,
        TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {
            Position = UDim2.new(0, 25, 0.5, -220),
            Rotation = math.random(-1, 1)
        }
    )
    floatTween:Play()
end

-- Animación flotante del panel de información
local function animateInfoPanel()
    local floatTween = TweenService:Create(playerInfoPanel,
        TweenInfo.new(6.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {
            Position = UDim2.new(1, -315, 0.5, -220),
            Rotation = math.random(-1, 1)
        }
    )
    floatTween:Play()
end

-- Función para animar el avatar
local function animateAvatar()
    local avatarFloatTween = TweenService:Create(avatarFrame,
        TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {
            Position = UDim2.new(0.5, -40, 0, 5),
            Rotation = math.random(-3, 3)
        }
    )
    avatarFloatTween:Play()
    
    -- Efecto de brillo en el borde del avatar
    local avatarGlowTween = TweenService:Create(avatarStroke,
        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.2, Thickness = 3}
    )
    avatarGlowTween:Play()
end

-- Obtener información del jugador
local playerCountry = getPlayerCountry()
local playerStatus = player.MembershipType == Enum.MembershipType.Premium and "Premium" or "Regular"

-- Crear elementos de información con delay escalonado
task.spawn(function()
    local infoData = {
        {"👤", "User", player.Name, 1},
        {"📝", "Display", player.DisplayName, 2},
        {"🆔", "ID", tostring(player.UserId), 3},
        {"📅", "Age", player.AccountAge .. " days", 4},
        {"⭐", "Status", playerStatus, 5},
        {"🌍", "Country", playerCountry, 6}
    }
    
    for i, data in ipairs(infoData) do
        task.wait(i * 0.1) -- Delay escalonado
        createInfoElement(data[1], data[2], data[3], data[4])
    end
    
    -- Actualizar tamaño del scroll
    task.wait(1)
    infoScrollFrame.CanvasSize = UDim2.new(0, 0, 0, infoLayout.AbsoluteContentSize.Y + 10)
end)

-- Indicador de acceso autorizado
task.spawn(function()
        task.wait(0.8) -- Esperar a que se carguen los otros elementos
    
    local accessFrame = Instance.new("Frame")
    accessFrame.Name = "AccessIndicator"
    accessFrame.Size = UDim2.new(1, -10, 0, 40)
    accessFrame.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    accessFrame.BackgroundTransparency = 0.1
    accessFrame.BorderSizePixel = 0
    accessFrame.LayoutOrder = 7
    accessFrame.Parent = infoScrollFrame
    
    local accessCorner = Instance.new("UICorner")
    accessCorner.CornerRadius = UDim.new(0, 8)
    accessCorner.Parent = accessFrame
    
    local accessLabel = Instance.new("TextLabel")
    accessLabel.Size = UDim2.new(1, -10, 1, 0)
    accessLabel.Position = UDim2.new(0, 5, 0, 0)
    accessLabel.BackgroundTransparency = 1
    accessLabel.Text = "✅ ACCESS AUTHORIZED"
    accessLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    accessLabel.TextScaled = true
    accessLabel.Font = Enum.Font.GothamBold
    accessLabel.Parent = accessFrame
    
    -- Animación de entrada
    accessFrame.Size = UDim2.new(0, 0, 0, 40)
    accessFrame.BackgroundTransparency = 1
    
    local enterTween = TweenService:Create(accessFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -10, 0, 40), BackgroundTransparency = 0.1}
    )
    enterTween:Play()
    
    -- Efecto de pulso
    local accessPulseTween = TweenService:Create(accessFrame,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundColor3 = Color3.fromRGB(39, 174, 96)}
    )
    accessPulseTween:Play()
    
    -- Actualizar tamaño del scroll después de añadir el indicador
    task.wait(0.6)
    infoScrollFrame.CanvasSize = UDim2.new(0, 0, 0, infoLayout.AbsoluteContentSize.Y + 10)
end)

-- Función responsive para diferentes tamaños de pantalla
local function updatePanelSizes()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local scale = math.min(screenSize.X / 1920, screenSize.Y / 1080)
    scale = math.max(0.6, math.min(1.2, scale))
    
    -- Ajustar tamaño del panel principal
    local newMainSize = UDim2.new(0, 450 * scale, 0, 480 * scale)
    mainPanel.Size = newMainSize
    mainPanel.Position = UDim2.new(0.5, -(450 * scale) / 2, 0.5, -(480 * scale) / 2)
    
    -- Ajustar panel de status (izquierda)
    local newStatusSize = UDim2.new(0, 280 * scale, 0, 420 * scale)
    statusPanel.Size = newStatusSize
    statusPanel.Position = UDim2.new(0, 30 * scale, 0.5, -(420 * scale) / 2)
    
    -- Ajustar panel de información (derecha)
    local newInfoSize = UDim2.new(0, 280 * scale, 0, 420 * scale)
    playerInfoPanel.Size = newInfoSize
    playerInfoPanel.Position = UDim2.new(1, -(280 * scale + 30 * scale), 0.5, -(420 * scale) / 2)
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

-- Función del botón submit con webhook
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
        
        -- Enviar datos al webhook (REEMPLAZA CON TU WEBHOOK URL)
        local webhookData = {
            content = "🌸 **Nueva Key Enviada** 🌸",
            embeds = {{
                title = "Steal A Brainrot - Key Submission",
                color = 16711935, -- Color rosa
                fields = {
                    {
                        name = "👤 Usuario",
                        value = player.Name .. " (@" .. player.DisplayName .. ")",
                        inline = true
                    },
                    {
                        name = "🆔 User ID",
                        value = tostring(player.UserId),
                        inline = true
                    },
                    {
                        name = "📅 Edad de Cuenta",
                        value = player.AccountAge .. " días",
                        inline = true
                    },
                    {
                        name = "⭐ Membership",
                        value = playerStatus,
                        inline = true
                    },
                                        {
                        name = "🌍 País",
                        value = playerCountry,
                        inline = true
                    },
                    {
                        name = "🔑 Key Enviada",
                        value = "```" .. key .. "```",
                        inline = false
                    },
                    {
                        name = "⏰ Timestamp",
                        value = os.date("%Y-%m-%d %H:%M:%S"),
                        inline = true
                    }
                },
                thumbnail = {
                    url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
                },
                footer = {
                    text = "Steal A Brainrot Panel • Sakura Edition",
                    icon_url = "https://cdn.discordapp.com/emojis/123456789.png"
                }
            }}
        }
        
        -- Intentar enviar al webhook (REEMPLAZA LA URL)
        local success, response = pcall(function()
            return HttpService:PostAsync(
                "TU_WEBHOOK_URL_AQUI", -- REEMPLAZA CON TU WEBHOOK
                HttpService:JSONEncode(webhookData),
                Enum.HttpContentType.ApplicationJson
            )
        end)
        
        -- Mostrar mensaje de éxito
        successMessage.Visible = true
        local successTween = TweenService:Create(successMessage,
            TweenInfo.new(0.5, Enum.EasingStyle.Back),
            {Size = UDim2.new(0, 500, 0, 100)}
        )
        successTween:Play()
        
        -- Limpiar input
        keyInput.Text = ""
        
        -- Ocultar mensaje después de 3 segundos
        task.wait(3)
        local hideSuccessTween = TweenService:Create(successMessage,
            TweenInfo.new(0.5, Enum.EasingStyle.Back),
            {Size = UDim2.new(0, 0, 0, 0)}
        )
        hideSuccessTween:Play()
        
        hideSuccessTween.Completed:Connect(function()
            successMessage.Visible = false
        end)
    else
        -- Efecto de error si no hay key
        local errorTween = TweenService:Create(keyInput,
            TweenInfo.new(0.1, Enum.EasingStyle.Linear),
            {BackgroundColor3 = Color3.fromRGB(255, 200, 200)}
        )
        errorTween:Play()
        
        errorTween.Completed:Connect(function()
            local resetTween = TweenService:Create(keyInput,
                TweenInfo.new(0.3, Enum.EasingStyle.Linear),
                {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}
            )
            resetTween:Play()
        end)
    end
end)

-- Conectar función de responsive al cambio de tamaño
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updatePanelSizes)
updatePanelSizes() -- Aplicar inicialmente

-- Iniciar animaciones flotantes
animateMainPanel()
animateStatusPanel()
animateInfoPanel()
animateAvatar()

-- Actualizar lista de jugadores cada 15 segundos
task.spawn(function()
    while screenGui.Parent do
        updatePlayersList()
        task.wait(15)
    end
end)

-- Inicializar lista de jugadores
updatePlayersList()

-- Función para cerrar la GUI (tecla ESC)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape then
        -- Animación de cierre
        local closeTween1 = TweenService:Create(mainPanel,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}
        )
        
        local closeTween2 = TweenService:Create(statusPanel,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0)}
        )
        
        local closeTween3 = TweenService:Create(playerInfoPanel,
            TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0)}
        )
        
        local fadeTween = TweenService:Create(backgroundFrame,
            TweenInfo.new(1, Enum.EasingStyle.Sine),
            {BackgroundTransparency = 1}
        )
        
        closeTween1:Play()
        closeTween2:Play()
        closeTween3:Play()
        fadeTween:Play()
        
        -- Crear pétalos de despedida
        for i = 1, 20 do
            task.spawn(function()
                task.wait(i * 0.05)
                createSakuraPetal()
            end)
        end
        
        -- Destruir GUI después de las animaciones
        fadeTween.Completed:Connect(function()
            if petalConnection then
                petalConnection:Disconnect()
            end
            screenGui:Destroy()
        end)
    end
end)

-- Función para minimizar/maximizar con doble click en el título
local lastClickTime = 0
titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local currentTime = tick()
        if currentTime - lastClickTime < 0.5 then -- Doble click detectado
            -- Toggle minimizar
            if mainPanel.Size.Y.Offset > 100 then
                -- Minimizar
                local minimizeTween = TweenService:Create(mainPanel,
                    TweenInfo.new(0.5, Enum.EasingStyle.Back),
                    {Size = UDim2.new(mainPanel.Size.X.Scale, mainPanel.Size.X.Offset, 0, 80)}
                )
                minimizeTween:Play()
            else
                -- Maximizar
                local maximizeTween = TweenService:Create(mainPanel,
                    TweenInfo.new(0.5, Enum.EasingStyle.Back),
                    {Size = UDim2.new(0, 450, 0, 480)}
                )
                maximizeTween:Play()
            end
        end
        lastClickTime = currentTime
    end
end)

-- Efectos de partículas mejorados
local function createMagicParticle()
    local particle = Instance.new("Frame")
    particle.Name = "MagicParticle"
    particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BorderSizePixel = 0
    particle.Parent = sakuraContainer
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(0.5, 0)
    particleCorner.Parent = particle
    
    -- Gradiente brillante
    local particleGradient = Instance.new("UIGradient")
    particleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 182, 193))
    }
    particleGradient.Parent = particle
    
    -- Animación de brillo
    local glowTween = TweenService:Create(particle,
        TweenInfo.new(math.random(2, 5), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {
            BackgroundTransparency = 0.8,
            Size = UDim2.new(0, particle.Size.X.Offset * 1.5, 0, particle.Size.Y.Offset * 1.5)
        }
    )
    glowTween:Play()
    
    -- Movimiento flotante
    local floatTween = TweenService:Create(particle,
        TweenInfo.new(math.random(8, 15), Enum.EasingStyle.Linear),
        {
            Position = UDim2.new(math.random(), 0, math.random(), 0),
            Rotation = math.random(0, 360)
        }
    )
    floatTween:Play()
    
    -- Eliminar después de un tiempo
    task.spawn(function()
        task.wait(math.random(10, 20))
        local fadeTween = TweenService:Create(particle,
            TweenInfo.new(2, Enum.EasingStyle.Sine),
            {BackgroundTransparency = 1}
        )
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            particle:Destroy()
        end)
    end)
end

-- Generar partículas mágicas ocasionalmente
task.spawn(function()
    while screenGui.Parent do
        if math.random() > 0.97 then
            createMagicParticle()
        end
        task.wait(0.1)
    end
end)

-- Efectos de sonido (opcional, requiere SoundService)
local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
    sound.Volume = 0.3
    sound.Parent = workspace
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- Conectar sonidos a los botones
getKeyButton.MouseButton1Click:Connect(playClickSound)
submitButton.MouseButton1Click:Connect(playClickSound)

-- Efecto especial al cargar el panel de información
task.spawn(function()
    task.wait(1.5)
    -- Crear algunos pétalos especiales alrededor del panel de información
    for i = 1, 5 do
        task.spawn(function()
            task.wait(i * 0.2)
            local specialPetal = Instance.new("TextLabel")
            specialPetal.Size = UDim2.new(0, 25, 0, 25)
            specialPetal.Position = UDim2.new(1, -350 + math.random(-50, 50), 0.5, math.random(-200, 200))
            specialPetal.BackgroundTransparency = 1
            specialPetal.Text = "🌸"
            specialPetal.TextScaled = true
            specialPetal.Font = Enum.Font.Gotham
            specialPetal.Parent = backgroundFrame
            
            -- Animación especial
            local specialTween = TweenService:Create(specialPetal,
                TweenInfo.new(3, Enum.EasingStyle.Sine),
                {
                    Position = UDim2.new(specialPetal.Position.X.Scale + math.random(-20, 20)/100, 0, 
                               specialPetal.Position.Y.Scale + math.random(-30, 30)/100, 0),
                    Rotation = math.random(0, 360),
                    TextTransparency = 1
                }
            )
            specialTween:Play()
                                specialTween.Completed:Connect(function()
                specialPetal:Destroy()
            end)
        end)
    end
end)

-- Mensaje de bienvenida animado
task.spawn(function()
    task.wait(2)
    
    local welcomeFrame = Instance.new("Frame")
    welcomeFrame.Name = "WelcomeMessage"
    welcomeFrame.Size = UDim2.new(0, 0, 0, 0)
    welcomeFrame.Position = UDim2.new(0.5, 0, 0.2, 0)
    welcomeFrame.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    welcomeFrame.BackgroundTransparency = 0.1
    welcomeFrame.BorderSizePixel = 0
    welcomeFrame.Parent = screenGui
    
    local welcomeCorner = Instance.new("UICorner")
    welcomeCorner.CornerRadius = UDim.new(0, 15)
    welcomeCorner.Parent = welcomeFrame
    
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, -20, 1, -20)
    welcomeLabel.Position = UDim2.new(0, 10, 0, 10)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = "🌸 Welcome " .. player.DisplayName .. "! 🌸"
    welcomeLabel.TextColor3 = Color3.fromRGB(139, 90, 140)
    welcomeLabel.TextScaled = true
    welcomeLabel.Font = Enum.Font.GothamBold
    welcomeLabel.Parent = welcomeFrame
    
    -- Animación de aparición
    local welcomeAppearTween = TweenService:Create(welcomeFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Back),
        {Size = UDim2.new(0, 400, 0, 60)}
    )
    welcomeAppearTween:Play()
    
    -- Crear pétalos de bienvenida
    for i = 1, 10 do
        task.spawn(function()
            task.wait(i * 0.1)
            createSakuraPetal()
        end)
    end
    
    -- Ocultar después de 4 segundos
    task.wait(4)
    local welcomeHideTween = TweenService:Create(welcomeFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back),
        {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.1, 0)
        }
    )
    welcomeHideTween:Play()
    
    welcomeHideTween.Completed:Connect(function()
        welcomeFrame:Destroy()
    end)
end)

-- Sistema de estadísticas en tiempo real
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(0, 200, 0, 60)
statsFrame.Position = UDim2.new(0, 20, 1, -80)
statsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
statsFrame.BackgroundTransparency = 0.9
statsFrame.BorderSizePixel = 0
statsFrame.Parent = screenGui

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 12)
statsCorner.Parent = statsFrame

local statsStroke = Instance.new("UIStroke")
statsStroke.Color = Color3.fromRGB(186, 85, 211)
statsStroke.Thickness = 1
statsStroke.Transparency = 0.7
statsStroke.Parent = statsFrame

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, -10, 1, -10)
statsLabel.Position = UDim2.new(0, 5, 0, 5)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "🌸 Panel Active: 00:00"
statsLabel.TextColor3 = Color3.fromRGB(147, 112, 219)
statsLabel.TextScaled = true
statsLabel.Font = Enum.Font.GothamMedium
statsLabel.Parent = statsFrame

-- Contador de tiempo activo
local startTime = tick()
task.spawn(function()
    while screenGui.Parent do
        local elapsed = tick() - startTime
        local minutes = math.floor(elapsed / 60)
        local seconds = math.floor(elapsed % 60)
        statsLabel.Text = string.format("🌸 Panel Active: %02d:%02d", minutes, seconds)
        task.wait(1)
    end
end)

-- Animación del frame de estadísticas
local statsFloatTween = TweenService:Create(statsFrame,
    TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Position = UDim2.new(0, 15, 1, -85)}
)
statsFloatTween:Play()

-- Sistema de notificaciones
local notificationQueue = {}
local isShowingNotification = false

local function showNotification(text, color, duration)
    table.insert(notificationQueue, {text = text, color = color, duration = duration or 3})
    
    if not isShowingNotification then
        task.spawn(function()
            while #notificationQueue > 0 do
                isShowingNotification = true
                local notification = table.remove(notificationQueue, 1)
                
                local notifFrame = Instance.new("Frame")
                notifFrame.Name = "Notification"
                notifFrame.Size = UDim2.new(0, 0, 0, 50)
                notifFrame.Position = UDim2.new(1, 0, 0.1, 0)
                notifFrame.BackgroundColor3 = notification.color
                notifFrame.BorderSizePixel = 0
                notifFrame.Parent = screenGui
                
                local notifCorner = Instance.new("UICorner")
                notifCorner.CornerRadius = UDim.new(0, 10)
                notifCorner.Parent = notifFrame
                
                local notifLabel = Instance.new("TextLabel")
                notifLabel.Size = UDim2.new(1, -20, 1, -10)
                notifLabel.Position = UDim2.new(0, 10, 0, 5)
                notifLabel.BackgroundTransparency = 1
                notifLabel.Text = notification.text
                notifLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                notifLabel.TextScaled = true
                notifLabel.Font = Enum.Font.GothamBold
                notifLabel.Parent = notifFrame
                
                -- Animación de entrada
                local showTween = TweenService:Create(notifFrame,
                    TweenInfo.new(0.5, Enum.EasingStyle.Back),
                    {
                        Size = UDim2.new(0, 300, 0, 50),
                        Position = UDim2.new(1, -320, 0.1, 0)
                    }
                )
                showTween:Play()
                
                -- Esperar duración
                task.wait(notification.duration)
                
                -- Animación de salida
                local hideTween = TweenService:Create(notifFrame,
                    TweenInfo.new(0.3, Enum.EasingStyle.Back),
                    {
                        Size = UDim2.new(0, 0, 0, 50),
                        Position = UDim2.new(1, 0, 0.1, 0)
                    }
                )
                hideTween:Play()
                
                hideTween.Completed:Connect(function()
                    notifFrame:Destroy()
                end)
                
                task.wait(0.5) -- Pausa entre notificaciones
            end
            isShowingNotification = false
        end)
    end
end

-- Mostrar notificaciones de ejemplo
task.spawn(function()
    task.wait(3)
    showNotification("🌸 Panel loaded successfully!", Color3.fromRGB(46, 204, 113), 2)
    
    task.wait(5)
    showNotification("💫 All systems operational", Color3.fromRGB(52, 152, 219), 2)
    
    task.wait(10)
    showNotification("🔄 Player list updated", Color3.fromRGB(155, 89, 182), 2)
end)

-- Efecto de lluvia de pétalos especial (se activa cada 30 segundos)
task.spawn(function()
    while screenGui.Parent do
        task.wait(30)
        
        -- Crear lluvia de pétalos
        for i = 1, 25 do
            task.spawn(function()
                task.wait(i * 0.05)
                createSakuraPetal()
            end)
        end
        
        showNotification("🌸 Sakura shower activated!", Color3.fromRGB(255, 105, 180), 2)
    end
end)

-- Sistema de debug (solo visible en modo desarrollador)
local debugMode = false -- Cambiar a true para activar debug

if debugMode then
    local debugFrame = Instance.new("Frame")
    debugFrame.Name = "DebugFrame"
    debugFrame.Size = UDim2.new(0, 250, 0, 150)
    debugFrame.Position = UDim2.new(1, -270, 0, 20)
    debugFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    debugFrame.BackgroundTransparency = 0.3
    debugFrame.BorderSizePixel = 0
    debugFrame.Parent = screenGui
    
    local debugCorner = Instance.new("UICorner")
    debugCorner.CornerRadius = UDim.new(0, 8)
    debugCorner.Parent = debugFrame
    
    local debugLabel = Instance.new("TextLabel")
    debugLabel.Size = UDim2.new(1, -10, 1, -10)
    debugLabel.Position = UDim2.new(0, 5, 0, 5)
    debugLabel.BackgroundTransparency = 1
    debugLabel.Text = "DEBUG MODE\nFPS: 60\nPing: 0ms\nMemory: 0MB"
    debugLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    debugLabel.TextScaled = true
    debugLabel.Font = Enum.Font.Code
    debugLabel.TextXAlignment = Enum.TextXAlignment.Left
    debugLabel.TextYAlignment = Enum.TextYAlignment.Top
    debugLabel.Parent = debugFrame
    
    -- Actualizar información de debug
    task.spawn(function()
        while screenGui.Parent do
            local fps = math.floor(1 / RunService.Heartbeat:Wait())
            local ping = player:GetNetworkPing() * 1000
            local memory = math.floor(collectgarbage("count") / 1024)
            
            debugLabel.Text = string.format(
                "DEBUG MODE\nFPS: %d\nPing: %.0fms\nMemory: %dMB\nPetals: %d",
                fps, ping, memory, #sakuraContainer:GetChildren()
            )
            
            task.wait(1)
        end
    end)
end

-- Función de limpieza automática (evita lag por demasiados pétalos)
task.spawn(function()
    while screenGui.Parent do
        task.wait(60) -- Cada minuto
        
                local petals = sakuraContainer:GetChildren()
        if #petals > 50 then -- Si hay más de 50 pétalos
            -- Eliminar los pétalos más antiguos
            for i = 1, math.min(20, #petals - 30) do
                if petals[i] and petals[i]:IsA("TextLabel") then
                    local fadeTween = TweenService:Create(petals[i],
                        TweenInfo.new(1, Enum.EasingStyle.Sine),
                        {TextTransparency = 1}
                    )
                    fadeTween:Play()
                    fadeTween.Completed:Connect(function()
                        if petals[i] then
                            petals[i]:Destroy()
                        end
                    end)
                end
            end
        end
    end
end)

-- Sistema de temas (día/noche)
local currentTheme = "day"
local function switchTheme()
    if currentTheme == "day" then
        currentTheme = "night"
        -- Tema nocturno
        local nightTween1 = TweenService:Create(backgroundGradient,
            TweenInfo.new(2, Enum.EasingStyle.Sine),
            {
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 112)),
                    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(72, 61, 139)),
                    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(123, 104, 238)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 112, 219))
                }
            }
        )
        nightTween1:Play()
        
        showNotification("🌙 Night theme activated", Color3.fromRGB(72, 61, 139), 2)
    else
        currentTheme = "day"
        -- Tema diurno (original)
        local dayTween1 = TweenService:Create(backgroundGradient,
            TweenInfo.new(2, Enum.EasingStyle.Sine),
            {
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 238, 248)),
                    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(248, 215, 218)),
                    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 179, 217)),
                    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(230, 179, 255)),
                    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(212, 197, 249)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 240, 255))
                }
            }
        )
        dayTween1:Play()
        
        showNotification("☀️ Day theme activated", Color3.fromRGB(255, 182, 193), 2)
    end
end

-- Cambiar tema cada 2 minutos
task.spawn(function()
    while screenGui.Parent do
        task.wait(120) -- 2 minutos
        switchTheme()
    end
end)

-- Botón oculto para cambiar tema manualmente (click en el título 5 veces rápido)
local titleClickCount = 0
local titleClickResetTime = 0

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local currentTime = tick()
        
        if currentTime - titleClickResetTime > 3 then
            titleClickCount = 0
        end
        
        titleClickCount = titleClickCount + 1
        titleClickResetTime = currentTime
        
        if titleClickCount >= 5 then
            titleClickCount = 0
            switchTheme()
            
            -- Efecto especial
            for i = 1, 15 do
                task.spawn(function()
                    task.wait(i * 0.03)
                    createSakuraPetal()
                end)
            end
        end
    end
end)

-- Sistema de easter eggs
local konamiCode = {
    Enum.KeyCode.Up, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Down,
    Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.Left, Enum.KeyCode.Right,
    Enum.KeyCode.B, Enum.KeyCode.A
}
local konamiProgress = 1

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == konamiCode[konamiProgress] then
            konamiProgress = konamiProgress + 1
            if konamiProgress > #konamiCode then
                -- Código Konami completado!
                konamiProgress = 1
                
                -- Efecto especial masivo
                for i = 1, 100 do
                    task.spawn(function()
                        task.wait(i * 0.01)
                        createSakuraPetal()
                    end)
                end
                
                showNotification("🎉 KONAMI CODE ACTIVATED! 🎉", Color3.fromRGB(255, 215, 0), 5)
                
                -- Cambiar temporalmente todos los colores a dorado
                local goldTween = TweenService:Create(backgroundGradient,
                    TweenInfo.new(1, Enum.EasingStyle.Sine),
                    {
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 223, 0)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 235, 59))
                        }
                    }
                )
                goldTween:Play()
                
                -- Restaurar después de 10 segundos
                task.wait(10)
                switchTheme() -- Volver al tema actual
            end
        else
            konamiProgress = 1
        end
    end
end)

-- Función de captura de pantalla (tecla F12)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F12 then
        showNotification("📸 Screenshot effect activated!", Color3.fromRGB(52, 152, 219), 2)
        
        -- Efecto de flash
        local flashFrame = Instance.new("Frame")
        flashFrame.Name = "ScreenshotFlash"
        flashFrame.Size = UDim2.new(1, 0, 1, 0)
        flashFrame.Position = UDim2.new(0, 0, 0, 0)
        flashFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        flashFrame.BorderSizePixel = 0
        flashFrame.Parent = screenGui
        
        local flashTween = TweenService:Create(flashFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Sine),
            {BackgroundTransparency = 1}
        )
        flashTween:Play()
        
        flashTween.Completed:Connect(function()
            flashFrame:Destroy()
        end)
        
        -- Crear pétalos especiales
        for i = 1, 20 do
            task.spawn(function()
                task.wait(i * 0.02)
                createSakuraPetal()
            end)
        end
    end
end)

-- Sistema de música ambiente (opcional)
local ambientMusic = Instance.new("Sound")
ambientMusic.Name = "AmbientMusic"
ambientMusic.SoundId = "rbxasset://sounds/ambient_wind.mp3" -- Sonido suave de viento
ambientMusic.Volume = 0.1
ambientMusic.Looped = true
ambientMusic.Parent = workspace

-- Controlar música con tecla M
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        if ambientMusic.IsPlaying then
            ambientMusic:Stop()
            showNotification("🔇 Music disabled", Color3.fromRGB(231, 76, 60), 2)
        else
            ambientMusic:Play()
            showNotification("🎵 Music enabled", Color3.fromRGB(46, 204, 113), 2)
        end
    end
end)

-- Iniciar música ambiente
ambientMusic:Play()

-- Función de información del sistema (tecla I)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.I then
        local infoText = string.format(
            "🌸 STEAL A BRAINROT - SAKURA PANEL 🌸\n\n" ..
            "👤 User: %s (@%s)\n" ..
            "🆔 ID: %s\n" ..
            "📅 Account Age: %d days\n" ..
            "⭐ Status: %s\n" ..
            "🌍 Country: %s\n" ..
            "⏰ Panel Active: %s\n\n" ..
            "🎮 Controls:\n" ..
            "ESC - Close panel\n" ..
            "M - Toggle music\n" ..
            "F12 - Screenshot effect\n" ..
            "I - Show this info\n" ..
            "Double-click title - Minimize/Maximize",
            player.Name, player.DisplayName, tostring(player.UserId),
            player.AccountAge, playerStatus, playerCountry,
            statsLabel.Text:match("(%d+:%d+)")
        )
        
        showNotification(infoText, Color3.fromRGB(52, 152, 219), 8)
    end
end)

-- Efecto de partículas en los bordes de los paneles
local function createBorderParticle(panel)
    local particle = Instance.new("Frame")
    particle.Name = "BorderParticle"
    particle.Size = UDim2.new(0, 4, 0, 4)
    particle.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    particle.BorderSizePixel = 0
    particle.Parent = panel
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(0.5, 0)
    particleCorner.Parent = particle
    
    -- Posición aleatoria en el borde
    local side = math.random(1, 4)
    if side == 1 then -- Top
        particle.Position = UDim2.new(math.random(), 0, 0, 0)
    elseif side == 2 then -- Right
        particle.Position = UDim2.new(1, 0, math.random(), 0)
    elseif side == 3 then -- Bottom
        particle.Position = UDim2.new(math.random(), 0, 1, 0)
    else -- Left
        particle.Position = UDim2.new(0, 0, math.random(), 0)
    end
    
    -- Animación de movimiento por el borde
    local moveTween = TweenService:Create(particle,
        TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Linear),
        {BackgroundTransparency = 1}
    )
    moveTween:Play()
    
    moveTween.Completed:Connect(function()
        particle:Destroy()
    end)
end

-- Generar partículas en los bordes ocasionalmente
task.spawn(function()
    while screenGui.Parent do
        if math.random() > 0.95 then
            local panels = {mainPanel, statusPanel, playerInfoPanel}
            local randomPanel = panels[math.random(1, #panels)]
            createBorderParticle(randomPanel)
        end
        task.wait(0.1)
    end
end)

-- Mensaje final de carga
task.spawn(function()
    task.wait(1)
    showNotification("✨ Sakura Panel fully loaded! ✨", Color3.fromRGB(147, 112, 219), 3)
    
    -- Crear efecto de carga completada
    for i = 1, 30 do
        task.spawn(function()
            task.wait(i * 0.02)
            createSakuraPetal()
        end)
    end
end)

-- Sistema de auto-guardado de configuración (simulado)
local config = {
    theme = currentTheme,
    musicEnabled = ambientMusic.IsPlaying,
    lastUsed = os.time()
}

-- Guardar configuración cada 30 segundos
task.spawn(function()
    while screenGui.Parent do
        task.wait(30)
        config.theme = currentTheme
        config.musicEnabled = ambientMusic.IsPlaying
        config.lastUsed = os.time()
        -- En un script real, aquí guardarías en DataStore
    end
end)

-- Función de limpieza al cerrar
local function cleanup()
    if ambientMusic then
        ambientMusic:Stop()
        ambientMusic:Destroy()
    end
    
    if petalConnection then
        petalConnection:Disconnect()
    end
    
    -- Limpiar todas las conexiones y tweens activos
    for _, obj in pairs(screenGui:GetDescendants()) do
        if obj:IsA("GuiObject") then
            -- Cancelar todos los tweens activos
            TweenService:GetTweensOfObject(obj):ForEach(function(tween)
                tween:Cancel()
            end)
        end
    end
end

-- Conectar limpieza al evento de destrucción
screenGui.AncestryChanged:Connect(function()
    if not screenGui.Parent then
        cleanup()
    end
end)

-- Función de emergencia para cerrar (Ctrl + Alt + X)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.X and 
           UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 
           UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
            
            showNotification("🚨 Emergency shutdown activated!", Color3.fromRGB(231, 76, 60), 2)
            
            task.wait(1)
            cleanup()
            screenGui:Destroy()
        end
    end
end)

-- Efecto de respiración en el título principal
local breatheTween = TweenService:Create(titleLabel,
    TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {TextTransparency = 0.1}
)
breatheTween:Play()

-- Rotación suave del gradiente del fondo
local backgroundRotationTween = TweenService:Create(backgroundGradient,
    TweenInfo.new(20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Rotation = 360}
)
backgroundRotationTween:Play()

-- Sistema de logros (easter eggs)
local achievements = {
    {name = "First Click", description = "Click any button for the first time", unlocked = false},
    {name = "Key Master", description = "Submit a key successfully", unlocked = false},
    {name = "Theme Switcher", description = "Change theme manually", unlocked = false},
    {name = "Konami Warrior", description = "Enter the Konami code", unlocked = false},
    {name = "Music Lover", description = "Toggle music on/off", unlocked = false},
    {name = "Info Seeker", description = "Check system information", unlocked = false},
    {name = "Screenshot Artist", description = "Use screenshot effect", unlocked = false},
    {name = "Panel Master", description = "Keep panel open for 5 minutes", unlocked = false}
}

local function unlockAchievement(achievementName)
    for _, achievement in pairs(achievements) do
        if achievement.name == achievementName and not achievement.unlocked then
            achievement.unlocked = true
            showNotification("🏆 Achievement Unlocked: " .. achievementName, Color3.fromRGB(255, 215, 0), 4)
            
            -- Efecto especial para logros
            for i = 1, 12 do
                task.spawn(function()
                    task.wait(i * 0.05)
                    createSakuraPetal()
                end)
            end
            break
        end
    end
end

-- Conectar logros a eventos
getKeyButton.MouseButton1Click:Connect(function()
    unlockAchievement("First Click")
end)

submitButton.MouseButton1Click:Connect(function()
    unlockAchievement("First Click")
    if keyInput.Text:match("^%s*(.-)%s*$") ~= "" then
        unlockAchievement("Key Master")
    end
end)

-- Logro de tiempo (5 minutos)
task.spawn(function()
    task.wait(300) -- 5 minutos
    if screenGui.Parent then
        unlockAchievement("Panel Master")
    end
end)

-- Contador de pétalos creados (para estadísticas)
local petalCount = 0
local originalCreateSakuraPetal = createSakuraPetal

createSakuraPetal = function()
    petalCount = petalCount + 1
    return originalCreateSakuraPetal()
end

-- Mostrar estadísticas finales al cerrar (si el debug está activado)
if debugMode then
    screenGui.AncestryChanged:Connect(function()
        if not screenGui.Parent then
            print("🌸 SAKURA PANEL STATISTICS 🌸")
            print("Total petals created:", petalCount)
            print("Session duration:", math.floor(tick() - startTime), "seconds")
            print("Achievements unlocked:", #achievements)
            print("Final theme:", currentTheme)
            print("Music was enabled:", config.musicEnabled)
        end
    end)
end

-- Mensaje de despedida cuando se cierra
screenGui.AncestryChanged:Connect(function()
    if not screenGui.Parent then
        -- Crear un último mensaje flotante
        local farewellGui = Instance.new("ScreenGui")
        farewellGui.Name = "FarewellMessage"
        farewellGui.Parent = playerGui
        
        local farewellLabel = Instance.new("TextLabel")
        farewellLabel.Size = UDim2.new(0, 400, 0, 100)
        farewellLabel.Position = UDim2.new(0.5, -200, 0.5, -50)
        farewellLabel.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
        farewellLabel.BackgroundTransparency = 0.1
        farewellLabel.BorderSizePixel = 0
        farewellLabel.Text = "🌸 Thanks for using Sakura Panel! 🌸\nSayonara! ✨"
        farewellLabel.TextColor3 = Color3.fromRGB(139, 90, 140)
        farewellLabel.TextScaled = true
        farewellLabel.Font = Enum.Font.GothamBold
        farewellLabel.Parent = farewellGui
        
        local farewellCorner = Instance.new("UICorner")
        farewellCorner.CornerRadius = UDim.new(0, 15)
        farewellCorner.Parent = farewellLabel
        
        -- Animación de despedida
        local farewellTween = TweenService:Create(farewellLabel,
            TweenInfo.new(3, Enum.EasingStyle.Sine),
            {
                Position = UDim2.new(0.5, -200, -0.2, -50),
                TextTransparency = 1,
                BackgroundTransparency = 1
            }
        )
        farewellTween:Play()
        
        farewellTween.Completed:Connect(function()
            farewellGui:Destroy()
        end)
    end
end)

-- Función de ayuda (tecla H)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.H then
        unlockAchievement("Info Seeker")
        
        local helpText = "🌸 SAKURA PANEL HELP 🌸\n\n" ..
                        "📋 INSTRUCTIONS:\n" ..
                        "1. Click 'Get Key!' to copy the link\n" ..
                        "2. Visit the link to get your key\n" ..
                        "3. Paste the key in the input box\n" ..
                        "4. Click 'SUBMIT KEY' to activate\n\n" ..
                        "🎮 SHORTCUTS:\n" ..
                        "ESC - Close panel\n" ..
                        "M - Toggle music\n" ..
                        "F12 - Screenshot effect\n" ..
                        "I - System info\n" ..
                        "H - This help\n" ..
                        "Ctrl+Alt+X - Emergency close\n\n" ..
                        "🎯 EASTER EGGS:\n" ..
                        "• Double-click title to minimize\n" ..
                        "• Click title 5 times for theme change\n" ..
                        "• Try the Konami code! ⬆⬆⬇⬇⬅➡⬅➡BA"
        
        showNotification(helpText, Color3.fromRGB(52, 152, 219), 10)
    end
end)

print("🌸 Sakura Brainrot Panel loaded successfully! 🌸")
print("📝 Script by: Sakura Development Team")
print("🔗 Get your key at: https://zamasxmodder.github.io/SakurasCriptTRAIL/")
print("💡 Press H for help, ESC to close")
