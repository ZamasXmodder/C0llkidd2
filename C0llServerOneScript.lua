-- Steal a Brainrot Ultimate Invisible Anti-Hit Panel by ZamasXmodder
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
local connections = {}
local panelOpen = false
local originalProperties = {}

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

-- Función para crear sombras
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

-- FUNCIÓN ANTI-HIT INVISIBLE ULTIMATE
local function toggleAntiHit()
    if not antiHitEnabled then
        antiHitEnabled = true
        
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local humanoid = character.Humanoid
            local rootPart = character.HumanoidRootPart
            
            -- Guardar propiedades originales
            originalProperties = {
                WalkSpeed = humanoid.WalkSpeed,
                JumpPower = humanoid.JumpPower,
                Health = humanoid.Health,
                MaxHealth = humanoid.MaxHealth,
                PlatformStand = humanoid.PlatformStand,
                Sit = humanoid.Sit
            }
            
            -- 1. PROTECCIÓN INVISIBLE CONTRA CAMBIOS DE ESTADO
            connections.invisibleStateProtection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("Humanoid") then
                    local hum = character.Humanoid
                    
                    -- Mantener estado siempre en Running/Freefall
                    if hum.Health > 0 then
                        local currentState = hum:GetState()
                        
                        -- Estados prohibidos que causan ragdoll o efectos visuales
                        local forbiddenStates = {
                            Enum.HumanoidStateType.Ragdoll,
                            Enum.HumanoidStateType.FallingDown,
                            Enum.HumanoidStateType.Flying,
                            Enum.HumanoidStateType.Physics,
                            Enum.HumanoidStateType.PlatformStanding,
                            Enum.HumanoidStateType.Seated,
                            Enum.HumanoidStateType.Dead,
                            Enum.HumanoidStateType.Climbing
                        }
                        
                        for _, state in pairs(forbiddenStates) do
                            if currentState == state then
                                hum:ChangeState(Enum.HumanoidStateType.Running)
                                break
                            end
                        end
                        
                        -- Forzar propiedades específicas
                        if hum.PlatformStand ~= false then
                            hum.PlatformStand = false
                        end
                        
                        if hum.Sit ~= false then
                            hum.Sit = false
                        end
                    end
                end
            end)
            
            -- 2. PROTECCIÓN CONTRA BODYMOVERS Y FUERZAS EXTERNAS
            connections.bodyMoverProtection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local rp = character.HumanoidRootPart
                    
                    -- Eliminar todos los BodyMovers inmediatamente
                    for _, child in pairs(rp:GetChildren()) do
                        if child:IsA("BodyVelocity") or 
                           child:IsA("BodyPosition") or 
                           child:IsA("BodyAngularVelocity") or 
                           child:IsA("BodyThrust") or
                           child:IsA("BodyForce") or
                           child:IsA("VectorForce") or
                           child:IsA("AlignPosition") or
                           child:IsA("AlignOrientation") then
                            child:Destroy()
                        end
                    end
                    
                    -- Resetear velocidades extremas instantáneamente
                    if rp.AssemblyLinearVelocity.Magnitude > 30 then
                        rp.AssemblyLinearVelocity = Vector3.new(0, rp.AssemblyLinearVelocity.Y, 0)
                    end
                    
                    if rp.AssemblyAngularVelocity.Magnitude > 5 then
                        rp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
            
            -- 3. PROTECCIÓN CONTRA HERRAMIENTAS Y SCRIPTS EXTERNOS
            connections.toolProtection = workspace.DescendantAdded:Connect(function(descendant)
                if descendant.Parent == character or 
                   (descendant.Parent and descendant.Parent.Parent == character) then
                    
                    -- Eliminar inmediatamente cualquier objeto que pueda causar efectos
                    if descendant:IsA("BodyVelocity") or 
                       descendant:IsA("BodyPosition") or 
                       descendant:IsA("BodyAngularVelocity") or 
                       descendant:IsA("BodyThrust") or
                       descendant:IsA("BodyForce") or
                       descendant:IsA("VectorForce") or
                       descendant:IsA("AlignPosition") or
                       descendant:IsA("AlignOrientation") or
                       descendant:IsA("Attachment") then
                        
                        RunService.Heartbeat:Wait()
                        if descendant.Parent then
                            descendant:Destroy()
                        end
                    end
                end
            end)
            
            -- 4. PROTECCIÓN CONTRA CAMBIOS EN LAS PARTES DEL CUERPO
            connections.bodyPartProtection = RunService.Heartbeat:Connect(function()
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part ~= rootPart then
                            -- Mantener CanCollide en true para evitar ragdoll
                            if part.CanCollide == false and part.Name ~= "HumanoidRootPart" then
                                part.CanCollide = true
                            end
                            
                            -- Resetear velocidades de partes individuales
                            if part.AssemblyLinearVelocity.Magnitude > 20 then
                                part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            end
                        end
                    end
                end
            end)
            
            -- 5. PROTECCIÓN CONTRA ELIMINACIÓN DE JOINTS
            connections.jointProtection = character.DescendantRemoving:Connect(function(descendant)
                if descendant:IsA("Motor6D") or descendant:IsA("Weld") or descendant:IsA("ManualWeld") then
                    -- Prevenir eliminación de joints críticos
                    local importantJoints = {"Neck", "RootJoint", "Right Shoulder", "Left Shoulder", "Right Hip", "Left Hip"}
                    
                    for _, jointName in pairs(importantJoints) do
                        if descendant.Name == jointName then
                            -- Recrear el joint inmediatamente
                            RunService.Heartbeat:Wait()
                            if character.Parent and not character:FindFirstChild(descendant.Name) then
                                local newJoint = descendant:Clone()
                                newJoint.Parent = descendant.Parent
                            end
                            break
                        end
                    end
                end
            end)
            
            -- 6. PROTECCIÓN CONTRA CAMBIOS DE PROPIEDADES DEL HUMANOID
            connections.humanoidProtection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("Humanoid") then
                    local hum = character.Humanoid
                    
                    -- Mantener salud al máximo
                    if hum.Health < hum.MaxHealth and hum.Health > 0 then
                        hum.Health = hum.MaxHealth
                    end
                    
                    -- Prevenir cambios extremos en velocidades
                    if hum.WalkSpeed > 100 or hum.WalkSpeed < 0 then
                        hum.WalkSpeed = originalProperties.WalkSpeed
                    end
                    
                    if hum.JumpPower > 200 or hum.JumpPower < 0 then
                                                    hum.JumpPower = originalProperties.JumpPower
                    end
                end
            end)
            
            -- 7. PROTECCIÓN CONTRA EFECTOS DE HERRAMIENTAS EN LA MANO
            connections.heldToolProtection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("Humanoid") then
                    local hum = character.Humanoid
                    local tool = character:FindFirstChildOfClass("Tool")
                    
                    if tool then
                        -- Proteger la herramienta de ser eliminada por efectos externos
                        for _, child in pairs(tool:GetChildren()) do
                            if child:IsA("BodyVelocity") or 
                               child:IsA("BodyPosition") or 
                               child:IsA("BodyAngularVelocity") or 
                               child:IsA("BodyThrust") then
                                child:Destroy()
                            end
                        end
                        
                        -- Asegurar que la herramienta permanezca equipada
                        if tool.Parent ~= character then
                            tool.Parent = character
                        end
                    end
                end
            end)
            
            -- 8. PROTECCIÓN CONTRA SCRIPTS DE KNOCKBACK ESPECÍFICOS
            connections.knockbackProtection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local rp = character.HumanoidRootPart
                    
                    -- Detectar y neutralizar intentos de knockback
                    local velocity = rp.AssemblyLinearVelocity
                    
                    -- Si detecta movimiento no natural (knockback), neutralizarlo
                    if velocity.Magnitude > 25 and velocity.Y > 10 then
                        -- Es probable que sea un knockback, neutralizar
                        rp.AssemblyLinearVelocity = Vector3.new(
                            velocity.X * 0.1, 
                            math.max(velocity.Y * 0.1, -5), 
                            velocity.Z * 0.1
                        )
                    end
                end
            end)
            
            -- 9. PROTECCIÓN CONTRA CAMBIOS DE CFRAME EXTREMOS
            local lastValidPosition = rootPart.CFrame
            connections.positionProtection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local rp = character.HumanoidRootPart
                    local currentPos = rp.CFrame.Position
                    local lastPos = lastValidPosition.Position
                    
                    -- Si se mueve demasiado rápido (teleport por knockback)
                    local distance = (currentPos - lastPos).Magnitude
                    if distance > 30 then
                        -- Restaurar a la última posición válida
                        rp.CFrame = lastValidPosition
                    else
                        -- Actualizar posición válida
                        lastValidPosition = rp.CFrame
                    end
                end
            end)
            
            -- 10. PROTECCIÓN CONTRA EFECTOS VISUALES DE RAGDOLL
            connections.visualProtection = RunService.Heartbeat:Connect(function()
                if character then
                    -- Asegurar que todas las partes mantengan sus rotaciones normales
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part ~= rootPart then
                            -- Prevenir rotaciones extremas que indican ragdoll
                            local cf = part.CFrame
                            local pos = cf.Position
                            local lookVector = cf.LookVector
                            
                            -- Si la parte está rotada de manera no natural, corregir
                            if math.abs(lookVector.Y) > 0.8 then
                                part.CFrame = CFrame.lookAt(pos, pos + Vector3.new(lookVector.X, 0, lookVector.Z))
                            end
                        end
                    end
                end
            end)
            
            -- 11. PROTECCIÓN CONTRA SCRIPTS DE STUN/FREEZE
            connections.stunProtection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("Humanoid") then
                    local hum = character.Humanoid
                    
                    -- Detectar si el personaje está "congelado" artificialmente
                    if hum.WalkSpeed == 0 and originalProperties.WalkSpeed > 0 then
                        hum.WalkSpeed = originalProperties.WalkSpeed
                    end
                    
                    if hum.JumpPower == 0 and originalProperties.JumpPower > 0 then
                        hum.JumpPower = originalProperties.JumpPower
                    end
                end
            end)
            
            -- 12. PROTECCIÓN CONTRA EFECTOS DE ANIMACIONES FORZADAS
            connections.animationProtection = character.ChildAdded:Connect(function(child)
                if child:IsA("StringValue") and child.Name == "ForceAnimation" then
                    child:Destroy()
                end
            end)
            
        end
        
        print("🛡️ INVISIBLE ANTI-HIT SYSTEM: ACTIVATED")
        print("🔒 Protection Level: MAXIMUM INVISIBILITY")
        print("👻 Status: GHOST MODE ENABLED")
        print("⚡ All attacks will pass through you invisibly")
        
    else
        antiHitEnabled = false
        
        -- Desconectar todas las protecciones
        for name, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
                connections[name] = nil
            end
        end
        
        -- Restaurar propiedades originales si existen
        if player.Character and player.Character:FindFirstChild("Humanoid") and originalProperties then
            local humanoid = player.Character.Humanoid
            humanoid.WalkSpeed = originalProperties.WalkSpeed or 16
            humanoid.JumpPower = originalProperties.JumpPower or 50
        end
        
        print("🛡️ INVISIBLE ANTI-HIT SYSTEM: DEACTIVATED")
        print("🔓 Protection Level: NONE")
        print("👤 Status: NORMAL MODE")
    end
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
    subtitle.Text = "Invisible Anti-Hit System"
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
    
    -- Campo de contraseña
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
    
    -- Botón de acceso
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
    loadingText.Text = "Loading Invisible Anti-Hit System..."
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
    floatingButton.Text = "👻"
    floatingButton.TextColor3 = COLORS.TEXT_PRIMARY
    floatingButton.TextSize = 24
    floatingButton.Font = Enum.Font.GothamBold
    floatingButton.Parent = screenGui
    
    local floatingCorner = Instance.new("UICorner")
    floatingCorner.CornerRadius = UDim.new(0.5, 0)
    floatingCorner.Parent = floatingButton
    
    createShadow(floatingButton, 0.3)
    createGradient(floatingButton, COLORS.ACCENT, Color3.fromRGB(0, 100, 200), 45)
    
    -- Panel principal compacto
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 380, 0, 280)
    mainPanel.Position = UDim2.new(0.5, -190, 0.5, -140)
    mainPanel.BackgroundColor3 = COLORS.PRIMARY
    mainPanel.BorderSizePixel = 0
    mainPanel.Visible = false
    mainPanel.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = mainPanel
    
    createShadow(mainPanel, 0.5)
    createGradient(mainPanel, COLORS.PRIMARY, COLORS.BACKGROUND, 135)
    
    -- Header del panel principal
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, -20, 0, 60)
    header.Position = UDim2.new(0, 10, 0, 10)
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
    panelTitle.Size = UDim2.new(0.7, 0, 0, 25)
    panelTitle.Position = UDim2.new(0, 20, 0, 8)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "INVISIBLE ANTI-HIT"
    panelTitle.TextColor3 = COLORS.TEXT_PRIMARY
    panelTitle.TextSize = 18
    panelTitle.Font = Enum.Font.GothamBold
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left
    panelTitle.Parent = header
    
    -- Versión
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Name = "VersionLabel"
    versionLabel.Size = UDim2.new(0.7, 0, 0, 20)
    versionLabel.Position = UDim2.new(0, 20, 0, 30)
        versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "Ghost Mode Edition v3.0"
    versionLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
    versionLabel.TextSize = 12
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.Parent = header
    
    -- Botón de cerrar mejorado
    local closeButton = createModernButton(
        header,
        "X",
        UDim2.new(1, -50, 0, 10),
        UDim2.new(0, 35, 0, 35),
        COLORS.DANGER,
        COLORS.TEXT_PRIMARY
    )
    
    -- Contenido del panel
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -90)
    contentFrame.Position = UDim2.new(0, 10, 0, 80)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainPanel
    
    -- Botón principal de Anti-Hit Invisible
    local antiHitButton = Instance.new("TextButton")
    antiHitButton.Name = "AntiHitButton"
    antiHitButton.Size = UDim2.new(1, 0, 0, 80)
    antiHitButton.Position = UDim2.new(0, 0, 0, 20)
    antiHitButton.BackgroundColor3 = COLORS.SECONDARY
    antiHitButton.BorderSizePixel = 0
    antiHitButton.Text = ""
    antiHitButton.Parent = contentFrame
    
    local antiHitCorner = Instance.new("UICorner")
    antiHitCorner.CornerRadius = UDim.new(0, 12)
    antiHitCorner.Parent = antiHitButton
    
    createShadow(antiHitButton, 0.15)
    
    -- Icono de estado
    local statusIcon = Instance.new("TextLabel")
    statusIcon.Name = "StatusIcon"
    statusIcon.Size = UDim2.new(0, 40, 0, 40)
    statusIcon.Position = UDim2.new(0, 15, 0, 20)
    statusIcon.BackgroundTransparency = 1
    statusIcon.Text = "🛡️"
    statusIcon.TextColor3 = COLORS.TEXT_PRIMARY
    statusIcon.TextSize = 24
    statusIcon.Font = Enum.Font.GothamBold
    statusIcon.Parent = antiHitButton
    
    -- Título del botón
    local antiHitTitle = Instance.new("TextLabel")
    antiHitTitle.Name = "AntiHitTitle"
    antiHitTitle.Size = UDim2.new(0.5, 0, 0, 25)
    antiHitTitle.Position = UDim2.new(0, 65, 0, 15)
    antiHitTitle.BackgroundTransparency = 1
    antiHitTitle.Text = "Invisible Protection"
    antiHitTitle.TextColor3 = COLORS.TEXT_PRIMARY
    antiHitTitle.TextSize = 16
    antiHitTitle.Font = Enum.Font.GothamBold
    antiHitTitle.TextXAlignment = Enum.TextXAlignment.Left
    antiHitTitle.Parent = antiHitButton
    
    -- Descripción
    local antiHitDesc = Instance.new("TextLabel")
    antiHitDesc.Name = "AntiHitDesc"
    antiHitDesc.Size = UDim2.new(0.5, 0, 0, 35)
    antiHitDesc.Position = UDim2.new(0, 65, 0, 35)
    antiHitDesc.BackgroundTransparency = 1
    antiHitDesc.Text = "Complete invisibility to all attacks\nNo visual effects or interruptions"
    antiHitDesc.TextColor3 = COLORS.TEXT_SECONDARY
    antiHitDesc.TextSize = 11
    antiHitDesc.Font = Enum.Font.Gotham
    antiHitDesc.TextXAlignment = Enum.TextXAlignment.Left
    antiHitDesc.TextWrapped = true
    antiHitDesc.Parent = antiHitButton
    
    -- Indicador de estado grande
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Size = UDim2.new(0, 120, 0, 50)
    statusIndicator.Position = UDim2.new(1, -135, 0, 15)
    statusIndicator.BackgroundColor3 = COLORS.DANGER
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Parent = antiHitButton
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 25)
    statusCorner.Parent = statusIndicator
    
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 0, 25)
    statusText.Position = UDim2.new(0, 0, 0, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = "DISABLED"
    statusText.TextColor3 = COLORS.TEXT_PRIMARY
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamBold
    statusText.Parent = statusIndicator
    
    local modeText = Instance.new("TextLabel")
    modeText.Name = "ModeText"
    modeText.Size = UDim2.new(1, 0, 0, 20)
    modeText.Position = UDim2.new(0, 0, 0, 25)
    modeText.BackgroundTransparency = 1
    modeText.Text = "Normal Mode"
    modeText.TextColor3 = COLORS.TEXT_SECONDARY
    modeText.TextSize = 10
    modeText.Font = Enum.Font.Gotham
    modeText.Parent = statusIndicator
    
    -- Información del usuario compacta
    local userInfo = Instance.new("Frame")
    userInfo.Name = "UserInfo"
    userInfo.Size = UDim2.new(1, 0, 0, 60)
    userInfo.Position = UDim2.new(0, 0, 0, 120)
    userInfo.BackgroundColor3 = COLORS.CARD
    userInfo.BorderSizePixel = 0
    userInfo.Parent = contentFrame
    
    local userInfoCorner = Instance.new("UICorner")
    userInfoCorner.CornerRadius = UDim.new(0, 12)
    userInfoCorner.Parent = userInfo
    
    createShadow(userInfo, 0.15)
    
    -- Avatar pequeño
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 10, 0, 10)
    avatar.BackgroundTransparency = 1
    avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
    avatar.Parent = userInfo
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 8)
    avatarCorner.Parent = avatar
    
    -- Info del usuario
    local userName = Instance.new("TextLabel")
    userName.Name = "UserName"
    userName.Size = UDim2.new(0.6, 0, 0, 20)
    userName.Position = UDim2.new(0, 60, 0, 10)
    userName.BackgroundTransparency = 1
    userName.Text = player.DisplayName .. " (@" .. player.Name .. ")"
    userName.TextColor3 = COLORS.TEXT_PRIMARY
    userName.TextSize = 12
    userName.Font = Enum.Font.GothamBold
    userName.TextXAlignment = Enum.TextXAlignment.Left
    userName.Parent = userInfo
    
    local userDetails = Instance.new("TextLabel")
    userDetails.Name = "UserDetails"
    userDetails.Size = UDim2.new(0.6, 0, 0, 15)
    userDetails.Position = UDim2.new(0, 60, 0, 30)
    userDetails.BackgroundTransparency = 1
    userDetails.Text = "ID: " .. player.UserId .. " | " .. getPlayerCountry()
    userDetails.TextColor3 = COLORS.TEXT_SECONDARY
    userDetails.TextSize = 10
    userDetails.Font = Enum.Font.Gotham
    userDetails.TextXAlignment = Enum.TextXAlignment.Left
    userDetails.Parent = userInfo
    
    -- Variables para estadísticas
    local attacksBlocked = 0
    local startTime = nil
    
    -- Estadísticas en tiempo real
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Name = "StatsLabel"
    statsLabel.Size = UDim2.new(0.3, 0, 0, 40)
    statsLabel.Position = UDim2.new(0.7, 0, 0, 10)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "Attacks Blocked: 0\nUptime: 00:00:00"
    statsLabel.TextColor3 = COLORS.SUCCESS
    statsLabel.TextSize = 10
    statsLabel.Font = Enum.Font.Gotham
    statsLabel.TextXAlignment = Enum.TextXAlignment.Right
    statsLabel.Parent = userInfo
    
    -- Función para actualizar estadísticas
    local function updateStats()
        if antiHitEnabled and startTime then
            local currentTime = tick()
            local elapsed = currentTime - startTime
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = math.floor(elapsed % 60)
            statsLabel.Text = string.format("Attacks Blocked: %d\nUptime: %02d:%02d:%02d", attacksBlocked, hours, minutes, seconds)
        else
            statsLabel.Text = "Attacks Blocked: 0\nUptime: 00:00:00"
        end
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
            local openTween = createTween(mainPanel, {Size = UDim2.new(0, 380, 0, 280)}, 0.6, Enum.EasingStyle.Back)
            openTween:Play()
            
            floatingButton.Text = "❌"
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
            
                        floatingButton.Text = "👻"
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
        
        floatingButton.Text = "👻"
        createTween(floatingButton, {
            BackgroundColor3 = COLORS.ACCENT,
            Rotation = 0
        }, 0.4):Play()
    end)
    
    -- Funcionalidad del Anti-Hit Invisible
    antiHitButton.MouseButton1Click:Connect(function()
        toggleAntiHit()
        
        if antiHitEnabled then
            -- Activado - Modo Fantasma
            statusIcon.Text = "👻"
            antiHitTitle.Text = "Ghost Mode Active"
            statusText.Text = "INVISIBLE"
            statusIndicator.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Púrpura fantasma
            modeText.Text = "Ghost Mode"
            modeText.TextColor3 = Color3.fromRGB(200, 150, 255)
            
            -- Reiniciar estadísticas
            attacksBlocked = 0
            startTime = tick()
            
            createTween(antiHitButton, {BackgroundColor3 = Color3.fromRGB(40, 20, 60)}, 0.3):Play()
            createGradient(statusIndicator, Color3.fromRGB(138, 43, 226), Color3.fromRGB(75, 0, 130), 45)
            
            -- Contador de ataques bloqueados mejorado
            connections.attackCounter = RunService.Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rp = player.Character.HumanoidRootPart
                    local humanoid = player.Character.Humanoid
                    
                    -- Detectar intentos de knockback/ragdoll
                    if rp.AssemblyLinearVelocity.Magnitude > 25 then
                        attacksBlocked = attacksBlocked + 1
                    end
                    
                    -- Detectar cambios de estado que indican ataques
                    local currentState = humanoid:GetState()
                    if currentState == Enum.HumanoidStateType.Ragdoll or 
                       currentState == Enum.HumanoidStateType.FallingDown or
                       currentState == Enum.HumanoidStateType.Physics then
                        attacksBlocked = attacksBlocked + 1
                    end
                end
            end)
            
        else
            -- Desactivado
            statusIcon.Text = "🛡️"
            antiHitTitle.Text = "Invisible Protection"
            statusText.Text = "DISABLED"
            statusIndicator.BackgroundColor3 = COLORS.DANGER
            modeText.Text = "Normal Mode"
            modeText.TextColor3 = COLORS.TEXT_SECONDARY
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
        local targetColor = antiHitEnabled and Color3.fromRGB(50, 30, 70) or Color3.fromRGB(50, 50, 65)
        createTween(antiHitButton, {
            BackgroundColor3 = targetColor,
            Size = UDim2.new(1, 2, 0, 82)
        }, 0.2):Play()
    end)
    
    antiHitButton.MouseLeave:Connect(function()
        local targetColor = antiHitEnabled and Color3.fromRGB(40, 20, 60) or COLORS.SECONDARY
        createTween(antiHitButton, {
            BackgroundColor3 = targetColor,
            Size = UDim2.new(1, 0, 0, 80)
        }, 0.2):Play()
    end)
    
    closeButton.MouseEnter:Connect(function()
        createTween(closeButton, {
            BackgroundColor3 = Color3.fromRGB(255, 80, 80),
            Size = UDim2.new(0, 37, 0, 37)
        }, 0.2):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        createTween(closeButton, {
            BackgroundColor3 = COLORS.DANGER,
            Size = UDim2.new(0, 35, 0, 35)
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
            statusIcon.Text = "👻"
            statusText.Text = "INVISIBLE"
            statusIndicator.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            modeText.Text = "Ghost Mode"
            modeText.TextColor3 = Color3.fromRGB(200, 150, 255)
            createGradient(statusIndicator, Color3.fromRGB(138, 43, 226), Color3.fromRGB(75, 0, 130), 45)
            
            -- Reiniciar estadísticas
            attacksBlocked = 0
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
    
    -- Efecto de pulsación fantasma en el botón flotante
    local pulseConnection
    pulseConnection = RunService.Heartbeat:Connect(function()
        if not panelOpen then
            local time = tick()
            local pulse = math.sin(time * 3) * 0.03 + 1
            local ghostEffect = math.sin(time * 2) * 0.1 + 0.9
            floatingButton.Size = UDim2.new(0, 70 * pulse, 0, 70 * pulse)
            floatingButton.BackgroundTransparency = antiHitEnabled and (1 - ghostEffect) or 0
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
    
    print("=== ZAMAS XMODDER INVISIBLE PANEL ===")
    print("Successfully Loaded - Ghost Mode Edition")
    print("User: " .. player.DisplayName .. " (@" .. player.Name .. ")")
    print("User ID: " .. player.UserId)
    print("Location: " .. getPlayerCountry())
    print("Protection Level: INVISIBLE GHOST MODE")
    print("System Status: Ready for Phantom Protection")
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
    warn("ZAMAS XMODDER INVISIBLE PANEL ERROR: " .. tostring(err))
    warn("Please report this error to the developer")
end

-- Proteger la ejecución principal
local success, error = pcall(function()
    createPasswordScreen()
end)

if not success then
    handleError(error)
end
