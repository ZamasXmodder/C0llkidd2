-- Steal a Brainrot Professional Script Panel by ZamasXmodder
-- Ubicación: ServerStorage como LocalScript o ejecutar en Command Bar de Studio

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalizationService = game:GetService("LocalizationService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local antiHitEnabled = false
local originalHumanoidState = nil
local connections = {}
local panelOpen = false

-- Colores del tema
local COLORS = {
    PRIMARY = Color3.fromRGB(45, 45, 55),
    SECONDARY = Color3.fromRGB(35, 35, 45),
    ACCENT = Color3.fromRGB(0, 122, 255),
    SUCCESS = Color3.fromRGB(52, 199, 89),
    DANGER = Color3.fromRGB(255, 59, 48),
    WARNING = Color3.fromRGB(255, 149, 0),
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
    TEXT_SECONDARY = Color3.fromRGB(174, 174, 178),
    BACKGROUND = Color3.fromRGB(28, 28, 30),
    CARD = Color3.fromRGB(44, 44, 46)
}

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZamasXmodderPanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Función para obtener el país del jugador
local function getPlayerCountry()
    local success, result = pcall(function()
        return LocalizationService:GetCountryRegionForPlayerAsync(player)
    end)
    return success and result or "Unknown"
end

-- Función para crear efectos de tween
local function createTween(object, properties, duration, easingStyle)
    local tweenInfo = TweenInfo.new(
        duration or 0.4,
        easingStyle or Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

-- Función para crear gradientes
local function createGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    return gradient
end

-- Función para crear sombras mejoradas
local function createShadow(parent, intensity)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/Controls/DropShadow.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = intensity or 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

-- Función para crear la información del usuario
local function createUserInfo(parent)
    local userInfoFrame = Instance.new("Frame")
    userInfoFrame.Name = "UserInfoFrame"
    userInfoFrame.Size = UDim2.new(1, -20, 0, 100)
    userInfoFrame.Position = UDim2.new(0, 10, 0, 10)
    userInfoFrame.BackgroundColor3 = COLORS.CARD
    userInfoFrame.BorderSizePixel = 0
    userInfoFrame.Parent = parent
    
    local userCorner = Instance.new("UICorner")
    userCorner.CornerRadius = UDim.new(0, 16)
    userCorner.Parent = userInfoFrame
    
    createShadow(userInfoFrame, 0.3)
    createGradient(userInfoFrame, COLORS.CARD, COLORS.SECONDARY, 45)
    
    -- Avatar del usuario con marco
    local avatarContainer = Instance.new("Frame")
    avatarContainer.Name = "AvatarContainer"
    avatarContainer.Size = UDim2.new(0, 80, 0, 80)
    avatarContainer.Position = UDim2.new(0, 15, 0, 10)
    avatarContainer.BackgroundColor3 = COLORS.ACCENT
    avatarContainer.BorderSizePixel = 0
    avatarContainer.Parent = userInfoFrame
    
    local avatarContainerCorner = Instance.new("UICorner")
    avatarContainerCorner.CornerRadius = UDim.new(0, 12)
    avatarContainerCorner.Parent = avatarContainer
    
    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, -6, 1, -6)
    avatarImage.Position = UDim2.new(0, 3, 0, 3)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
    avatarImage.Parent = avatarContainer
    
    local avatarImageCorner = Instance.new("UICorner")
    avatarImageCorner.CornerRadius = UDim.new(0, 9)
    avatarImageCorner.Parent = avatarImage
    
    -- Información del usuario con mejor tipografía
    local userNameLabel = Instance.new("TextLabel")
    userNameLabel.Name = "UserNameLabel"
    userNameLabel.Size = UDim2.new(0, 250, 0, 25)
    userNameLabel.Position = UDim2.new(0, 110, 0, 15)
    userNameLabel.BackgroundTransparency = 1
    userNameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
    userNameLabel.TextColor3 = COLORS.TEXT_PRIMARY
    userNameLabel.TextSize = 16
    userNameLabel.Font = Enum.Font.GothamBold
    userNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    userNameLabel.Parent = userInfoFrame
    
    -- País del usuario
    local countryLabel = Instance.new("TextLabel")
    countryLabel.Name = "CountryLabel"
    countryLabel.Size = UDim2.new(0, 250, 0, 20)
    countryLabel.Position = UDim2.new(0, 110, 0, 40)
    countryLabel.BackgroundTransparency = 1
    countryLabel.Text = "Location: " .. getPlayerCountry()
    countryLabel.TextColor3 = COLORS.TEXT_SECONDARY
    countryLabel.TextSize = 14
    countryLabel.Font = Enum.Font.Gotham
    countryLabel.TextXAlignment = Enum.TextXAlignment.Left
    countryLabel.Parent = userInfoFrame
    
    -- ID del usuario
    local userIdLabel = Instance.new("TextLabel")
    userIdLabel.Name = "UserIdLabel"
    userIdLabel.Size = UDim2.new(0, 250, 0, 20)
    userIdLabel.Position = UDim2.new(0, 110, 0, 60)
    userIdLabel.BackgroundTransparency = 1
    userIdLabel.Text = "User ID: " .. player.UserId
    userIdLabel.TextColor3 = COLORS.TEXT_SECONDARY
    userIdLabel.TextSize = 14
    userIdLabel.Font = Enum.Font.Gotham
    userIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    userIdLabel.Parent = userInfoFrame
    
    return userInfoFrame
end

-- Función para crear botones modernos
local function createModernButton(parent, text, position, size, color, textColor)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = textColor or COLORS.TEXT_PRIMARY
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button
    
    createShadow(button, 0.2)
    
    return button
end

-- Función para crear la pantalla de contraseña
local function createPasswordScreen()
    local passwordFrame = Instance.new("Frame")
    passwordFrame.Name = "PasswordFrame"
    passwordFrame.Size = UDim2.new(0, 450, 0, 300)
    passwordFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    passwordFrame.BackgroundColor3 = COLORS.PRIMARY
    passwordFrame.BorderSizePixel = 0
    passwordFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = passwordFrame
    
    createShadow(passwordFrame, 0.4)
    createGradient(passwordFrame, COLORS.PRIMARY, COLORS.BACKGROUND, 135)
    
    -- Header con gradiente
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 80)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = COLORS.ACCENT
    header.BorderSizePixel = 0
    header.Parent = passwordFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 20)
    headerCorner.Parent = header
    
    createGradient(header, COLORS.ACCENT, Color3.fromRGB(0, 100, 200), 45)
    
    -- Título principal
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = "ZAMAS XMODDER PANEL"
    title.TextColor3 = COLORS.TEXT_PRIMARY
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = header
    
    -- Subtítulo
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, 0, 0, 25)
    subtitle.Position = UDim2.new(0, 0, 0, 50)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Professional Script Interface"
    subtitle.TextColor3 = Color3.fromRGB(200, 220, 255)
    subtitle.TextSize = 16
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = header
    
    -- Instrucción
    local instruction = Instance.new("TextLabel")
    instruction.Name = "Instruction"
    instruction.Size = UDim2.new(1, 0, 0, 30)
    instruction.Position = UDim2.new(0, 0, 0, 100)
    instruction.BackgroundTransparency = 1
    instruction.Text = "Enter authentication key to continue"
    instruction.TextColor3 = COLORS.TEXT_SECONDARY
    instruction.TextSize = 16
    instruction.Font = Enum.Font.Gotham
    instruction.Parent = passwordFrame
    
    -- Campo de contraseña mejorado
    local passwordContainer = Instance.new("Frame")
    passwordContainer.Name = "PasswordContainer"
    passwordContainer.Size = UDim2.new(0.85, 0, 0, 50)
    passwordContainer.Position = UDim2.new(0.075, 0, 0, 150)
    passwordContainer.BackgroundColor3 = COLORS.SECONDARY
    passwordContainer.BorderSizePixel = 0
    passwordContainer.Parent = passwordFrame
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 12)
    containerCorner.Parent = passwordContainer
    
    local passwordBox = Instance.new("TextBox")
    passwordBox.Name = "PasswordBox"
    passwordBox.Size = UDim2.new(1, -20, 1, -10)
    passwordBox.Position = UDim2.new(0, 10, 0, 5)
    passwordBox.BackgroundTransparency = 1
    passwordBox.Text = ""
    passwordBox.PlaceholderText = "Authentication Key..."
    passwordBox.TextColor3 = COLORS.TEXT_PRIMARY
    passwordBox.PlaceholderColor3 = COLORS.TEXT_SECONDARY
    passwordBox.TextSize = 16
    passwordBox.Font = Enum.Font.Gotham
    passwordBox.Parent = passwordContainer
    
    -- Botón de acceso mejorado
    local accessButton = createModernButton(
        passwordFrame,
        "AUTHENTICATE",
        UDim2.new(0.075, 0, 0, 220),
        UDim2.new(0.85, 0, 0, 50),
        COLORS.ACCENT,
        COLORS.TEXT_PRIMARY
    )
    
    -- Animación de entrada
    passwordFrame.Size = UDim2.new(0, 0, 0, 0)
    local enterTween = createTween(passwordFrame, {Size = UDim2.new(0, 450, 0, 300)}, 0.6, Enum.EasingStyle.Back)
    enterTween:Play()
    
    -- Función de verificación de contraseña
    local function checkPassword()
        if passwordBox.Text == "ZamasXmodder" then
            passwordBox.Text = "Authentication successful!"
            passwordBox.TextColor3 = COLORS.SUCCESS
            accessButton.Text = "ACCESS GRANTED"
            accessButton.BackgroundColor3 = COLORS.SUCCESS
            wait(1)
            createLoadingScreen(passwordFrame)
        else
                        passwordBox.Text = "Invalid authentication key!"
            passwordBox.TextColor3 = COLORS.DANGER
            accessButton.Text = "ACCESS DENIED"
            accessButton.BackgroundColor3 = COLORS.DANGER
            
            local shakeTween = createTween(passwordFrame, {Position = UDim2.new(0.5, -215, 0.5, -150)}, 0.1)
            shakeTween:Play()
            shakeTween.Completed:Connect(function()
                local backTween = createTween(passwordFrame, {Position = UDim2.new(0.5, -225, 0.5, -150)}, 0.1)
                backTween:Play()
            end)
            
            wait(2)
            passwordBox.Text = ""
            passwordBox.TextColor3 = COLORS.TEXT_PRIMARY
            accessButton.Text = "AUTHENTICATE"
            accessButton.BackgroundColor3 = COLORS.ACCENT
        end
    end
    
    accessButton.MouseButton1Click:Connect(checkPassword)
    passwordBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            checkPassword()
        end
    end)
    
    -- Efectos hover mejorados
    accessButton.MouseEnter:Connect(function()
        createTween(accessButton, {
            BackgroundColor3 = Color3.fromRGB(30, 144, 255),
            Size = UDim2.new(0.85, 0, 0, 52)
        }, 0.2):Play()
    end)
    
    accessButton.MouseLeave:Connect(function()
        createTween(accessButton, {
            BackgroundColor3 = COLORS.ACCENT,
            Size = UDim2.new(0.85, 0, 0, 50)
        }, 0.2):Play()
    end)
    
    passwordContainer.MouseEnter:Connect(function()
        createTween(passwordContainer, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}, 0.2):Play()
    end)
    
    passwordContainer.MouseLeave:Connect(function()
        createTween(passwordContainer, {BackgroundColor3 = COLORS.SECONDARY}, 0.2):Play()
    end)
end

-- Función para crear la pantalla de carga
function createLoadingScreen(passwordFrame)
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.Size = UDim2.new(0, 400, 0, 200)
    loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    loadingFrame.BackgroundColor3 = COLORS.PRIMARY
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Parent = screenGui
    
    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0, 20)
    loadingCorner.Parent = loadingFrame
    
    createShadow(loadingFrame, 0.4)
    createGradient(loadingFrame, COLORS.PRIMARY, COLORS.BACKGROUND, 135)
    
    -- Ocultar frame de contraseña
    createTween(passwordFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4):Play()
    wait(0.4)
    passwordFrame:Destroy()
    
    -- Header de carga
    local loadingHeader = Instance.new("Frame")
    loadingHeader.Name = "LoadingHeader"
    loadingHeader.Size = UDim2.new(1, 0, 0, 60)
    loadingHeader.Position = UDim2.new(0, 0, 0, 0)
    loadingHeader.BackgroundColor3 = COLORS.ACCENT
    loadingHeader.BorderSizePixel = 0
    loadingHeader.Parent = loadingFrame
    
    local loadingHeaderCorner = Instance.new("UICorner")
    loadingHeaderCorner.CornerRadius = UDim.new(0, 20)
    loadingHeaderCorner.Parent = loadingHeader
    
    createGradient(loadingHeader, COLORS.ACCENT, Color3.fromRGB(0, 100, 200), 45)
    
    -- Texto de carga
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "LoadingText"
    loadingText.Size = UDim2.new(1, 0, 1, 0)
    loadingText.Position = UDim2.new(0, 0, 0, 0)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "Initializing Panel Components..."
    loadingText.TextColor3 = COLORS.TEXT_PRIMARY
    loadingText.TextSize = 18
    loadingText.Font = Enum.Font.GothamBold
    loadingText.Parent = loadingHeader
    
    -- Contenedor de progreso
    local progressContainer = Instance.new("Frame")
    progressContainer.Name = "ProgressContainer"
    progressContainer.Size = UDim2.new(0.9, 0, 0, 20)
    progressContainer.Position = UDim2.new(0.05, 0, 0, 100)
    progressContainer.BackgroundColor3 = COLORS.SECONDARY
    progressContainer.BorderSizePixel = 0
    progressContainer.Parent = loadingFrame
    
    local progressContainerCorner = Instance.new("UICorner")
    progressContainerCorner.CornerRadius = UDim.new(0, 10)
    progressContainerCorner.Parent = progressContainer
    
    local progressFill = Instance.new("Frame")
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = COLORS.ACCENT
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressContainer
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 10)
    fillCorner.Parent = progressFill
    
    createGradient(progressFill, COLORS.ACCENT, Color3.fromRGB(0, 150, 255), 0)
    
    -- Porcentaje de carga
    local percentageLabel = Instance.new("TextLabel")
    percentageLabel.Name = "PercentageLabel"
    percentageLabel.Size = UDim2.new(1, 0, 0, 30)
    percentageLabel.Position = UDim2.new(0, 0, 0, 140)
    percentageLabel.BackgroundTransparency = 1
    percentageLabel.Text = "0%"
    percentageLabel.TextColor3 = COLORS.TEXT_SECONDARY
    percentageLabel.TextSize = 16
    percentageLabel.Font = Enum.Font.Gotham
    percentageLabel.Parent = loadingFrame
    
    -- Animación de carga con porcentaje
    local progressTween = createTween(progressFill, {Size = UDim2.new(1, 0, 1, 0)}, 3, Enum.EasingStyle.Quad)
    progressTween:Play()
    
    -- Actualizar porcentaje
    local startTime = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / 3, 1)
        local percentage = math.floor(progress * 100)
        percentageLabel.Text = percentage .. "%"
        
        if progress >= 1 then
            connection:Disconnect()
        end
    end)
    
    -- Después de 3 segundos, mostrar el panel principal
    wait(3)
    createTween(loadingFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4):Play()
    wait(0.4)
    loadingFrame:Destroy()
    
    createMainPanel()
end

-- Función Anti-Hit mejorada
local function toggleAntiHit()
    if not antiHitEnabled then
        antiHitEnabled = true
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            
            connections.antiHit = humanoid.StateChanged:Connect(function(oldState, newState)
                if newState == Enum.HumanoidStateType.Ragdoll or 
                   newState == Enum.HumanoidStateType.FallingDown or
                   newState == Enum.HumanoidStateType.Flying then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
            
            connections.platformStand = RunService.Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    local humanoid = player.Character.Humanoid
                    if humanoid.PlatformStand then
                        humanoid.PlatformStand = false
                    end
                end
            end)
        end
        
        print("Anti-Hit System: ACTIVATED")
    else
        antiHitEnabled = false
        
        if connections.antiHit then
            connections.antiHit:Disconnect()
            connections.antiHit = nil
        end
        
        if connections.platformStand then
            connections.platformStand:Disconnect()
            connections.platformStand = nil
        end
        
        print("Anti-Hit System: DEACTIVATED")
    end
end

-- Función para crear el panel principal
function createMainPanel()
    -- Botón flotante mejorado
    local floatingButton = Instance.new("TextButton")
    floatingButton.Name = "FloatingButton"
    floatingButton.Size = UDim2.new(0, 70, 0, 70)
    floatingButton.Position = UDim2.new(0, 25, 0.5, -35)
    floatingButton.BackgroundColor3 = COLORS.ACCENT
    floatingButton.BorderSizePixel = 0
    floatingButton.Text = "ZX"
    floatingButton.TextColor3 = COLORS.TEXT_PRIMARY
    floatingButton.TextSize = 20
    floatingButton.Font = Enum.Font.GothamBold
    floatingButton.Parent = screenGui
    
    local floatingCorner = Instance.new("UICorner")
    floatingCorner.CornerRadius = UDim.new(0.5, 0)
    floatingCorner.Parent = floatingButton
    
    createShadow(floatingButton, 0.3)
    createGradient(floatingButton, COLORS.ACCENT, Color3.fromRGB(0, 100, 200), 45)
    
    -- Panel principal mejorado
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 420, 0, 550)
    mainPanel.Position = UDim2.new(0.5, -210, 0.5, -275)
    mainPanel.BackgroundColor3 = COLORS.PRIMARY
    mainPanel.BorderSizePixel = 0
    mainPanel.Visible = false
    mainPanel.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = mainPanel
    
    createShadow(mainPanel, 0.5)
    createGradient(mainPanel, COLORS.PRIMARY, COLORS.BACKGROUND, 135)
    
    -- Crear información del usuario
    local userInfo = createUserInfo(mainPanel)
    
    -- Header del panel principal
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, -20, 0, 70)
    header.Position = UDim2.new(0, 10, 0, 120)
    header.BackgroundColor3 = COLORS.ACCENT
    header.BorderSizePixel = 0
    header.Parent = mainPanel
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 16)
    headerCorner.Parent = header
    
    createGradient(header, COLORS.ACCENT, Color3.fromRGB(0, 100, 200), 45)
    
    -- Título del panel
    local panelTitle = Instance.new("TextLabel")
    panelTitle.Name = "PanelTitle"
    panelTitle.Size = UDim2.new(0.7, 0, 0, 30)
    panelTitle.Position = UDim2.new(0, 20, 0, 10)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "CONTROL PANEL"
    panelTitle.TextColor3 = COLORS.TEXT_PRIMARY
    panelTitle.TextSize = 20
    panelTitle.Font = Enum.Font.GothamBold
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left
    panelTitle.Parent = header
    
    -- Versión
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Name = "VersionLabel"
    versionLabel.Size = UDim2.new(0.7, 0, 0, 20)
    versionLabel.Position = UDim2.new(0, 20, 0, 40)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "Version 1.0 - Professional Edition"
    versionLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
    versionLabel.TextSize = 14
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.Parent = header
    
    -- Botón de cerrar mejorado
    local closeButton = createModernButton(
        header,
        "X",
        UDim2.new(1, -60, 0, 15),
        UDim2.new(0, 40, 0, 40),
        COLORS.DANGER,
        COLORS.TEXT_PRIMARY
    )
    
    -- Contenido del panel
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -210)
    contentFrame.Position = UDim2.new(0, 10, 0, 200)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainPanel
    
    -- Sección de funciones
    local functionsSection = Instance.new("Frame")
    functionsSection.Name = "FunctionsSection"
    functionsSection.Size = UDim2.new(1, 0, 0, 150)
    functionsSection.Position = UDim2.new(0, 0, 0, 20)
    functionsSection.BackgroundColor3 = COLORS.CARD
    functionsSection.BorderSizePixel = 0
        functionsSection.Parent = contentFrame
    
    local functionsCorner = Instance.new("UICorner")
    functionsCorner.CornerRadius = UDim.new(0, 16)
    functionsCorner.Parent = functionsSection
    
    createShadow(functionsSection, 0.2)
    
    -- Título de la sección
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Size = UDim2.new(1, 0, 0, 40)
    sectionTitle.Position = UDim2.new(0, 0, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = "GAME FUNCTIONS"
    sectionTitle.TextColor3 = COLORS.TEXT_PRIMARY
    sectionTitle.TextSize = 18
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.Parent = functionsSection
    
    -- Botón Anti-Hit mejorado
    local antiHitButton = Instance.new("TextButton")
    antiHitButton.Name = "AntiHitButton"
    antiHitButton.Size = UDim2.new(1, -20, 0, 60)
    antiHitButton.Position = UDim2.new(0, 10, 0, 50)
    antiHitButton.BackgroundColor3 = COLORS.SECONDARY
    antiHitButton.BorderSizePixel = 0
    antiHitButton.Text = ""
    antiHitButton.Parent = functionsSection
    
    local antiHitCorner = Instance.new("UICorner")
    antiHitCorner.CornerRadius = UDim.new(0, 12)
    antiHitCorner.Parent = antiHitButton
    
    createShadow(antiHitButton, 0.15)
    
    -- Contenido del botón Anti-Hit
    local antiHitTitle = Instance.new("TextLabel")
    antiHitTitle.Name = "AntiHitTitle"
    antiHitTitle.Size = UDim2.new(0.7, 0, 0, 25)
    antiHitTitle.Position = UDim2.new(0, 15, 0, 10)
    antiHitTitle.BackgroundTransparency = 1
    antiHitTitle.Text = "Anti-Hit Protection"
    antiHitTitle.TextColor3 = COLORS.TEXT_PRIMARY
    antiHitTitle.TextSize = 16
    antiHitTitle.Font = Enum.Font.GothamBold
    antiHitTitle.TextXAlignment = Enum.TextXAlignment.Left
    antiHitTitle.Parent = antiHitButton
    
    local antiHitDesc = Instance.new("TextLabel")
    antiHitDesc.Name = "AntiHitDesc"
    antiHitDesc.Size = UDim2.new(0.7, 0, 0, 20)
    antiHitDesc.Position = UDim2.new(0, 15, 0, 30)
    antiHitDesc.BackgroundTransparency = 1
    antiHitDesc.Text = "Prevents ragdoll and knockdown effects"
    antiHitDesc.TextColor3 = COLORS.TEXT_SECONDARY
    antiHitDesc.TextSize = 12
    antiHitDesc.Font = Enum.Font.Gotham
    antiHitDesc.TextXAlignment = Enum.TextXAlignment.Left
    antiHitDesc.Parent = antiHitButton
    
    -- Indicador de estado
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Size = UDim2.new(0, 80, 0, 30)
    statusIndicator.Position = UDim2.new(1, -95, 0, 15)
    statusIndicator.BackgroundColor3 = COLORS.DANGER
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Parent = antiHitButton
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 15)
    statusCorner.Parent = statusIndicator
    
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 1, 0)
    statusText.Position = UDim2.new(0, 0, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "OFF"
    statusText.TextColor3 = COLORS.TEXT_PRIMARY
    statusText.TextSize = 12
    statusText.Font = Enum.Font.GothamBold
    statusText.Parent = statusIndicator
    
    -- Sección de información
    local infoSection = Instance.new("Frame")
    infoSection.Name = "InfoSection"
    infoSection.Size = UDim2.new(1, 0, 0, 120)
    infoSection.Position = UDim2.new(0, 0, 0, 190)
    infoSection.BackgroundColor3 = COLORS.CARD
    infoSection.BorderSizePixel = 0
    infoSection.Parent = contentFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 16)
    infoCorner.Parent = infoSection
    
    createShadow(infoSection, 0.2)
    
    -- Título de información
    local infoTitle = Instance.new("TextLabel")
    infoTitle.Name = "InfoTitle"
    infoTitle.Size = UDim2.new(1, 0, 0, 35)
    infoTitle.Position = UDim2.new(0, 0, 0, 10)
    infoTitle.BackgroundTransparency = 1
    infoTitle.Text = "SYSTEM INFORMATION"
    infoTitle.TextColor3 = COLORS.TEXT_PRIMARY
    infoTitle.TextSize = 16
    infoTitle.Font = Enum.Font.GothamBold
    infoTitle.Parent = infoSection
    
    -- Información del desarrollador
    local devInfo = Instance.new("TextLabel")
    devInfo.Name = "DevInfo"
    devInfo.Size = UDim2.new(1, -20, 0, 25)
    devInfo.Position = UDim2.new(0, 10, 0, 45)
    devInfo.BackgroundTransparency = 1
    devInfo.Text = "Developer: ZamasXmodder"
    devInfo.TextColor3 = COLORS.TEXT_SECONDARY
    devInfo.TextSize = 14
    devInfo.Font = Enum.Font.Gotham
    devInfo.TextXAlignment = Enum.TextXAlignment.Left
    devInfo.Parent = infoSection
    
    -- Estado del sistema
    local systemStatus = Instance.new("TextLabel")
    systemStatus.Name = "SystemStatus"
    systemStatus.Size = UDim2.new(1, -20, 0, 25)
    systemStatus.Position = UDim2.new(0, 10, 0, 70)
    systemStatus.BackgroundTransparency = 1
    systemStatus.Text = "System Status: Online"
    systemStatus.TextColor3 = COLORS.SUCCESS
    systemStatus.TextSize = 14
    systemStatus.Font = Enum.Font.Gotham
    systemStatus.TextXAlignment = Enum.TextXAlignment.Left
    systemStatus.Parent = infoSection
    
    -- Próximas actualizaciones
    local updatesInfo = Instance.new("TextLabel")
    updatesInfo.Name = "UpdatesInfo"
    updatesInfo.Size = UDim2.new(1, -20, 0, 25)
    updatesInfo.Position = UDim2.new(0, 10, 0, 95)
    updatesInfo.BackgroundTransparency = 1
    updatesInfo.Text = "More features coming soon..."
    updatesInfo.TextColor3 = COLORS.TEXT_SECONDARY
    updatesInfo.TextSize = 14
    updatesInfo.Font = Enum.Font.Gotham
    updatesInfo.TextXAlignment = Enum.TextXAlignment.Left
    updatesInfo.Parent = infoSection
    
    -- Funcionalidad del botón flotante
    floatingButton.MouseButton1Click:Connect(function()
        panelOpen = not panelOpen
        
        if panelOpen then
            mainPanel.Visible = true
            mainPanel.Size = UDim2.new(0, 0, 0, 0)
            local openTween = createTween(mainPanel, {Size = UDim2.new(0, 420, 0, 550)}, 0.6, Enum.EasingStyle.Back)
            openTween:Play()
            
            floatingButton.Text = "X"
            createTween(floatingButton, {
                BackgroundColor3 = COLORS.DANGER,
                Rotation = 180
            }, 0.4):Play()
        else
            local closeTween = createTween(mainPanel, {Size = UDim2.new(0, 0, 0, 0)}, 0.4)
            closeTween:Play()
            closeTween.Completed:Connect(function()
                mainPanel.Visible = false
            end)
            
            floatingButton.Text = "ZX"
            createTween(floatingButton, {
                BackgroundColor3 = COLORS.ACCENT,
                Rotation = 0
            }, 0.4):Play()
        end
    end)
    
    -- Funcionalidad del botón de cerrar
    closeButton.MouseButton1Click:Connect(function()
        panelOpen = false
        local closeTween = createTween(mainPanel, {Size = UDim2.new(0, 0, 0, 0)}, 0.4)
        closeTween:Play()
        closeTween.Completed:Connect(function()
            mainPanel.Visible = false
        end)
        
        floatingButton.Text = "ZX"
        createTween(floatingButton, {
            BackgroundColor3 = COLORS.ACCENT,
            Rotation = 0
        }, 0.4):Play()
    end)
    
    -- Funcionalidad del Anti-Hit
    antiHitButton.MouseButton1Click:Connect(function()
        toggleAntiHit()
        
        if antiHitEnabled then
            antiHitTitle.Text = "Anti-Hit Protection"
            statusText.Text = "ON"
            statusIndicator.BackgroundColor3 = COLORS.SUCCESS
            createTween(antiHitButton, {BackgroundColor3 = Color3.fromRGB(40, 60, 40)}, 0.3):Play()
            createGradient(statusIndicator, COLORS.SUCCESS, Color3.fromRGB(40, 180, 60), 0)
        else
            antiHitTitle.Text = "Anti-Hit Protection"
            statusText.Text = "OFF"
            statusIndicator.BackgroundColor3 = COLORS.DANGER
            createTween(antiHitButton, {BackgroundColor3 = COLORS.SECONDARY}, 0.3):Play()
            createGradient(statusIndicator, COLORS.DANGER, Color3.fromRGB(200, 40, 40), 0)
        end
    end)
    
    -- Efectos hover mejorados
    antiHitButton.MouseEnter:Connect(function()
        createTween(antiHitButton, {
            BackgroundColor3 = Color3.fromRGB(50, 50, 65),
            Size = UDim2.new(1, -18, 0, 62)
        }, 0.2):Play()
    end)
    
    antiHitButton.MouseLeave:Connect(function()
        local targetColor = antiHitEnabled and Color3.fromRGB(40, 60, 40) or COLORS.SECONDARY
        createTween(antiHitButton, {
            BackgroundColor3 = targetColor,
            Size = UDim2.new(1, -20, 0, 60)
        }, 0.2):Play()
    end)
    
    closeButton.MouseEnter:Connect(function()
        createTween(closeButton, {
            BackgroundColor3 = Color3.fromRGB(255, 80, 80),
            Size = UDim2.new(0, 42, 0, 42)
        }, 0.2):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        createTween(closeButton, {
            BackgroundColor3 = COLORS.DANGER,
            Size = UDim2.new(0, 40, 0, 40)
        }, 0.2):Play()
    end)
    
    floatingButton.MouseEnter:Connect(function()
        createTween(floatingButton, {
            Size = UDim2.new(0, 75, 0, 75),
            BackgroundColor3 = panelOpen and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(30, 144, 255)
        }, 0.2):Play()
    end)
    
    floatingButton.MouseLeave:Connect(function()
        createTween(floatingButton, {
            Size = UDim2.new(0, 70, 0, 70),
            BackgroundColor3 = panelOpen and COLORS.DANGER or COLORS.ACCENT
                }, 0.2):Play()
    end)
    
    -- Hacer el panel arrastrable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainPanel.Position
            
            -- Efecto visual al arrastrar
            createTween(mainPanel, {BackgroundTransparency = 0.1}, 0.2):Play()
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainPanel.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            
            -- Restaurar transparencia
            createTween(mainPanel, {BackgroundTransparency = 0}, 0.2):Play()
        end
    end)
    
    -- Efecto de cursor al pasar por el header
    header.MouseEnter:Connect(function()
        if not dragging then
            createTween(header, {BackgroundColor3 = Color3.fromRGB(30, 144, 255)}, 0.2):Play()
        end
    end)
    
    header.MouseLeave:Connect(function()
        if not dragging then
            createTween(header, {BackgroundColor3 = COLORS.ACCENT}, 0.2):Play()
        end
    end)
    
    -- Reconectar Anti-Hit cuando el personaje respawnea
    player.CharacterAdded:Connect(function()
        if antiHitEnabled then
            wait(2) -- Esperar a que el personaje se cargue completamente
            antiHitEnabled = false -- Resetear estado
            toggleAntiHit() -- Reactivar
            
            -- Actualizar UI
            statusText.Text = "ON"
            statusIndicator.BackgroundColor3 = COLORS.SUCCESS
            createGradient(statusIndicator, COLORS.SUCCESS, Color3.fromRGB(40, 180, 60), 0)
        end
    end)
    
    -- Animación de entrada del botón flotante
    floatingButton.Size = UDim2.new(0, 0, 0, 0)
    floatingButton.Rotation = 180
    wait(0.5)
    
    local floatingEnterTween = createTween(floatingButton, {
        Size = UDim2.new(0, 70, 0, 70),
        Rotation = 0
    }, 0.6, Enum.EasingStyle.Back)
    floatingEnterTween:Play()
    
    -- Efecto de pulsación periódica en el botón flotante
    local pulseConnection
    pulseConnection = RunService.Heartbeat:Connect(function()
        if not panelOpen then
            local time = tick()
            local pulse = math.sin(time * 2) * 0.1 + 1
            floatingButton.Size = UDim2.new(0, 70 * pulse, 0, 70 * pulse)
        end
    end)
    
    -- Limpiar conexión cuando se destruya el GUI
    screenGui.AncestryChanged:Connect(function()
        if not screenGui.Parent then
            if pulseConnection then
                pulseConnection:Disconnect()
            end
        end
    end)
    
    print("ZAMAS XMODDER PANEL - Successfully Loaded")
    print("User: " .. player.DisplayName .. " (@" .. player.Name .. ")")
    print("User ID: " .. player.UserId)
    print("Location: " .. getPlayerCountry())
    print("System Status: Online")
end

-- Función para limpiar conexiones al salir
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        -- Limpiar todas las conexiones
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
end)

-- Manejo de errores global
local function handleError(err)
    warn("ZAMAS XMODDER PANEL ERROR: " .. tostring(err))
end

-- Proteger la ejecución principal
local success, error = pcall(function()
    createPasswordScreen()
end)

if not success then
    handleError(error)
end
