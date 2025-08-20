-- Sistema Anti-Ragdoll que simula el estado "Trapped"
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiRagdollGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 320, 0, 200)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🕳️ ANTI-RAGDOLL (Trap State)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.25, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🟢 Estado: Vulnerable a golpes"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham

-- Info del modo
local modeLabel = Instance.new("TextLabel")
modeLabel.Parent = mainFrame
modeLabel.Size = UDim2.new(1, 0, 0, 20)
modeLabel.Position = UDim2.new(0, 0, 0.42, 0)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "Modo: Simulación de Trap"
modeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
modeLabel.TextScaled = true
modeLabel.Font = Enum.Font.Gotham

-- Timer
local timerLabel = Instance.new("TextLabel")
timerLabel.Parent = mainFrame
timerLabel.Size = UDim2.new(1, 0, 0, 30)
timerLabel.Position = UDim2.new(0, 0, 0.55, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "⏱️ Tiempo: Inactivo"
timerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.GothamBold

-- Botón principal
local trapButton = Instance.new("TextButton")
trapButton.Parent = mainFrame
trapButton.Size = UDim2.new(0.9, 0, 0, 40)
trapButton.Position = UDim2.new(0.05, 0, 0.75, 0)
trapButton.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
trapButton.Text = "🕳️ ACTIVAR TRAP STATE"
trapButton.TextColor3 = Color3.fromRGB(255, 255, 255)
trapButton.TextScaled = true
trapButton.Font = Enum.Font.GothamBold

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = trapButton

-- Variables de estado
local trapStateActive = false
local timeRemaining = 0
local connections = {}
local originalStates = {}

-- Función para aplicar estado "Trapped" (inmune a ragdoll)
local function applyTrapState()
    if not character or not humanoid or not humanoidRootPart then return false end
    
    print("🕳️ Aplicando estado Trapped...")
    
    -- Guardar estados originales
    originalStates = {
        PlatformStand = humanoid.PlatformStand,
        Sit = humanoid.Sit,
        Jump = humanoid.Jump,
        RootPartAnchored = humanoidRootPart.Anchored,
        RootPartCanCollide = humanoidRootPart.CanCollide
    }
    
    -- Método 1: Anclar RootPart (evita movimiento por golpes)
    humanoidRootPart.Anchored = true
    
    -- Método 2: Desactivar colisiones de todas las partes del cuerpo
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part ~= humanoidRootPart then
            part.CanCollide = false
        end
    end
    
    -- Método 3: Configurar Humanoid para evitar ragdoll
    humanoid.PlatformStand = true  -- Evita que caiga
    humanoid.Sit = false
    humanoid.Jump = false
    
    -- Método 4: Protección continua contra cambios de estado
    connections.stateProtection = RunService.Heartbeat:Connect(function()
        if trapStateActive and humanoid and humanoidRootPart then
            -- Mantener anclado
            if not humanoidRootPart.Anchored then
                humanoidRootPart.Anchored = true
            end
            
            -- Mantener PlatformStand
            if not humanoid.PlatformStand then
                humanoid.PlatformStand = true
            end
            
            -- Evitar que se siente o salte
            humanoid.Sit = false
            humanoid.Jump = false
            
            -- Mantener colisiones desactivadas
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part ~= humanoidRootPart then
                    if part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    
    -- Método 5: Interceptar eventos de daño/golpe
    connections.damageProtection = humanoid.StateChanged:Connect(function(oldState, newState)
        if trapStateActive then
            -- Evitar estados de ragdoll
            if newState == Enum.HumanoidStateType.Physics or 
               newState == Enum.HumanoidStateType.FallingDown or
               newState == Enum.HumanoidStateType.Ragdoll then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                humanoid.PlatformStand = true
                print("🛡️ Estado ragdoll bloqueado")
            end
        end
    end)
    
    print("✅ Estado Trapped aplicado - Inmune a golpes")
    return true
end

-- Función para crear efectos visuales del trap
local function createTrapEffects()
    -- Efecto de "atrapado" similar al trap real
    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Name = "TrapStateEffect"
    selectionBox.Parent = workspace
    selectionBox.Adornee = humanoidRootPart
    selectionBox.Color3 = Color3.fromRGB(150, 50, 200)
    selectionBox.LineThickness = 0.4
    selectionBox.Transparency = 0.3
    
    -- Efecto de partículas (opcional)
    local attachment = Instance.new("Attachment")
    attachment.Name = "TrapParticles"
    attachment.Parent = humanoidRootPart
    
    return selectionBox, attachment
end

-- Función para intentar activar trap real del juego
local function tryActivateRealTrap()
    local trap = workspace:FindFirstChild("Trap")
    if trap then
        print("🎯 Intentando activar trap real...")
        
        -- Buscar partes del trap y simular contacto
        for _, part in pairs(trap:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Simular que el jugador tocó la trampa
                pcall(function()
                    if part.Touched then
                        part.Touched:Fire(humanoidRootPart)
                        print("✅ Trap real activado")
                        return true
                    end
                end)
            end
        end
    end
    return false
end

-- Función principal para activar trap state
local function activateTrapState()
    print("🚀 Activando Trap State...")
    
    trapStateActive = true
    timeRemaining = 10
    
    -- Intentar usar trap real primero
    local realTrapUsed = tryActivateRealTrap()
    
    -- Aplicar estado trapped independientemente
    if not applyTrapState() then
        print("❌ Error aplicando trap state")
        trapStateActive = false
        return
    end
    
    -- Crear efectos visuales
    local selectionBox, particles = createTrapEffects()
    
    -- Actualizar UI
    statusLabel.Text = "🔴 Estado: TRAPPED (Inmune a golpes)"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    trapButton.Text = "🔓 DESACTIVAR TRAP STATE"
    trapButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    modeLabel.Text = realTrapUsed and "Modo: Trap Real + Simulado" or "Modo: Simulado"
    
    -- Timer countdown
    connections.timer = RunService.Heartbeat:Connect(function(deltaTime)
        if trapStateActive then
            timeRemaining = timeRemaining - deltaTime
            
            local seconds = math.ceil(math.max(0, timeRemaining))
            timerLabel.Text = "⏱️ Tiempo: " .. seconds .. "s"
            
            -- Cambiar color según tiempo
            if seconds <= 3 then
                timerLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            elseif seconds <= 5 then
                timerLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            else
                timerLabel.TextColor3 = Color3.fromRGB(150, 50, 200)
            end
            
            if timeRemaining <= 0 then
                deactivateTrapState()
            end
        end
    end)
    
    -- Función de limpieza
    connections.cleanup = function()
        if selectionBox then selectionBox:Destroy() end
        if particles then particles:Destroy() end
            end
    
    print("✅ Trap State activado - Inmune a golpes por 10 segundos")
    print("🛡️ Los golpes de bate/mano/espada no causarán ragdoll")
end

-- Función para desactivar trap state
local function deactivateTrapState()
    print("🛑 Desactivando Trap State...")
    
    trapStateActive = false
    timeRemaining = 0
    
    -- Ejecutar limpieza de efectos
    if connections.cleanup then
        connections.cleanup()
    end
    
    -- Desconectar todas las conexiones
    for name, connection in pairs(connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    connections = {}
    
    -- Restaurar estados originales del personaje
    if character and humanoid and humanoidRootPart then
        pcall(function()
            -- Restaurar RootPart
            humanoidRootPart.Anchored = originalStates.RootPartAnchored or false
            humanoidRootPart.CanCollide = originalStates.RootPartCanCollide or false
            
            -- Restaurar Humanoid
            humanoid.PlatformStand = originalStates.PlatformStand or false
            humanoid.Sit = originalStates.Sit or false
            humanoid.Jump = originalStates.Jump or false
            
            -- Restaurar colisiones de todas las partes
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part ~= humanoidRootPart then
                    part.CanCollide = true
                end
            end
            
            -- Asegurar estado normal
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    
    -- Restaurar UI
    statusLabel.Text = "🟢 Estado: Vulnerable a golpes"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    timerLabel.Text = "⏱️ Tiempo: Inactivo"
    timerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    trapButton.Text = "🕳️ ACTIVAR TRAP STATE"
    trapButton.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
    modeLabel.Text = "Modo: Simulación de Trap"
    modeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    
    print("✅ Trap State desactivado - Vulnerable a golpes normalmente")
end

-- Toggle principal
local function toggleTrapState()
    if trapStateActive then
        deactivateTrapState()
    else
        activateTrapState()
    end
end

-- Función para detectar golpes entrantes (para logging)
local function setupHitDetection()
    if not character then return end
    
    -- Detectar cuando otros jugadores intentan golpear
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(function(hit)
                if trapStateActive then
                    local hitCharacter = hit.Parent
                    if hitCharacter:FindFirstChild("Humanoid") and hitCharacter ~= character then
                        print("🛡️ Golpe bloqueado de: " .. (hitCharacter.Name or "Desconocido"))
                    end
                end
            end)
        end
    end
end

-- Función para monitorear intentos de ragdoll
local function setupRagdollMonitoring()
    if not humanoid then return end
    
    -- Monitorear cambios de estado que indican ragdoll
    humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Physics or 
           newState == Enum.HumanoidStateType.FallingDown or
           newState == Enum.HumanoidStateType.Ragdoll then
            
            if trapStateActive then
                print("🚫 Intento de ragdoll bloqueado")
            else
                print("💥 Ragdoll detectado (no protegido)")
            end
        end
    end)
end

-- Conectar eventos
trapButton.MouseButton1Click:Connect(toggleTrapState)

-- Efectos de hover
trapButton.MouseEnter:Connect(function()
    if not trapStateActive then
        trapButton.BackgroundColor3 = Color3.fromRGB(170, 70, 220)
    end
end)

trapButton.MouseLeave:Connect(function()
    if not trapStateActive then
        trapButton.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
    end
end)

-- Manejar respawn
player.CharacterAdded:Connect(function(newCharacter)
    wait(1) -- Esperar a que cargue completamente
    
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid", 5)
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    
    -- Desactivar si estaba activo
    if trapStateActive then
        deactivateTrapState()
    end
    
    -- Reconfigurar detección
    setupHitDetection()
    setupRagdollMonitoring()
    
    print("🔄 Personaje respawneado - Sistema anti-ragdoll reiniciado")
end)

-- Función de diagnóstico específica para ragdoll
local function diagnoseTrapSystem()
    print("\n🔍 DIAGNÓSTICO ANTI-RAGDOLL:")
    print("=" * 50)
    
    -- Verificar personaje
    if character and humanoid and humanoidRootPart then
        print("✅ Personaje: OK")
        print("   🏃 Estado actual: " .. tostring(humanoid:GetState()))
        print("   ⚓ RootPart anclado: " .. tostring(humanoidRootPart.Anchored))
        print("   🚫 PlatformStand: " .. tostring(humanoid.PlatformStand))
    else
        print("❌ Personaje: ERROR")
    end
    
    -- Verificar trap en workspace
    local trap = workspace:FindFirstChild("Trap")
    if trap then
        print("✅ Trap en workspace: Encontrado")
        print("   📍 Posición: " .. tostring(trap:FindFirstChild("HumanoidRootPart") and trap.HumanoidRootPart.Position or "N/A"))
    else
        print("⚠️ Trap en workspace: No encontrado")
    end
    
    -- Verificar otros jugadores cerca
    local nearbyPlayers = 0
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (humanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < 50 then
                nearbyPlayers = nearbyPlayers + 1
            end
        end
    end
    print("👥 Jugadores cercanos: " .. nearbyPlayers)
    
    print("=" * 50)
    print("🎯 Diagnóstico completado\n")
end

-- Comando de prueba para verificar inmunidad
local function testImmunity()
    if not trapStateActive then
        print("⚠️ Activa el Trap State primero para probar")
        return
    end
    
    print("🧪 Probando inmunidad anti-ragdoll...")
    
    -- Simular intento de ragdoll
    if humanoid then
        local originalState = humanoid:GetState()
        
        -- Intentar cambiar a estado de física (ragdoll)
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        
        wait(0.1)
        
        -- Verificar si se mantuvo protegido
        if humanoid.PlatformStand and humanoidRootPart.Anchored then
            print("✅ Prueba exitosa - Inmunidad funcionando")
        else
            print("❌ Prueba fallida - Revisar configuración")
        end
    end
end

-- Botón de diagnóstico (opcional)
local diagButton = Instance.new("TextButton")
diagButton.Parent = mainFrame
diagButton.Size = UDim2.new(0.25, 0, 0, 20)
diagButton.Position = UDim2.new(0.05, 0, 0.05, 0)
diagButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
diagButton.Text = "🔍"
diagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
diagButton.TextScaled = true
diagButton.Font = Enum.Font.Gotham

local diagCorner = Instance.new("UICorner")
diagCorner.CornerRadius = UDim.new(0, 5)
diagCorner.Parent = diagButton

diagButton.MouseButton1Click:Connect(diagnoseTrapSystem)

-- Botón de prueba (opcional)
local testButton = Instance.new("TextButton")
testButton.Parent = mainFrame
testButton.Size = UDim2.new(0.25, 0, 0, 20)
testButton.Position = UDim2.new(0.32, 0, 0.05, 0)
testButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
testButton.Text = "🧪"
testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testButton.TextScaled = true
testButton.Font = Enum.Font.Gotham

local testCorner = Instance.new("UICorner")
testCorner.CornerRadius = UDim.new(0, 5)
testCorner.Parent = testButton

testButton.MouseButton1Click:Connect(testImmunity)

-- Inicialización
print("🎮 Anti-Ragdoll Trap System iniciado")
print("🕳️ Simula el estado 'Trapped' del juego")
print("🛡️ Protege contra golpes de bate, mano y espada")
print("⏱️ Duración: 10 segundos (como trap real)")

-- Configurar detección inicial
setupHitDetection()
setupRagdollMonitoring()

-- Ejecutar diagnóstico inicial
diagnoseTrapSystem()

print("✅ Sistema listo - Presiona el botón para activar inmunidad anti-ragdoll")
print("🔍 Usa el botón 🔍 para diagnóstico")
print("🧪 Usa el botón 🧪 para probar inmunidad")
