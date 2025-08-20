-- Bypass Definitivo para Knockback Walls - Steal a Brainrot
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local bypassEnabled = false
local originalCollisions = {}
local hookedNamecall = nil

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WallBypassGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 70)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local bypassButton = Instance.new("TextButton")
bypassButton.Size = UDim2.new(0, 180, 0, 40)
bypassButton.Position = UDim2.new(0, 10, 0, 15)
bypassButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
bypassButton.Text = "BypassWall: OFF"
bypassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassButton.TextScaled = true
bypassButton.Font = Enum.Font.GothamBold
bypassButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = bypassButton

-- Función para identificar knockback walls
local function isKnockbackWall(part)
    if not part or not part:IsA("BasePart") then
        return false
    end
    
    local name = part.Name:lower()
    local parent = part.Parent and part.Parent.Name:lower() or ""
    
    -- Patrones específicos para knockback walls
    local patterns = {
        "wall", "barrier", "knockback", "invisible", "push", "bounce",
        "teleport", "kill", "damage", "hurt", "death", "block"
    }
    
    for _, pattern in pairs(patterns) do
        if name:find(pattern) or parent:find(pattern) then
            return true
        end
    end
    
    -- Verificar por propiedades (walls invisibles con colisión)
    if part.Transparency >= 0.8 and part.CanCollide then
        return true
    end
    
    -- Verificar por material
    if part.Material == Enum.Material.ForceField or part.Material == Enum.Material.Neon then
        return true
    end
    
    return false
end

-- Función para desactivar colisiones permanentemente
local function disableWallCollisions()
    for _, obj in pairs(workspace:GetDescendants()) do
        if isKnockbackWall(obj) then
            if not originalCollisions[obj] then
                originalCollisions[obj] = obj.CanCollide
            end
            obj.CanCollide = false
        end
    end
end

-- Función para restaurar colisiones
local function restoreWallCollisions()
    for wall, originalState in pairs(originalCollisions) do
        if wall and wall.Parent then
            wall.CanCollide = originalState
        end
    end
    originalCollisions = {}
end

-- Hook para interceptar RemoteEvents de knockback
local function hookKnockbackRemotes()
    hookedNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if bypassEnabled and (method == "FireServer" or method == "InvokeServer") then
            local remoteName = self.Name:lower()
            
            -- Nombres comunes de remotes de knockback en Steal a Brainrot
            local knockbackRemotes = {
                "knockback", "push", "bounce", "teleport", "damage",
                "hurt", "kill", "wall", "barrier", "collision"
            }
            
            for _, pattern in pairs(knockbackRemotes) do
                if remoteName:find(pattern) then
                    return -- Bloquear completamente el remote
                end
            end
            
            -- Verificar argumentos que indican knockback
            for _, arg in pairs(args) do
                if type(arg) == "string" then
                    local argLower = arg:lower()
                    for _, pattern in pairs(knockbackRemotes) do
                        if argLower:find(pattern) then
                            return -- Bloquear remote con argumentos de knockback
                        end
                    end
                end
            end
        end
        
        return hookedNamecall(self, ...)
    end)
end

-- Función para restaurar hooks
local function restoreHooks()
    if hookedNamecall then
        hookmetamethod(game, "__namecall", hookedNamecall)
        hookedNamecall = nil
    end
end

-- Función principal de toggle
local function toggleBypass()
    bypassEnabled = not bypassEnabled
    
    if bypassEnabled then
        -- Activar bypass
        bypassButton.Text = "BypassWall: ON"
        bypassButton.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
        
        -- Desactivar colisiones de todas las knockback walls
        disableWallCollisions()
        
        -- Hook de remotes de knockback
        hookKnockbackRemotes()
        
        -- Monitorear nuevas walls que aparezcan
        workspace.DescendantAdded:Connect(function(obj)
            if bypassEnabled and isKnockbackWall(obj) then
                originalCollisions[obj] = obj.CanCollide
                obj.CanCollide = false
            end
        end)
        
    else
        -- Desactivar bypass
        bypassButton.Text = "BypassWall: OFF"
        bypassButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        
        -- Restaurar colisiones
        restoreWallCollisions()
        
        -- Restaurar hooks
        restoreHooks()
    end
end

-- Animación del botón
local function animateButton()
    local tween = TweenService:Create(
        bypassButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad),
        {Size = UDim2.new(0, 175, 0, 38)}
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        TweenService:Create(
            bypassButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0, 180, 0, 40)}
        ):Play()
    end)
end

-- Eventos del botón
bypassButton.MouseButton1Click:Connect(function()
    animateButton()
    toggleBypass()
end)

-- Tecla rápida (B para bypass)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.B then
        toggleBypass()
    end
end)

-- Limpieza automática
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        restoreWallCollisions()
        restoreHooks()
    end
end)

-- Auto-activación al cargar (opcional, descomenta si quieres)
-- task.wait(2)
-- toggleBypass()
