-- Anti-Hit Sigiloso - Evita detección de anti-cheat
-- Advertencia: Usar scripts en Roblox puede resultar en baneos

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables del script
local antiHitEnabled = false
local panelOpen = false
local connections = {}
local originalCFrame = nil
local hitboxReduction = false

-- Crear la GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealthPanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Botón flotante para abrir/cerrar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "🎯"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.Gotham
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 25)
toggleCorner.Parent = toggleButton

-- Panel principal
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(1, 0, 1, 0)
mainPanel.Position = UDim2.new(0, 0, 0, 0)
mainPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainPanel.BackgroundTransparency = 0.4
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Parent = screenGui

-- Contenedor central
local centerFrame = Instance.new("Frame")
centerFrame.Size = UDim2.new(0, 380, 0, 280)
centerFrame.Position = UDim2.new(0.5, -190, 0.5, -140)
centerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
centerFrame.BorderSizePixel = 0
centerFrame.Parent = mainPanel

local centerCorner = Instance.new("UICorner")
centerCorner.CornerRadius = UDim.new(0, 12)
centerCorner.Parent = centerFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "STEALTH ANTI-HIT"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = centerFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Botón cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleLabel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton

-- Contenido
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = centerFrame

-- Botón Anti-Hit Sigiloso
local stealthButton = Instance.new("TextButton")
stealthButton.Size = UDim2.new(0.9, 0, 0, 60)
stealthButton.Position = UDim2.new(0.05, 0, 0.1, 0)
stealthButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
stealthButton.BorderSizePixel = 0
stealthButton.Text = "ANTI-HIT SIGILOSO: OFF"
stealthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stealthButton.TextScaled = true
stealthButton.Font = Enum.Font.GothamBold
stealthButton.Parent = contentFrame

local stealthCorner = Instance.new("UICorner")
stealthCorner.CornerRadius = UDim.new(0, 8)
stealthCorner.Parent = stealthButton

-- Estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Normal"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = contentFrame

-- Descripción
local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(0.9, 0, 0, 80)
descLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
descLabel.BackgroundTransparency = 1
descLabel.Text = "Método sigiloso que evita detección:\n• Hitbox reducida al mínimo\n• Movimiento impredecible sutil\n• Sin modificaciones obvias\n\nTecla: H"
descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
descLabel.TextScaled = true
descLabel.Font = Enum.Font.Gotham
descLabel.Parent = contentFrame

-- Función para reducir hitbox de forma sigilosa
local function setupStealthHitbox()
    if not player.Character then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Reducir el tamaño del HumanoidRootPart de forma muy sutil
    local originalSize = humanoidRootPart.Size
    humanoidRootPart.Size = Vector3.new(0.1, 0.1, 0.1) -- Muy pequeño
    humanoidRootPart.Transparency = 1 -- Invisible
    
    -- Crear una parte falsa visible para que parezca normal
    local fakePart = Instance.new("Part")
    fakePart.Name = "FakeRoot"
    fakePart.Size = originalSize
    fakePart.CFrame = humanoidRootPart.CFrame
    fakePart.Transparency = 1 -- También invisible, solo para referencia
    fakePart.CanCollide = false
    fakePart.Anchored = false
    fakePart.Parent = player.Character
    
    -- Weld para mantener la parte falsa conectada
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = humanoidRootPart
    weld.Part1 = fakePart
    weld.Parent = humanoidRootPart
    
    return fakePart
end

-- Función de movimiento impredecible sutil
local function startSubtleMovement()
    local counter = 0
    
    connections.movement = RunService.Heartbeat:Connect(function()
        if not antiHitEnabled then return end
        
        counter = counter + 1
        
        -- Solo cada 10 frames para ser más sutil
        if counter % 10 == 0 then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = character.HumanoidRootPart
                local humanoid = character:FindFirstChild("Humanoid")
                
                if humanoid and humanoid.MoveDirection.Magnitude < 0.1 then
                    -- Solo cuando no nos movemos, hacer micro-ajustes
                    local currentCFrame = humanoidRootPart.CFrame
                    local randomOffset = Vector3.new(
                        math.random(-5, 5) * 0.01, -- Muy pequeño
                        0,
                        math.random(-5, 5) * 0.01
                    )
                    
                    humanoidRootPart.CFrame = currentCFrame + randomOffset
                end
            end
        end
    end)
end

-- Función para hacer las partes del cuerpo más pequeñas
local function reduceBodyParts()
    if not player.Character then return end
    
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            -- Reducir tamaño de partes del cuerpo de forma sutil
            local originalSize = part.Size
            part.Size = originalSize * 0.7 -- 30% más pequeño
            part.Transparency = 0.3 -- Ligeramente transparente
        end
    end
end

-- Función principal del anti-hit sigiloso
local function toggleStealthAntiHit()
    antiHitEnabled = not antiHitEnabled
    
    if antiHitEnabled then
        stealthButton.Text = "ANTI-HIT SIGILOSO: ON"
        stealthButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        statusLabel.Text = "Estado: Protegido (Modo Sigiloso)"
        statusLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
        
        -- Aplicar métodos sigilosos
        setupStealthHitbox()
        startSubtleMovement()
        reduceBodyParts()
        
        -- Guardar posición original
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            originalCFrame = player.Character.HumanoidRootPart.CFrame
        end
        
    else
        stealthButton.Text = "ANTI-HIT SIGILOSO: OFF"
        stealthButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        statusLabel.Text = "Estado: Normal"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        -- Limpiar conexiones
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
        connections = {}
        
        -- Restaurar partes del cuerpo
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                end
                if part.Name == "FakeRoot" then
                    part:Destroy()
                end
            end
            
            -- Restaurar HumanoidRootPart
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Size = Vector3.new(2, 2, 1) -- Tamaño original
                humanoidRootPart.Transparency = 1 -- Mantener invisible (normal)
            end
        end
    end
end

-- Función para abrir/cerrar panel
local function togglePanel()
    panelOpen = not panelOpen
    
    if panelOpen then
        mainPanel.Visible = true
        toggleButton.Text = "×"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        
        centerFrame.Size = UDim2.new(0, 0, 0, 0)
        centerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local tween = TweenService:Create(centerFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 380, 0, 280),
            Position = UDim2.new(0.5, -190, 0.5, -140)
        })
        tween:Play()
    else
        toggleButton.Text = "🎯"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        
        local tween = TweenService:Create(centerFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            mainPanel.Visible = false
        end)
    end
end

-- Auto-aplicar al respawnear
player.CharacterAdded:Connect(function(character)
    if antiHitEnabled then
        character:WaitForChild("HumanoidRootPart")
        wait(0.5) -- Esperar más tiempo para evitar detección
        setupStealthHitbox()
        startSubtleMovement()
        reduceBodyParts()
    end
end)

-- Conectar eventos
toggleButton.MouseButton1Click:Connect(togglePanel)
closeButton.MouseButton1Click:Connect(togglePanel)
stealthButton.MouseButton1Click:Connect(toggleStealthAntiHit)

-- Cerrar panel
mainPanel.MouseButton1Click:Connect(function()
    if panelOpen then togglePanel() end
end)

centerFrame.MouseButton1Click:Connect(function() end)

-- Teclas rápidas
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.H then
                            toggleStealthAntiHit()
        elseif input.KeyCode == Enum.KeyCode.Insert then
            togglePanel()
        end
    end
end)

-- Función adicional: Evasión inteligente
local function setupSmartEvasion()
    connections.evasion = RunService.Heartbeat:Connect(function()
        if not antiHitEnabled then return end
        
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local humanoidRootPart = character.HumanoidRootPart
        local humanoid = character:FindFirstChild("Humanoid")
        
        -- Detectar jugadores cercanos con herramientas
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherCharacter = otherPlayer.Character
                local otherHRP = otherCharacter:FindFirstChild("HumanoidRootPart")
                local tool = otherCharacter:FindFirstChildOfClass("Tool")
                
                if otherHRP and tool then
                    local distance = (humanoidRootPart.Position - otherHRP.Position).Magnitude
                    
                    -- Si alguien con herramienta está muy cerca (posible ataque)
                    if distance < 8 then
                        -- Micro-evasión sutil
                        local direction = (humanoidRootPart.Position - otherHRP.Position).Unit
                        local evasionForce = direction * 0.5
                        
                        -- Solo aplicar si no nos estamos moviendo activamente
                        if humanoid.MoveDirection.Magnitude < 0.1 then
                            humanoidRootPart.CFrame = humanoidRootPart.CFrame + evasionForce
                        end
                    end
                end
            end
        end
    end)
end

-- Función para hacer el personaje más "escurridizo"
local function makeSlippery()
    if not player.Character then return end
    
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            -- Crear BodyVelocity muy sutil para resistir knockback
            local bodyVel = Instance.new("BodyVelocity")
            bodyVel.MaxForce = Vector3.new(1000, 0, 1000) -- Solo en X y Z
            bodyVel.Velocity = Vector3.new(0, 0, 0)
            bodyVel.Parent = part
            
            -- Remover después de poco tiempo para no ser detectado
            game:GetService("Debris"):AddItem(bodyVel, 0.1)
        end
    end
end

-- Aplicar función escurridiza constantemente
local function startSlipperyMode()
    connections.slippery = RunService.Heartbeat:Connect(function()
        if antiHitEnabled then
            makeSlippery()
        end
    end)
end

-- Función mejorada del anti-hit sigiloso
local function toggleStealthAntiHitImproved()
    antiHitEnabled = not antiHitEnabled
    
    if antiHitEnabled then
        stealthButton.Text = "ANTI-HIT SIGILOSO: ON"
        stealthButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        statusLabel.Text = "Estado: Protegido (Evasión Inteligente)"
        statusLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
        
        -- Aplicar todos los métodos sigilosos
        setupStealthHitbox()
        startSubtleMovement()
        reduceBodyParts()
        setupSmartEvasion()
        startSlipperyMode()
        
        -- Configuración adicional anti-detección
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            -- Aumentar ligeramente la velocidad de caminar para evasión
            humanoid.WalkSpeed = humanoid.WalkSpeed * 1.1
        end
        
    else
        stealthButton.Text = "ANTI-HIT SIGILOSO: OFF"
        stealthButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        statusLabel.Text = "Estado: Normal"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        -- Limpiar todas las conexiones
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
        connections = {}
        
        -- Restaurar todo a la normalidad
        if player.Character then
            -- Restaurar velocidad
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16 -- Velocidad normal
            end
            
            -- Limpiar partes modificadas
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                    -- Restaurar tamaño original (aproximado)
                    if part.Name == "Torso" or part.Name == "UpperTorso" then
                        part.Size = Vector3.new(2, 2, 1)
                    elseif part.Name:find("Arm") then
                        part.Size = Vector3.new(1, 2, 1)
                    elseif part.Name:find("Leg") then
                        part.Size = Vector3.new(1, 2, 1)
                    end
                end
                
                if part.Name == "FakeRoot" then
                    part:Destroy()
                end
            end
            
            -- Restaurar HumanoidRootPart
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Size = Vector3.new(2, 2, 1)
                humanoidRootPart.Transparency = 1
            end
        end
    end
end

-- Reemplazar la función anterior
stealthButton.MouseButton1Click:Connect(toggleStealthAntiHitImproved)

-- Animaciones de hover
stealthButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(stealthButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0.95, 0, 0, 65),
        BackgroundColor3 = antiHitEnabled and Color3.fromRGB(60, 220, 60) or Color3.fromRGB(80, 150, 200)
    })
    tween:Play()
end)

stealthButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(stealthButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0.9, 0, 0, 60),
        BackgroundColor3 = antiHitEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(70, 130, 180)
    })
    tween:Play()
end)

-- Limpiar al salir del juego
game:GetService("Players").PlayerRemoving:Connect(function(playerLeaving)
    if playerLeaving == player then
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
end)

print("🎯 ANTI-HIT SIGILOSO CARGADO!")
print("📋 CONTROLES:")
print("   - INSERT: Abrir/cerrar panel")
print("   - H: Toggle anti-hit sigiloso")
print("🔧 CARACTERÍSTICAS SIGILOSAS:")
print("   - Hitbox reducida al mínimo")
print("   - Evasión inteligente automática")
print("   - Resistencia sutil al knockback")
print("   - Detección de amenazas cercanas")
print("   - Movimientos impredecibles sutiles")
print("⚡ VENTAJAS:")
print("   - Menos detectable por anti-cheat")
print("   - Mantiene apariencia normal")
print("   - Funcionalidad completa del juego")
print("⚠️  Uso bajo tu responsabilidad")
