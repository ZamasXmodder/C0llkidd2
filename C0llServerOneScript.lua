local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear el ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GamePanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.Text = "Game Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- ScrollingFrame para los botones
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ButtonContainer"
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

-- Variables para funciones
local laserAimbotEnabled = false
local espEnabled = false
local secretEspEnabled = false
local laserAimbotConnection = nil
local basePosition = Vector3.new(0, 0, 0) -- Cambia esto por la posición de tu base

-- Lista de secretos brainrots
local brainrotSecrets = {
    "La Vacca Saturno Saturnita",
    "Torrtuginni Dragonfrutini",
    "Agarrini La Palini",
    "Los Tralaleritos",
    "Las Tralaleritas",
    "Job Job Job Sahur",
    "Las Vaquitas Saturnitas",
    "Ketupat Kepat",
    "Graipuss Medussi",
    "Pot Hotspot",
    "Chicleteira Bicicleteira",
    "La Grande Combinasion",
    "Los Combinasionas",
    "Nuclearo Dinossauro",
    "Los Hotspotsitos",
    "Esok Sekolah",
    "Garama and Madundung",
    "Los Matteos",
    "Dragon Cannelloni",
    "Los Spyderinis",
    "La Supreme Combinasion",
    "Spaghetti Tualetti",
    "Secret Lucky Block"
}

-- Función para crear botones
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    -- Efecto hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    
    return button
end

-- Función para verificar si tenemos un brainrot robado
local function hasStolenBrainrot()
    if not player.Character then return false end
    
    -- Buscar en el backpack y character por brainrots
    local function checkContainer(container)
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") then
                for _, secretName in pairs(brainrotSecrets) do
                    if string.find(item.Name:lower(), secretName:lower()) then
                        return true
                    end
                end
            end
        end
        return false
    end
    
    return checkContainer(player.Backpack) or checkContainer(player.Character)
end

-- Función para encontrar el jugador más cercano
local function getClosestPlayer()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance and distance <= 200 then -- Rango máximo de 200 studs
                shortestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    
    return closestPlayer
end

-- Función para interceptar y redirigir el láser
local function setupLaserRedirection()
    -- Hook para interceptar RemoteEvents del láser
    local oldFireServer = nil
    
    for _, remoteEvent in pairs(ReplicatedStorage:GetDescendants()) do
        if remoteEvent:IsA("RemoteEvent") and (remoteEvent.Name == "UseItem" or remoteEvent.Name:find("Laser") or remoteEvent.Name:find("Fire")) then
            if not oldFireServer then
                oldFireServer = remoteEvent.FireServer
                
                remoteEvent.FireServer = function(self, ...)
                    local args = {...}
                    
                    if laserAimbotEnabled then
                        local target = getClosestPlayer()
                        if target and target.Character and target.Character:FindFirstChild("Head") then
                            -- Redirigir el láser hacia el jugador más cercano
                            args[1] = target.Character.Head.Position
                            args[2] = target.Character
                            print("Láser redirigido hacia: " .. target.Name)
                        end
                    end
                    
                    return oldFireServer(self, unpack(args))
                end
            end
        end
    end
end

-- Función Laser Aimbot (Redirección automática)
local function toggleLaserAimbot()
    laserAimbotEnabled = not laserAimbotEnabled
    
    if laserAimbotEnabled then
        setupLaserRedirection()
        print("Laser Aimbot activado - Todos los disparos serán redirigidos automáticamente")
    else
        print("Laser Aimbot desactivado")
    end
end

-- Función Smart TP (Solo con brainrot robado)
local function smartTpToBase()
    if not hasStolenBrainrot() then
        print("❌ No tienes ningún brainrot robado. TP cancelado.")
        return
    end
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        print("❌ Character no encontrado")
        return
    end
    
    local humanoidRootPart = player.Character.HumanoidRootPart
    local startPosition = humanoidRootPart.Position
    
    print("🚀 Iniciando Smart TP hacia la base...")
    
    -- Crear path usando PathfindingService
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 20
    })
    
    local success, errorMessage = pcall(function()
        path:ComputeAsync(startPosition, basePosition)
    end)
    
    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        
        -- Teleportarse por waypoints cada 20 studs
        for i, waypoint in pairs(waypoints) do
            if not hasStolenBrainrot() then
                print("❌ Brainrot perdido durante el viaje. TP detenido.")
                break
            end
            
            -- Teleportarse al waypoint
            humanoidRootPart.CFrame = CFrame.new(waypoint.Position + Vector3.new(0, 3, 0))
            
            -- Pequeña pausa para simular movimiento rápido
            wait(0.1)
            
            print("📍 Waypoint " .. i .. "/" .. #waypoints .. " alcanzado")
        end
        
        print("✅ Smart TP completado - Has llegado a la base")
    else
        -- Fallback: TP directo en línea recta con paradas cada 20 studs
        print("⚠️ Pathfinding falló, usando TP directo...")
        
        local direction = (basePosition - startPosition).Unit
        local totalDistance = (basePosition - startPosition).Magnitude
        local steps = math.ceil(totalDistance / 20)
        
        for i = 1, steps do
            if not hasStolenBrainrot() then
                print("❌ Brainrot perdido durante el viaje. TP detenido.")
                break
            end
            
            local stepDistance = math.min(20, totalDistance - (i-1) * 20)
            local newPosition = startPosition + direction * (i * 20)
            
            -- Raycast para evitar paredes
            local raycast = workspace:Raycast(humanoidRootPart.Position, newPosition - humanoidRootPart.Position)
            if not raycast then
                humanoidRootPart.CFrame = CFrame.new(newPosition + Vector3.new(0, 3, 0))
                wait(0.1)
                print("📍 Paso " .. i .. "/" .. steps .. " completado")
            else
                print("⚠️ Obstáculo detectado, ajustando ruta...")
                newPosition = newPosition + Vector3.new(0, 10, 0) -- Subir para evitar obstáculo
                humanoidRootPart.CFrame = CFrame.new(newPosition)
                wait(0.1)
            end
        end
        
        print("✅ Smart TP completado")
    end
end

-- Función ESP Players
local function togglePlayerEsp()
    espEnabled = not espEnabled
    
    if espEnabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "PlayerESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = otherPlayer.Character
            end
        end
        print("ESP Players activado")
    else
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer.Character and otherPlayer.Character:FindFirstChild("PlayerESP") then
                otherPlayer.Character.PlayerESP:Destroy()
            end
        end
        print("ESP Players desactivado")
    end
end

-- Función ESP Brainrots Secrets
local function toggleSecretEsp()
    secretEspEnabled = not secretEspEnabled
    
    if secretEspEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                for _, secretName in pairs(brainrotSecrets) do
                    if string.find(obj.Name:lower(), secretName:lower()) or 
                       (obj.Parent and string.find(obj.Parent.Name:lower(), secretName:lower())) then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "SecretESP"
                        highlight.FillColor = Color3.fromRGB(0, 255, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        highlight.Parent = obj
                        break
                    end
                end
            end
        end
        print("ESP Brainrots Secrets activado")
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("SecretESP") then
                obj.SecretESP:Destroy()
            end
        end
        print("ESP Brainrots Secrets desactivado")
    end
end

-- Crear botones
createButton("Laser Aimbot (Auto-Redirect)", toggleLaserAimbot)
createButton("Smart TP to Base", smartTpToBase)
createButton("ESP Players", togglePlayerEsp)
createButton("ESP Brainrots Secrets", toggleSecretEsp)

-- Botón para abrir/cerrar panel
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
toggleButton.Text = "Panel"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Función para toggle del panel
local function togglePanel()
    mainFrame.Visible = not mainFrame.Visible
    
    if mainFrame.Visible then
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        toggleButton.Text = "Cerrar"
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        toggleButton.Text = "Panel"
    end
end

toggleButton.MouseButton1Click:Connect(togglePanel)

-- Tecla para abrir/cerrar (Insert)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        togglePanel()
    end
end)

-- Actualizar canvas size del scroll frame
local function updateScrollSize()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollSize)
updateScrollSize()

-- Configurar posición de la base (IMPORTANTE: Cambia estas coordenadas por las de tu base)
spawn(function()
    wait(5) -- Esperar a que el juego cargue
    -- Aquí debes poner las coordenadas de tu base
    -- Ejemplo: basePosition = Vector3.new(100, 50, 200)
    print("⚠️ IMPORTANTE: Configura la posición de tu base en la variable 'basePosition'")
    print("📍 Posición actual de base: " .. tostring(basePosition))
end)

-- Monitor de brainrots robados
spawn(function()
    while true do
        wait(1)
        if hasStolenBrainrot() then
            -- Cambiar color del botón TP cuando tengas un brainrot
            for _, button in pairs(scrollFrame:GetChildren()) do
                if button:IsA("TextButton") and button.Text == "Smart TP to Base" then
                    button.BackgroundColor3 = Color3.fromRGB(50, 150, 50) -- Verde cuando disponible
                    break
                end
            end
        else
            -- Color normal cuando no tengas brainrot
            for _, button in pairs(scrollFrame:GetChildren()) do
                if button:IsA("TextButton") and button.Text == "Smart TP to Base" then
                    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Gris normal
                    break
                end
            end
        end
    end
end)

print("🎮 Panel de juego cargado exitosamente!")
print("🔧 Funciones disponibles:")
print("   • Laser Aimbot: Redirige TODOS los disparos hacia jugadores automáticamente")
print("   • Smart TP: Solo funciona con brainrot robado, evita paredes")
print("   • ESP Players: Resalta jugadores")
print("   • ESP Brainrots: Resalta secretos brainrots")
print("⌨️ Presiona Insert o el botón 'Panel' para abrir/cerrar")
print("⚠️ RECUERDA: Configura la variable 'basePosition' con las coordenadas de tu base")
