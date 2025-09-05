-- Server Script - Coloca en ServerScriptService
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Lista completa de brainrots
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
local brainrotSystemEnabled = true -- Activado por defecto
local playersWithBrainrots = {}
local chatConnections = {}

-- Función para crear GUI en el cliente
local function createPlayerGUI(player)
    player.CharacterAdded:Connect(function(character)
        wait(1) -- Esperar a que cargue
        
        local playerGui = player:WaitForChild("PlayerGui")
        
        -- Crear ScreenGui
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "BrainrotGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
        
        -- Crear botón de toggle
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 150, 0, 40)
        toggleButton.Position = UDim2.new(0, 10, 0, 10)
        toggleButton.BackgroundColor3 = brainrotSystemEnabled and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
        toggleButton.Text = brainrotSystemEnabled and "BRAINROT: ON" or "BRAINROT: OFF"
        toggleButton.TextColor3 = Color3.new(1, 1, 1)
        toggleButton.TextScaled = true
        toggleButton.Font = Enum.Font.SourceSansBold
        toggleButton.Parent = screenGui
        
        -- Esquinas redondeadas
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = toggleButton
        
        -- Info label
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(0, 300, 0, 60)
        infoLabel.Position = UDim2.new(0, 10, 0, 60)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Text = "Escribe cualquier brainrot en el chat\npara que tu cuerpo caiga al vacío"
        infoLabel.TextColor3 = Color3.new(1, 1, 1)
        infoLabel.TextScaled = true
        infoLabel.Font = Enum.Font.SourceSans
        infoLabel.Parent = screenGui
        
        -- Evento del botón
        toggleButton.MouseButton1Click:Connect(function()
            brainrotSystemEnabled = not brainrotSystemEnabled
            
            if brainrotSystemEnabled then
                toggleButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
                toggleButton.Text = "BRAINROT: ON"
                print("🎮 Sistema Brainrot ACTIVADO")
            else
                toggleButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
                toggleButton.Text = "BRAINROT: OFF"
                print("🎮 Sistema Brainrot DESACTIVADO")
            end
        end)
    end)
end

-- Función para crear brainrot en workspace
local function createBrainrotInWorkspace(brainrotName, player)
    local brainrotFolder = workspace:FindFirstChild("ActiveBrainrots")
    if not brainrotFolder then
        brainrotFolder = Instance.new("Folder")
        brainrotFolder.Name = "ActiveBrainrots"
        brainrotFolder.Parent = workspace
    end
    
    -- Crear el brainrot visual flotante
    local brainrotPart = Instance.new("Part")
    brainrotPart.Name = brainrotName .. "_" .. player.Name
    brainrotPart.Size = Vector3.new(3, 0.2, 6)
    brainrotPart.Material = Enum.Material.ForceField
    brainrotPart.BrickColor = BrickColor.new("Bright green")
    brainrotPart.Anchored = true
    brainrotPart.CanCollide = false
    brainrotPart.Shape = Enum.PartType.Block
    brainrotPart.Transparency = 0.3
    
    -- Efecto de brillo
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(0, 1, 0)
    pointLight.Brightness = 2
    pointLight.Range = 10
    pointLight.Parent = brainrotPart
    
    -- Texto del brainrot
    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.new(0, 400, 0, 100)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.Parent = brainrotPart
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "🧠 " .. brainrotName .. " 🧠"
    textLabel.TextColor3 = Color3.new(0, 1, 0)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = gui
    
    -- Posicionar cerca del jugador
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        brainrotPart.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 8, 0)
    end
    
    brainrotPart.Parent = brainrotFolder
    
    -- Animación flotante
    local floatTween = TweenService:Create(brainrotPart, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Position = brainrotPart.Position + Vector3.new(0, 2, 0)
    })
    floatTween:Play()
    
    return brainrotPart
end

-- Función PRINCIPAL para dropear el cuerpo
local function dropPlayerBody(player, brainrotName)
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoidRootPart or not humanoid then return end
    
    -- 1. CREAR CUERPO QUE CAERÁ
    local bodyClone = character:Clone()
    bodyClone.Name = character.Name .. "_FallingBody"
    bodyClone.Parent = workspace
    
    -- Limpiar scripts del clon
    for _, obj in pairs(bodyClone:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            obj:Destroy()
        end
    end
    
    -- Hacer que el cuerpo caiga DRAMÁTICAMENTE
    local cloneHRP = bodyClone:FindFirstChild("HumanoidRootPart")
    if cloneHRP then
        cloneHRP.Anchored = false
        cloneHRP.CanCollide = false -- Para que atraviese el suelo
        
        -- IMPULSO FUERTE hacia abajo
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, -100, 0) -- Caída súper rápida
        bodyVelocity.Parent = cloneHRP
        
        -- Efecto visual en el cuerpo que cae
        local fire = Instance.new("Fire")
        fire.Size = 10
        fire.Heat = 10
        fire.Color = Color3.new(1, 0, 0)
        fire.Parent = cloneHRP
        
        -- Sonido de caída (opcional)
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/impact_water.mp3"
        sound.Volume = 0.5
        sound.Parent = cloneHRP
        sound:Play()
    end
    
    -- 2. CONVERTIR AL JUGADOR EN SOLO ROOTPART
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part ~= humanoidRootPart then
            part:Destroy() -- Eliminar todas las partes excepto HumanoidRootPart
        elseif part:IsA("Accessory") then
            part:Destroy() -- Eliminar accesorios
        elseif part:IsA("Clothing") then
            part:Destroy() -- Eliminar ropa
        end
    end
    
    -- Hacer el HumanoidRootPart más visible
    humanoidRootPart.Material = Enum.Material.Neon
    humanoidRootPart.BrickColor = BrickColor.new("Bright blue")
    humanoidRootPart.Transparency = 0
    humanoidRootPart.Shape = Enum.PartType.Block
    humanoidRootPart.Size = Vector3.new(2, 2, 1) -- Hacer más grande para que se vea
    
    -- Agregar efecto visual al jugador
    local playerLight = Instance.new("PointLight")
    playerLight.Color = Color3.new(0, 0, 1)
    playerLight.Brightness = 2
    playerLight.Range = 8
    playerLight.Parent = humanoidRootPart
    
    -- Mensaje de confirmación visible
    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.new(0, 200, 0, 50)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.Parent = humanoidRootPart
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name .. " (CUBO)"
    nameLabel.TextColor3 = Color3.new(0, 0, 1)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = gui
    
    -- Limpiar el cuerpo caído después de 20 segundos
    game:GetService("Debris"):AddItem(bodyClone, 20)
    
    print("💀 " .. player.Name .. " se convirtió en cubo y su cuerpo cayó al vacío con: " .. brainrotName)
end

-- Función para verificar si es brainrot válido
local function isValidBrainrot(name)
    for _, brainrot in pairs(BRAINROTS) do
        if string.lower(brainrot) == string.lower(name) then
            return brainrot -- Devolver el nombre exacto
        end
    end
    return nil
end

-- EVENTOS PRINCIPALES
Players.PlayerAdded:Connect(function(player)
    playersWithBrainrots[player.UserId] = {}
    
    -- Crear GUI para el jugador
    createPlayerGUI(player)
    
    -- Conectar chat
    player.CharacterAdded:Connect(function(character)
        -- Desconectar conexión anterior
        if chatConnections[player.UserId] then
            chatConnections[player.UserId]:Disconnect()
        end
        
        chatConnections[player.UserId] = player.Chatted:Connect(function(message)
            if brainrotSystemEnabled then
                local validBrainrot = isValidBrainrot(message)
                if validBrainrot then
                    -- Solo permitir un brainrot por jugador
                    if not playersWithBrainrots[player.UserId][validBrainrot] then
                        playersWithBrainrots[player.UserId][validBrainrot] = true
                        
                        -- Crear brainrot en workspace
                        createBrainrotInWorkspace(validBrainrot, player)
                        
                        -- DROPEAR EL CUERPO
                        dropPlayerBody(player, validBrainrot)
                        
                        -- Mensaje global
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= player then
                                -- Puedes agregar aquí notificaciones a otros jugadores
                            end
                        end
                    end
                end
            end
        end)
    end)
end)

-- Limpiar al salir
Players.PlayerRemoving:Connect(function(player)
    playersWithBrainrots[player.UserId] = nil
    
    if chatConnections[player.UserId] then
        chatConnections[player.UserId]:Disconnect()
        chatConnections[player.UserId] = nil
    end
end)

print("🧠 Sistema Brainrot Body Drop cargado!")
print("📝 Escribe cualquier brainrot en el chat para activar el efecto")
print("🎮 Total de brainrots disponibles: " .. #BRAINROTS)
