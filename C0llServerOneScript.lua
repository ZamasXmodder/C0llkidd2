-- Script para generar piso invisible cuando el jugador está en el aire
-- Colocar este script en ServerScriptService

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Configuración
local FALL_DETECTION_HEIGHT = 10 -- Altura mínima para detectar caída
local FLOOR_SIZE = Vector3.new(20, 1, 20) -- Tamaño del piso invisible
local FLOOR_OFFSET = -5 -- Distancia debajo del jugador para colocar el piso
local CHECK_INTERVAL = 0.1 -- Intervalo de verificación en segundos

-- Tabla para almacenar los pisos invisibles de cada jugador
local invisibleFloors = {}

-- Función para verificar si el jugador está en el aire
local function isPlayerInAir(player)
    local character = player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    -- Verificar si el jugador está cayendo y no está en el suelo
    return humanoid:GetState() == Enum.HumanoidStateType.Freefall or
           humanoid:GetState() == Enum.HumanoidStateType.Flying
end

-- Función para verificar si hay suelo debajo del jugador usando Raycast
local function hasGroundBelow(player, maxDistance)
    local character = player.Character
    if not character then return true end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return true end
    
    -- Crear raycast hacia abajo
    local rayOrigin = rootPart.Position
    local rayDirection = Vector3.new(0, -maxDistance, 0)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character}
    
    -- Si hay un piso invisible, también excluirlo del raycast
    if invisibleFloors[player] then
        local filterList = {character, invisibleFloors[player]}
        raycastParams.FilterDescendantsInstances = filterList
    end
    
    local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    return raycastResult ~= nil
end

-- Función para crear piso invisible
local function createInvisibleFloor(player)
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Eliminar piso anterior si existe
    if invisibleFloors[player] then
        invisibleFloors[player]:Destroy()
    end
    
    -- Crear nuevo piso invisible
    local floor = Instance.new("Part")
    floor.Name = "InvisibleFloor_" .. player.Name
    floor.Size = FLOOR_SIZE
    floor.Position = rootPart.Position + Vector3.new(0, FLOOR_OFFSET, 0)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Transparency = 1 -- Completamente invisible
    floor.Material = Enum.Material.ForceField
    floor.BrickColor = BrickColor.new("Bright blue")
    
    -- Opcional: Agregar un efecto visual sutil (comentar si no se desea)
    --floor.Transparency = 0.8
    
    floor.Parent = Workspace
    invisibleFloors[player] = floor
    
    print("Piso invisible creado para " .. player.Name)
    
    -- Eliminar el piso después de un tiempo si el jugador ya no lo necesita
    spawn(function()
        wait(2) -- Esperar 2 segundos
        if invisibleFloors[player] == floor then
            -- Verificar si el jugador ya está en suelo firme
            if not isPlayerInAir(player) or hasGroundBelow(player, FALL_DETECTION_HEIGHT) then
                floor:Destroy()
                if invisibleFloors[player] == floor then
                    invisibleFloors[player] = nil
                end
                print("Piso invisible removido para " .. player.Name)
            end
        end
    end)
end

-- Función para eliminar piso invisible
local function removeInvisibleFloor(player)
    if invisibleFloors[player] then
        invisibleFloors[player]:Destroy()
        invisibleFloors[player] = nil
        print("Piso invisible removido para " .. player.Name)
    end
end

-- Función principal de verificación
local function checkPlayer(player)
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Verificar si el jugador está en el aire y no hay suelo debajo
    if isPlayerInAir(player) and not hasGroundBelow(player, FALL_DETECTION_HEIGHT) then
        -- Crear piso invisible si no existe
        if not invisibleFloors[player] then
            createInvisibleFloor(player)
        end
    else
        -- Remover piso invisible si existe y el jugador ya no lo necesita
        if invisibleFloors[player] then
            removeInvisibleFloor(player)
        end
    end
end

-- Función que se ejecuta cuando un jugador se une
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        print(player.Name .. " se unió al juego")
        
        -- Esperar a que el personaje se cargue completamente
        character:WaitForChild("HumanoidRootPart")
        character:WaitForChild("Humanoid")
        
        -- Comenzar verificación periódica para este jugador
        spawn(function()
            while player.Parent and character.Parent do
                checkPlayer(player)
                wait(CHECK_INTERVAL)
            end
        end)
    end)
end

-- Función que se ejecuta cuando un jugador se va
local function onPlayerRemoving(player)
    removeInvisibleFloor(player)
    print(player.Name .. " salió del juego")
end

-- Conectar eventos
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Manejar jugadores que ya están en el juego
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

print("Sistema de piso invisible iniciado")
