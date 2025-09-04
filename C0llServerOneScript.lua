-- Script completo para generar piso invisible con panel de control integrado
-- IMPORTANTE: Colocar este script en StarterGui como LocalScript (NO en ServerScriptService)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Referencias del jugador local
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuración
local FALL_DETECTION_HEIGHT = 10 -- Altura mínima para detectar caída
local FLOOR_SIZE = Vector3.new(20, 1, 20) -- Tamaño del piso invisible
local FLOOR_OFFSET = -5 -- Distancia debajo del jugador para colocar el piso
local CHECK_INTERVAL = 0.1 -- Intervalo de verificación en segundos

-- Variables de estado
local systemEnabled = false -- Sistema desactivado por defecto
local invisibleFloor = nil -- Piso invisible del jugador local
local isLooping = false -- Control del bucle de verificación
local panelVisible = false -- Estado de visibilidad del panel
local mainGui = nil -- Referencia al GUI principal

-- Función para verificar si el jugador está en el aire
local function isPlayerInAir()
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
local function hasGroundBelow(maxDistance)
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
    if invisibleFloor then
        local filterList = {character, invisibleFloor}
        raycastParams.FilterDescendantsInstances = filterList
    end
    
    local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    return raycastResult ~= nil
end

-- Función para crear piso invisible
local function createInvisibleFloor()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Eliminar piso anterior si existe
    if invisibleFloor then
        invisibleFloor:Destroy()
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
    invisibleFloor = floor
    
    print("Piso invisible creado")
    
    -- Eliminar el piso después de un tiempo si el jugador ya no lo necesita
    spawn(function()
        wait(2) -- Esperar 2 segundos
        if invisibleFloor == floor then
            -- Verificar si el jugador ya está en suelo firme
            if not isPlayerInAir() or hasGroundBelow(FALL_DETECTION_HEIGHT) then
                floor:Destroy()
                if invisibleFloor == floor then
                    invisibleFloor = nil
                end
                print("Piso invisible removido")
            end
        end
    end)
end

-- Función para eliminar piso invisible
local function removeInvisibleFloor()
    if invisibleFloor then
        invisibleFloor:Destroy()
        invisibleFloor = nil
        print("Piso invisible removido")
    end
end

-- Función principal de verificación
local function checkPlayer()
    -- Solo funciona si el sistema está activado
    if not systemEnabled then
        -- Si el sistema está desactivado, remover cualquier piso existente
        if invisibleFloor then
            removeInvisibleFloor()
        end
        return
    end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Verificar si el jugador está en el aire y no hay suelo debajo
    if isPlayerInAir() and not hasGroundBelow(FALL_DETECTION_HEIGHT) then
        -- Crear piso invisible si no existe
        if not invisibleFloor then
            createInvisibleFloor()
        end
    else
        -- Remover piso invisible si existe y el jugador ya no lo necesita
        if invisibleFloor then
            removeInvisibleFloor()
        end
    end
end

-- Función para activar/desactivar el sistema
local function toggleSystem(enabled)
    systemEnabled = enabled
    
    if enabled then
        print("✅ Sistema de piso invisible ACTIVADO")
        -- Iniciar el bucle de verificación
        if not isLooping then
            startPlayerLoop()
        end
    else
        print("❌ Sistema de piso invisible DESACTIVADO")
        -- Remover el piso invisible
        removeInvisibleFloor()
        -- Detener el bucle
        isLooping = false
    end
end

-- Función para iniciar el bucle de verificación
local function startPlayerLoop()
    if isLooping then return end -- Ya existe un bucle
    
    isLooping = true
    spawn(function()
        while isLooping and player.Parent do
            if player.Character then
                checkPlayer()
            end
            wait(CHECK_INTERVAL)
        end
    end)
end

-- Función para mostrar/ocultar el panel
local function togglePanel()
    if mainGui then
        panelVisible = not panelVisible
        local targetTransparency = panelVisible and 0 or 1
        local targetPosition = panelVisible and UDim2.new(0.5, -150, 0.5, -60) or UDim2.new(0.5, -150, -0.5, -60)
        
        -- Animación suave
        local tween = TweenService:Create(
            mainGui.MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {
                Position = targetPosition,
                BackgroundTransparency = targetTransparency
            }
        )
        tween:Play()
        
        -- Animar los elementos internos
        for _, child in pairs(mainGui.MainFrame:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                local childTween = TweenService:Create(
                    child,
                    TweenInfo.new(0.3),
                    {TextTransparency = targetTransparency}
                )
                childTween:Play()
            end
        end
        
        print(panelVisible and "📱 Panel mostrado" or "📱 Panel ocultado")
    end
end

-- Función para crear el panel GUI
local function createGUI()
    
    -- Crear ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InvisibleFloorPanel"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal del panel (inicialmente oculto)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 120)
    mainFrame.Position = UDim2.new(0.5, -150, -0.5, -60) -- Posición inicial fuera de pantalla
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BackgroundTransparency = 1 -- Inicialmente invisible
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
    titleLabel.TextTransparency = 1 -- Inicialmente invisible
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
    statusLabel.TextTransparency = 1 -- Inicialmente invisible
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
    toggleButton.TextTransparency = 1 -- Inicialmente invisible
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
        
        -- Actualizar la GUI
        updateGUI(systemEnabled)
    end)
    
    -- Actualizar GUI inicial
    updateGUI(systemEnabled)
    
    -- Almacenar referencia global
    mainGui = screenGui
    
    return screenGui
end

-- Crear GUI al cargar el script
spawn(function()
    createGUI()
end)

-- Detectar cuando presionen la tecla F
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Ignorar si está escribiendo en chat
    
    if input.KeyCode == Enum.KeyCode.F then
        togglePanel()
    end
end)

-- Manejar cuando el jugador respawnea
player.CharacterAdded:Connect(function(character)
    print("🎮 Personaje cargado")
    
    -- Esperar a que el personaje se cargue completamente
    character:WaitForChild("HumanoidRootPart")
    character:WaitForChild("Humanoid")
    
    -- Reiniciar el bucle si el sistema está activado
    if systemEnabled then
        isLooping = false -- Reset del estado
        startPlayerLoop()
    end
end)

print("🚀 Sistema de piso invisible con panel controlado por tecla F cargado")
print("💡 Estado inicial: DESACTIVADO")
print("🎮 Presiona F para mostrar/ocultar el panel de control")
