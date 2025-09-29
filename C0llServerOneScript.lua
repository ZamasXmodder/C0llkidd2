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
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- VERIFICACIÓN DE CUENTA (Mínimo 5 días)
local accountAge = player.AccountAge
local minimumDays = 5
local hasAccess = accountAge >= minimumDays

-- Frame de fondo completo
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

-- Decoraciones sakura flotantes
local function createFloatingSakura(position, emoji)
    local sakura = Instance.new("TextLabel")
    sakura.Size = UDim2.new(0, 40, 0, 40)
    sakura.Position = position
    sakura.BackgroundTransparency = 1
    sakura.Text = emoji
    sakura.TextScaled = true
    sakura.Font = Enum.Font.Gotham
    sakura.Parent = backgroundFrame
    
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

createFloatingSakura(UDim2.new(0.05, 0, 0.1, 0), "🌸")
createFloatingSakura(UDim2.new(0.9, 0, 0.15, 0), "🌺")
createFloatingSakura(UDim2.new(0.1, 0, 0.8, 0), "🌸")
createFloatingSakura(UDim2.new(0.85, 0, 0.75, 0), "🌺")
createFloatingSakura(UDim2.new(0.15, 0, 0.3, 0), "🌸")
createFloatingSakura(UDim2.new(0.8, 0, 0.4, 0), "🌺")

-- SI NO TIENE ACCESO, MOSTRAR MENSAJE DE DENEGACIÓN
if not hasAccess then
    local deniedFrame = Instance.new("Frame")
    deniedFrame.Name = "AccessDenied"
    deniedFrame.Size = UDim2.new(0, 500, 0, 300)
    deniedFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    deniedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    deniedFrame.BorderSizePixel = 0
    deniedFrame.Parent = screenGui
    
    local deniedCorner = Instance.new("UICorner")
    deniedCorner.CornerRadius = UDim.new(0, 25)
    deniedCorner.Parent = deniedFrame
    
    local deniedStroke = Instance.new("UIStroke")
    deniedStroke.Color = Color3.fromRGB(231, 76, 60)
    deniedStroke.Thickness = 4
    deniedStroke.Parent = deniedFrame
    
    local warningIcon = Instance.new("TextLabel")
    warningIcon.Size = UDim2.new(0, 80, 0, 80)
    warningIcon.Position = UDim2.new(0.5, -40, 0, 30)
    warningIcon.BackgroundTransparency = 1
    warningIcon.Text = "⚠️"
    warningIcon.TextScaled = true
    warningIcon.Font = Enum.Font.GothamBold
    warningIcon.Parent = deniedFrame
    
    local deniedTitle = Instance.new("TextLabel")
    deniedTitle.Size = UDim2.new(1, -40, 0, 50)
    deniedTitle.Position = UDim2.new(0, 20, 0, 120)
    deniedTitle.BackgroundTransparency = 1
    deniedTitle.Text = "NO TIENES ACCESO AUTORIZADO"
    deniedTitle.TextColor3 = Color3.fromRGB(231, 76, 60)
    deniedTitle.TextScaled = true
    deniedTitle.Font = Enum.Font.GothamBold
    deniedTitle.Parent = deniedFrame
    
    local deniedSubtext = Instance.new("TextLabel")
    deniedSubtext.Size = UDim2.new(1, -40, 0, 80)
    deniedSubtext.Position = UDim2.new(0, 20, 0, 180)
    deniedSubtext.BackgroundTransparency = 1
    deniedSubtext.Text = "(ACCOUNT NOT AUTHORIZED)\n\nTu cuenta debe tener al menos " .. minimumDays .. " días.\nActualmente: " .. accountAge .. " días"
    deniedSubtext.TextColor3 = Color3.fromRGB(200, 200, 200)
    deniedSubtext.TextScaled = true
    deniedSubtext.Font = Enum.Font.Gotham
    deniedSubtext.TextWrapped = true
    deniedSubtext.Parent = deniedFrame
    
    -- Animación de pulso
    local pulseTween = TweenService:Create(deniedStroke,
        TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Thickness = 6, Color = Color3.fromRGB(255, 100, 100)}
    )
    pulseTween:Play()
    
    return -- Detener la ejecución si no tiene acceso
end

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

-- Panel de status (lado izquierdo) - MÁS PEQUEÑO
local statusPanel = Instance.new("Frame")
statusPanel.Name = "StatusPanel"
statusPanel.Size = UDim2.new(0, 220, 0, 350)
statusPanel.Position = UDim2.new(0, 20, 0.5, -175)
statusPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
statusPanel.BackgroundTransparency = 0.85
statusPanel.BorderSizePixel = 0
statusPanel.Parent = screenGui

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 20)
statusCorner.Parent = statusPanel

local statusStroke = Instance.new("UIStroke")
statusStroke.Color = Color3.fromRGB(186, 85, 211)
statusStroke.Thickness = 2
statusStroke.Transparency = 0.6
statusStroke.Parent = statusPanel

local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(1, -20, 0, 40)
statusTitle.Position = UDim2.new(0, 10, 0, 10)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "ONLINE CLIENTS"
statusTitle.TextColor3 = Color3.fromRGB(147, 112, 219)
statusTitle.TextScaled = true
statusTitle.Font = Enum.Font.GothamBold
statusTitle.Parent = statusPanel

local playersScrollFrame = Instance.new("ScrollingFrame")
playersScrollFrame.Name = "PlayersScrollFrame"
playersScrollFrame.Size = UDim2.new(1, -20, 1, -60)
playersScrollFrame.Position = UDim2.new(0, 10, 0, 55)
playersScrollFrame.BackgroundTransparency = 1
playersScrollFrame.ScrollBarThickness = 4
playersScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(186, 85, 211)
playersScrollFrame.ScrollBarImageTransparency = 0.3
playersScrollFrame.BorderSizePixel = 0
playersScrollFrame.Parent = statusPanel

local playersLayout = Instance.new("UIListLayout")
playersLayout.SortOrder = Enum.SortOrder.LayoutOrder
playersLayout.Padding = UDim.new(0, 8)
playersLayout.Parent = playersScrollFrame

-- PANEL DE INFORMACIÓN DEL JUGADOR (lado derecho) - MÁS PEQUEÑO
local playerInfoPanel = Instance.new("Frame")
playerInfoPanel.Name = "PlayerInfoPanel"
playerInfoPanel.Size = UDim2.new(0, 240, 0, 400)
playerInfoPanel.Position = UDim2.new(1, -260, 0.5, -200)
playerInfoPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
playerInfoPanel.BackgroundTransparency = 0.85
playerInfoPanel.BorderSizePixel = 0
playerInfoPanel.Parent = screenGui

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 20)
infoCorner.Parent = playerInfoPanel

local infoStroke = Instance.new("UIStroke")
infoStroke.Color = Color3.fromRGB(186, 85, 211)
infoStroke.Thickness = 2
infoStroke.Transparency = 0.6
infoStroke.Parent = playerInfoPanel

-- Título del panel de info
local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.new(1, -20, 0, 35)
infoTitle.Position = UDim2.new(0, 10, 0, 8)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "YOUR PROFILE"
infoTitle.TextColor3 = Color3.fromRGB(147, 112, 219)
infoTitle.TextScaled = true
infoTitle.Font = Enum.Font.GothamBold
infoTitle.Parent = playerInfoPanel

-- Headshot del jugador - MÁS PEQUEÑO
local headshotFrame = Instance.new("Frame")
headshotFrame.Size = UDim2.new(0, 90, 0, 90)
headshotFrame.Position = UDim2.new(0.5, -45, 0, 50)
headshotFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
headshotFrame.BorderSizePixel = 0
headshotFrame.Parent = playerInfoPanel

local headshotCorner = Instance.new("UICorner")
headshotCorner.CornerRadius = UDim.new(1, 0)
headshotCorner.Parent = headshotFrame

local headshotStroke = Instance.new("UIStroke")
headshotStroke.Color = Color3.fromRGB(255, 105, 180)
headshotStroke.Thickness = 3
headshotStroke.Parent = headshotFrame

local headshot = Instance.new("ImageLabel")
headshot.Size = UDim2.new(1, -10, 1, -10)
headshot.Position = UDim2.new(0, 5, 0, 5)
headshot.BackgroundTransparency = 1
headshot.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
headshot.Parent = headshotFrame

local headshotImgCorner = Instance.new("UICorner")
headshotImgCorner.CornerRadius = UDim.new(1, 0)
headshotImgCorner.Parent = headshot

-- Container de información
local infoContainer = Instance.new("Frame")
infoContainer.Size = UDim2.new(1, -20, 0, 240)
infoContainer.Position = UDim2.new(0, 10, 0, 150)
infoContainer.BackgroundTransparency = 1
infoContainer.Parent = playerInfoPanel

local infoLayout = Instance.new("UIListLayout")
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
infoLayout.Padding = UDim.new(0, 6)
infoLayout.Parent = infoContainer

-- Función para crear info item - MÁS COMPACTO
local function createInfoItem(title, value, icon)
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(1, 0, 0, 35)
    itemFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    itemFrame.BackgroundTransparency = 0.9
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = infoContainer
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 8)
    itemCorner.Parent = itemFrame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 24, 0, 24)
    iconLabel.Position = UDim2.new(0, 8, 0.5, -12)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextScaled = true
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.Parent = itemFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 60, 1, 0)
    titleLabel.Position = UDim2.new(0, 36, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(139, 90, 140)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = itemFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, -105, 1, 0)
    valueLabel.Position = UDim2.new(0, 100, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = value
    valueLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.TextWrapped = true
    valueLabel.Parent = itemFrame
    
    return itemFrame
end

-- Obtener país simulado (Roblox no proporciona esta info directamente)
local countries = {"Colombia", "Mexico", "Spain", "Argentina", "USA", "Brazil", "Chile", "Peru"}
local playerCountry = countries[math.random(1, #countries)]

-- Crear items de información
createInfoItem("Username:", player.Name, "👤")
createInfoItem("Display:", player.DisplayName, "✨")
createInfoItem("User ID:", tostring(player.UserId), "🆔")
createInfoItem("Account:", accountAge .. " days old", "📅")
createInfoItem("Country:", playerCountry, "🌍")

-- Status del jugador - MÁS COMPACTO
local statusItem = Instance.new("Frame")
statusItem.Size = UDim2.new(1, 0, 0, 38)
statusItem.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
statusItem.BackgroundTransparency = 0.3
statusItem.BorderSizePixel = 0
statusItem.Parent = infoContainer

local statusItemCorner = Instance.new("UICorner")
statusItemCorner.CornerRadius = UDim.new(0, 8)
statusItemCorner.Parent = statusItem

local statusIcon = Instance.new("TextLabel")
statusIcon.Size = UDim2.new(0, 24, 0, 24)
statusIcon.Position = UDim2.new(0, 8, 0.5, -12)
statusIcon.BackgroundTransparency = 1
statusIcon.Text = "✅"
statusIcon.TextScaled = true
statusIcon.Font = Enum.Font.Gotham
statusIcon.Parent = statusItem

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -40, 1, 0)
statusText.Position = UDim2.new(0, 36, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "ACCESS GRANTED"
statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusText.TextScaled = true
statusText.Font = Enum.Font.GothamBold
statusText.Parent = statusItem

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
    
    if isOnline then
        local pulseTween = TweenService:Create(statusIndicator,
            TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {BackgroundColor3 = Color3.fromRGB(39, 174, 96)}
        )
        pulseTween:Play()
    end
    
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
    
    task.wait(0.4)
    
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
    
    for i, username in ipairs(selectedUsers) do
        task.spawn(function()
            task.wait(i * 0.1)
            local isOnline = math.random() > 0.3
            createPlayerElement(username, isOnline)
        end)
    end
    
    task.wait(1)
    playersScrollFrame.CanvasSize = UDim2.new(0, 0, 0, playersLayout.AbsoluteContentSize.Y + 10)
end

-- Panel principal - MÁS PEQUEÑO
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 380, 0, 400)
mainPanel.Position = UDim2.new(0.5, -190, 0.5, -200)
mainPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainPanel.BackgroundTransparency = 0.82
mainPanel.BorderSizePixel = 0
mainPanel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 25)
panelCorner.Parent = mainPanel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(255, 105, 180)
panelStroke.Thickness = 3
panelStroke.Transparency = 0.6
panelStroke.Parent = mainPanel

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

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 12)
getKeyCorner.Parent = getKeyButton

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

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 15)
inputCorner.Parent = keyInput

local inputPadding = Instance.new("UIPadding")
inputPadding.PaddingLeft = UDim.new(0, 15)
inputPadding.PaddingRight = UDim.new(0, 15)
inputPadding.Parent = keyInput

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(255, 182, 193)
inputStroke.Thickness = 2
inputStroke.Transparency = 0.7
inputStroke.Parent = keyInput

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

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 15)
buttonCorner.Parent = submitButton

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

-- Función para crear pétalos de sakura
local function createSakuraPetal()
    local petal = Instance.new("Frame")
    petal.Name = "SakuraPetal"
    petal.Size = UDim2.new(0, math.random(8, 16), 0, math.random(8, 16))
    petal.Position = UDim2.new(math.random(), 0, 0, math.random(-50, -20))
    petal.BackgroundColor3 = Color3.fromRGB(255, 179, 217)
    petal.BorderSizePixel = 0
    petal.Rotation = math.random(0, 360)
    petal.Parent = sakuraContainer
    
    local petalCorner = Instance.new("UICorner")
    petalCorner.CornerRadius = UDim.new(0, math.random(3, 8))
    petalCorner.Parent = petal
    
    local colors = {
        Color3.fromRGB(255, 179, 217), Color3.fromRGB(255, 192, 203),
        Color3.fromRGB(255, 182, 193), Color3.fromRGB(221, 160, 221),
        Color3.fromRGB(240, 230, 140), Color3.fromRGB(255, 218, 185),
        Color3.fromRGB(230, 230, 250), Color3.fromRGB(255, 240, 245)
    }
    petal.BackgroundColor3 = colors[math.random(1, #colors)]
    
    if math.random() > 0.5 then
        local petalGradient = Instance.new("UIGradient")
        petalGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, petal.BackgroundColor3),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }
        petalGradient.Rotation = math.random(0, 360)
        petalGradient.Parent = petal
    end
    
    local fallTime = math.random(8, 15)
    local fallTween = TweenService:Create(petal,
        TweenInfo.new(fallTime, Enum.EasingStyle.Linear),
        {
            Position = UDim2.new(petal.Position.X.Scale + math.random(-30, 30)/100, 0, 1.3, 0),
            Rotation = petal.Rotation + math.random(360, 720),
            BackgroundTransparency = 1
        }
    )
    
    local swayTween = TweenService:Create(petal,
        TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, math.floor(fallTime/3), true),
        {Position = UDim2.new(petal.Position.X.Scale + math.random(-10, 10)/100, 0, petal.Position.Y.Scale, 0)}
    )
    
    fallTween:Play()
    swayTween:Play()
    
    fallTween.Completed:Connect(function()
        petal:Destroy()
    end)
end

-- Función para crear efectos especiales
local function createSpecialEffect()
    for i = 1, 35 do
        task.spawn(function()
            task.wait(i * 0.03)
            createSakuraPetal()
        end)
    end
    
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

-- Generar pétalos continuamente
local petalConnection
petalConnection = RunService.Heartbeat:Connect(function()
    if math.random() > 0.94 then
        createSakuraPetal()
    end
end)

-- Efectos del Get Key Button
getKeyButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(getKeyButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -30, 0, 50), BackgroundColor3 = Color3.fromRGB(128, 0, 128)}
    )
    hoverTween:Play()
end)

getKeyButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(getKeyButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -40, 0, 45), BackgroundColor3 = Color3.fromRGB(138, 43, 226)}
    )
    leaveTween:Play()
end)

-- Función del botón Get Key
getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://zamasxmodder.github.io/SakurasCriptTRAIL/")
    
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
    
    getKeyToast.Visible = true
    getKeyToast.Position = UDim2.new(0.5, -200, 0, -100)
    
    local showToastTween = TweenService:Create(getKeyToast,
        TweenInfo.new(0.5, Enum.EasingStyle.Back),
        {Position = UDim2.new(0.5, -200, 0, 50)}
    )
    showToastTween:Play()
    
    for i = 1, 8 do
        task.wait(0.1)
        createSakuraPetal()
    end
    
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

keyInput:GetPropertyChangedSignal("Text"):Connect(function()
    if #keyInput.Text > 0 and math.random() > 0.6 then
        createSakuraPetal()
    end
end)

-- Efectos del botón Submit
submitButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(submitButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -30, 0, 60), BackgroundColor3 = Color3.fromRGB(255, 0, 128)}
    )
    hoverTween:Play()
end)

submitButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(submitButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -40, 0, 55), BackgroundColor3 = Color3.fromRGB(255, 20, 147)}
    )
    leaveTween:Play()
end)

-- Función del botón submit
submitButton.MouseButton1Click:Connect(function()
    local key = keyInput.Text:match("^%s*(.-)%s*$")
    
    if key and key ~= "" then
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
        
        createSpecialEffect()
        
        successMessage.Visible = true
        successMessage.Size = UDim2.new(0, 0, 0, 0)
        
        local showTween = TweenService:Create(successMessage,
            TweenInfo.new(0.5, Enum.EasingStyle.Back),
            {Size = UDim2.new(0, 380, 0, 90)}
        )
        showTween:Play()
        
        task.wait(0.3)
        keyInput.Text = ""
        keyInput.PlaceholderText = '"' .. key .. '" - Key registered! ✨'
        
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
        
        print("🌸 Key submitted:", key)
    end
end)

-- Animación flotante de paneles
local function animatePanels()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isMobile = screenSize.X < 800
    
    if not isMobile then
        -- Solo animar en PC/Tablet
        local mainTween = TweenService:Create(mainPanel,
            TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Position = UDim2.new(0.5, -190, 0.5, -210), Rotation = math.random(-1, 1)}
        )
        mainTween:Play()
        
        local statusTween = TweenService:Create(statusPanel,
            TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Position = UDim2.new(0, 20, 0.5, -185), Rotation = math.random(-1, 1)}
        )
        statusTween:Play()
        
        local infoTween = TweenService:Create(playerInfoPanel,
            TweenInfo.new(7.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Position = UDim2.new(1, -260, 0.5, -210), Rotation = math.random(-1, 1)}
        )
        infoTween:Play()
    end
end

-- Iniciar animaciones
animatePanels()
updatePlayersList()

-- Actualizar lista cada 5 minutos
task.spawn(function()
    while screenGui.Parent do
        task.wait(300)
        if screenGui.Parent then
            updatePlayersList()
        end
    end
end)

-- Crear pétalos iniciales
for i = 1, 25 do
    task.spawn(function()
        task.wait(i * 0.15)
        createSakuraPetal()
    end)
end

-- Función para alternar visibilidad (Tecla F)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Retornar tabla con funciones útiles
return {
    GUI = screenGui,
    HasAccess = hasAccess,
    AccountAge = accountAge,
    CreatePetal = createSakuraPetal,
    SpecialEffect = createSpecialEffect,
    UpdatePlayersList = updatePlayersList
}
