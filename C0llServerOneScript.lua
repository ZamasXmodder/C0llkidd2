-- GUI Panel para Bypass de Knockback Walls
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables de estado
local bypassEnabled = false
local originalCollisions = {}
local connections = {}

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WallBypassPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 80)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Botón principal
local bypassButton = Instance.new("TextButton")
bypassButton.Name = "BypassButton"
bypassButton.Size = UDim2.new(0, 180, 0, 40)
bypassButton.Position = UDim2.new(0, 10, 0, 20)
bypassButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
bypassButton.Text = "BypassWall: OFF"
bypassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassButton.TextScaled = true
bypassButton.Font = Enum.Font.GothamBold
bypassButton.Parent = mainFrame

-- Esquinas del botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = bypassButton

-- Función para identificar knockback walls
local function isKnockbackWall(part)
    if not part or not part:IsA("BasePart") then
        return false
    end
    
    -- Métodos de identificación de knockback walls:
    -- 1. Por nombre común
    local name = part.Name:lower()
    if name:find("knockback") or name:find("wall") or name:find("barrier") or name:find("invisible") then
        return true
    end
    
    -- 2. Por material específico (común en estos juegos)
    if part.Material == Enum.Material.ForceField or part.Material == Enum.Material.Neon then
        return true
    end
    
    -- 3. Por transparencia (walls invisibles)
    if part.Transparency > 0.8 and part.CanCollide then
        return true
    end
    
    -- 4. Por scripts específicos (buscar scripts de knockback)
    for _, child in pairs(part:GetChildren()) do
        if child:IsA("Script") or child:IsA("LocalScript") then
            local source = child.Source or ""
            if source:lower():find("knockback") or source:lower():find("push") then
                return true
            end
        end
    end
    
    return false
end

-- Función para encontrar todas las knockback walls
local function findKnockbackWalls()
    local walls = {}
    
    -- Buscar en workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if isKnockbackWall(obj) then
            table.insert(walls, obj)
        end
    end
    
    return walls
end

-- Función para desactivar colisiones
local function disableWallCollisions()
    local walls = findKnockbackWalls()
    
    for _, wall in pairs(walls) do
        if wall and wall.Parent then
            -- Guardar estado original
            if not originalCollisions[wall] then
                originalCollisions[wall] = {
                    canCollide = wall.CanCollide,
                    transparency = wall.Transparency
                }
            end
            
            -- Desactivar colisión
            wall.CanCollide = false
            
            -- Opcional: hacer más transparente para indicar bypass
            if wall.Transparency < 0.9 then
                wall.Transparency = 0.9
            end
        end
    end
end

-- Función para restaurar colisiones
local function restoreWallCollisions()
    for wall, originalState in pairs(originalCollisions) do
        if wall and wall.Parent then
            wall.CanCollide = originalState.canCollide
            wall.Transparency = originalState.transparency
        end
    end
    originalCollisions = {}
end

-- Función para desactivar scripts de knockback
local function disableKnockbackScripts()
    local walls = findKnockbackWalls()
    
    for _, wall in pairs(walls) do
        if wall and wall.Parent then
            -- Desactivar scripts de knockback
            for _, script in pairs(wall:GetDescendants()) do
                if script:IsA("Script") or script:IsA("LocalScript") then
                    script.Disabled = true
                end
            end
            
            -- Desconectar eventos de Touched
            for _, connection in pairs(getconnections(wall.Touched)) do
                connection:Disable()
            end
        end
    end
end

-- Función para reactivar scripts de knockback
local function enableKnockbackScripts()
    local walls = findKnockbackWalls()
    
    for _, wall in pairs(walls) do
        if wall and wall.Parent then
            -- Reactivar scripts
            for _, script in pairs(wall:GetDescendants()) do
                if script:IsA("Script") or script:IsA("LocalScript") then
                    script.Disabled = false
                end
            end
            
            -- Reconectar eventos de Touched
            for _, connection in pairs(getconnections(wall.Touched)) do
                connection:Enable()
            end
        end
    end
end

-- Función principal de toggle
local function toggleBypass()
    bypassEnabled = not bypassEnabled
    
    if bypassEnabled then
        -- Activar bypass
        bypassButton.Text = "BypassWall: ON"
        bypassButton.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
        
        -- Desactivar colisiones y scripts
        disableWallCollisions()
        disableKnockbackScripts()
        
        -- Monitoreo continuo para nuevas walls
        connections.monitor = RunService.Heartbeat:Connect(function()
            disableWallCollisions()
        end)
        
    else
        -- Desactivar bypass
        bypassButton.Text = "BypassWall: OFF"
        bypassButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        
        -- Restaurar estado original
        restoreWallCollisions()
        enableKnockbackScripts()
        
        -- Desconectar monitoreo
        if connections.monitor then
            connections.monitor:Disconnect()
            connections.monitor = nil
        end
    end
end

-- Animación del botón
local function animateButton()
    local tween = TweenService:Create(
        bypassButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {Size = UDim2.new(0, 175, 0, 38)}
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        local tween2 = TweenService:Create(
            bypassButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Size = UDim2.new(0, 180, 0, 40)}
        )
        tween2:Play()
    end)
end

-- Eventos
bypassButton.MouseButton1Click:Connect(function()
    animateButton()
    toggleBypass()
end)

-- Tecla de acceso rápido (F para toggle)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleBypass()
    end
end)

-- Limpiar al salir
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
end)
