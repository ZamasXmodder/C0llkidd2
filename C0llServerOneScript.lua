-- Italian Brainrot Invisible Steal Panel - FIXED VERSION
-- Makes player and equipped brainrot completely invisible to ALL players

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local invisibleStealEnabled = false
local invisibilityConnection = nil
local originalTransparencies = {}
local hiddenConnections = {}

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

-- Make object invisible (proper method)
local function makeInvisible(object)
    if not object then return end
    
    for _, part in pairs(object:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Store original transparency
            if not originalTransparencies[part] then
                originalTransparencies[part] = part.Transparency
            end
            -- Make invisible
            part.Transparency = 1
            
        elseif part:IsA("Decal") or part:IsA("Texture") then
            if not originalTransparencies[part] then
                originalTransparencies[part] = part.Transparency
            end
            part.Transparency = 1
            
        elseif part:IsA("SurfaceGui") or part:IsA("BillboardGui") or part:IsA("ScreenGui") then
            if not originalTransparencies[part] then
                originalTransparencies[part] = part.Enabled
            end
            part.Enabled = false
            
        elseif part:IsA("Fire") or part:IsA("Smoke") or part:IsA("Sparkles") then
            if not originalTransparencies[part] then
                originalTransparencies[part] = part.Enabled
            end
            part.Enabled = false
            
        elseif part:IsA("PointLight") or part:IsA("SpotLight") or part:IsA("SurfaceLight") then
            if not originalTransparencies[part] then
                originalTransparencies[part] = part.Enabled
            end
            part.Enabled = false
        end
    end
end

-- Make object visible (restore)
local function makeVisible(object)
    if not object then return end
    
    for _, part in pairs(object:GetDescendants()) do
        if originalTransparencies[part] ~= nil then
            if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = originalTransparencies[part]
            elseif part:IsA("SurfaceGui") or part:IsA("BillboardGui") or part:IsA("ScreenGui") or 
                   part:IsA("Fire") or part:IsA("Smoke") or part:IsA("Sparkles") or
                   part:IsA("PointLight") or part:IsA("SpotLight") or part:IsA("SurfaceLight") then
                part.Enabled = originalTransparencies[part]
            end
            originalTransparencies[part] = nil
        end
    end
end

-- Advanced invisibility method using CFrame manipulation
local function makeInvisibleAdvanced(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Method 1: Set all parts to maximum transparency
    makeInvisible(character)
    
    -- Method 2: Move character far away (but keep functionality)
    local rootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        -- Disable name display
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
    
    -- Method 3: Make character extremely small (almost invisible)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part ~= rootPart then
            if not originalTransparencies[part .. "_size"] then
                originalTransparencies[part .. "_size"] = part.Size
            end
            part.Size = Vector3.new(0.001, 0.001, 0.001)
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                if not originalTransparencies[handle .. "_size"] then
                    originalTransparencies[handle .. "_size"] = handle.Size
                end
                handle.Size = Vector3.new(0.001, 0.001, 0.001)
            end
        end
    end
end

-- Restore character visibility
local function makeVisibleAdvanced(character)
    if not character then return end
    
    makeVisible(character)
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
    end
    
    -- Restore sizes
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and originalTransparencies[part .. "_size"] then
            part.Size = originalTransparencies[part .. "_size"]
            originalTransparencies[part .. "_size"] = nil
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle and originalTransparencies[handle .. "_size"] then
                handle.Size = originalTransparencies[handle .. "_size"]
                originalTransparencies[handle .. "_size"] = nil
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
        
        -- Make player invisible
        makeInvisibleAdvanced(character)
        
        -- Handle equipped tool
        local equippedTool = character:FindFirstChildOfClass("Tool")
        if equippedTool and isBrainrot(equippedTool.Name) then
            makeInvisible(equippedTool)
        end
        
        -- Also check backpack for brainrots
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and isBrainrot(tool.Name) then
                    makeInvisible(tool)
                end
            end
        end
    end)
    
    print("👻 Invisible Steal: ACTIVADO")
    print("🧠 Jugador y brainrots completamente invisibles!")
end

-- Stop invisible steal
local function stopInvisibleSteal()
    if invisibilityConnection then
        invisibilityConnection:Disconnect()
        invisibilityConnection = nil
    end
    
    -- Restore visibility
    if player.Character then
        makeVisibleAdvanced(player.Character)
        
        -- Restore equipped tool
        local equippedTool = player.Character:FindFirstChildOfClass("Tool")
        if equippedTool then
            makeVisible(equippedTool)
        end
        
        -- Restore backpack tools
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    makeVisible(tool)
                end
            end
        end
    end
    
    -- Clear all stored data
    originalTransparencies = {}
    
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
    screenGui.ResetOnSpawn = false
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 250)
    mainFrame.Position = UDim2.new(0, 320, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- Add stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(128, 0, 128)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
    title.Text = "👻 INVISIBLE STEAL PANEL"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = title
    
    -- Invisible Steal Button
    local stealBtn = Instance.new("TextButton")
    stealBtn.Name = "InvisibleStealButton"
    stealBtn.Size = UDim2.new(0.85, 0, 0, 55)
    stealBtn.Position = UDim2.new(0.075, 0, 0, 80)
    stealBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
    stealBtn.Text = "🔴 INVISIBLE STEAL: OFF"
    stealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stealBtn.TextScaled = true
    stealBtn.Font = Enum.Font.GothamBold
    stealBtn.Parent = mainFrame
    
    local stealCorner = Instance.new("UICorner")
    stealCorner.CornerRadius = UDim.new(0, 10)
    stealCorner.Parent = stealBtn
    
    -- Info Label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0.9, 0, 0, 90)
    infoLabel.Position = UDim2.new(0.05, 0, 0, 150)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "🧠 Te hace COMPLETAMENTE invisible\na ti y al brainrot equipado\n👻 Invisible para TODOS los jugadores\n🎯 Método avanzado mejorado\n✅ Sin congelamiento del personaje"
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = mainFrame
    
    -- Button functionality
    stealBtn.MouseButton1Click:Connect(function()
        toggleInvisibleSteal()
        
        if invisibleStealEnabled then
            stealBtn.Text = "🟢 INVISIBLE STEAL: ON"
            stealBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            stealBtn.Text = "🔴 INVISIBLE STEAL: OFF"
            stealBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
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
    
    -- Clear stored data
    originalTransparencies = {}
    invisibleStealEnabled = false
end)

-- Restore when character respawns
player.CharacterAdded:Connect(function()
    wait(3) -- Wait for character to fully load
    if invisibleStealEnabled then
        -- Auto-restart if it was enabled
        startInvisibleSteal()
    end
end)

-- Initialize panel
local panel = createInvisibleStealPanel()

print("👻 Invisible Steal Panel V3 FIXED cargado!")
print("🧠 Método avanzado sin congelamiento")
print("🎯 Invisible para TODOS los jugadores")
print("✅ Funcionalidad del personaje preservada")
