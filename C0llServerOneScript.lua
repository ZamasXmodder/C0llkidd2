-- Server Script - Panel de Administración con Sistema Brainrot
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuración de administradores (agrega tu UserId aquí)
local ADMINS = {
    4622374080, -- Reemplaza con tu UserId
    -- Agrega más UserIds de admins aquí
}

-- Lista completa de todos los brainrots
local BRAINROTS = {
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
    "Cocofanta Elefanto", "Girafa Celestre", "Gyattatino Nyanino", "Matteo", "Tralalero Tralala",
    "Espresso Signora", "Odin Din Din Dun", "Statutino Libertino", "Trenostruzzo Turbo 3000",
    "Ballerino Lololo", "Los Orcalitos", "Tralalita Tralala", "Urubini Flamenguini",
    "Trigoligre Frutonni", "Orcalero Orcala", "Bulbito Bandito Traktorito", "Los Crocodilitos",
    "Piccione Macchina", "Trippi Troppi Troppa Trippa", "Los Tungtuntuncitos", "Tukanno Bananno",
    "Alessio", "Tipi Topi Taco", "Pakrahmatmamat", "Bombardini Tortinii", "La Vacca Saturno Saturnita",
    "Chimpanzini Spiderini", "Los Tralaleritos", "Las Tralaleritas", "Graipuss Medussi",
    "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung", "Tortuginni Dragonfruitini",
    "Pot Hotspot", "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira", "Agarrini la Palini",
    "Dragon Cannelloni", "Los Combinasionas", "Karkerkar Kurkur", "Los Hotspotsitos",
    "Esok Sekolah", "Los Matteos", "Dul Dul Dul", "Blackhole Goat", "Nooo My Hotspot",
    "Sammyini Spyderini", "La Supreme Combinasion", "Ketupat Kepat"
}

-- Variables del sistema
local brainrotSystemEnabled = false
local playersWithBrainrots = {}
local droppedBodies = {}
local chatConnections = {}

-- Función para verificar si es admin
local function isAdmin(player)
    for _, adminId in pairs(ADMINS) do
        if player.UserId == adminId then
            return true
        end
    end
    return false
end

-- Función para crear el panel de administración
local function createAdminPanel(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Crear ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdminPanel"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -40, 0, 50)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎮 Panel de Administración"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = mainFrame
    
    -- Botón de cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Sección Brainrot
    local brainrotSection = Instance.new("Frame")
    brainrotSection.Name = "BrainrotSection"
    brainrotSection.Size = UDim2.new(1, -40, 0, 80)
    brainrotSection.Position = UDim2.new(0, 20, 0, 70)
    brainrotSection.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
    brainrotSection.BorderSizePixel = 0
    brainrotSection.Parent = mainFrame
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = brainrotSection
    
    -- Título de sección
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, -20, 0, 30)
    sectionTitle.Position = UDim2.new(0, 10, 0, 5)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = "Sistema Brainrot Body Drop"
    sectionTitle.TextColor3 = Color3.new(1, 1, 1)
    sectionTitle.TextScaled = true
    sectionTitle.Font = Enum.Font.SourceSans
    sectionTitle.Parent = brainrotSection
    
    -- Toggle Brainrot System
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleBrainrot"
    toggleButton.Size = UDim2.new(0, 100, 0, 35)
    toggleButton.Position = UDim2.new(0, 15, 0, 40)
    toggleButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    toggleButton.Text = "DESACTIVADO"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.Parent = brainrotSection
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 200, 0, 35)
    statusLabel.Position = UDim2.new(0, 125, 0, 40)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Los jugadores NO pueden usar brainrots"
    statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Parent = brainrotSection
    
    -- Información adicional
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 80)
    infoLabel.Position = UDim2.new(0, 20, 0, 160)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "ℹ️ Cuando esté activado:\n• Los jugadores pueden escribir nombres de brainrots en el chat\n• Su cuerpo se soltará y caerá por debajo del mapa\n• Podrán seguir caminando normalmente"
    infoLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.Parent = mainFrame
    
    -- Función para actualizar UI
    local function updateUI()
        if brainrotSystemEnabled then
            toggleButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
            toggleButton.Text = "ACTIVADO"
            statusLabel.Text = "Los jugadores PUEDEN usar brainrots"
            statusLabel.TextColor3 = Color3.new(0.2, 0.8, 0.2)
        else
            toggleButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
            toggleButton.Text = "DESACTIVADO"
            statusLabel.Text = "Los jugadores NO pueden usar brainrots"
            statusLabel.TextColor3 = Color3.new(0.8, 0.2, 0.2)
        end
    end
    
    -- Eventos
    toggleButton.MouseButton1Click:Connect(function()
        brainrotSystemEnabled = not brainrotSystemEnabled
        updateUI()
        
        if brainrotSystemEnabled then
            print("🎮 Sistema Brainrot ACTIVADO por " .. player.Name)
        else
            print("🎮 Sistema Brainrot DESACTIVADO por " .. player.Name)
            -- Limpiar brainrots activos
            local activeFolder = workspace:FindFirstChild("ActiveBrainrots")
            if activeFolder then
                activeFolder:ClearAllChildren()
            end
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Animación de entrada
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 300)
    })
    openTween:Play()
end

-- Funciones del sistema Brainrot (las mismas de antes)
local function createBrainrotInWorkspace(brainrotName, player)
    local brainrotFolder = workspace:FindFirstChild("ActiveBrainrots")
    if not brainrotFolder then
        brainrotFolder = Instance.new("Folder")
        brainrotFolder.Name = "ActiveBrainrots"
        brainrotFolder.Parent = workspace
    end
    
    local brainrotPart = Instance.new("Part")
    brainrotPart.Name = brainrotName .. "_" .. player.Name
    brainrotPart.Size = Vector3.new(2, 0.1, 4)
    brainrotPart.Material = Enum.Material.Neon
    brainrotPart.BrickColor = BrickColor.new("Bright green")
    brainrotPart.Anchored = true
    brainrotPart.CanCollide = false
    brainrotPart.Shape = Enum.PartType.Cylinder
    
    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.new(0, 200, 0, 50)
    gui.StudsOffset = Vector3.new(0, 2, 0)
    gui.Parent = brainrotPart
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = brainrotName
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = gui
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        brainrotPart.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
    end
    
    brainrotPart.Parent = brainrotFolder
    return brainrotPart
end

local function dropPlayerBody(player)
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoidRootPart or not humanoid then return end
    
    local bodyClone = character:Clone()
    bodyClone.Name = character.Name .. "_DroppedBody"
    bodyClone.Parent = workspace
    
    for _, obj in pairs(bodyClone:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            obj:Destroy()
        end
    end
    
    local cloneHRP = bodyClone:FindFirstChild("HumanoidRootPart")
    if cloneHRP then
        cloneHRP.Anchored = false
        cloneHRP.CanCollide = true
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, -50, 0)
        bodyVelocity.Parent = cloneHRP
        
        game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
    end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part ~= humanoidRootPart then
            part.Transparency = 1
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 1
            end
        end
    end
    
    droppedBodies[player.UserId] = bodyClone
    game:GetService("Debris"):AddItem(bodyClone, 30)
end

local function isValidBrainrot(name)
    for _, brainrot in pairs(BRAINROTS) do
        if string.lower(brainrot) == string.lower(name) then
            return true
        end
    end
    return false
end

-- Eventos de jugadores
Players.PlayerAdded:Connect(function(player)
    playersWithBrainrots[player.UserId] = {}
    
    -- Crear panel para admins
    if isAdmin(player) then
        player.CharacterAdded:Connect(function()
            wait(2) -- Esperar a que cargue completamente
            createAdminPanel(player)
        end)
    end
    
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Desconectar conexión anterior si existe
        if chatConnections[player.UserId] then
            chatConnections[player.UserId]:Disconnect()
        end
        
        chatConnections[player.UserId] = player.Chatted:Connect(function(message)
            if brainrotSystemEnabled and isValidBrainrot(message) then
                if not playersWithBrainrots[player.UserId][message] then
                    playersWithBrainrots[player.UserId][message] = true
                    
                    createBrainrotInWorkspace(message, player)
                    dropPlayerBody(player)
                    
                    print("🎮 " .. player.Name .. " agarró: " .. message)
                end
            end
        end)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    playersWithBrainrots[player.UserId] = nil
    
    if chatConnections[player.UserId] then
        chatConnections[player.UserId]:Disconnect()
        chatConnections[player.UserId] = nil
    end
    
    if droppedBodies[player.UserId] then
        droppedBodies[player.UserId]:Destroy()
        droppedBodies[player.UserId] = nil
    end
end)

print("🎮 Panel de Administración con Sistema Brainrot cargado!")
print("🔑 Admins configurados: " .. #ADMINS)
