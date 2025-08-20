-- Anti-Hit GUI Script para Steal a Brainrot
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
local originalConnections = {}
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Función para activar/desactivar Anti-Hit
local function toggleAntiHit()
    antiHitEnabled = not antiHitEnabled
    
    if antiHitEnabled then
        -- Activar Anti-Hit
        antiHitButton.Text = "Anti-Hit: ON"
        antiHitButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
        
        -- Hacer al personaje inmune a daño
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
        
        -- Desactivar PlatformStand (permite movimiento)
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        -- Hacer todas las partes del cuerpo "CanCollide" = false para evitar empujes
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
        
        -- Prevenir ragdoll desconectando todas las conexiones de daño
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = character.HumanoidRootPart
        
        -- Proteger contra scripts que intenten cambiar la salud
        originalConnections.healthChanged = humanoid.HealthChanged:Connect(function()
            if antiHitEnabled then
                humanoid.Health = math.huge
            end
        end)
        
        -- Proteger contra cambios en PlatformStand
        originalConnections.platformStandChanged = humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
            if antiHitEnabled then
                humanoid.PlatformStand = false
            end
        end)
        
        print("Anti-Hit activado - Inmune a todos los ataques pero puedes moverte")
        
    else
        -- Desactivar Anti-Hit
        antiHitButton.Text = "Anti-Hit: OFF"
        antiHitButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        
        -- Restaurar valores normales
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid.PlatformStand = false
        end
        
        -- Restaurar colisiones
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        
        -- Limpiar BodyVelocity
        local bodyVel = character.HumanoidRootPart:FindFirstChild("BodyVelocity")
        if bodyVel then
            bodyVel:Destroy()
        end
        
        -- Desconectar todas las conexiones
        for _, connection in pairs(originalConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        originalConnections = {}
        
        print("Anti-Hit desactivado - Vulnerable a ataques normalmente")
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

print("Anti-Hit GUI cargado exitosamente")
