-- Steal a Brainrot Ultimate Anti-Hit Panel by ZamasXmodder
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
local originalPosition = nil
local originalVelocity = nil

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

-- FUNCIÓN ANTI-HIT ULTIMATE MEJORADA
local function toggleAntiHit()
    if not antiHitEnabled then
        antiHitEnabled = true
        
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local humanoid = character.Humanoid
            local rootPart = character.HumanoidRootPart
            
            -- Guardar posición original
            originalPosition = rootPart.CFrame
            
            -- 1. Protección contra cambios de estado del Humanoid
            connections.stateChanged = humanoid.StateChanged:Connect(function(oldState, newState)
                if newState == Enum.HumanoidStateType.Ragdoll or 
                   newState == Enum.HumanoidStateType.FallingDown or
                   newState == Enum.HumanoidStateType.Flying or
                   newState == Enum.HumanoidStateType.Physics or
                   newState == Enum.HumanoidStateType.PlatformStanding then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
            
            -- 2. Protección contra PlatformStand
            connections.platformStand = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("Humanoid") then
                    local hum = character.Humanoid
                    if hum.PlatformStand then
                        hum.PlatformStand = false
                    end
                end
            end)
            
            -- 3. Protección contra velocidad excesiva (empujones)
            connections.velocityProtection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local rp = character.HumanoidRootPart
                    local bodyVelocity = rp:FindFirstChild("BodyVelocity")
                    local bodyPosition = rp:FindFirstChild("BodyPosition")
                    local bodyAngularVelocity = rp:FindFirstChild("BodyAngularVelocity")
                    
                    -- Eliminar BodyMovers no deseados
                    if bodyVelocity and bodyVelocity.MaxForce.Magnitude > 4000 then
                        bodyVelocity:Destroy()
                    end
                    if bodyPosition and bodyPosition.MaxForce.Magnitude > 4000 then
                        bodyPosition:Destroy()
                    end
                    if bodyAngularVelocity then
                        bodyAngularVelocity:Destroy()
                    end
                    
                    -- Limitar velocidad
                    if rp.AssemblyLinearVelocity.Magnitude > 50 then
                        rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                    
                    -- Limitar velocidad angular
                    if rp.AssemblyAngularVelocity.Magnitude > 10 then
                        rp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
            
            -- 4. Protección contra herramientas que causan knockback
            connections.toolProtection = character.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    child.ChildAdded:Connect(function(toolChild)
                        if toolChild:IsA("BodyVelocity") or toolChild:IsA("BodyPosition") or 
                           toolChild:IsA("BodyAngularVelocity") or toolChild:IsA("BodyThrust") then
                            toolChild:Destroy()
                        end
                    end)
                end
            end)
            
            -- 5. Protección contra cambios en las propiedades del personaje
            connections.propertyProtection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
                    local hum = character.Humanoid
                    local rp = character.HumanoidRootPart
                    
                    -- Mantener propiedades del Humanoid
                    if hum.Health <= 0 then return end
                    
                    -- Proteger contra sit
                    if hum.Sit then
                        hum.Sit = false
                    end
                    
                    -- Proteger contra jump power alterado
                    if hum.JumpPower ~= 50 and hum.JumpPower > 100 then
                        hum.JumpPower = 50
                    end
                    
                    -- Proteger contra walkspeed alterado extremo
                    if hum.WalkSpeed > 100 or hum.WalkSpeed < 0 then
                        hum.WalkSpeed = 16
                    end
                end
            end)
            
            -- 6. Protección contra efectos de scripts externos
            connections.scriptProtection = workspace.DescendantAdded:Connect(function(descendant)
                if descendant.Parent == character or descendant.Parent == character.HumanoidRootPart then
                    if descendant:IsA("BodyVelocity") or descendant:IsA("BodyPosition") or 
                       descendant:IsA("BodyAngularVelocity") or descendant:IsA("BodyThrust") or
                       descendant:IsA("Attachment") or descendant:IsA("VectorForce") or
                       descendant:IsA("AlignPosition") or descendant:IsA("AlignOrientation") then
                        wait(0.1) -- Pequeña espera para evitar conflictos
                        if descendant.Parent then
                            descendant:Destroy()
                        end
                    end
                end
            end)
            
            -- 7. Protección contra cambios de CFrame extremos
            local lastPosition = rootPart.Position
            connections.positionProtection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local rp = character.HumanoidRootPart
                    local currentPosition = rp.Position
                    local distance = (currentPosition - lastPosition).Magnitude
                    
                    -- Si se mueve demasiado rápido (teleport/knockback), restaurar posición
                    if distance > 20 then
                        rp.CFrame = CFrame.new(lastPosition)
                    else
                        lastPosition = currentPosition
                    end
                end
            end)
            
            -- 8. Protección contra efectos de ragdoll por scripts
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part ~= character.HumanoidRootPart then
                    connections["part_" .. part.Name] = part:GetPropertyChangedSignal("CanCollide"):Connect(function()
                        if part.CanCollide == false and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end)
                end
            end
            
            -- 9. Protección contra eliminación de joints
            connections.jointProtection = character.DescendantRemoving:Connect(function(descendant)
                if descendant:IsA("Motor6D") or descendant:IsA("Weld") or descendant:IsA("ManualWeld") then
                    -- Recrear el joint después de un frame
                    RunService.Heartbeat:Wait()
                    if character.Parent and not character:FindFirstChild(descendant.Name) then
                        local newJoint = descendant:Clone()
                        newJoint.Parent = descendant.Parent
                    end
                end
            end)
            
        end
        
        print("ULTIMATE ANTI-HIT SYSTEM: ACTIVATED")
        print("Protection Level: MAXIMUM")
        print("Immunity Status: COMPLETE")
        
    else
        antiHitEnabled = false
        
        -- Desconectar todas las protecciones
        for name, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
                connections[name] = nil
            end
        end
        
        print("ULTIMATE ANTI-HIT SYSTEM: DEACTIVATED")
    end
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
    subtitle.Text = "Ultimate Anti-Hit System"
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
    loadingText.Text = "Loading Ultimate Anti-Hit System..."
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
    mainPanel.Size = UDim2.new(0, 420, 0, 600)
    mainPanel.Position = UDim2.new(0.5, -210, 0.5, -300)
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
    panelTitle.Text = "ULTIMATE CONTROL PANEL"
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
    versionLabel.Text = "Version 2.0 - Ultimate Anti-Hit Edition"
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
    
    -- Sección de funciones principales
    local functionsSection = Instance.new("Frame")
    functionsSection.Name = "FunctionsSection"
    functionsSection.Size = UDim2.new(1, 0, 0, 180)
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
    sectionTitle.Text = "ULTIMATE PROTECTION SYSTEM"
    sectionTitle.TextColor3 = COLORS.TEXT_PRIMARY
    sectionTitle.TextSize = 18
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.Parent = functionsSection
    
        -- Botón Anti-Hit Ultimate mejorado
    local antiHitButton = Instance.new("TextButton")
    antiHitButton.Name = "AntiHitButton"
    antiHitButton.Size = UDim2.new(1, -20, 0, 80)
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
    antiHitTitle.Size = UDim2.new(0.65, 0, 0, 25)
    antiHitTitle.Position = UDim2.new(0, 15, 0, 15)
    antiHitTitle.BackgroundTransparency = 1
    antiHitTitle.Text = "Ultimate Anti-Hit Protection"
    antiHitTitle.TextColor3 = COLORS.TEXT_PRIMARY
    antiHitTitle.TextSize = 16
    antiHitTitle.Font = Enum.Font.GothamBold
    antiHitTitle.TextXAlignment = Enum.TextXAlignment.Left
    antiHitTitle.Parent = antiHitButton
    
    local antiHitDesc = Instance.new("TextLabel")
    antiHitDesc.Name = "AntiHitDesc"
    antiHitDesc.Size = UDim2.new(0.65, 0, 0, 35)
    antiHitDesc.Position = UDim2.new(0, 15, 0, 35)
    antiHitDesc.BackgroundTransparency = 1
    antiHitDesc.Text = "Complete immunity to all attacks, knockbacks,\nragdoll effects, and external forces"
    antiHitDesc.TextColor3 = COLORS.TEXT_SECONDARY
    antiHitDesc.TextSize = 12
    antiHitDesc.Font = Enum.Font.Gotham
    antiHitDesc.TextXAlignment = Enum.TextXAlignment.Left
    antiHitDesc.TextWrapped = true
    antiHitDesc.Parent = antiHitButton
    
    -- Indicador de estado mejorado
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Size = UDim2.new(0, 100, 0, 35)
    statusIndicator.Position = UDim2.new(1, -115, 0, 15)
    statusIndicator.BackgroundColor3 = COLORS.DANGER
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Parent = antiHitButton
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 17)
    statusCorner.Parent = statusIndicator
    
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 1, 0)
    statusText.Position = UDim2.new(0, 0, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "DISABLED"
    statusText.TextColor3 = COLORS.TEXT_PRIMARY
    statusText.TextSize = 12
    statusText.Font = Enum.Font.GothamBold
    statusText.Parent = statusIndicator
    
    -- Nivel de protección
    local protectionLevel = Instance.new("TextLabel")
    protectionLevel.Name = "ProtectionLevel"
    protectionLevel.Size = UDim2.new(0, 100, 0, 20)
    protectionLevel.Position = UDim2.new(1, -115, 0, 50)
    protectionLevel.BackgroundTransparency = 1
    protectionLevel.Text = "Level: NONE"
    protectionLevel.TextColor3 = COLORS.TEXT_SECONDARY
    protectionLevel.TextSize = 10
    protectionLevel.Font = Enum.Font.Gotham
    protectionLevel.Parent = antiHitButton
    
    -- Sección de estadísticas
    local statsSection = Instance.new("Frame")
    statsSection.Name = "StatsSection"
    statsSection.Size = UDim2.new(1, 0, 0, 120)
    statsSection.Position = UDim2.new(0, 0, 0, 220)
    statsSection.BackgroundColor3 = COLORS.CARD
    statsSection.BorderSizePixel = 0
    statsSection.Parent = contentFrame
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 16)
    statsCorner.Parent = statsSection
    
    createShadow(statsSection, 0.2)
    
    -- Título de estadísticas
    local statsTitle = Instance.new("TextLabel")
    statsTitle.Name = "StatsTitle"
    statsTitle.Size = UDim2.new(1, 0, 0, 35)
    statsTitle.Position = UDim2.new(0, 0, 0, 10)
    statsTitle.BackgroundTransparency = 1
    statsTitle.Text = "PROTECTION STATISTICS"
    statsTitle.TextColor3 = COLORS.TEXT_PRIMARY
    statsTitle.TextSize = 16
    statsTitle.Font = Enum.Font.GothamBold
    statsTitle.Parent = statsSection
    
    -- Estadísticas en tiempo real
    local blockedAttacks = Instance.new("TextLabel")
    blockedAttacks.Name = "BlockedAttacks"
    blockedAttacks.Size = UDim2.new(0.5, -10, 0, 25)
    blockedAttacks.Position = UDim2.new(0, 10, 0, 45)
    blockedAttacks.BackgroundTransparency = 1
    blockedAttacks.Text = "Blocked Attacks: 0"
    blockedAttacks.TextColor3 = COLORS.SUCCESS
    blockedAttacks.TextSize = 14
    blockedAttacks.Font = Enum.Font.Gotham
    blockedAttacks.TextXAlignment = Enum.TextXAlignment.Left
    blockedAttacks.Parent = statsSection
    
    local preventedRagdolls = Instance.new("TextLabel")
    preventedRagdolls.Name = "PreventedRagdolls"
    preventedRagdolls.Size = UDim2.new(0.5, -10, 0, 25)
    preventedRagdolls.Position = UDim2.new(0.5, 0, 0, 45)
    preventedRagdolls.BackgroundTransparency = 1
    preventedRagdolls.Text = "Prevented Ragdolls: 0"
    preventedRagdolls.TextColor3 = COLORS.WARNING
    preventedRagdolls.TextSize = 14
    preventedRagdolls.Font = Enum.Font.Gotham
    preventedRagdolls.TextXAlignment = Enum.TextXAlignment.Left
    preventedRagdolls.Parent = statsSection
    
    local uptime = Instance.new("TextLabel")
    uptime.Name = "Uptime"
    uptime.Size = UDim2.new(0.5, -10, 0, 25)
    uptime.Position = UDim2.new(0, 10, 0, 70)
    uptime.BackgroundTransparency = 1
    uptime.Text = "Uptime: 00:00:00"
    uptime.TextColor3 = COLORS.ACCENT
    uptime.TextSize = 14
    uptime.Font = Enum.Font.Gotham
    uptime.TextXAlignment = Enum.TextXAlignment.Left
    uptime.Parent = statsSection
    
    local systemStatus = Instance.new("TextLabel")
    systemStatus.Name = "SystemStatus"
    systemStatus.Size = UDim2.new(0.5, -10, 0, 25)
    systemStatus.Position = UDim2.new(0.5, 0, 0, 70)
    systemStatus.BackgroundTransparency = 1
    systemStatus.Text = "Status: Standby"
    systemStatus.TextColor3 = COLORS.TEXT_SECONDARY
    systemStatus.TextSize = 14
    systemStatus.Font = Enum.Font.Gotham
    systemStatus.TextXAlignment = Enum.TextXAlignment.Left
    systemStatus.Parent = statsSection
    
    -- Variables para estadísticas
    local attacksBlocked = 0
    local ragdollsPrevented = 0
    local startTime = nil
    
    -- Función para actualizar estadísticas
    local function updateStats()
        if antiHitEnabled and startTime then
            local currentTime = tick()
            local elapsed = currentTime - startTime
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = math.floor(elapsed % 60)
            uptime.Text = string.format("Uptime: %02d:%02d:%02d", hours, minutes, seconds)
        else
            uptime.Text = "Uptime: 00:00:00"
        end
        
        blockedAttacks.Text = "Blocked Attacks: " .. attacksBlocked
        preventedRagdolls.Text = "Prevented Ragdolls: " .. ragdollsPrevented
    end
    
    -- Actualizar estadísticas cada segundo
    local statsConnection = RunService.Heartbeat:Connect(function()
        updateStats()
    end)
    
    -- Funcionalidad del botón flotante
    floatingButton.MouseButton1Click:Connect(function()
        panelOpen = not panelOpen
        
        if panelOpen then
            mainPanel.Visible = true
            mainPanel.Size = UDim2.new(0, 0, 0, 0)
            local openTween = createTween(mainPanel, {Size = UDim2.new(0, 420, 0, 600)}, 0.6, Enum.EasingStyle.Back)
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
    
    -- Funcionalidad del Anti-Hit Ultimate
    antiHitButton.MouseButton1Click:Connect(function()
        toggleAntiHit()
        
        if antiHitEnabled then
            -- Activado
            antiHitTitle.Text = "Ultimate Anti-Hit Protection"
            statusText.Text = "ENABLED"
            statusIndicator.BackgroundColor3 = COLORS.SUCCESS
            protectionLevel.Text = "Level: MAXIMUM"
            systemStatus.Text = "Status: Active"
            systemStatus.TextColor3 = COLORS.SUCCESS
            
            -- Reiniciar estadísticas
            attacksBlocked = 0
            ragdollsPrevented = 0
            startTime = tick()
            
            createTween(antiHitButton, {BackgroundColor3 = Color3.fromRGB(40, 60, 40)}, 0.3):Play()
            createGradient(statusIndicator, COLORS.SUCCESS, Color3.fromRGB(40, 180, 60), 0)
            
            -- Conectar contadores de estadísticas a las protecciones
            if connections.stateChanged then
                local originalStateChanged = connections.stateChanged
                connections.stateChanged:Disconnect()
                
                connections.stateChanged = player.Character.Humanoid.StateChanged:Connect(function(oldState, newState)
                    if newState == Enum.HumanoidStateType.Ragdoll or 
                       newState == Enum.HumanoidStateType.FallingDown or
                       newState == Enum.HumanoidStateType.Flying or
                       newState == Enum.HumanoidStateType.Physics or
                       newState == Enum.HumanoidStateType.PlatformStanding then
                        
                        ragdollsPrevented = ragdollsPrevented + 1
                        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end)
            end
            
            -- Contador para ataques bloqueados
            connections.attackCounter = RunService.Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rp = player.Character.HumanoidRootPart
                    
                    -- Detectar intentos de knockback
                    if rp.AssemblyLinearVelocity.Magnitude > 50 then
                        attacksBlocked = attacksBlocked + 1
                    end
                end
            end)
            
        else
            -- Desactivado
            antiHitTitle.Text = "Ultimate Anti-Hit Protection"
            statusText.Text = "DISABLED"
            statusIndicator.BackgroundColor3 = COLORS.DANGER
            protectionLevel.Text = "Level: NONE"
            systemStatus.Text = "Status: Standby"
            systemStatus.TextColor3 = COLORS.TEXT_SECONDARY
            startTime = nil
            
            createTween(antiHitButton, {BackgroundColor3 = COLORS.SECONDARY}, 0.3):Play()
            createGradient(statusIndicator, COLORS.DANGER, Color3.fromRGB(200, 40, 40), 0)
            
            if connections.attackCounter then
                connections.attackCounter:Disconnect()
                connections.attackCounter = nil
            end
        end
    end)
    
    -- Efectos hover mejorados
    antiHitButton.MouseEnter:Connect(function()
        createTween(antiHitButton, {
            BackgroundColor3 = Color3.fromRGB(50, 50, 65),
            Size = UDim2.new(1, -18, 0, 82)
        }, 0.2):Play()
    end)
    
    antiHitButton.MouseLeave:Connect(function()
        local targetColor = antiHitEnabled and Color3.fromRGB(40, 60, 40) or COLORS.SECONDARY
        createTween(antiHitButton, {
            BackgroundColor3 = targetColor,
            Size = UDim2.new(1, -20, 0, 80)
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
            createTween(mainPanel, {BackgroundTransparency = 0}, 0.2):Play()
        end
    end)
    
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
        wait(2) -- Esperar a que el personaje se cargue completamente
        
        if antiHitEnabled then
            antiHitEnabled = false -- Resetear estado
            toggleAntiHit() -- Reactivar
            
            -- Actualizar UI
            statusText.Text = "ENABLED"
            statusIndicator.BackgroundColor3 = COLORS.SUCCESS
            protectionLevel.Text = "Level: MAXIMUM"
            systemStatus.Text = "Status: Active"
            systemStatus.TextColor3 = COLORS.SUCCESS
            createGradient(statusIndicator, COLORS.SUCCESS, Color3.fromRGB(40, 180, 60), 0)
            
            -- Reiniciar estadísticas
            attacksBlocked = 0
            ragdollsPrevented = 0
            startTime = tick()
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
            local pulse = math.sin(time * 2) * 0.05 + 1
            floatingButton.Size = UDim2.new(0, 70 * pulse, 0, 70 * pulse)
        end
    end)
    
    -- Limpiar conexión cuando se destruya el GUI
    screenGui.AncestryChanged:Connect(function()
        if not screenGui.Parent then
            if pulseConnection then
                pulseConnection:Disconnect()
            end
            if statsConnection then
                statsConnection:Disconnect()
            end
        end
    end)
    
    print("=== ZAMAS XMODDER ULTIMATE PANEL ===")
    print("Successfully Loaded - Ultimate Anti-Hit Edition")
    print("User: " .. player.DisplayName .. " (@" .. player.Name .. ")")
    print("User ID: " .. player.UserId)
    print("Location: " .. getPlayerCountry())
    print("Protection Level: ULTIMATE")
    print("System Status: Online and Ready")
    print("=====================================")
end

-- Función para limpiar conexiones al salir
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
end)

-- Manejo de errores global
local function handleError(err)
    warn("ZAMAS XMODDER ULTIMATE PANEL ERROR: " .. tostring(err))
    warn("Please report this error to the developer")
end

-- Proteger la ejecución principal
local success, error = pcall(function()
    createPasswordScreen()
end)

if not success then
    handleError(error)
end
