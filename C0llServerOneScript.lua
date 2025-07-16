-- Panel de administración básico para Steal a Brainrot
-- Funciones: Float con cruz, Freeze/Unfreeze, Control de altura, Movimiento congelado, Bat lanzador

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
local bodyVelocity = nil
local bodyPosition = nil
local frozenPosition = nil

-- Configuración de velocidades
local FLOAT_SPEED = 25 -- Velocidad controlada para flotación
local FROZEN_SPEED = 3 -- Velocidad tipo speedcoil para movimiento congelado
local KNOCKBACK_FORCE = 150 -- Fuerza de lanzamiento del bate

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
        
        print("Flotación activada - Usa WASD + Q/E para moverte en cruz")
    else
        -- Desactivar flotación
        isFloating = false
        
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
        
        print("Personaje congelado - Velocidad tipo speedcoil activada")
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

-- Función para manejar movimiento cuando está congelado (velocidad speedcoil)
local function handleFrozenMovement()
    if not isFrozen or not bodyPosition then return end
    
    local moveVector = Vector3.new(0, 0, 0)
    
    -- Movimiento en cruz (sin rotación de cámara)
    if UserInputService:IsKeyDown(FORWARD_KEY) then
        moveVector = moveVector + Vector3.new(0, 0, -1) -- Adelante
    end
    if UserInputService:IsKeyDown(BACKWARD_KEY) then
        moveVector = moveVector + Vector3.new(0, 0, 1) -- Atrás
    end
    if UserInputService:IsKeyDown(LEFT_KEY) then
        moveVector = moveVector + Vector3.new(-1, 0, 0) -- Izquierda
    end
    if UserInputService:IsKeyDown(RIGHT_KEY) then
        moveVector = moveVector + Vector3.new(1, 0, 0) -- Derecha
    end
    if UserInputService:IsKeyDown(UP_KEY) then
        moveVector = moveVector + Vector3.new(0, 1, 0) -- Arriba
    end
    if UserInputService:IsKeyDown(DOWN_KEY) then
        moveVector = moveVector + Vector3.new(0, -1, 0) -- Abajo
    end
    
    -- Aplicar movimiento con velocidad tipo speedcoil
    if moveVector.Magnitude > 0 then
        frozenPosition = frozenPosition + (moveVector.Unit * FROZEN_SPEED)
        bodyPosition.Position = frozenPosition
    end
end

-- Función para manejar flotación en cruz
local function handleFloat()
    if not isFloating or not bodyVelocity then return end
    
    local velocity = Vector3.new(0, 0, 0)
    
    -- Movimiento en cruz con velocidad limitada
    if UserInputService:IsKeyDown(FORWARD_KEY) then
        velocity = velocity + Vector3.new(0, 0, -FLOAT_SPEED) -- Adelante
    end
    if UserInputService:IsKeyDown(BACKWARD_KEY) then
        velocity = velocity + Vector3.new(0, 0, FLOAT_SPEED) -- Atrás
    end
    if UserInputService:IsKeyDown(LEFT_KEY) then
        velocity = velocity + Vector3.new(-FLOAT_SPEED, 0, 0) -- Izquierda
    end
    if UserInputService:IsKeyDown(RIGHT_KEY) then
        velocity = velocity + Vector3.new(FLOAT_SPEED, 0, 0) -- Derecha
    end
    if UserInputService:IsKeyDown(UP_KEY) then
        velocity = velocity + Vector3.new(0, FLOAT_SPEED, 0) -- Arriba
    end
    if UserInputService:IsKeyDown(DOWN_KEY) then
        velocity = velocity + Vector3.new(0, -FLOAT_SPEED, 0) -- Abajo
    end
    
    bodyVelocity.Velocity = velocity
end

-- Función para lanzar a todos los jugadores con el bate
local function launchAllPlayers()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if otherRoot then
                -- Calcular dirección desde mi posición hacia el otro jugador
                local direction = (otherRoot.Position - rootPart.Position).Unit
                
                -- Crear efecto de lanzamiento
                local bodyVel = Instance.new("BodyVelocity")
                bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
                
                -- Lanzar hacia arriba y en la dirección calculada
                local launchDirection = direction + Vector3.new(0, 0.5, 0) -- Añadir componente hacia arriba
                bodyVel.Velocity = launchDirection.Unit * KNOCKBACK_FORCE
                bodyVel.Parent = otherRoot
                
                -- Remover el BodyVelocity después de un tiempo
                game:GetService("Debris"):AddItem(bodyVel, 1)
                
                print("Jugador " .. otherPlayer.Name .. " lanzado!")
            end
        end
    end
end

-- Función para hacer el bate lanzador global
local function makeBatLauncher()
    local function setupBat(tool)
        if tool.Name:lower():find("bat") or tool.Name:lower():find("bate") then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                -- Crear conexión para lanzamiento global
                local connection
                connection = tool.Activated:Connect(function()
                    launchAllPlayers()
                    print("¡Bate activado! Todos los jugadores han sido lanzados")
                end)
                
                tool.Unequipped:Connect(function()
                    if connection then
                        connection:Disconnect()
                    end
                end)
                
                print("Bate lanzador global activado!")
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

-- Configurar bate lanzador al inicio
makeBatLauncher()

-- Reconfigurar cuando el personaje respawnee
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Resetear estados
    isFloating = false
    isFrozen = false
    
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyPosition then bodyPosition:Destroy() bodyPosition = nil end
    
    -- Reconfigurar bate lanzador
    wait(1) -- Esperar a que cargue completamente
    makeBatLauncher()
end)

-- Mostrar controles
print("=== PANEL DE ADMINISTRACIÓN ===")
print("F - Flotación en cruz (velocidad normal)")
print("G - Congelar/Descongelar (velocidad speedcoil)")
print("WASD - Adelante/Atrás/Izquierda/Derecha")
print("Q/E - Arriba/Abajo")
print("Bate - Lanza a TODOS los jugadores desde cualquier distancia")
print("===============================")
