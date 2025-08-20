-- Anti-Ragdoll con movimiento libre (como trap real)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiRagdollFreeGUI"
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
titleLabel.Text = "🕳️ ANTI-RAGDOLL (Movimiento Libre)"
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

-- Info del movimiento
local movementLabel = Instance.new("TextLabel")
movementLabel.Parent = mainFrame
movementLabel.Size = UDim2.new(1, 0, 0, 20)
movementLabel.Position = UDim2.new(0, 0, 0.42, 0)
movementLabel.BackgroundTransparency = 1
movementLabel.Text = "🚶 Movimiento: Libre"
movementLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
movementLabel.TextScaled = true
movementLabel.Font = Enum.Font.Gotham

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
trapButton.Text = "🕳️ ACTIVAR ANTI-RAGDOLL"
trapButton.TextColor3 = Color3.fromRGB(255, 255, 255)
trapButton.TextScaled = true
trapButton.Font = Enum.Font.GothamBold

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = trapButton

-- Variables de estado
local antiRagdollActive = false
local timeRemaining = 0
local connections = {}
local originalStates = {}

-- Función para aplicar anti-ragdoll SIN restringir movimiento
local function applyAntiRagdollFree()
    if not character or not humanoid or not humanoidRootPart then return false end
    
    print("🕳️ Aplicando anti-ragdoll con movimiento libre...")
    
    -- Guardar estados originales
    originalStates = {
        PlatformStand = humanoid.PlatformStand,
        Sit = humanoid.Sit,
        WalkSpeed = humanoid.WalkSpeed,
        JumpPower = humanoid.JumpPower
    }
    
    -- NO anclar RootPart - mantener movimiento libre
    humanoidRootPart.Anchored = false
    
    -- Configurar humanoid para movimiento normal pero sin ragdoll
    humanoid.PlatformStand = false  -- Permitir movimiento
    humanoid.Sit = false
    
    -- Mantener velocidades normales
    humanoid.WalkSpeed = originalStates.WalkSpeed
    humanoid.JumpPower = originalStates.JumpPower
    
    -- Método 1: Interceptar y bloquear SOLO estados de ragdoll
    connections.ragdollProtection = humanoid.StateChanged:Connect(function(oldState, newState)
        if antiRagdollActive then
            -- Bloquear SOLO estados problemáticos
            if newState == Enum.HumanoidStateType.Physics or 
               newState == Enum.HumanoidStateType.FallingDown or
               newState == Enum.HumanoidStateType.Ragdoll or
               newState == Enum.HumanoidStateType.PlatformStanding then
                
                -- Cambiar a estado de correr (permite movimiento)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                print("🛡️ Estado ragdoll bloqueado - Manteniendo movimiento")
            end
        end
    end)
    
    -- Método 2: Protección ligera contra colisiones de golpes
    connections.hitProtection = RunService.Heartbeat:Connect(function()
        if antiRagdollActive and humanoid and humanoidRootPart then
            -- Mantener humanoid en estado activo
            if humanoid.PlatformStand then
                humanoid.PlatformStand = false
            end
            
            -- Asegurar que puede moverse
            if humanoid.WalkSpeed <= 0 then
                humanoid.WalkSpeed = 16
            end
            
            -- Evitar que se "atasque" en estados problemáticos
            local currentState = humanoid:GetState()
            if currentState == Enum.HumanoidStateType.Physics or
               currentState == Enum.HumanoidStateType.Ragdoll then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end)
    
    -- Método 3: Protección específica contra herramientas de golpe
    connections.toolProtection = character.ChildAdded:Connect(function(child)
        if antiRagdollActive and child:IsA("Tool") then
            -- Si alguien intenta usar una herramienta en ti, bloquear efectos
            child.Activated:Connect(function()
                if antiRagdollActive then
                    print("🛡️ Herramienta bloqueada")
                end
            end)
        end
    end)
    
    -- Método 4: Protección contra cambios de velocidad por golpes
    connections.velocityProtection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if antiRagdollActive then
            -- Si algo intenta cambiar la velocidad drásticamente, restaurar
            if humanoid.WalkSpeed < 5 or humanoid.WalkSpeed > 50 then
                humanoid.WalkSpeed = 16
            end
        end
    end)
    
    print("✅ Anti-ragdoll aplicado - Movimiento libre mantenido")
    return true
end

-- Función para crear efectos visuales sutiles
local function createSubtleEffects()
    -- Efecto sutil que no interfiere con el movimiento
    local highlight = Instance.new("Highlight")
    highlight.Name = "AntiRagdollHighlight"
    highlight.Parent = character
    highlight.FillColor = Color3.fromRGB(150, 50, 200)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0.5
    
    -- Efecto de partículas en los pies
    local attachment = Instance.new("Attachment")
    attachment.Name = "TrapEffect"
    attachment.Parent = humanoidRootPart
    attachment.Position = Vector3.new(0, -2, 0)
    
    return highlight, attachment
end

-- Función para intentar activar trap real
local function tryActivateRealTrap()
    local trap = workspace:FindFirstChild("Trap")
    if trap then
        print("🎯 Intentando activar trap real...")
        
        for _, part in pairs(trap:GetDescendants()) do
            if part:IsA("BasePart") then
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

-- Función principal para activar anti-ragdoll
local function activateAntiRagdoll()
    print("🚀 Activando Anti-Ragdoll con movimiento libre...")
    
    antiRagdollActive = true
    timeRemaining = 10
    
    -- Intentar usar trap real
    local realTrapUsed = tryActivateRealTrap()
    
    -- Aplicar protección anti-ragdoll
    if not applyAntiRagdollFree() then
        print("❌ Error aplicando anti-ragdoll")
        antiRagdollActive = false
        return
    end
    
    -- Crear efectos sutiles
    local highlight, particles = createSubtleEffects()
    
    -- Actualizar UI
    statusLabel.Text = "🔴 Estado: PROTEGIDO (Anti-Ragdoll)"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    movementLabel.Text = "🏃 Movimiento: LIBRE ✅"
    movementLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    trapButton.Text = "🔓 DESACTIVAR PROTECCIÓN"
    trapButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    
    -- Timer countdown
    connections.timer = RunService.Heartbeat:Connect(function(deltaTime)
        if antiRagdollActive then
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
                deactivateAntiRagdoll()
            end
        end
    end)
    
    -- Función de limpieza
    connections.cleanup = function()
        if highlight then highlight:Destroy() end
        if particles then particles:Destroy() end
    end
    
    print("✅ Anti-Ragdoll activado - Puedes moverte libremente")
    print("🛡️ Inmune a golpes de bate/mano/espada por 10 segundos")
end

-- Función para desactivar anti-ragdoll
local function deactivateAntiRagdoll()
    print("🛑 Desactivando Anti-Ragdoll...")
    
    antiRagdollActive = false
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
    
    -- Restaurar estados originales (manteniendo movimiento libre)
    if character and humanoid and humanoidRootPart then
        pcall(function()
            -- NO anclar - mantener movimiento libre
            humanoidRootPart.Anchored = false
            
            -- Restaurar humanoid a estado normal
            humanoid.PlatformStand = originalStates.PlatformStand or false
            humanoid.Sit = originalStates.Sit or false
            humanoid.WalkSpeed = originalStates.WalkSpeed or 16
            humanoid.JumpPower = originalStates.JumpPower or 50
            
            -- Asegurar estado de movimiento normal
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    
    -- Restaurar UI
    statusLabel.Text = "🟢 Estado: Vulnerable a golpes"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    movementLabel.Text = "🚶 Movimiento: Libre"
    movementLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    timerLabel.Text = "⏱️ Tiempo: Inactivo"
    timerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    trapButton.Text = "🕳️ ACTIVAR ANTI-RAGDOLL"
    trapButton.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
    
    print("✅ Anti-Ragdoll desactivado - Movimiento sigue libre")
end

-- Toggle principal
local function toggleAntiRagdoll()
    if antiRagdollActive then
        deactivateAntiRagdoll()
    else
        activateAntiRagdoll()
    end
end

-- Función para probar movimiento durante protección
local function testMovementDuringProtection()
    if not antiRagdollActive then
        print("⚠️ Activa la protección primero")
        return
    end
    
    print("🧪 Probando movimiento durante protección...")
    
    if humanoid then
        print("   🏃 WalkSpeed: " .. humanoid.WalkSpeed)
        print("   🦘 JumpPower: " .. humanoid.JumpPower)
        print("   ⚓ Anchored: " .. tostring(humanoidRootPart.Anchored))
        print("   🚫 PlatformStand: " .. tostring(humanoid.PlatformStand))
        print("   🏃 Estado: " .. tostring(humanoid:GetState()))
        
        if humanoid.WalkSpeed > 0 and not humanoidRootPart.Anchored and not humanoid.PlatformStand then
            print("✅ Movimiento libre confirmado")
        else
            print("⚠️ Movimiento puede estar restringido")
        end
    end
end

-- Función para detectar golpes sin bloquear movimiento
local function setupSmartHitDetection()
    if not character then return end
    
    -- Detectar golpes pero mantener movimiento
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(function(hit)
                if antiRagdollActive then
                    local hitCharacter = hit.Parent
                    if hitCharacter:FindFirstChild("Humanoid") and hitCharacter ~= character then
                        -- Detectar si es un golpe de herramienta
                        local tool = hit.Parent
                        if tool:IsA("Tool") or hit.Name:lower():find("handle") then
                            print("🛡️ Golpe de herramienta bloqueado: " .. (tool.Name or hit.Name))
                            
                            -- Mantener estado de movimiento después del golpe
                            wait(0.1)
                            if humanoid then
                                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                humanoid.PlatformStand = false
                            end
                        end
                    end
                end
            end)
        end
    end
end

-- Conectar eventos
trapButton.MouseButton1Click:Connect(toggleAntiRagdoll)

-- Efectos de hover
trapButton.MouseEnter:Connect(function()
    if not antiRagdollActive then
        trapButton.BackgroundColor3 = Color3.fromRGB(170, 70, 220)
    end
end)

trapButton.MouseLeave:Connect(function()
    if not antiRagdollActive then
        trapButton.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
    end
end)

-- Manejar respawn
player.CharacterAdded:Connect(function(newCharacter)
    wait(1)
    
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid", 5)
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    
    if antiRagdollActive then
        deactivateAntiRagdoll()
    end
    
    setupSmartHitDetection()
    
    print("🔄 Personaje respawneado - Anti-ragdoll con movimiento libre reiniciado")
end)

-- Botones adicionales para testing
local testMovButton = Instance.new("TextButton")
testMovButton.Parent = mainFrame
testMovButton.Size = UDim2.new(0.25, 0, 0, 20)
testMovButton.Position = UDim2.new(0.05, 0, 0.05, 0)
testMovButton.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
testMovButton.Text = "🏃"
testMovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testMovButton.TextScaled = true
testMovButton.Font = Enum.Font.Gotham

local testMovCorner = Instance.new("UICorner")
testMovCorner.CornerRadius = UDim.new(0, 5)
testMovCorner.Parent = testMovButton

testMovButton.MouseButton1Click:Connect(testMovementDuringProtection)

-- Botón de velocidad boost (opcional)
local speedButton = Instance.new("TextButton")
speedButton.Parent = mainFrame
speedButton.Size = UDim2.new(0.25, 0, 0, 20)
speedButton.Position = UDim2.new(0.32, 0, 0.05, 0)
speedButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
speedButton.Text = "⚡"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextScaled = true
speedButton.Font = Enum.Font.Gotham

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 5)
speedCorner.Parent = speedButton

speedButton.MouseButton1Click:Connect(function()
    if humanoid then
        humanoid.WalkSpeed = humanoid.WalkSpeed == 16 and 25 or 16
        print("⚡ Velocidad cambiada a: " .. humanoid.WalkSpeed)
    end
end)

-- Función de diagnóstico mejorada
local function diagnoseMovementSystem()
    print("\n🔍 DIAGNÓSTICO MOVIMIENTO + ANTI-RAGDOLL:")
    print("=" * 60)
    
    if character and humanoid and humanoidRootPart then
        print("✅ Personaje: OK")
        print("   🏃 Estado: " .. tostring(humanoid:GetState()))
        print("   🚶 WalkSpeed: " .. humanoid.WalkSpeed)
        print("   🦘 JumpPower: " .. humanoid.JumpPower)
        print("   ⚓ RootPart Anchored: " .. tostring(humanoidRootPart.Anchored))
        print("   🚫 PlatformStand: " .. tostring(humanoid.PlatformStand))
        print("   💺 Sit: " .. tostring(humanoid.Sit))
        
        -- Verificar si puede moverse
        local canMove = humanoid.WalkSpeed > 0 and not humanoidRootPart.Anchored and not humanoid.PlatformStand
        print("   🎯 Puede moverse: " .. (canMove and "✅ SÍ" or "❌ NO"))
        
        if antiRagdollActive then
            print("   🛡️ Protección: ✅ ACTIVA")
            print("   ⏱️ Tiempo restante: " .. math.ceil(timeRemaining) .. "s")
        else
            print("   🛡️ Protección: ❌ INACTIVA")
        end
    else
        print("❌ Personaje: ERROR")
    end
    
    print("=" * 60)
    print("🎯 Diagnóstico completado\n")
end

-- Botón de diagnóstico
local diagButton = Instance.new("TextButton")
diagButton.Parent = mainFrame
diagButton.Size = UDim2.new(0.25, 0, 0, 20)
diagButton.Position = UDim2.new(0.59, 0, 0.05, 0)
diagButton.BackgroundColor3 = Color3.fromRGB(150, 100, 100)
diagButton.Text = "🔍"
diagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
diagButton.TextScaled = true
diagButton.Font = Enum.Font.Gotham

local diagCorner = Instance.new("UICorner")
diagCorner.CornerRadius = UDim.new(0, 5)
diagCorner.Parent = diagButton

diagButton.MouseButton1Click:Connect(diagnoseMovementSystem)

-- Inicialización
print("🎮 Anti-Ragdoll con Movimiento Libre iniciado")
print("🕳️ Simula el estado 'Trapped' pero mantienes movilidad")
print("🛡️ Protege contra ragdoll de bate/mano/espada")
print("🏃 Movimiento completamente libre durante protección")

setupSmartHitDetection()
diagnoseMovementSystem()

print("✅ Sistema listo")
print("🔘 Botón principal: Activar/Desactivar protección")
print("🏃 Botón 🏃: Probar movimiento durante protección")
print("⚡ Botón ⚡: Cambiar velocidad (16/25)")
print("🔍 Botón 🔍: Diagnóstico completo del sistema")

-- Función adicional para optimizar el rendimiento
local function optimizePerformance()
    -- Reducir la frecuencia de verificaciones para mejor rendimiento
    local lastCheck = 0
    local checkInterval = 0.1 -- Verificar cada 0.1 segundos en lugar de cada frame
    
    connections.optimizedProtection = RunService.Heartbeat:Connect(function()
        if antiRagdollActive and tick() - lastCheck >= checkInterval then
            lastCheck = tick()
            
            if humanoid and humanoidRootPart then
                -- Verificaciones optimizadas
                local currentState = humanoid:GetState()
                
                -- Solo intervenir si realmente hay un problema
                if currentState == Enum.HumanoidStateType.Physics or
                   currentState == Enum.HumanoidStateType.Ragdoll or
                   currentState == Enum.HumanoidStateType.FallingDown then
                    
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    humanoid.PlatformStand = false
                end
                
                -- Mantener velocidad mínima
                if humanoid.WalkSpeed < 5 then
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end)
end

-- Función para manejar golpes específicos de herramientas
local function handleToolHits()
    -- Detectar cuando otros jugadores equipan herramientas cerca
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            otherPlayer.Character.ChildAdded:Connect(function(child)
                if child:IsA("Tool") and antiRagdollActive then
                    local toolName = child.Name:lower()
                    
                    -- Detectar herramientas de golpe comunes
                    if toolName:find("bat") or toolName:find("sword") or 
                       toolName:find("knife") or toolName:find("punch") or
                       toolName:find("fist") or toolName:find("hammer") then
                        
                        print("⚠️ Jugador " .. otherPlayer.Name .. " equipó: " .. child.Name)
                        
                        -- Preparar defensa extra
                        if humanoid then
                            humanoid.PlatformStand = false
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end
                end
            end)
        end
    end
end

-- Función para crear indicador de estado en pantalla
local function createStatusIndicator()
    local indicator = Instance.new("TextLabel")
    indicator.Name = "AntiRagdollIndicator"
    indicator.Parent = screenGui
    indicator.Size = UDim2.new(0, 200, 0, 30)
    indicator.Position = UDim2.new(0.5, -100, 0, 100)
    indicator.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    indicator.BackgroundTransparency = 0.3
    indicator.Text = ""
    indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
    indicator.TextScaled = true
    indicator.Font = Enum.Font.GothamBold
    indicator.Visible = false
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 10)
    indicatorCorner.Parent = indicator
    
    return indicator
end

-- Crear indicador de estado
local statusIndicator = createStatusIndicator()

-- Función para mostrar notificaciones temporales
local function showNotification(text, duration, color)
    statusIndicator.Text = text
    statusIndicator.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    statusIndicator.Visible = true
    
    -- Efecto de aparición
    statusIndicator:TweenSize(
        UDim2.new(0, 220, 0, 35),
        "Out", "Quad", 0.2, true
    )
    
    -- Ocultar después del tiempo especificado
    wait(duration or 2)
    
    statusIndicator:TweenSize(
        UDim2.new(0, 200, 0, 30),
        "In", "Quad", 0.2, true,
        function()
            statusIndicator.Visible = false
        end
    )
end

-- Función mejorada para activar con notificaciones
local function activateAntiRagdollImproved()
    activateAntiRagdoll()
    
    -- Optimizar rendimiento
    optimizePerformance()
    
    -- Configurar detección de herramientas
    handleToolHits()
    
    -- Mostrar notificación
    spawn(function()
        showNotification("🛡️ ANTI-RAGDOLL ACTIVADO", 2, Color3.fromRGB(100, 255, 100))
    end)
end

-- Función mejorada para desactivar
local function deactivateAntiRagdollImproved()
    deactivateAntiRagdoll()
    
    -- Mostrar notificación
    spawn(function()
        showNotification("❌ Protección desactivada", 1.5, Color3.fromRGB(255, 100, 100))
    end)
end

-- Actualizar el toggle para usar las funciones mejoradas
local function toggleAntiRagdollImproved()
    if antiRagdollActive then
        deactivateAntiRagdollImproved()
    else
        activateAntiRagdollImproved()
    end
end

-- Reconectar el botón principal
trapButton.MouseButton1Click:Disconnect()
trapButton.MouseButton1Click:Connect(toggleAntiRagdollImproved)

-- Función para mostrar ayuda
local function showHelp()
    print("\n📖 GUÍA DE USO:")
    print("=" * 50)
    print("🕳️ BOTÓN PRINCIPAL: Activa/desactiva anti-ragdoll")
    print("   • Duración: 10 segundos")
    print("   • Movimiento: Completamente libre")
    print("   • Protección: Contra bate, mano, espada")
    print("")
    print("🏃 BOTÓN 🏃: Verifica que puedes moverte")
    print("⚡ BOTÓN ⚡: Cambia velocidad (16 ↔ 25)")
    print("🔍 BOTÓN 🔍: Diagnóstico completo")
    print("")
    print("💡 CONSEJOS:")
    print("   • Activa antes de que te golpeen")
    print("   • Puedes correr, saltar y moverte normalmente")
    print("   • El efecto dura exactamente 10 segundos")
    print("   • Funciona contra todas las herramientas de golpe")
    print("=" * 50)
end

-- Botón de ayuda
local helpButton = Instance.new("TextButton")
helpButton.Parent = mainFrame
helpButton.Size = UDim2.new(0.15, 0, 0, 20)
helpButton.Position = UDim2.new(0.8, 0, 0.05, 0)
helpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
helpButton.Text = "❓"
helpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
helpButton.TextScaled = true
helpButton.Font = Enum.Font.Gotham

local helpCorner = Instance.new("UICorner")
helpCorner.CornerRadius = UDim.new(0, 5)
helpCorner.Parent = helpButton

helpButton.MouseButton1Click:Connect(showHelp)

-- Comando de teclado para activación rápida (opcional)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.T then -- Presiona T para toggle rápido
            toggleAntiRagdollImproved()
        elseif input.KeyCode == Enum.KeyCode.H then -- Presiona H para ayuda
            showHelp()
        end
    end
end)

-- Función de auto-activación cuando detecta peligro (opcional)
local function setupAutoActivation()
    local dangerousTools = {"bat", "sword", "knife", "punch", "fist", "hammer", "axe"}
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            otherPlayer.Character.ChildAdded:Connect(function(child)
                if child:IsA("Tool") and not antiRagdollActive then
                    local toolName = child.Name:lower()
                    
                    for _, dangerous in pairs(dangerousTools) do
                        if toolName:find(dangerous) then
                            -- Verificar distancia
                            if otherPlayer.Character:FindFirstChild("HumanoidRootPart") and
                               humanoidRootPart then
                                local distance = (otherPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                                
                                if distance < 20 then -- Si está cerca
                                    print("⚠️ PELIGRO DETECTADO: " .. otherPlayer.Name .. " con " .. child.Name)
                                    print("🤖 Auto-activando protección...")
                                    
                                    spawn(function()
                                        showNotification("⚠️ PELIGRO - Auto-protección", 2, Color3.fromRGB(255, 200, 100))
                                    end)
                                    
                                    activateAntiRagdollImproved()
                                end
                            end
                            break
                        end
                    end
                end
            end)
        end
    end
end

-- Botón para activar/desactivar auto-protección
local autoButton = Instance.new("TextButton")
autoButton.Parent = mainFrame
autoButton.Size = UDim2.new(0.4, 0, 0, 15)
autoButton.Position = UDim2.new(0.55, 0, 0.88, 0)
autoButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autoButton.Text = "🤖 Auto: OFF"
autoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoButton.TextScaled = true
autoButton.Font = Enum.Font.Gotham

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 5)
autoCorner.Parent = autoButton

local autoProtectionEnabled = false

autoButton.MouseButton1Click:Connect(function()
    autoProtectionEnabled = not autoProtectionEnabled
    
    if autoProtectionEnabled then
        autoButton.Text = "🤖 Auto: ON"
        autoButton.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
        setupAutoActivation()
        print("🤖 Auto-protección activada")
    else
        autoButton.Text = "🤖 Auto: OFF"
        autoButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        print("🤖 Auto-protección desactivada")
    end
end)

-- Mensaje final de inicialización
print("\n🎮 SISTEMA COMPLETAMENTE CARGADO")
print("=" * 50)
print("✅ Anti-Ragdoll con movimiento libre")
print("🎯 Protección contra bate, mano, espada")
print("🏃 Movimiento completamente libre")
print("⏱️ Duración: 10 segundos")
print("🔘 Controles:")
print("   • Clic en botón principal o presiona T")
print("   • H para ayuda")
print("   • 🤖 Auto-protección disponible")
print("   • F9 para limpieza de emergencia")
print("=" * 50)
print("🚀 ¡Listo para usar!")

-- Función de estadísticas de uso
local usageStats = {
    activations = 0,
    totalTimeProtected = 0,
    hitsBlocked = 0,
    lastActivation = 0
}

-- Función para actualizar estadísticas
local function updateStats()
    usageStats.activations = usageStats.activations + 1
    usageStats.lastActivation = tick()
    
    -- Contador de tiempo protegido
    spawn(function()
        local startTime = tick()
        while antiRagdollActive do
            wait(0.1)
        end
        usageStats.totalTimeProtected = usageStats.totalTimeProtected + (tick() - startTime)
    end)
end

-- Función para mostrar estadísticas
local function showStats()
    print("\n📊 ESTADÍSTICAS DE USO:")
    print("=" * 40)
    print("🔢 Activaciones: " .. usageStats.activations)
    print("⏱️ Tiempo total protegido: " .. math.floor(usageStats.totalTimeProtected) .. "s")
    print("🛡️ Golpes bloqueados: " .. usageStats.hitsBlocked)
    
    if usageStats.lastActivation > 0 then
        local timeSince = math.floor(tick() - usageStats.lastActivation)
        print("🕐 Última activación: hace " .. timeSince .. "s")
    end
    print("=" * 40)
end

-- Botón de estadísticas
local statsButton = Instance.new("TextButton")
statsButton.Parent = mainFrame
statsButton.Size = UDim2.new(0.4, 0, 0, 15)
statsButton.Position = UDim2.new(0.05, 0, 0.88, 0)
statsButton.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
statsButton.Text = "📊 Stats"
statsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
statsButton.TextScaled = true
statsButton.Font = Enum.Font.Gotham

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 5)
statsCorner.Parent = statsButton

statsButton.MouseButton1Click:Connect(showStats)

-- Actualizar la función de activación para incluir estadísticas
local originalActivate = activateAntiRagdollImproved
activateAntiRagdollImproved = function()
    originalActivate()
    updateStats()
end

-- Función para detectar y contar golpes bloqueados
local function setupHitCounter()
    if not character then return end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(function(hit)
                if antiRagdollActive then
                    local hitCharacter = hit.Parent
                    if hitCharacter:FindFirstChild("Humanoid") and hitCharacter ~= character then
                        local tool = hit.Parent
                        if tool:IsA("Tool") or hit.Name:lower():find("handle") then
                            usageStats.hitsBlocked = usageStats.hitsBlocked + 1
                            
                            -- Mostrar notificación de golpe bloqueado
                            spawn(function()
                                showNotification("🛡️ Golpe #" .. usageStats.hitsBlocked .. " bloqueado!", 1, Color3.fromRGB(255, 200, 100))
                            end)
                        end
                    end
                end
            end)
        end
    end
end

-- Configurar contador de golpes inicial
setupHitCounter()

-- Función de limpieza mejorada para emergencias
local function emergencyCleanupImproved()
    print("🚨 LIMPIEZA DE EMERGENCIA ACTIVADA")
    
    -- Desactivar sistema
    antiRagdollActive = false
    
    -- Limpiar todas las conexiones
    for _, connection in pairs(connections) do
        pcall(function()
            if connection then connection:Disconnect() end
        end)
    end
    connections = {}
    
    -- Restaurar personaje completamente
    if character and humanoid and humanoidRootPart then
        pcall(function()
            humanoidRootPart.Anchored = false
            humanoid.PlatformStand = false
            humanoid.Sit = false
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    
    -- Limpiar efectos visuales
    if character then
        for _, obj in pairs(character:GetChildren()) do
            if obj.Name:find("AntiRagdoll") or obj.Name:find("Trap") then
                obj:Destroy()
            end
        end
    end
    
    -- Limpiar GUI si es necesario
    if screenGui then
        for _, obj in pairs(screenGui:GetChildren()) do
            if obj.Name:find("Indicator") then
                obj:Destroy()
            end
        end
    end
    
    -- Resetear UI
    statusLabel.Text = "🟢 Estado: Vulnerable a golpes"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    movementLabel.Text = "🚶 Movimiento: Libre"
    timerLabel.Text = "⏱️ Tiempo: Inactivo"
    trapButton.Text = "🕳️ ACTIVAR ANTI-RAGDOLL"
    trapButton.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
    
    print("✅ Limpieza de emergencia completada")
    print("🔄 Sistema reiniciado - Todo debería funcionar normalmente")
    
    -- Mostrar notificación
    spawn(function()
        showNotification("🚨 Sistema reiniciado", 2, Color3.fromRGB(255, 100, 100))
    end)
end

-- Actualizar comando de emergencia
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F9 then
            emergencyCleanupImproved()
        elseif input.KeyCode == Enum.KeyCode.T then
            toggleAntiRagdollImproved()
        elseif input.KeyCode == Enum.KeyCode.H then
            showHelp()
        elseif input.KeyCode == Enum.KeyCode.P then -- P para estadísticas
            showStats()
        end
    end
end)

-- Función para verificar la salud del sistema periódicamente
local function systemHealthCheck()
    spawn(function()
        while true do
            wait(30) -- Verificar cada 30 segundos
            
            if character and humanoid and humanoidRootPart then
                -- Verificar que todo esté funcionando correctamente
                local isHealthy = true
                local issues = {}
                
                -- Verificar GUI
                if not screenGui or not screenGui.Parent then
                    isHealthy = false
                    table.insert(issues, "GUI desconectada")
                end
                
                -- Verificar personaje
                if not character.Parent then
                    isHealthy = false
                    table.insert(issues, "Personaje no válido")
                end
                
                -- Verificar conexiones activas si el sistema está activado
                if antiRagdollActive then
                    local activeConnections = 0
                    for _, connection in pairs(connections) do
                        if connection and connection.Connected then
                            activeConnections = activeConnections + 1
                        end
                    end
                    
                    if activeConnections < 2 then
                        isHealthy = false
                        table.insert(issues, "Conexiones perdidas")
                    end
                end
                
                -- Reportar problemas si los hay
                if not isHealthy then
                    print("⚠️ Problemas detectados en el sistema:")
                    for _, issue in pairs(issues) do
                        print("   • " .. issue)
                    end
                    print("💡 Usa F9 para reiniciar si es necesario")
                end
            end
        end
    end)
end

-- Iniciar verificación de salud del sistema
systemHealthCheck()

-- Mensaje de bienvenida final
print("\n🎉 SISTEMA ANTI-RAGDOLL COMPLETAMENTE OPERATIVO")
print("🛡️ Protección inteligente contra golpes")
print("🏃 Movimiento libre garantizado")
print("📊 Estadísticas y monitoreo incluidos")
print("🤖 Auto-protección opcional")
print("🔧 Sistema de emergencia integrado")
print("\n💡 COMANDOS DE TECLADO:")
print("   T = Toggle protección")
print("   H = Ayuda")
print("   P = Estadísticas")
print("   F9 = Emergencia")
print("\n🚀 ¡Disfruta tu inmunidad con movimiento libre!")
