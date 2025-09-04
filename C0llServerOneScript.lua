-- Script completo para generar piso invisible con panel de control integrado
-- Colocar este script en ServerScriptService

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuración
local FALL_DETECTION_HEIGHT = 10 -- Altura mínima para detectar caída
local FLOOR_SIZE = Vector3.new(20, 1, 20) -- Tamaño del piso invisible
local FLOOR_OFFSET = -5 -- Distancia debajo del jugador para colocar el piso
local CHECK_INTERVAL = 0.1 -- Intervalo de verificación en segundos

-- Variables de estado globales
local systemEnabled = false -- Sistema desactivado por defecto
local invisibleFloors = {}
local playerLoops = {} -- Para controlar los bucles de cada jugador
local playerGUIs = {} -- Para almacenar las GUIs de cada jugador

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
    -- Solo funciona si el sistema está activado
    if not systemEnabled then
        -- Si el sistema está desactivado, remover cualquier piso existente
        if invisibleFloors[player] then
            removeInvisibleFloor(player)
        end
        return
    end
    
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

-- Función para activar/desactivar el sistema
local function toggleSystem(enabled)
    systemEnabled = enabled
    
    if enabled then
        print("✅ Sistema de piso invisible ACTIVADO")
        -- Iniciar verificación para todos los jugadores conectados
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and not playerLoops[player] then
                startPlayerLoop(player)
            end
        end
    else
        print("❌ Sistema de piso invisible DESACTIVADO")
        -- Remover todos los pisos invisibles
        for player, floor in pairs(invisibleFloors) do
            removeInvisibleFloor(player)
        end
        -- Detener todos los bucles
        for player, _ in pairs(playerLoops) do
            playerLoops[player] = false
        end
    end
end

-- Función para iniciar el bucle de verificación de un jugador
local function startPlayerLoop(player)
    if playerLoops[player] then return end -- Ya existe un bucle para este jugador
    
    playerLoops[player] = true
    spawn(function()
        while player.Parent and player.Character and playerLoops[player] do
            checkPlayer(player)
            wait(CHECK_INTERVAL)
        end
        playerLoops[player] = nil
    end)
end

-- Función que se ejecuta cuando un jugador se une
local function onPlayerAdded(player)
    -- Crear GUI para el jugador
    spawn(function()
        createGUI(player)
    end)
    
    player.CharacterAdded:Connect(function(character)
        print(player.Name .. " se unió al juego")
        
        -- Esperar a que el personaje se cargue completamente
        character:WaitForChild("HumanoidRootPart")
        character:WaitForChild("Humanoid")
        
        -- Solo iniciar el bucle si el sistema está activado
        if systemEnabled then
            startPlayerLoop(player)
        end
    end)
end

-- Función que se ejecuta cuando un jugador se va
local function onPlayerRemoving(player)
    removeInvisibleFloor(player)
    playerLoops[player] = false -- Detener el bucle del jugador
    
    -- Limpiar GUI del jugador
    if playerGUIs[player] then
        if playerGUIs[player].gui then
            playerGUIs[player].gui:Destroy()
        end
        playerGUIs[player] = nil
    end
    
    print(player.Name .. " salió del juego")
end

-- Función para crear el panel GUI para un jugador
local function createGUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Crear ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InvisibleFloorPanel"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal del panel
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 120)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Sombra del panel
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, 3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    -- Título del panel
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🛡️ Piso Invisible"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame
    
    -- Estado del sistema
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, -20, 0, 20)
    statusLabel.Position = UDim2.new(0, 10, 0, 35)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "❌ DESACTIVADO"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame
    
    -- Botón de toggle
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, -20, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 65)
    toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "ACTIVAR SISTEMA"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = toggleButton
    
    -- Función para actualizar la GUI
    local function updateGUI(enabled)
        if enabled then
            statusLabel.Text = "✅ ACTIVADO"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            toggleButton.Text = "DESACTIVAR SISTEMA"
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        else
            statusLabel.Text = "❌ DESACTIVADO"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            toggleButton.Text = "ACTIVAR SISTEMA"
            toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        end
    end
    
    -- Evento del botón
    toggleButton.MouseButton1Click:Connect(function()
        -- Efecto visual del botón
        local tween = TweenService:Create(toggleButton, TweenInfo.new(0.1), {Size = UDim2.new(1, -25, 0, 35)})
        tween:Play()
        tween.Completed:Connect(function()
            local tween2 = TweenService:Create(toggleButton, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 40)})
            tween2:Play()
        end)
        
        -- Cambiar estado del sistema
        systemEnabled = not systemEnabled
        toggleSystem(systemEnabled)
        
        -- Actualizar todas las GUIs
        for _, gui in pairs(playerGUIs) do
            if gui and gui.updateFunction then
                gui.updateFunction(systemEnabled)
            end
        end
    end)
    
    -- Actualizar GUI inicial
    updateGUI(systemEnabled)
    
    -- Almacenar referencia
    playerGUIs[player] = {
        gui = screenGui,
        updateFunction = updateGUI
    }
    
    return screenGui
end

-- Conectar eventos
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Manejar jugadores que ya están en el juego
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

print("🚀 Sistema de piso invisible con GUI integrado cargado")
print("💡 Estado inicial: DESACTIVADO")
print("🎮 Los jugadores verán un panel en la esquina superior izquierda para controlarlo")
