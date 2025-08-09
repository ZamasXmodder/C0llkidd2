-- Panel Anti-Hit Definitivo - Invisibilidad Total + Teletransporte
-- Advertencia: Usar scripts en Roblox puede resultar en baneos

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables del script
local antiHitEnabled = false
local originalTransparencies = {}
local panelOpen = false
local teleportConnection = nil
local lastPosition = nil

-- Crear la GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateAntiHitPanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Botón flotante para abrir/cerrar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 20, 0.5, -30)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "🛡️"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 30)
toggleCorner.Parent = toggleButton

-- Panel principal (pantalla completa)
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(1, 0, 1, 0)
mainPanel.Position = UDim2.new(0, 0, 0, 0)
mainPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainPanel.BackgroundTransparency = 0.3
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Parent = screenGui

-- Contenedor central del panel
local centerFrame = Instance.new("Frame")
centerFrame.Size = UDim2.new(0, 500, 0, 400)
centerFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
centerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
centerFrame.BorderSizePixel = 0
centerFrame.Parent = mainPanel

local centerCorner = Instance.new("UICorner")
centerCorner.CornerRadius = UDim.new(0, 15)
centerCorner.Parent = centerFrame

-- Barra superior del panel
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 60)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
topBar.BorderSizePixel = 0
topBar.Parent = centerFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 15)
topCorner.Parent = topBar

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Position = UDim2.new(0.1, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ANTI-HIT DEFINITIVO"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = topBar

-- Botón cerrar (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 20)
closeCorner.Parent = closeButton

-- Contenido del panel
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -40, 1, -100)
contentFrame.Position = UDim2.new(0, 20, 0, 80)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = centerFrame

-- Botón principal Anti-Hit
local antiHitButton = Instance.new("TextButton")
antiHitButton.Size = UDim2.new(0.8, 0, 0, 80)
antiHitButton.Position = UDim2.new(0.1, 0, 0.05, 0)
antiHitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
antiHitButton.BorderSizePixel = 0
antiHitButton.Text = "ANTI-HIT: OFF"
antiHitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
antiHitButton.TextScaled = true
antiHitButton.Font = Enum.Font.GothamBold
antiHitButton.Parent = contentFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = antiHitButton

-- Estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 40)
statusLabel.Position = UDim2.new(0.1, 0, 0.35, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Vulnerable"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = contentFrame

-- Descripción
local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(0.8, 0, 0, 100)
descLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
descLabel.BackgroundTransparency = 1
descLabel.Text = "MODO DEFINITIVO:\n• Invisibilidad total (incluso HumanoidRootPart)\n• Teletransporte micro constante\n• Imposible de golpear\n\nTecla rápida: G"
descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
descLabel.TextScaled = true
descLabel.Font = Enum.Font.Gotham
descLabel.Parent = contentFrame

-- Función para hacer completamente invisible
local function makeCompletelyInvisible(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            originalTransparencies[part] = part.Transparency
            part.Transparency = 1
            -- Ocultar todo tipo de decoraciones
            for _, child in pairs(part:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceGui") then
                    child.Transparency = 1
                end
            end
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                originalTransparencies[handle] = handle.Transparency
                handle.Transparency = 1
                for _, child in pairs(handle:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SpecialMesh") then
                        if child:IsA("SpecialMesh") then
                            child.TextureId = ""
                        else
                            child.Transparency = 1
                        end
                    end
                end
            end
        end
    end
end

-- Función para restaurar visibilidad
local function makeVisible(character)
    for part, transparency in pairs(originalTransparencies) do
        if part and part.Parent then
            part.Transparency = transparency
            for _, child in pairs(part:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceGui") then
                    child.Transparency = 0
                end
            end
        end
    end
    originalTransparencies = {}
end

-- Función de teletransporte micro
local function startMicroTeleport()
    if teleportConnection then
        teleportConnection:Disconnect()
    end
    
    teleportConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local currentPos = humanoidRootPart.CFrame
            
            -- Micro teletransporte aleatorio (muy pequeño para que no se note)
            local randomX = math.random(-2, 2) * 0.1
            local randomZ = math.random(-2, 2) * 0.1
            
            -- Solo teletransportar si no nos estamos moviendo mucho
            if lastPosition then
                local distance = (currentPos.Position - lastPosition.Position).Magnitude
                if distance < 10 then -- Solo si no nos movemos muy rápido
                    humanoidRootPart.CFrame = currentPos + Vector3.new(randomX, 0, randomZ)
                end
            end
            
            lastPosition = currentPos
        end
    end)
end

-- Función principal del anti-hit definitivo
local function toggleUltimateAntiHit()
    if not player.Character then return end
    
    antiHitEnabled = not antiHitEnabled
    
    if antiHitEnabled then
        -- Activar modo definitivo
        antiHitButton.Text = "ANTI-HIT: ON"
        antiHitButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        statusLabel.Text = "Estado: INVENCIBLE - Invisible + Teletransporte"
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        
        -- Hacer completamente invisible
        makeCompletelyInvisible(player.Character)
        
        -- Iniciar micro teletransporte
        startMicroTeleport()
        
        -- Hacer que el personaje no pueda ser empujado
        if player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = true
        end
        
    else
        -- Desactivar modo definitivo
        antiHitButton.Text = "ANTI-HIT: OFF"
        antiHitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        statusLabel.Text = "Estado: Vulnerable"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Restaurar visibilidad
        makeVisible(player.Character)
        
        -- Detener teletransporte
        if teleportConnection then
            teleportConnection:Disconnect()
            teleportConnection = nil
        end
        
        -- Restaurar física normal
        if player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = false
        end
    end
end

-- Función para abrir/cerrar panel
local function togglePanel()
    panelOpen = not panelOpen
    
    if panelOpen then
        mainPanel.Visible = true
        toggleButton.Text = "✕"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        
        centerFrame.Size = UDim2.new(0, 0, 0, 0)
        centerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local tween = TweenService:Create(centerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 500, 0, 400),
            Position = UDim2.new(0.5, -250, 0.5, -200)
        })
        tween:Play()
    else
        toggleButton.Text = "🛡️"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        local tween = TweenService:Create(centerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
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
        wait(0.2)
        makeCompletelyInvisible(character)
        startMicroTeleport()
        if character:FindFirstChild("Humanoid") then
            character.Humanoid.PlatformStand = true
        end
    end
end)

-- Conectar eventos
toggleButton.MouseButton1Click:Connect(togglePanel)
closeButton.MouseButton1Click:Connect(togglePanel)
antiHitButton.MouseButton1Click:Connect(toggleUltimateAntiHit)

-- Cerrar panel al hacer clic en el fondo
mainPanel.MouseButton1Click:Connect(function()
    if panelOpen then togglePanel() end
end)

centerFrame.MouseButton1Click:Connect(function() end)

-- Animaciones
antiHitButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(antiHitButton, TweenInfo.new(0.2), {Size = UDim2.new(0.85, 0, 0, 85)})
    tween:Play()
end)

antiHitButton.MouseLeave:Connect(function()
        local tween = TweenService:Create(antiHitButton, TweenInfo.new(0.2), {Size = UDim2.new(0.8, 0, 0, 80)})
    tween:Play()
end)

-- Teclas rápidas
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.G then
            toggleUltimateAntiHit()
        elseif input.KeyCode == Enum.KeyCode.Insert then
            togglePanel()
        end
    end
end)

-- Función adicional: Anti-fling (evitar ser lanzado)
local function setupAntiFling()
    if player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = part
                
                -- Remover después de un tiempo para no interferir con el movimiento normal
                game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
            end
        end
    end
end

-- Aplicar anti-fling constantemente cuando está activado
local antiFlingConnection = nil

local function startAntiFling()
    if antiFlingConnection then
        antiFlingConnection:Disconnect()
    end
    
    antiFlingConnection = RunService.Heartbeat:Connect(function()
        if antiHitEnabled then
            setupAntiFling()
        end
    end)
end

-- Iniciar anti-fling
startAntiFling()

-- Limpiar conexiones al salir
game.Players.PlayerRemoving:Connect(function(playerLeaving)
    if playerLeaving == player then
        if teleportConnection then
            teleportConnection:Disconnect()
        end
        if antiFlingConnection then
            antiFlingConnection:Disconnect()
        end
    end
end)

print("🛡️ ANTI-HIT DEFINITIVO CARGADO!")
print("📋 CONTROLES:")
print("   - INSERT: Abrir/cerrar panel")
print("   - G: Activar/desactivar anti-hit definitivo")
print("🔥 CARACTERÍSTICAS:")
print("   - Invisibilidad 100% total")
print("   - Micro-teletransporte constante")
print("   - Anti-fling integrado")
print("   - Imposible de golpear")
print("⚠️  ADVERTENCIA: Uso bajo tu responsabilidad")
