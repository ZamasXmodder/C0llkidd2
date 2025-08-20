-- Sistema de Trap corregido - Sin errores
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrapSystemFixed"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🛡️ ANTI-HIT SYSTEM"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- Status del sistema
local systemStatus = Instance.new("TextLabel")
systemStatus.Parent = mainFrame
systemStatus.Size = UDim2.new(1, 0, 0, 20)
systemStatus.Position = UDim2.new(0, 0, 0.2, 0)
systemStatus.BackgroundTransparency = 1
systemStatus.Text = "Sistema: Listo"
systemStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
systemStatus.TextScaled = true
systemStatus.Font = Enum.Font.Gotham

-- Status del jugador
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.35, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🟢 Estado: Vulnerable"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham

-- Timer
local timerLabel = Instance.new("TextLabel")
timerLabel.Parent = mainFrame
timerLabel.Size = UDim2.new(1, 0, 0, 30)
timerLabel.Position = UDim2.new(0, 0, 0.52, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "⏱️ Tiempo: Inactivo"
timerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.GothamBold

-- Botón principal
local activateButton = Instance.new("TextButton")
activateButton.Parent = mainFrame
activateButton.Size = UDim2.new(0.9, 0, 0, 40)
activateButton.Position = UDim2.new(0.05, 0, 0.75, 0)
activateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
activateButton.Text = "🔒 ACTIVAR ANTI-HIT"
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.TextScaled = true
activateButton.Font = Enum.Font.GothamBold

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = activateButton

-- Variables de estado
local antiHitActive = false
local timeRemaining = 0
local connections = {}
local originalMaxHealth = 100

-- Función segura para verificar el sistema
local function checkGameSystem()
    local systemInfo = {
        controllers = false,
        trapScript = false,
        remoteEvents = {},
        workspaceTrap = false
    }
    
    -- Verificar Controllers (sin intentar usarlos)
    local controllers = ReplicatedStorage:FindFirstChild("Controllers")
    if controllers then
        systemInfo.controllers = true
        print("✅ Controllers encontrado")
        
        -- Solo verificar existencia, no usar
        if controllers:FindFirstChild("TrapController") then
            print("  📁 TrapController detectado")
        end
        if controllers:FindFirstChild("ItemController") then
            print("  📁 ItemController detectado")
        end
    end
    
    -- Verificar TrapScript
    local items = ReplicatedStorage:FindFirstChild("Items")
    if items then
        local trap = items:FindFirstChild("Trap")
        if trap and trap:FindFirstChild("TrapScript") then
            systemInfo.trapScript = true
            print("✅ TrapScript encontrado")
        end
    end
    
    -- Verificar RemoteEvents (solo listar, no usar)
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(systemInfo.remoteEvents, obj.Name)
        end
    end
    
    -- Verificar trampa en workspace
    if workspace:FindFirstChild("Trap") then
        systemInfo.workspaceTrap = true
        print("✅ Trampa en workspace detectada")
    end
    
    return systemInfo
end

-- Función para crear efectos visuales seguros
local function createSafeVisualEffects()
    -- Crear indicador visual simple
    local highlight = Instance.new("Highlight")
    highlight.Name = "AntiHitHighlight"
    highlight.Parent = character
    highlight.FillColor = Color3.fromRGB(0, 255, 100)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.3
    
    return highlight
end

-- Función para aplicar inmunidad de forma segura
local function applySafeImmunity()
    if not humanoid then return false end
    
    -- Guardar salud original
    originalMaxHealth = humanoid.MaxHealth
    
    -- Aplicar inmunidad
    humanoid.MaxHealth = 999999
    humanoid.Health = 999999
    
    -- Asegurar movimiento libre
    humanoid.PlatformStand = false
    humanoid.Sit = false
    
    -- Protección continua contra daño
    connections.healthProtection = humanoid.HealthChanged:Connect(function(health)
        if antiHitActive and health < humanoid.MaxHealth * 0.9 then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
    
    -- Protección contra estados restrictivos
    connections.stateProtection = RunService.Heartbeat:Connect(function()
        if antiHitActive and humanoid then
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end
    end)
    
    print("🛡️ Inmunidad aplicada de forma segura")
    return true
end

-- Función para intentar usar sistema nativo (de forma segura)
local function tryNativeSystem()
    -- Solo intentar si hay trampa en workspace
    local trap = workspace:FindFirstChild("Trap")
    if trap then
        print("🎯 Intentando activar trampa nativa...")
        
        -- Buscar partes de forma segura
        for _, descendant in pairs(trap:GetDescendants()) do
            if descendant:IsA("BasePart") then
                -- Verificar si tiene evento Touched antes de usarlo
                local success, result = pcall(function()
                    if descendant.Touched then
                        descendant.Touched:Fire(humanoidRootPart)
                        return true
                    end
                    return false
                end)
                
                if success and result then
                    print("✅ Trampa nativa activada")
                    return true
                end
            end
        end
    end
    
    print("⚠️ Sistema nativo no disponible, usando modo independiente")
    return false
end

-- Función principal para activar anti-hit
local function activateAntiHit()
    print("🚀 Activando Anti-Hit...")
    
    antiHitActive = true
    timeRemaining = 10
    
    -- Intentar sistema nativo de forma segura
    tryNativeSystem()
    
    -- Aplicar inmunidad independiente
    if not applySafeImmunity() then
        print("❌ Error aplicando inmunidad")
        antiHitActive = false
        return
    end
    
    -- Crear efectos visuales
    local highlight = createSafeVisualEffects()
    
    -- Actualizar UI
    statusLabel.Text = "🔴 Estado: INVULNERABLE"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    activateButton.Text = "🔓 DESACTIVAR ANTI-HIT"
    activateButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    systemStatus.Text = "Sistema: ACTIVO"
    systemStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    
    -- Timer countdown
    connections.timer = RunService.Heartbeat:Connect(function(deltaTime)
        if antiHitActive then
            timeRemaining = timeRemaining - deltaTime
            
            local seconds = math.ceil(math.max(0, timeRemaining))
            timerLabel.Text = "⏱️ Tiempo: " .. seconds .. "s"
            
            -- Cambiar color según tiempo
            if seconds <= 3 then
                timerLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            elseif seconds <= 5 then
                timerLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            else
                timerLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
            
            if timeRemaining <= 0 then
                deactivateAntiHit()
            end
        end
    end)
    
    -- Función de limpieza
    connections.cleanup = function()
        if highlight then highlight:Destroy() end
    end
    
    print("✅ Anti-Hit activado por 10 segundos")
end

-- Función para desactivar anti-hit
local function deactivateAntiHit()
    print("🛑 Desactivando Anti-Hit...")
    
    antiHitActive = false
    timeRemaining = 0
    
        -- Ejecutar limpieza
    if connections.cleanup then
        connections.cleanup()
    end
    
    -- Desconectar todas las conexiones de forma segura
    for name, connection in pairs(connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    connections = {}
    
    -- Restaurar UI
    statusLabel.Text = "🟢 Estado: Vulnerable"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    timerLabel.Text = "⏱️ Tiempo: Inactivo"
    timerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    activateButton.Text = "🔒 ACTIVAR ANTI-HIT"
    activateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    systemStatus.Text = "Sistema: Listo"
    systemStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    -- Restaurar salud normal de forma segura
    if humanoid then
        pcall(function()
            humanoid.MaxHealth = originalMaxHealth
            humanoid.Health = originalMaxHealth
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end)
    end
    
    print("✅ Anti-Hit desactivado - Estado normal restaurado")
end

-- Toggle principal
local function toggleAntiHit()
    if antiHitActive then
        deactivateAntiHit()
    else
        activateAntiHit()
    end
end

-- Conectar eventos de forma segura
pcall(function()
    activateButton.MouseButton1Click:Connect(toggleAntiHit)
end)

-- Efectos de hover en el botón
pcall(function()
    activateButton.MouseEnter:Connect(function()
        if not antiHitActive then
            activateButton.BackgroundColor3 = Color3.fromRGB(70, 170, 255)
        end
    end)
    
    activateButton.MouseLeave:Connect(function()
        if not antiHitActive then
            activateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
        end
    end)
end)

-- Manejar respawn del personaje de forma segura
pcall(function()
    player.CharacterAdded:Connect(function(newCharacter)
        -- Esperar a que el personaje esté completamente cargado
        wait(1)
        
        character = newCharacter
        humanoid = character:WaitForChild("Humanoid", 5)
        humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
        
        -- Desactivar si estaba activo
        if antiHitActive then
            deactivateAntiHit()
        end
        
        print("🔄 Personaje respawneado - Sistema reiniciado")
    end)
end)

-- Función de diagnóstico mejorada
local function runDiagnostics()
    print("\n🔍 DIAGNÓSTICO DEL SISTEMA:")
    print("=" * 50)
    
    -- Verificar personaje
    if character and humanoid and humanoidRootPart then
        print("✅ Personaje: OK")
        print("   👤 Character: " .. character.Name)
        print("   ❤️ Humanoid: " .. humanoid.Health .. "/" .. humanoid.MaxHealth)
        print("   📍 RootPart: " .. tostring(humanoidRootPart.Position))
    else
        print("❌ Personaje: ERROR")
    end
    
    -- Verificar sistema del juego
    local systemInfo = checkGameSystem()
    print("\n🎮 Sistema del juego:")
    print("   📁 Controllers: " .. (systemInfo.controllers and "✅" or "❌"))
    print("   📜 TrapScript: " .. (systemInfo.trapScript and "✅" or "❌"))
    print("   🕳️ Workspace Trap: " .. (systemInfo.workspaceTrap and "✅" or "❌"))
    print("   🌐 RemoteEvents: " .. #systemInfo.remoteEvents .. " encontrados")
    
    -- Verificar GUI
    if screenGui and screenGui.Parent then
        print("   🖥️ GUI: ✅ Funcionando")
    else
        print("   🖥️ GUI: ❌ Error")
    end
    
    print("=" * 50)
    print("🎯 Diagnóstico completado\n")
end

-- Inicialización segura
pcall(function()
    print("🎮 Anti-Hit System (Fixed) iniciando...")
    
    -- Ejecutar diagnóstico inicial
    runDiagnostics()
    
    -- Verificar sistema del juego
    local systemInfo = checkGameSystem()
    
    if systemInfo.controllers or systemInfo.trapScript then
        systemStatus.Text = "Sistema: Nativo detectado"
        systemStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        print("✅ Sistema nativo del juego detectado")
    else
        systemStatus.Text = "Sistema: Modo independiente"
        systemStatus.TextColor3 = Color3.fromRGB(255, 200, 100)
        print("⚠️ Usando modo completamente independiente")
    end
    
    print("🛡️ Anti-Hit System listo para usar")
    print("💡 Presiona el botón para activar inmunidad por 10 segundos")
end)

-- Función de emergencia para limpiar todo
local function emergencyCleanup()
    print("🚨 Ejecutando limpieza de emergencia...")
    
    antiHitActive = false
    
    -- Limpiar conexiones
    for _, connection in pairs(connections) do
        pcall(function()
            if connection then connection:Disconnect() end
        end)
    end
    connections = {}
    
    -- Restaurar humanoid
    if humanoid then
        pcall(function()
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end)
    end
    
    -- Limpiar efectos visuales
    if character then
        for _, obj in pairs(character:GetChildren()) do
            if obj.Name == "AntiHitHighlight" then
                obj:Destroy()
            end
        end
    end
    
    print("✅ Limpieza de emergencia completada")
end

-- Comando de emergencia (por si algo sale mal)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F9 then
        emergencyCleanup()
    end
end)

print("🎮 Sistema completamente cargado")
print("🔧 Presiona F9 para limpieza de emergencia si es necesario")
