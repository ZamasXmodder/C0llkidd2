-- Bypass GUI para Knockback Walls - Método Avanzado
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables de estado
local bypassEnabled = false
local originalVelocity = Vector3.new(0, 0, 0)
local connections = {}
local hookedFunctions = {}

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WallBypassPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 90)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local bypassButton = Instance.new("TextButton")
bypassButton.Size = UDim2.new(0, 200, 0, 50)
bypassButton.Position = UDim2.new(0, 10, 0, 20)
bypassButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
bypassButton.Text = "BypassWall: OFF"
bypassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassButton.TextScaled = true
bypassButton.Font = Enum.Font.GothamBold
bypassButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = bypassButton

-- Función para interceptar y anular knockback
local function interceptKnockback()
    -- Método 1: Anular cambios de velocidad del RootPart
    local originalAssemblyLinearVelocity = rootPart.AssemblyLinearVelocity
    
    connections.velocityMonitor = RunService.Heartbeat:Connect(function()
        if bypassEnabled then
            local currentVelocity = rootPart.AssemblyLinearVelocity
            
            -- Detectar knockback (cambio súbito de velocidad)
            local velocityChange = (currentVelocity - originalVelocity).Magnitude
            
            if velocityChange > 50 then -- Umbral de knockback detectado
                -- Restaurar velocidad anterior inmediatamente
                rootPart.AssemblyLinearVelocity = originalVelocity
                rootPart.Velocity = Vector3.new(0, 0, 0)
            else
                originalVelocity = currentVelocity
            end
        end
    end)
    
    -- Método 2: Hook de BodyVelocity y BodyPosition
    connections.bodyObjectMonitor = RunService.Heartbeat:Connect(function()
        if bypassEnabled then
            for _, obj in pairs(rootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or 
                   obj:IsA("BodyThrust") or obj:IsA("BodyAngularVelocity") then
                    obj:Destroy()
                end
            end
        end
    end)
end

-- Función para anular scripts de knockback mediante hooking
local function hookKnockbackFunctions()
    -- Hook de funciones comunes de knockback
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if bypassEnabled then
            -- Interceptar llamadas que aplican knockback
            if method == "ApplyImpulse" or method == "ApplyAngularImpulse" then
                if self == rootPart or self.Parent == character then
                    return -- Anular impulso
                end
            end
            
            -- Interceptar cambios de velocidad
            if method == "SetPrimaryPartCFrame" and self == character then
                return -- Anular teletransporte forzado
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    hookedFunctions.namecall = oldNamecall
end

-- Función para anular colisiones específicas
local function bypassCollisions()
    connections.collisionBypass = RunService.Stepped:Connect(function()
        if bypassEnabled then
            -- Detectar y anular colisiones con knockback walls
            local raycast = workspace:Raycast(rootPart.Position, humanoid.MoveDirection * 5)
            
            if raycast and raycast.Instance then
                local hitPart = raycast.Instance
                
                -- Verificar si es una knockback wall
                if isKnockbackWall(hitPart) then
                    -- Temporalmente desactivar colisión
                    hitPart.CanCollide = false
                    
                    -- Reactivar después de pasar
                    task.wait(0.1)
                    if hitPart and hitPart.Parent then
                        hitPart.CanCollide = true
                    end
                end
            end
        end
    end)
end

-- Función mejorada para identificar knockback walls
function isKnockbackWall(part)
    if not part or not part:IsA("BasePart") then
        return false
    end
    
    local name = part.Name:lower()
    local parent = part.Parent and part.Parent.Name:lower() or ""
    
    -- Patrones específicos de Steal a Brainrot
    local knockbackPatterns = {
        "knockback", "wall", "barrier", "invisible", "push", "bounce",
        "teleport", "kill", "damage", "hurt", "death"
    }
    
    for _, pattern in pairs(knockbackPatterns) do
        if name:find(pattern) or parent:find(pattern) then
            return true
        end
    end
    
    -- Verificar por propiedades físicas
    if part.Material == Enum.Material.ForceField or 
       part.Material == Enum.Material.Neon or
       (part.Transparency > 0.5 and part.CanCollide) then
        return true
    end
    
    return false
end

-- Función principal de toggle
local function toggleBypass()
    bypassEnabled = not bypassEnabled
    
    if bypassEnabled then
        bypassButton.Text = "BypassWall: ON"
        bypassButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        
        -- Activar todos los métodos de bypass
        interceptKnockback()
        hookKnockbackFunctions()
        bypassCollisions()
        
        -- Protección adicional contra lag
        connections.antiLag = RunService.Heartbeat:Connect(function()
            if rootPart.Velocity.Magnitude > 100 then
                rootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        
    else
        bypassButton.Text = "BypassWall: OFF"
        bypassButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        
        -- Desconectar todas las conexiones
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
        connections = {}
        
        -- Restaurar hooks
        for name, originalFunc in pairs(hookedFunctions) do
            if originalFunc then
                hookmetamethod(game, "__" .. name, originalFunc)
            end
        end
        hookedFunctions = {}
    end
end

-- Animación del botón
local function animateButton()
    local tween = TweenService:Create(
        bypassButton,
        TweenInfo.new(0.05, Enum.EasingStyle.Quad),
        {Size = UDim2.new(0, 195, 0, 48)}
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        TweenService:Create(
            bypassButton,
            TweenInfo.new(0.05, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0, 200, 0, 50)}
        ):Play()
    end)
end

-- Eventos
bypassButton.MouseButton1Click:Connect(function()
    animateButton()
    toggleBypass()
end)

-- Tecla rápida (X para toggle)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.X then
        toggleBypass()
    end
end)

-- Actualizar referencias del personaje
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reactivar bypass si estaba activo
    if bypassEnabled then
        bypassEnabled = false
        toggleBypass()
    end
end)

-- Limpieza al salir
game:BindToClose(function()
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
end)
