-- Anti-Hit GUI Script para Steal a Brainrot (Sistema Nativo del Gancho)
-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiHitGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Crear Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Anti-Hit Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold

-- Botón Anti-Hit
local antiHitButton = Instance.new("TextButton")
antiHitButton.Name = "AntiHitButton"
antiHitButton.Parent = mainFrame
antiHitButton.Size = UDim2.new(0.8, 0, 0, 40)
antiHitButton.Position = UDim2.new(0.1, 0, 0.4, 0)
antiHitButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
antiHitButton.Text = "Anti-Hit: OFF"
antiHitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
antiHitButton.TextScaled = true
antiHitButton.Font = Enum.Font.SourceSansBold

-- Esquinas redondeadas para el botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = antiHitButton

-- Variables de estado
local antiHitEnabled = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hookConnection = nil
local originalHookPart = nil

-- Función para encontrar la trampa exacta en el workspace
local function findTrapInWorkspace()
    local trap = nil
    
    -- Buscar específicamente "Trap" en workspace (como vimos en Dex)
    trap = workspace:FindFirstChild("Trap")
    if trap then
        print("Trampa encontrada en workspace: " .. trap.Name)
        return trap
    end
    
    -- Buscar en todos los descendientes por si está anidada
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Trap" then
            trap = obj
            print("Trampa encontrada: " .. obj:GetFullName())
            break
        end
    end
    
    -- Buscar por otras variaciones si no encuentra "Trap" exacto
    if not trap then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (
                obj.Name:lower() == "trap" or
                obj.Name == "TrapModel" or
                obj.Name == "TrapPart" or
                (obj:FindFirstChild("TrapScript") and obj:IsA("BasePart"))
            ) then
                trap = obj
                print("Trampa encontrada por script: " .. obj:GetFullName())
                break
            end
        end
    end
    
    if not trap then
        print("No se encontró trampa. Asegúrate de haber colocado una trampa primero.")
    end
    
    return trap
end

-- Función para simular pisar la trampa específica encontrada
local function simulateTrapStep()
    local trap = findTrapInWorkspace()
    
    if trap then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Verificar si la trampa tiene el evento Touched
            if trap.Touched then
                -- Disparar el evento Touched de la trampa real
                trap.Touched:Fire(humanoidRootPart)
                originalHookPart = trap
                print("Simulando toque en trampa: " .. trap:GetFullName())
                
                -- También intentar activar cualquier script que tenga
                local trapScript = trap:FindFirstChild("TrapScript")
                if trapScript then
                    print("TrapScript encontrado en la trampa")
                end
                
                return true
            else
                print("La trampa no tiene evento Touched disponible")
            end
        end
    end
    
    return false
end

-- Función para mantener el efecto de la trampa activo
local function maintainTrapEffect()
    if originalHookPart and originalHookPart.Parent then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Reactivar el toque cada pocos frames para mantener el efecto
            originalHookPart.Touched:Fire(humanoidRootPart)
        end
    end
end

-- Función para activar/desactivar Anti-Hit
local function toggleAntiHit()
    antiHitEnabled = not antiHitEnabled
    
    if antiHitEnabled then
        -- Activar Anti-Hit usando el sistema nativo del juego
        antiHitButton.Text = "Anti-Hit: ON"
        antiHitButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
        
        -- Intentar simular el gancho real
        local success = simulateHookStep()
        
        if success then
            -- Mantener el efecto activo
            hookConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if antiHitEnabled then
                    maintainHookEffect()
                    
                    -- Asegurar que el jugador pueda moverse
                    if humanoid then
                        humanoid.PlatformStand = false
                        humanoid.Sit = false
                    end
                end
            end)
            
            print("Anti-Hit activado - Sistema nativo del gancho simulado")
        else
            -- Fallback: método manual si no encontramos el gancho
            print("Gancho no encontrado, usando método alternativo...")
            
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                humanoid.PlatformStand = false
            end
            
            -- Crear efecto de inmunidad manual
            hookConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if antiHitEnabled and humanoid then
                    humanoid.Health = math.huge
                    humanoid.PlatformStand = false
                end
            end)
        end
        
    else
        -- Desactivar Anti-Hit
        antiHitButton.Text = "Anti-Hit: OFF"
        antiHitButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        
        -- Desconectar el mantenimiento del efecto
        if hookConnection then
            hookConnection:Disconnect()
            hookConnection = nil
        end
        
        -- Restaurar valores normales
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid.PlatformStand = false
        end
        
        originalHookPart = nil
        print("Anti-Hit desactivado - Vulnerable normalmente")
    end
end

-- Conectar el botón
antiHitButton.MouseButton1Click:Connect(toggleAntiHit)

-- Reconectar cuando el personaje respawnee
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    -- Si Anti-Hit estaba activado, reactivarlo
    if antiHitEnabled then
        antiHitEnabled = false -- Resetear para que toggleAntiHit lo active correctamente
        wait(1) -- Esperar a que el personaje cargue completamente
        toggleAntiHit()
    end
end)

print("Anti-Hit GUI cargado - Buscando sistema nativo de trampas...")
