-- Italian Brainrot Invisible Steal Panel
-- Makes player and equipped brainrot completely invisible

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local invisibleStealEnabled = false
local invisibilityConnection = nil
local originalTransparencies = {}

-- Italian Brainrots List
local brainrotList = {
    -- Regular brainrots
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
    "Alessio", "Tipi Topi Taco", "Pakrahmatmamat", "Bombardini Tortinii"
}

-- Secret brainrots
local secretBrainrots = {
    "La Vacca Saturno Saturnita", "Chimpanzini Spiderini", "Los Tralaleritos", "Las Tralaleritas",
    "Graipuss Medussi", "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung",
    "Tortuginni Dragonfruitini", "Pot Hotspot", "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira",
    "Agarrini la Palini", "Dragon Cannelloni", "Los Combinasionas", "Karkerkar Kurkur",
    "Los Hotspotsitos", "Esok Sekolah", "Los Matteos", "Dul Dul Dul", "Blackhole Goat",
    "Nooo My Hotspot", "Sammyini Spyderini", "La Supreme Combinasion", "Ketupat Kepat"
}

-- Check if a tool is a brainrot
local function isBrainrot(toolName)
    for _, brainrot in pairs(brainrotList) do
        if string.lower(toolName) == string.lower(brainrot) then
            return true
        end
    end
    for _, secret in pairs(secretBrainrots) do
        if string.lower(toolName) == string.lower(secret) then
            return true
        end
    end
    return false
end

-- Make object invisible
local function makeInvisible(object)
    if not object then return end
    
    for _, part in pairs(object:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Texture") then
            if not originalTransparencies[part] then
                originalTransparencies[part] = part.Transparency
            end
            part.Transparency = 1
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                if not originalTransparencies[handle] then
                    originalTransparencies[handle] = handle.Transparency
                end
                handle.Transparency = 1
            end
        end
    end
end

-- Make object visible
local function makeVisible(object)
    if not object then return end
    
    for _, part in pairs(object:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Texture") then
            if originalTransparencies[part] then
                part.Transparency = originalTransparencies[part]
                originalTransparencies[part] = nil
            end
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle and originalTransparencies[handle] then
                handle.Transparency = originalTransparencies[handle]
                originalTransparencies[handle] = nil
            end
        end
    end
end

-- Start invisible steal
local function startInvisibleSteal()
    if invisibilityConnection then
        invisibilityConnection:Disconnect()
    end
    
    invisibilityConnection = RunService.Heartbeat:Connect(function()
        if not player.Character then return end
        
        local character = player.Character
        local equippedTool = character:FindFirstChildOfClass("Tool")
        
        -- Make player invisible
        makeInvisible(character)
        
        -- Make equipped brainrot invisible if it's a brainrot
        if equippedTool and isBrainrot(equippedTool.Name) then
            makeInvisible(equippedTool)
        end
    end)
    
    print("👻 Invisible Steal: ACTIVADO")
    print("🧠 Jugador y brainrots equipados ahora son invisibles!")
end

-- Stop invisible steal
local function stopInvisibleSteal()
    if invisibilityConnection then
        invisibilityConnection:Disconnect()
        invisibilityConnection = nil
    end
    
    -- Restore visibility
    if player.Character then
        makeVisible(player.Character)
        
        local equippedTool = player.Character:FindFirstChildOfClass("Tool")
        if equippedTool then
            makeVisible(equippedTool)
        end
    end
    
    print("👻 Invisible Steal: DESACTIVADO")
    print("🧠 Visibilidad restaurada!")
end

-- Toggle invisible steal
local function toggleInvisibleSteal()
    if invisibleStealEnabled then
        invisibleStealEnabled = false
        stopInvisibleSteal()
    else
        invisibleStealEnabled = true
        startInvisibleSteal()
    end
end

-- Create control panel
local function createInvisibleStealPanel()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InvisibleStealPanel"
    screenGui.Parent = playerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 280, 0, 200)
    mainFrame.Position = UDim2.new(0, 320, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.Text = "👻 INVISIBLE STEAL PANEL"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title
    
    -- Invisible Steal Button
    local stealBtn = Instance.new("TextButton")
    stealBtn.Name = "InvisibleStealButton"
    stealBtn.Size = UDim2.new(0.9, 0, 0, 50)
    stealBtn.Position = UDim2.new(0.05, 0, 0, 70)
    stealBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
    stealBtn.Text = "INVISIBLE STEAL: OFF"
    stealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stealBtn.TextScaled = true
    stealBtn.Font = Enum.Font.GothamBold
    stealBtn.Parent = mainFrame
    
    local stealCorner = Instance.new("UICorner")
    stealCorner.CornerRadius = UDim.new(0, 8)
    stealCorner.Parent = stealBtn
    
    -- Info Label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0.9, 0, 0, 60)
    infoLabel.Position = UDim2.new(0.05, 0, 0, 130)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "🧠 Te hace invisible a ti y al\nbrainrot que tengas equipado\n👻 Perfecto para robar sin ser visto"
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = mainFrame
    
    -- Button functionality
    stealBtn.MouseButton1Click:Connect(function()
        toggleInvisibleSteal()
        
        if invisibleStealEnabled then
            stealBtn.Text = "INVISIBLE STEAL: ON"
            stealBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            stealBtn.Text = "INVISIBLE STEAL: OFF"
            stealBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
        end
    end)
    
    return screenGui
end

-- Clean up when character is removed
player.CharacterRemoving:Connect(function()
    if invisibilityConnection then
        invisibilityConnection:Disconnect()
        invisibilityConnection = nil
    end
    
    -- Clear stored transparencies
    originalTransparencies = {}
    
    invisibleStealEnabled = false
end)

-- Clean up when player leaves
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        if invisibilityConnection then
            invisibilityConnection:Disconnect()
            invisibilityConnection = nil
        end
        originalTransparencies = {}
    end
end)

-- Initialize panel
local panel = createInvisibleStealPanel()

print("👻 Invisible Steal Panel cargado!")
print("🧠 Haz clic en el botón para activar/desactivar")
print("🎯 Te volverás invisible junto con cualquier brainrot equipado")
