-- Panel de administración básico para Steal a Brainrot
-- Funciones: Float, Freeze/Unfreeze, Control de altura, Movimiento congelado, Bat infinito

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables de estado
local isFloating = false
local isFrozen = false
local floatHeight = 0
local bodyVelocity = nil
local bodyPosition = nil
local frozenPosition = nil
local movementSpeed = 16

-- Configuración de teclas
local FLOAT_KEY = Enum.KeyCode.F
local FREEZE_KEY = Enum.KeyCode.G
local UP_KEY = Enum.KeyCode.Q
local DOWN_KEY = Enum.KeyCode.E
local FORWARD_KEY = Enum.KeyCode.W
local BACKWARD_KEY = Enum.KeyCode.S
local LEFT_KEY = Enum.KeyCode.A
local RIGHT_KEY = Enum.KeyCode.D

-- Función para activar/desactivar flotación
local function toggleFloat()
    if not isFloating then
        -- Activar flotación
        isFloating = true
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        print("Flotación activada - Presiona Q/E para subir/bajar")
    else
        -- Desactivar flotación
        isFloating = false
        floatHeight = 0
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        print("Flotación desactivada")
    end
end

-- Función para congelar/descongelar personaje
local function toggleFreeze()
    if not isFrozen then
        -- Congelar personaje
        isFrozen = true
        frozenPosition = rootPart.Position
        
        bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyPosition.Position = frozenPosition
        bodyPosition.Parent = rootPart
        
        humanoid.PlatformStand = true
        
        print("Personaje congelado - Usa WASD para mover")
    else
        -- Descongelar personaje
        isFrozen = false
        frozenPosition = nil
        
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        
        humanoid.PlatformStand = false
        
        print("Personaje descongelado")
    end
end

-- Función para manejar movimiento cuando está congelado
local function handleFrozenMovement()
    if not isFrozen or not bodyPosition then return end
    
    local camera = workspace.CurrentCamera
    local moveVector = Vector3.new(0, 0, 0)
    
    -- Obtener dirección de la cámara (sin componente Y)
    local cameraCFrame = camera.CFrame
    local forward = cameraCFrame.LookVector
    local right = cameraCFrame.RightVector
    
    -- Normalizar vectores en el plano horizontal
    forward = Vector3.new(forward.X, 0, forward.Z).Unit
    right = Vector3.new(right.X, 0, right.Z).Unit
    
    -- Calcular movimiento basado en teclas presionadas
    if UserInputService:IsKeyDown(FORWARD_KEY) then
        moveVector = moveVector + forward
    end
    if UserInputService:IsKeyDown(BACKWARD_KEY) then
        moveVector = moveVector - forward
    end
    if UserInputService:IsKeyDown(LEFT_KEY) then
        moveVector = moveVector - right
    end
    if UserInputService:IsKeyDown(RIGHT_KEY) then
        moveVector = moveVector + right
    end
    if UserInputService:IsKeyDown(UP_KEY) then
        moveVector = moveVector + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(DOWN_KEY) then
        moveVector = moveVector + Vector3.new(0, -1, 0)
    end
    
    -- Aplicar movimiento
    if moveVector.Magnitude > 0 then
        frozenPosition = frozenPosition + (moveVector.Unit * movementSpeed * 0.1)
        bodyPosition.Position = frozenPosition
    end
end

-- Función para manejar flotación
local function handleFloat()
    if not isFloating or not bodyVelocity then return end
    
    local velocity = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(UP_KEY) then
        floatHeight = floatHeight + 0.5
    end
    if UserInputService:IsKeyDown(DOWN_KEY) then
        floatHeight = floatHeight - 0.5
    end
    
    velocity = Vector3.new(0, floatHeight, 0)
    bodyVelocity.Velocity = velocity
end

-- Función para hacer el bate infinito
local function makeBatInfinite()
    local function setupBat(tool)
        if tool.Name:lower():find("bat") or tool.Name:lower():find("bate") then
            -- Buscar el script del bate y modificarlo
            local handle = tool:FindFirstChild("Handle")
            if handle then
                -- Crear conexión para golpes infinitos
                local connection
                connection = tool.Activated:Connect(function()
                    -- Buscar todos los jugadores cercanos
                    for _, otherPlayer in pairs(Players:GetPlayers()) do
                        if otherPlayer ~= player and otherPlayer.Character then
                            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                            
                            if otherRoot and otherHumanoid then
                                local distance = (rootPart.Position - otherRoot.Position).Magnitude
                                if distance <= 50 then -- Rango infinito (50 studs)
                                    -- Simular golpe
                                    otherHumanoid.Health = otherHumanoid.Health - 20
                                    
                                    -- Efecto de knockback
                                    local bodyVel = Instance.new("BodyVelocity")
                                    bodyVel.MaxForce = Vector3.new(4000, 0, 4000)
                                    bodyVel.Velocity = (otherRoot.Position - rootPart.Position).Unit * 50
                                    bodyVel.Parent = otherRoot
                                    
                                    game:GetService("Debris"):AddItem(bodyVel, 0.5)
                                end
                            end
                        end
                    end
                end)
                
                tool.Unequipped:Connect(function()
                    if connection then
                        connection:Disconnect()
                    end
                end)
                
                print("Bate infinito activado!")
            end
        end
    end
    
    -- Configurar bate actual si existe
    for _, tool in pairs(player.Backpack:GetChildren()) do
        setupBat(tool)
    end
    
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                setupBat(tool)
            end
        end
    end
    
    -- Configurar futuros bates
    player.Backpack.ChildAdded:Connect(setupBat)
    if character then
        character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                setupBat(child)
            end
        end)
    end
end

-- Manejar input del teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == FLOAT_KEY then
        toggleFloat()
    elseif input.KeyCode == FREEZE_KEY then
        toggleFreeze()
    end
end)

-- Loop principal para movimiento
RunService.Heartbeat:Connect(function()
    handleFloat()
    handleFrozenMovement()
end)

-- Configurar bate infinito al inicio
makeBatInfinite()

-- Reconfigurar cuando el personaje respawnee
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Resetear estados
    isFloating = false
    isFrozen = false
    floatHeight = 0
    
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyPosition then bodyPosition:Destroy() bodyPosition = nil end
    
    -- Reconfigurar bate infinito
    wait(1) -- Esperar a que cargue completamente
    makeBatInfinite()
end)

-- Mostrar controles
print("=== PANEL DE ADMINISTRACIÓN ===")
print("F - Activar/Desactivar Flotación")
print("G - Congelar/Descongelar Personaje")
print("Q/E - Subir/Bajar (en flotación o congelado)")
print("WASD - Mover cuando está congelado")
print("Bate infinito: Activado automáticamente")
print("===============================")
