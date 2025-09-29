-- Steal A Brainrot - Enhanced Sakura Panel GUI for Roblox with User Info Panel
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

-- NUEVO: Panel de información del usuario (lado derecho)
local userInfoPanel = Instance.new("Frame")
userInfoPanel.Name = "UserInfoPanel"
userInfoPanel.Size = UDim2.new(0, 300, 0, 450)
userInfoPanel.Position = UDim2.new(1, -330, 0.5, -225)
userInfoPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
userInfoPanel.BackgroundTransparency = 0.85
userInfoPanel.BorderSizePixel = 0
userInfoPanel.Parent = screenGui

-- Corner radius para el panel de usuario
local userInfoCorner = Instance.new("UICorner")
userInfoCorner.CornerRadius = UDim.new(0, 20)
userInfoCorner.Parent = userInfoPanel

-- Borde del panel de usuario
local userInfoStroke = Instance.new("UIStroke")
userInfoStroke.Color = Color3.fromRGB(255, 105, 180)
userInfoStroke.Thickness = 2
userInfoStroke.Transparency = 0.6
userInfoStroke.Parent = userInfoPanel

-- Gradiente en el borde del panel de usuario
local userInfoStrokeGradient = Instance.new("UIGradient")
userInfoStrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 20, 147)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(218, 112, 214))
}
userInfoStrokeGradient.Parent = userInfoStroke

-- Decoración sakura en el panel de usuario
local userPanelSakura1 = Instance.new("TextLabel")
userPanelSakura1.Size = UDim2.new(0, 35, 0, 35)
userPanelSakura1.Position = UDim2.new(0, -10, 0, -10)
userPanelSakura1.BackgroundTransparency = 1
userPanelSakura1.Text = "🌸"
userPanelSakura1.TextScaled = true
userPanelSakura1.Font = Enum.Font.Gotham
userPanelSakura1.Parent = userInfoPanel

local userPanelSakura2 = Instance.new("TextLabel")
userPanelSakura2.Size = UDim2.new(0, 30, 0, 30)
userPanelSakura2.Position = UDim2.new(1, -25, 1, -25)
userPanelSakura2.BackgroundTransparency = 1
userPanelSakura2.Text = "🌺"
userPanelSakura2.TextScaled = true
userPanelSakura2.Font = Enum.Font.Gotham
userPanelSakura2.Parent = userInfoPanel

-- Animaciones de las decoraciones
local userSakura1Tween = TweenService:Create(userPanelSakura1,
    TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Rotation = 20, Position = UDim2.new(0, -5, 0, -15)}
)
userSakura1Tween:Play()

local userSakura2Tween = TweenService:Create(userPanelSakura2,
    TweenInfo.new(3.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Rotation = -15, Position = UDim2.new(1, -30, 1, -20)}
)
userSakura2Tween:Play()

-- Título del panel de usuario
local userInfoTitle = Instance.new("TextLabel")
userInfoTitle.Name = "UserInfoTitle"
userInfoTitle.Size = UDim2.new(1, -20, 0, 40)
userInfoTitle.Position = UDim2.new(0, 10, 0, 15)
userInfoTitle.BackgroundTransparency = 1
userInfoTitle.Text = "USER PROFILE"
userInfoTitle.TextColor3 = Color3.fromRGB(255, 20, 147)
userInfoTitle.TextScaled = true
userInfoTitle.Font = Enum.Font.GothamBold
userInfoTitle.Parent = userInfoPanel

-- Gradiente del título de usuario
local userInfoTitleGradient = Instance.new("UIGradient")
userInfoTitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(218, 112, 214))
}
userInfoTitleGradient.Rotation = 45
userInfoTitleGradient.Parent = userInfoTitle

-- Foto de perfil circular
local profileImageFrame = Instance.new("Frame")
profileImageFrame.Name = "ProfileImageFrame"
profileImageFrame.Size = UDim2.new(0, 100, 0, 100)
profileImageFrame.Position = UDim2.new(0.5, -50, 0, 70)
profileImageFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
profileImageFrame.BorderSizePixel = 0
profileImageFrame.Parent = userInfoPanel

-- Hacer la foto circular
local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0.5, 0)
profileCorner.Parent = profileImageFrame

-- Borde de la foto de perfil
local profileStroke = Instance.new("UIStroke")
profileStroke.Color = Color3.fromRGB(255, 105, 180)
profileStroke.Thickness = 4
profileStroke.Transparency = 0.3
profileStroke.Parent = profileImageFrame

-- Imagen de perfil (headshot del jugador)
local profileImage = Instance.new("ImageLabel")
profileImage.Name = "ProfileImage"
profileImage.Size = UDim2.new(1, -8, 1, -8)
profileImage.Position = UDim2.new(0, 4, 0, 4)
profileImage.BackgroundTransparency = 1
profileImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
profileImage.Parent = profileImageFrame

-- Hacer la imagen circular también
local profileImageCorner = Instance.new("UICorner")
profileImageCorner.CornerRadius = UDim.new(0.5, 0)
profileImageCorner.Parent = profileImage

-- Animación de pulso en el borde de la foto
local profilePulseTween = TweenService:Create(profileStroke,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Thickness = 6, Transparency = 0.1}
)
profilePulseTween:Play()

-- Nombre de usuario
local usernameDisplay = Instance.new("TextLabel")
usernameDisplay.Name = "UsernameDisplay"
usernameDisplay.Size = UDim2.new(1, -20, 0, 35)
usernameDisplay.Position = UDim2.new(0, 10, 0, 185)
usernameDisplay.BackgroundTransparency = 1
usernameDisplay.Text = "👤 " .. player.DisplayName .. " (@" .. player.Name .. ")"
usernameDisplay.TextColor3 = Color3.fromRGB(139, 90, 140)
usernameDisplay.TextScaled = true
usernameDisplay.Font = Enum.Font.GothamMedium
usernameDisplay.Parent = userInfoPanel

-- Estado online con indicador
local onlineStatusFrame = Instance.new("Frame")
onlineStatusFrame.Name = "OnlineStatusFrame"
onlineStatusFrame.Size = UDim2.new(1, -40, 0, 30)
onlineStatusFrame.Position = UDim2.new(0, 20, 0, 230)
onlineStatusFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
onlineStatusFrame.BackgroundTransparency = 0.9
onlineStatusFrame.BorderSizePixel = 0
onlineStatusFrame.Parent = userInfoPanel

local onlineStatusCorner = Instance.new("UICorner")
onlineStatusCorner.CornerRadius = UDim.new(0, 10)
onlineStatusCorner.Parent = onlineStatusFrame

-- Indicador de estado online
local onlineIndicator = Instance.new("Frame")
onlineIndicator.Name = "OnlineIndicator"
onlineIndicator.Size = UDim2.new(0, 15, 0, 15)
onlineIndicator.Position = UDim2.new(0, 10, 0.5, -7.5)
onlineIndicator.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
onlineIndicator.BorderSizePixel = 0
onlineIndicator.Parent = onlineStatusFrame

local onlineIndicatorCorner = Instance.new("UICorner")
onlineIndicatorCorner.CornerRadius = UDim.new(0.5, 0)
onlineIndicatorCorner.Parent = onlineIndicator

-- Pulso del indicador online
local onlinePulseTween = TweenService:Create(onlineIndicator,
    TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {BackgroundColor3 = Color3.fromRGB(39, 174, 96), Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 8.5, 0.5, -9)}
)
onlinePulseTween:Play()

-- Texto del estado
local onlineStatusText = Instance.new("TextLabel")
onlineStatusText.Name = "OnlineStatusText"
onlineStatusText.Size = UDim2.new(1, -40, 1, 0)
onlineStatusText.Position = UDim2.new(0, 35, 0, 0)
onlineStatusText.BackgroundTransparency = 1
onlineStatusText.Text = "ONLINE • Active now"
onlineStatusText.TextColor3 = Color3.fromRGB(46, 204, 113)
onlineStatusText.TextScaled = true
onlineStatusText.Font = Enum.Font.GothamMedium
onlineStatusText.TextXAlignment = Enum.TextXAlignment.Left
onlineStatusText.Parent = onlineStatusFrame

-- Panel de información adicional
local infoContainer = Instance.new("Frame")
infoContainer.Name = "InfoContainer"
infoContainer.Size = UDim2.new(1, -40, 0, 150)
infoContainer.Position = UDim2.new(0, 20, 0, 275)
infoContainer.BackgroundTransparency = 1
infoContainer.Parent = userInfoPanel

-- Layout para la información
local infoLayout = Instance.new("UIListLayout")
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
infoLayout.Padding = UDim.new(0, 8)
infoLayout.Parent = infoContainer

-- Función para obtener información del país (simulada)
local function getCountryInfo()
    local countries = {
        {flag = "🇺🇸", name = "United States", code = "US"},
        {flag = "🇲🇽", name = "Mexico", code = "MX"},
        {flag = "🇨🇴", name = "Colombia", code = "CO"},
        {flag = "🇧🇷", name = "Brazil", code = "BR"},
        {flag = "🇦🇷", name = "Argentina", code = "AR"},
        {flag = "🇪🇸", name = "Spain", code = "ES"},
        {flag = "🇫🇷", name = "France", code = "FR"},
        {flag = "🇩🇪", name = "Germany", code = "DE"},
        {flag = "🇬🇧", name = "United Kingdom", code = "UK"},
        {flag = "🇨🇦", name = "Canada", code = "CA"}
    }
    return countries[math.random(1, #countries)]
end

-- Función para obtener estadísticas del juego
local function getGameStats()
    return {
        playtime = math.random(50, 500) .. "h",
        level = math.random(1, 100),
        premium = math.random() > 0.5,
        joinDate = "2019-" .. string.format("%02d", math.random(1, 12))
    }
end

-- Función para crear elementos de información
local function createInfoElement(icon, label, value, layoutOrder)
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = label .. "Info"
    infoFrame.Size = UDim2.new(1, 0, 0, 25)
    infoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    infoFrame.BackgroundTransparency = 0.92
    infoFrame.BorderSizePixel = 0
    infoFrame.LayoutOrder = layoutOrder
    infoFrame.Parent = infoContainer
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoFrame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "IconLabel"
    iconLabel.Size = UDim2.new(0, 25, 1, 0)
    iconLabel.Position = UDim2.new(0, 5, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextScaled = true
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.Parent = infoFrame
    
    local infoText = Instance.new("TextLabel")
    infoText.Name = "InfoText"
    infoText.Size = UDim2.new(1, -35, 1, 0)
    infoText.Position = UDim2.new(0, 30, 0, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = label .. ": " .. value
    infoText.TextColor3 = Color3.fromRGB(139, 90, 140)
    infoText.TextScaled = true
    infoText.Font = Enum.Font.Gotham
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.Parent = infoFrame
    
    -- Animación de entrada
    infoFrame.Size = UDim2.new(0, 0, 0, 25)
    infoFrame.BackgroundTransparency = 1
    
    task.spawn(function()
        task.wait(layoutOrder * 0.1)
        
        local enterTween = TweenService:Create(infoFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back),
            {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 0.92}
        )
        enterTween:Play()
    end)
    
    return infoFrame
end

-- Crear elementos de información
task.spawn(function()
    local countryInfo = getCountryInfo()
    local gameStats = getGameStats()
    
    createInfoElement("🌍", "Country", countryInfo.flag .. " " .. countryInfo.name, 1)
    createInfoElement("⏱️", "Playtime", gameStats.playtime, 2)
    createInfoElement("🎯", "Level", tostring(gameStats.level), 3)
    createInfoElement("💎", "Premium", gameStats.premium and "Yes ✨" or "No", 4)
    createInfoElement("📅", "Joined", gameStats.joinDate, 5)
end)

-- Botón de configuración en el panel de usuario
local configButton = Instance.new("TextButton")
configButton.Name = "ConfigButton"
configButton.Size = UDim2.new(1, -40, 0, 35)
configButton.Position = UDim2.new(0, 20, 1, -50)
configButton.BackgroundColor3 = Color3.fromRGB(186, 85, 211)
configButton.BorderSizePixel = 0
configButton.Text = "⚙️ Settings"
configButton.TextColor3 = Color3.fromRGB(255, 255, 255)
configButton.TextScaled = true
configButton.Font = Enum.Font.GothamMedium
configButton.Parent = userInfoPanel

local configButtonCorner = Instance.new("UICorner")
configButtonCorner.CornerRadius = UDim.new(0, 10)
configButtonCorner.Parent = configButton

-- Gradiente del botón de configuración
local configButtonGradient = Instance.new("UIGradient")
configButtonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 85, 211)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(147, 112, 219)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
}
configButtonGradient.Rotation = 45
configButtonGradient.Parent = configButton

-- Efectos del botón de configuración
configButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(configButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -30, 0, 40)}
    )
    hoverTween:Play()
end)

configButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(configButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -40, 0, 35)}
    )
    leaveTween:Play()
end)

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

-- Panel principal con escalado automático (centrado entre los dos paneles)
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 450, 0, 480)
mainPanel.Position = UDim2.new(0.5, -225, 0.5, -240)
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

-- Animación flotante del panel de usuario
local function animateUserPanel()
    local floatTween = TweenService:Create(userInfoPanel,
        TweenInfo.new(6.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {
            Position = UDim2.new(1, -340, 0.5, -235),
            Rotation = math.random(-1, 1)
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
    
    -- Panel principal (centrado)
    mainPanel.Size = UDim2.new(0, 450 * scale, 0, 480 * scale)
    mainPanel.Position = UDim2.new(0.5, -225 * scale, 0.5, -240 * scale)
    
    -- Panel de status (izquierda)
    statusPanel.Size = UDim2.new(0, 280 * scale, 0, 420 * scale)
    statusPanel.Position = UDim2.new(0, 30 * scale, 0.5, -210 * scale)
    
    -- Panel de usuario (derecha)
    userInfoPanel.Size = UDim2.new(0, 300 * scale, 0, 450 * scale)
    userInfoPanel.Position = UDim2.new(1, -330 * scale, 0.5, -225 * scale)
end

-- Conectar el redimensionamiento
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updatePanelSize)
updatePanelSize() -- Aplicar al inicio

-- Iniciar animaciones
animateMainPanel()
animateUserPanel()

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

-- Efecto especial al hacer hover sobre la foto de perfil
profileImageFrame.MouseEnter:Connect(function()
    -- Crear explosión de pétalos desde la foto de perfil
    createSakuraExplosion(UDim2.new(1, -165, 0.5, -155)) -- Posición relativa a la pantalla
    
    -- Efecto de zoom en la foto
    local zoomTween = TweenService:Create(profileImageFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(0, 110, 0, 110)}
    )
    zoomTween:Play()
end)

profileImageFrame.MouseLeave:Connect(function()
    local normalTween = TweenService:Create(profileImageFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(0, 100, 0, 100)}
    )
    normalTween:Play()
end)

-- Función para actualizar información del usuario dinámicamente
local function updateUserInfo()
    -- Simular cambios en la información
    local newCountryInfo = getCountryInfo()
    local newGameStats = getGameStats()
    
    -- Encontrar y actualizar los elementos de información
    for _, child in pairs(infoContainer:GetChildren()) do
        if child:IsA("Frame") then
            local infoText = child:FindFirstChild("InfoText")
            if infoText then
                if child.Name:find("Country") then
                    infoText.Text = "Country: " .. newCountryInfo.flag .. " " .. newCountryInfo.name
                elseif child.Name:find("Playtime") then
                    infoText.Text = "Playtime: " .. newGameStats.playtime
                elseif child.Name:find("Level") then
                    infoText.Text = "Level: " .. tostring(newGameStats.level)
                elseif child.Name:find("Premium") then
                    infoText.Text = "Premium: " .. (newGameStats.premium and "Yes ✨" or "No")
                end
            end
        end
    end
end

-- Actualizar información del usuario cada 2 minutos
local userInfoUpdateConnection
userInfoUpdateConnection = task.spawn(function()
    while screenGui.Parent do
        task.wait(120) -- 2 minutos
        if screenGui.Parent then
            updateUserInfo()
        end
    end
end)

-- Función del botón de configuración
configButton.MouseButton1Click:Connect(function()
    -- Efecto de click
    local clickTween = TweenService:Create(configButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -50, 0, 30)}
    )
    clickTween:Play()
    
    clickTween.Completed:Connect(function()
        local releaseTween = TweenService:Create(configButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Back),
            {Size = UDim2.new(1, -40, 0, 35)}
        )
        releaseTween:Play()
    end)
    
    -- Crear efecto especial desde el botón
    createSakuraExplosion(UDim2.new(1, -165, 1, -32)) -- Posición del botón
    
    -- Aquí puedes agregar tu lógica para abrir configuraciones
    print("🌸 Settings button clicked!")
end)

-- Función para mostrar notificaciones en el panel de usuario
local function showUserNotification(text, color)
    local notification = Instance.new("Frame")
    notification.Name = "UserNotification"
    notification.Size = UDim2.new(1, -20, 0, 40)
    notification.Position = UDim2.new(0, 10, 0, -50)
    notification.BackgroundColor3 = color or Color3.fromRGB(255, 240, 245)
    notification.BorderSizePixel = 0
    notification.Parent = userInfoPanel
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 12)
    notificationCorner.Parent = notification
    
    local notificationStroke = Instance.new("UIStroke")
    notificationStroke.Color = Color3.fromRGB(255, 105, 180)
    notificationStroke.Thickness = 1
    notificationStroke.Transparency = 0.5
    notificationStroke.Parent = notification
    
    local notificationText = Instance.new("TextLabel")
    notificationText.Size = UDim2.new(1, -20, 1, -10)
    notificationText.Position = UDim2.new(0, 10, 0, 5)
    notificationText.BackgroundTransparency = 1
    notificationText.Text = text
    notificationText.TextColor3 = Color3.fromRGB(139, 90, 140)
    notificationText.TextScaled = true
    notificationText.Font = Enum.Font.GothamMedium
    notificationText.Parent = notification
    
    -- Animación de entrada
    notification.Size = UDim2.new(0, 0, 0, 40)
    local showNotificationTween = TweenService:Create(notification,
        TweenInfo.new(0.4, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -20, 0, 40)}
    )
    showNotificationTween:Play()
    
    -- Auto-ocultar después de 3 segundos
    task.spawn(function()
        task.wait(3)
        local hideNotificationTween = TweenService:Create(notification,
            TweenInfo.new(0.3, Enum.EasingStyle.Back),
            {Size = UDim2.new(0, 0, 0, 40), Position = UDim2.new(0, 10, 0, -50)}
        )
        hideNotificationTween:Play()
        
        hideNotificationTween.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- Mostrar notificación de bienvenida
task.spawn(function()
    task.wait(2)
    showUserNotification("🌸 Welcome to Sakura Panel! 🌸", Color3.fromRGB(255, 240, 245))
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
    StatusPanel = statusPanel,
    UserInfoPanel = userInfoPanel,
    ShowUserNotification = showUserNotification,
    UpdateUserInfo = updateUserInfo
}
