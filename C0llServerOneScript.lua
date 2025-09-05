
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

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoStealPanel"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 45)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
button.Text = "🔄 Auto Steal: OFF"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 65)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "💤 Status: Inactive"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -20, 0, 20)
countLabel.Position = UDim2.new(0, 10, 0, 95)
countLabel.BackgroundTransparency = 1
countLabel.Text = "🎯 Found: 0 brainrots"
countLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
countLabel.TextScaled = true
countLabel.Font = Enum.Font.Gotham
countLabel.Parent = frame

-- Función para encontrar brainrots en workspace
local function findBrainrots()
    local brainrots = {}
    
    -- Buscar en workspace directamente
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            for _, brainrotName in pairs(brainrotList) do
                if obj.Name == brainrotName then
                    -- Verificar que tenga PrimaryPart o alguna parte principal
                    if obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("Part") then
                        table.insert(brainrots, obj)
                    end
                    break
                end
            end
        end
    end
    
    -- También buscar en ReplicatedStorage si es necesario
    if ReplicatedStorage:FindFirstChild("Models") then
        for _, obj in pairs(ReplicatedStorage.Models:GetChildren()) do
            if obj:IsA("Model") then
                for _, brainrotName in pairs(brainrotList) do
                    if obj.Name == brainrotName then
                        table.insert(brainrots, obj)
                        break
                    end
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

-- Función para mover suavemente hacia un objetivo
local function moveToTarget(targetPosition)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    isMoving = true
    local humanoidRootPart = player.Character.HumanoidRootPart
    local humanoid = player.Character:FindFirstChild("Humanoid")
    
    -- Usar Humanoid.MoveTo para movimiento más natural
    if humanoid then
        humanoid:MoveTo(targetPosition)
        
        -- Esperar a que llegue o timeout
        local startTime = tick()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not autoStealActive or tick() - startTime > 10 then
                connection:Disconnect()
                isMoving = false
                return
            end
            
            local distance = (targetPosition - humanoidRootPart.Position).Magnitude
            if distance < 5 then
                connection:Disconnect()
                isMoving = false
                
                -- Simular recolección
                wait(1)
                if homePosition and autoStealActive then
                    statusLabel.Text = "🏠 Returning home..."
                    humanoid:MoveTo(homePosition)
                end
            end
        end)
    end
end

-- Función para crear efectos visuales
local function createVisualEffects(position)
    for i = 1, 6 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Material = Enum.Material.ForceField
        part.BrickColor = BrickColor.new("Bright blue")
        part.CanCollide = false
        part.Anchored = true
        part.Shape = Enum.PartType.Ball
        
        local angle = (i - 1) * (math.pi * 2 / 6)
        local radius = 8
        part.Position = position + Vector3.new(
            math.cos(angle) * radius,
            math.random(2, 6),
            math.sin(angle) * radius
        )
        
        part.Parent = workspace
        
        -- Efecto de brillo
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.fromRGB(0, 162, 255)
        pointLight.Brightness = 2
        pointLight.Range = 10
        pointLight.Parent = part
        
        -- Animación de flotación
        spawn(function()
            local startY = part.Position.Y
            for t = 0, 5, 0.1 do
                if part.Parent then
                    part.Position = part.Position + Vector3.new(0, math.sin(t * 3) * 0.1, 0)
                    part.Rotation = Vector3.new(0, t * 50, 0)
                end
                wait(0.1)
            end
            if part.Parent then
                part:Destroy()
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
                    statusLabel.Text = "🎯 Moving to: " .. closestBrainrot.Name
                    createVisualEffects(targetPos)
                    moveToTarget(targetPos)
                end
            end
        end
    else
        statusLabel.Text = "🔍 Searching for brainrots..."
    end
end

-- Evento del botón
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
            wait(2) -- Esperar 2 segundos entre búsquedas
            autoStealLoop()
        end)
    else
        button.Text = "🔴 Auto Steal: OFF"
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        statusLabel.Text = "💤 Status: Inactive"
        countLabel.Text = "🎯 Found: 0 brainrots"
        isMoving = false
        
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
print("🎯 Click the button to activate auto stealing")
