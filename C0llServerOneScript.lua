
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Lista de todos los brainrots
local brainrotList = {
    "Noobini Pizzanini", "Lirili Larila", "TIM Cheese", "Flurifura", "Talpa Di Fero",
    "Svinia Bombardino", "Pipi Kiwi", "Racooni Jandelini", "Pipi Corni", "Trippi Troppi",
    "Tung Tung Tung Sahur", "Gangster Footera", "Bandito Bobritto", "Boneca Ambalabu",
    "Cacto Hipopotamo", "Ta Ta Ta Ta Sahur", "Tric Trac Baraboom", "Steal a Brainrot Pipi Avocado",
    "Cappuccino Assassino", "Brr Brr Patapin", "Trulimero Trulicina", "Bambini Crostini",
    "Bananita Dolphinita", "Perochello Lemonchello", "Brri Brri Bicus Dicus Bombicus",
    "Avocadini Guffo", "Salamino Penguino", "Ti Ti Ti Sahur", "Penguino Cocosino",
    "Burbalini Loliloli", "Chimpanzini Bananini", "Ballerina Cappuccina", "Chef Crabracadabra",
    "Lionel Cactuseli", "Glorbo Fruttodrillo", "Blueberrini Octapusini", "Strawberelli Flamingelli",
    "Pandaccini Bananini", "Cocosini Mama", "Sigma Boy", "Pi Pi Watermelon", "Frigo Camelo",
    "Orangutini Ananasini", "Rhino Toasterino", "Bombardiro Crocodilo", "Bombombini Gusini",
    "Cavallo Virtuso", "Gorillo Watermelondrillo", "Avocadorilla", "Tob Tobi Tobi",
    "Gangazelli Trulala", "Te Te Te Sahur", "Tracoducotulu Delapeladustuz", "Lerulerulerule",
    "Carloo", "Spioniro Golubiro", "Zibra Zubra Zibralini", "Tigrilini Watermelini",
    "Cocofanta Elefanto", "Girafa Celestre", "Gyattatino Nyanino", "Matteo",
    "Tralalero Tralala", "Espresso Signora", "Odin Din Din Dun", "Statutino Libertino",
    "Trenostruzzo Turbo 3000", "Ballerino Lololo", "Los Orcalitos", "Tralalita Tralala",
    "Urubini Flamenguini", "Trigoligre Frutonni", "Orcalero Orcala", "Bulbito Bandito Traktorito",
    "Los Crocodilitos", "Piccione Macchina", "Trippi Troppi Troppa Trippa", "Los Tungtuntuncitos",
    "Tukanno Bananno", "Alessio", "Tipi Topi Taco", "Pakrahmatmamat", "Bombardini Tortinii",
    "La Vacca Saturno Saturnita", "Chimpanzini Spiderini", "Los Tralaleritos", "Las Tralaleritas",
    "Graipuss Medussi", "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung",
    "Tortuginni Dragonfruitini", "Pot Hotspot", "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira",
    "Agarrini la Palini", "Dragon Cannelloni", "Los Combinasionas", "Karkerkar Kurkur",
    "Los Hotspotsitos", "Esok Sekolah", "Los Matteos", "Dul Dul Dul", "Blackhole Goat",
    "Nooo My Hotspot", "Sammyini Spyderini", "La Supreme Combinasion", "Ketupat Kepat"
}

-- Variables de estado
local autoStealActive = false
local currentConnection = nil
local homePosition = nil
local isMoving = false
local floatSpeed = 50
local carrierParts = {}
local bodyVelocity = nil

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoStealPanel"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 25)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🚀 Auto Steal Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = frame

-- Botón principal
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 35)
button.Position = UDim2.new(0, 10, 0, 35)
button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
button.Text = "🔄 Auto Steal: OFF"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

-- Control de velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 80)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Float Speed: " .. floatSpeed
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = frame

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(1, -20, 0, 15)
speedSlider.Position = UDim2.new(0, 10, 0, 105)
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.Parent = frame

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 7)
speedSliderCorner.Parent = speedSlider

local speedHandle = Instance.new("TextButton")
speedHandle.Size = UDim2.new(0, 20, 1, 0)
speedHandle.Position = UDim2.new((floatSpeed - 10) / 190, -10, 0, 0)
speedHandle.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
speedHandle.Text = ""
speedHandle.Parent = speedSlider

local speedHandleCorner = Instance.new("UICorner")
speedHandleCorner.CornerRadius = UDim.new(0, 7)
speedHandleCorner.Parent = speedHandle

-- Status labels
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 130)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "💤 Status: Inactive"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -20, 0, 18)
countLabel.Position = UDim2.new(0, 10, 0, 155)
countLabel.BackgroundTransparency = 1
countLabel.Text = "🎯 Found: 0 brainrots"
countLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
countLabel.TextScaled = true
countLabel.Font = Enum.Font.Gotham
countLabel.Parent = frame

-- Función para el slider de velocidad
local function updateSpeedSlider()
    local mouse = Players.LocalPlayer:GetMouse()
    local connection
    
    connection = mouse.Button1Up:Connect(function()
        connection:Disconnect()
    end)
    
    local moveConnection
    moveConnection = mouse.Move:Connect(function()
        if mouse.Target == speedHandle or mouse.Target == speedSlider then
            local relativeX = mouse.X - speedSlider.AbsolutePosition.X
            local percentage = math.clamp(relativeX / speedSlider.AbsoluteSize.X, 0, 1)
            
            floatSpeed = math.floor(10 + (percentage * 190)) -- Rango de 10 a 200
            speedHandle.Position = UDim2.new(percentage, -10, 0, 0)
            speedLabel.Text = "⚡ Float Speed: " .. floatSpeed
        end
    end)
    
    mouse.Button1Up:Connect(function()
        if moveConnection then
            moveConnection:Disconnect()
        end
    end)
end

speedHandle.MouseButton1Down:Connect(updateSpeedSlider)
speedSlider.MouseButton1Down:Connect(updateSpeedSlider)

-- Función para encontrar brainrots en workspace
local function findBrainrots()
    local brainrots = {}
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            for _, brainrotName in pairs(brainrotList) do
                if obj.Name == brainrotName then
                    if obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("Part") then
                        table.insert(brainrots, obj)
                    end
                    break
                end
            end
        end
    end
    
    return brainrots
end

-- Función para obtener la posición del brainrot
local function getBrainrotPosition(brainrot)
    if brainrot.PrimaryPart then
        return brainrot.PrimaryPart.Position
    elseif brainrot:FindFirstChild("HumanoidRootPart") then
        return brainrot.HumanoidRootPart.Position
    elseif brainrot:FindFirstChildOfClass("Part") then
        return brainrot:FindFirstChildOfClass("Part").Position
    end
    return nil
end

-- Función para crear las partes que llevarán al jugador
local function createCarrierParts(targetPosition)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    -- Limpiar partes anteriores
    for _, part in pairs(carrierParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    carrierParts = {}
    
    -- Crear 6 partes flotantes
    for i = 1, 6 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 2, 2)
        part.Material = Enum.Material.ForceField
        part.BrickColor = BrickColor.new("Bright blue")
        part.CanCollide = false
        part.Anchored = false
        part.Shape = Enum.PartType.Ball
        part.TopSurface = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        
        local angle = (i - 1) * (math.pi * 2 / 6)
        local radius = 8
        part.Position = humanoidRootPart.Position + Vector3.new(
            math.cos(angle) * radius,
            math.random(3, 7),
            math.sin(angle) * radius
        )
        
        part.Parent = workspace
        table.insert(carrierParts, part)
        
        -- Efecto de brillo
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.fromRGB(0, 162, 255)
        pointLight.Brightness = 3
        pointLight.Range = 15
        pointLight.Parent = part
        
        -- BodyVelocity para movimiento suave
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        bodyVel.Parent = part
        
        -- BodyAngularVelocity para rotación
        local bodyAngular = Instance.new("BodyAngularVelocity")
        bodyAngular.AngularVelocity = Vector3.new(0, math.random(5, 15), 0)
        bodyAngular.MaxTorque = Vector3.new(0, math.huge, 0)
        bodyAngular.Parent = part
    end
    
    -- Crear BodyVelocity para el jugador
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart
    
        -- Inmovilizar al jugador
    if player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.PlatformStand = true
    end
end

-- Función para mover flotando hacia el objetivo
local function floatToTarget(targetPosition)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    isMoving = true
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    -- Crear las partes que llevarán al jugador
    createCarrierParts(targetPosition)
    
    -- Movimiento flotante
    spawn(function()
        local startTime = tick()
        local connection
        
        connection = RunService.Heartbeat:Connect(function()
            if not autoStealActive or tick() - startTime > 15 then
                connection:Disconnect()
                isMoving = false
                
                -- Limpiar efectos
                if bodyVelocity then
                    bodyVelocity:Destroy()
                    bodyVelocity = nil
                end
                
                for _, part in pairs(carrierParts) do
                    if part and part.Parent then
                        part:Destroy()
                    end
                end
                carrierParts = {}
                
                -- Restaurar control del jugador
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.PlatformStand = false
                end
                return
            end
            
            if humanoidRootPart and humanoidRootPart.Parent then
                local direction = (targetPosition - humanoidRootPart.Position)
                local distance = direction.Magnitude
                
                if distance < 8 then
                    -- Llegamos al objetivo
                    connection:Disconnect()
                    isMoving = false
                    
                    -- Simular recolección
                    statusLabel.Text = "✨ Collecting brainrot..."
                    wait(2)
                    
                    -- Regresar a casa
                    if homePosition and autoStealActive then
                        statusLabel.Text = "🏠 Returning home..."
                        floatToTarget(homePosition)
                    else
                        -- Limpiar efectos
                        if bodyVelocity then
                            bodyVelocity:Destroy()
                            bodyVelocity = nil
                        end
                        
                        for _, part in pairs(carrierParts) do
                            if part and part.Parent then
                                part:Destroy()
                            end
                        end
                        carrierParts = {}
                        
                        -- Restaurar control del jugador
                        if player.Character and player.Character:FindFirstChild("Humanoid") then
                            player.Character.Humanoid.PlatformStand = false
                        end
                    end
                    return
                end
                
                -- Calcular velocidad
                direction = direction.Unit
                local velocity = direction * floatSpeed
                
                -- Aplicar movimiento al jugador
                if bodyVelocity then
                    bodyVelocity.Velocity = velocity
                end
                
                -- Mover las partes flotantes alrededor del jugador
                for i, part in pairs(carrierParts) do
                    if part and part.Parent and part:FindFirstChild("BodyVelocity") then
                        local angle = (i - 1) * (math.pi * 2 / 6) + tick() * 2
                        local radius = 8
                        local targetPartPos = humanoidRootPart.Position + Vector3.new(
                            math.cos(angle) * radius,
                            5 + math.sin(tick() * 3 + i) * 2,
                            math.sin(angle) * radius
                        )
                        
                        local partDirection = (targetPartPos - part.Position).Unit
                        part.BodyVelocity.Velocity = partDirection * (floatSpeed * 0.8)
                    end
                end
            end
        end)
    end)
end

-- Función para crear efectos visuales en el brainrot
local function createBrainrotEffects(position)
    for i = 1, 3 do
        local effect = Instance.new("Part")
        effect.Size = Vector3.new(1, 1, 1)
        effect.Material = Enum.Material.Neon
        effect.BrickColor = BrickColor.new("Bright green")
        effect.CanCollide = false
        effect.Anchored = true
        effect.Shape = Enum.PartType.Ball
        effect.Transparency = 0.3
        
        local angle = (i - 1) * (math.pi * 2 / 3)
        local radius = 5
        effect.Position = position + Vector3.new(
            math.cos(angle) * radius,
            math.random(1, 4),
            math.sin(angle) * radius
        )
        
        effect.Parent = workspace
        
        -- Animación de crecimiento y desvanecimiento
        spawn(function()
            for t = 0, 3, 0.1 do
                if effect.Parent then
                    effect.Size = Vector3.new(1 + t, 1 + t, 1 + t)
                    effect.Transparency = 0.3 + (t / 3) * 0.7
                    effect.Position = effect.Position + Vector3.new(0, 0.1, 0)
                end
                wait(0.1)
            end
            if effect.Parent then
                effect:Destroy()
            end
        end)
    end
end

-- Función principal de auto steal
local function autoStealLoop()
    if not autoStealActive or isMoving then return end
    
    local brainrots = findBrainrots()
    countLabel.Text = "🎯 Found: " .. #brainrots .. " brainrots"
    
    if #brainrots > 0 then
        local closestBrainrot = nil
        local closestDistance = math.huge
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPos = player.Character.HumanoidRootPart.Position
            
            for _, brainrot in pairs(brainrots) do
                local brainrotPos = getBrainrotPosition(brainrot)
                if brainrotPos then
                    local distance = (brainrotPos - playerPos).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestBrainrot = brainrot
                    end
                end
            end
            
            if closestBrainrot then
                local targetPos = getBrainrotPosition(closestBrainrot)
                if targetPos then
                    statusLabel.Text = "🚀 Flying to: " .. closestBrainrot.Name
                    createBrainrotEffects(targetPos)
                    floatToTarget(targetPos)
                end
            end
        end
    else
        statusLabel.Text = "🔍 Searching for brainrots..."
    end
end

-- Evento del botón principal
button.MouseButton1Click:Connect(function()
    autoStealActive = not autoStealActive
    
    if autoStealActive then
        button.Text = "🟢 Auto Steal: ON"
        button.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
        statusLabel.Text = "⚡ Active - Scanning..."
        
        -- Guardar posición inicial
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            homePosition = player.Character.HumanoidRootPart.Position
        end
        
        -- Iniciar loop
        currentConnection = RunService.Heartbeat:Connect(function()
            wait(3) -- Esperar 3 segundos entre búsquedas
            autoStealLoop()
        end)
    else
        button.Text = "🔴 Auto Steal: OFF"
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        statusLabel.Text = "💤 Status: Inactive"
        countLabel.Text = "🎯 Found: 0 brainrots"
        isMoving = false
        
        -- Limpiar todo
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        for _, part in pairs(carrierParts) do
            if part and part.Parent then
                part:Destroy()
            end
        end
        carrierParts = {}
        
        -- Restaurar control del jugador
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = false
        end
        
        -- Detener loop
        if currentConnection then
            currentConnection:Disconnect()
            currentConnection = nil
        end
    end
end)

-- Hacer el panel arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Función para limpiar al salir
game.Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        if currentConnection then
            currentConnection:Disconnect()
        end
        if screenGui then
            screenGui:Destroy()
        end
    end
end)

-- Notificación de inicio
spawn(function()
    wait(1)
    statusLabel.Text = "✅ Auto Steal Panel Ready!"
    wait(2)
    if not autoStealActive then
        statusLabel.Text = "💤 Status: Inactive"
    end
end)

print("🎮 Auto Steal Panel loaded successfully!")
print("📋 Monitoring " .. #brainrotList .. " different brainrots")
print("🚀 Float system activated - Player will be carried by magical parts!")
print("⚡ Adjustable speed: 10-200 units")
