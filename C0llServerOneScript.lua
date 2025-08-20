-- Debug y Bypass para Knockback Walls - Steal a Brainrot
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local bypassEnabled = false
local debugMode = true -- Cambiar a false cuando encuentres el remote
local originalCollisions = {}
local hookedNamecall = nil
local bodyObjectConnection = nil
local knownKnockbackRemote = nil -- Aquí guardaremos el remote identificado

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WallBypassGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local bypassButton = Instance.new("TextButton")
bypassButton.Size = UDim2.new(0, 230, 0, 40)
bypassButton.Position = UDim2.new(0, 10, 0, 10)
bypassButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
bypassButton.Text = "BypassWall: OFF"
bypassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassButton.TextScaled = true
bypassButton.Font = Enum.Font.GothamBold
bypassButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = bypassButton

local debugButton = Instance.new("TextButton")
debugButton.Size = UDim2.new(0, 110, 0, 30)
debugButton.Position = UDim2.new(0, 10, 0, 60)
debugButton.BackgroundColor3 = Color3.fromRGB(70, 70, 255)
debugButton.Text = "Debug: ON"
debugButton.TextColor3 = Color3.fromRGB(255, 255, 255)
debugButton.TextScaled = true
debugButton.Font = Enum.Font.Gotham
debugButton.Parent = mainFrame

local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0, 110, 0, 30)
clearButton.Position = UDim2.new(0, 130, 0, 60)
clearButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
clearButton.Text = "Clear Console"
clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clearButton.TextScaled = true
clearButton.Font = Enum.Font.Gotham
clearButton.Parent = mainFrame

local debugCorner1 = Instance.new("UICorner")
debugCorner1.CornerRadius = UDim.new(0, 4)
debugCorner1.Parent = debugButton

local debugCorner2 = Instance.new("UICorner")
debugCorner2.CornerRadius = UDim.new(0, 4)
debugCorner2.Parent = clearButton

-- Función para identificar knockback walls
local function isKnockbackWall(part)
    if not part or not part:IsA("BasePart") then
        return false
    end
    
    local name = part.Name:lower()
    local parent = part.Parent and part.Parent.Name:lower() or ""
    
    -- Patrones amplios para detectar walls
    local patterns = {
        "wall", "barrier", "invisible", "block", "teleport", "kill", "damage", "hurt", "death"
    }
    
    for _, pattern in pairs(patterns) do
        if name:find(pattern) or parent:find(pattern) then
            return true
        end
    end
    
    -- Walls invisibles con colisión
    if part.Transparency >= 0.7 and part.CanCollide then
        return true
    end
    
    return false
end

-- Función para desactivar colisiones
local function disableWallCollisions()
    for _, obj in pairs(workspace:GetDescendants()) do
        if isKnockbackWall(obj) then
            if not originalCollisions[obj] then
                originalCollisions[obj] = obj.CanCollide
            end
            obj.CanCollide = false
            if debugMode then
                warn("Colisión desactivada en:", obj.Name, "Parent:", obj.Parent.Name)
            end
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

-- Función para destruir BodyObjects de knockback
local function destroyKnockbackObjects()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    bodyObjectConnection = RunService.Heartbeat:Connect(function()
        if bypassEnabled then
            for _, obj in pairs(rootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or 
                   obj:IsA("BodyThrust") or obj:IsA("BodyAngularVelocity") or
                   obj:IsA("VectorForce") or obj:IsA("AlignPosition") or
                   obj:IsA("AlignOrientation") then
                    if debugMode then
                        warn("Destruyendo BodyObject:", obj.ClassName, "de knockback")
                    end
                    obj:Destroy()
                end
            end
        end
    end)
end

-- Hook principal para detectar remotes
local function hookRemoteDetection()
    hookedNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" or method == "InvokeServer" then
            if debugMode then
                -- Mostrar TODOS los remotes para identificar el correcto
                warn("=== REMOTE DETECTADO ===")
                warn("Nombre:", self.Name)
                warn("Clase:", self.ClassName)
                warn("Parent:", self.Parent and self.Parent.Name or "nil")
                warn("Método:", method)
                warn("Argumentos:", unpack(args))
                warn("========================")
            end
            
            -- Si ya identificamos el remote de knockback, bloquearlo
            if bypassEnabled and knownKnockbackRemote and self.Name == knownKnockbackRemote then
                warn("BLOQUEANDO REMOTE DE KNOCKBACK:", self.Name)
                return -- Bloquear completamente
            end
        end
        
        return hookedNamecall(self, ...)
    end)
end

-- Función para establecer el remote de knockback identificado
local function setKnockbackRemote(remoteName)
    knownKnockbackRemote = remoteName
    warn("Remote de knockback establecido:", remoteName)
end

-- Función principal de toggle
local function toggleBypass()
    bypassEnabled = not bypassEnabled
    
    if bypassEnabled then
        bypassButton.Text = "BypassWall: ON"
        bypassButton.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
        
        -- Desactivar colisiones
        disableWallCollisions()
        
        -- Destruir BodyObjects de knockback
        destroyKnockbackObjects()
        
        -- Monitorear nuevas walls
        workspace.DescendantAdded:Connect(function(obj)
            if bypassEnabled and isKnockbackWall(obj) then
                originalCollisions[obj] = obj.CanCollide
                obj.CanCollide = false
                if debugMode then
                    warn("Nueva wall detectada y desactivada:", obj.Name)
                end
            end
        end)
        
        warn("BYPASS ACTIVADO - Toca una knockback wall para ver los remotes")
        
    else
        bypassButton.Text = "BypassWall: OFF"
        bypassButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        
        -- Restaurar colisiones
        restoreWallCollisions()
        
        -- Desconectar monitoreo de BodyObjects
        if bodyObjectConnection then
            bodyObjectConnection:Disconnect()
            bodyObjectConnection = nil
        end
        
        warn("BYPASS DESACTIVADO")
    end
end

-- Toggle debug mode
local function toggleDebug()
    debugMode = not debugMode
    debugButton.Text = debugMode and "Debug: ON" or "Debug: OFF"
    debugButton.BackgroundColor3 = debugMode and Color3.fromRGB(70, 70, 255) or Color3.fromRGB(100, 100, 100)
    warn("Debug mode:", debugMode and "ACTIVADO" or "DESACTIVADO")
end

-- Limpiar consola
local function clearConsole()
    for i = 1, 50 do
        print("")
    end
    warn("=== CONSOLA LIMPIADA ===")
end

-- Eventos
bypassButton.MouseButton1Click:Connect(toggleBypass)
debugButton.MouseButton1Click:Connect(toggleDebug)
clearButton.MouseButton1Click:Connect(clearConsole)

-- Teclas rápidas
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.B then
        toggleBypass()
    elseif input.KeyCode == Enum.KeyCode.N then
        toggleDebug()
    elseif input.KeyCode == Enum.KeyCode.M then
        clearConsole()
    end
end)

-- Inicializar hook
hookRemoteDetection()

warn("=== WALL BYPASS CARGADO ===")
warn("1. Activa Debug y toca una knockback wall")
warn("2. Mira la consola para ver el remote exacto")
warn("3. Dime el nombre del remote para bloquearlo")
warn("Teclas: B=Bypass, N=Debug, M=Clear")
warn("===========================")

-- Función para establecer manualmente el remote (usar en consola)
_G.setKnockbackRemote = setKnockbackRemote
