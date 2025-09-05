-- Italian Brainrot Invisible Steal Panel
-- Makes player and equipped brainrot completely invisible to ALL players

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local invisibleStealEnabled = false
local invisibilityConnection = nil
local originalTransparencies = {}
local hiddenParts = {}

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

-- Make object completely invisible to everyone
local function makeCompletelyInvisible(object)
    if not object then return end
    
    for _, part in pairs(object:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Store original properties
            if not hiddenParts[part] then
                hiddenParts[part] = {
                    transparency = part.Transparency,
                    canCollide = part.CanCollide,
                    parent = part.Parent
                }
            end
            
            -- Make completely invisible and non-collidable
            part.Transparency = 1
            part.CanCollide = false
            
            -- Hide from everyone by moving to ReplicatedStorage temporarily
            if part.Parent ~= game.ReplicatedStorage then
                part.Parent = game.ReplicatedStorage
            end
            
        elseif part:IsA("Decal") or part:IsA("Texture") or part:IsA("SurfaceGui") then
            if not hiddenParts[part] then
                hiddenParts[part] = {
                    transparency = part.Transparency or 0,
                    parent = part.Parent
                }
            end
            part.Transparency = 1
            
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                if not hiddenParts[handle] then
                    hiddenParts[handle] = {
                        transparency = handle.Transparency,
                        canCollide = handle.CanCollide,
                        parent = handle.Parent
                    }
                end
                handle.Transparency = 1
                handle.CanCollide = false
                if handle.Parent ~= game.ReplicatedStorage then
                    handle.Parent = game.ReplicatedStorage
                end
            end
        end
    end
end

-- Restore object visibility
local function makeCompletelyVisible(object)
    if not object then return end
    
    for _, part in pairs(object:GetDescendants()) do
        if hiddenParts[part] then
            local stored = hiddenParts[part]
            
            -- Restore original properties
            if part:IsA("BasePart") then
                part.Transparency = stored.transparency
                part.CanCollide = stored.canCollide
                if stored.parent and stored.parent ~= game.ReplicatedStorage then
                    part.Parent = stored.parent
                end
            elseif part:IsA("Decal") or part:IsA("Texture") or part:IsA("SurfaceGui") then
                part.Transparency = stored.transparency
                if stored.parent then
                    part.Parent = stored.parent
                end
            end
            
            hiddenParts[part] = nil
        end
    end
end

-- Alternative method: Use CFrame manipulation to hide
local function hidePlayerAlternative(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    
    -- Move player far underground where no one can see
    if not hiddenParts[character] then
        hiddenParts[character] = {
            originalCFrame = rootPart.CFrame
        }
    end
    
    -- Teleport to underground position
    rootPart.CFrame = rootPart.CFrame + Vector3.new(0, -1000, 0)
    
    -- Make all parts invisible as backup
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part ~= rootPart then
            if not hiddenParts[part] then
                hiddenParts[part] = {transparency = part.Transparency}
            end
            part.Transparency = 1
        end
    end
end

-- Restore player position
local function showPlayerAlternative(character)
    if not character or not hiddenParts[character] then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart and hiddenParts[character].originalCFrame then
        rootPart.CFrame = hiddenParts[character].originalCFrame
    end
    
    -- Restore part visibility
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and hiddenParts[part] then
            part.Transparency = hiddenParts[part].transparency
            hiddenParts[part] = nil
        end
    end
    
    hiddenParts[character] = nil
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
        
        -- Method 1: Complete invisibility
        makeCompletelyInvisible(character)
        
        -- Method 2: Underground hiding (backup)
        hidePlayerAlternative(character)
        
        -- Hide equipped brainrot if it's a brainrot
        if equippedTool and isBrainrot(equippedTool.Name) then
            makeCompletelyInvisible(equippedTool)
            
            -- Additional method: Move tool parts to ReplicatedStorage
            for _, part in pairs(equippedTool:GetDescendants()) do
                if part:IsA("BasePart") and part.Parent ~= game.ReplicatedStorage then
                    part.Parent = game.ReplicatedStorage
                end
            end
        end
    end)
    
    print("👻 Invisible Steal: ACTIVADO")
    print("🧠 Jugador y brainrots equipados completamente invisibles para TODOS!")
end

-- Stop invisible steal
local function stopInvisibleSteal()
    if invisibilityConnection then
        invisibilityConnection:Disconnect()
        invisibilityConnection = nil
    end
    
    -- Restore visibility
    if player.Character then
        makeCompletelyVisible(player.Character)
        showPlayerAlternative(player.Character)
        
        local equippedTool = player.Character:FindFirstChildOfClass("Tool")
        if equippedTool then
            makeCompletelyVisible(equippedTool)
            
            -- Restore tool parts to proper parent
            for _, part in pairs(equippedTool:GetDescendants()) do
                if part:IsA("BasePart") and hiddenParts[part] and hiddenParts[part].parent then
                    part.Parent = hiddenParts[part].parent
                end
            end
        end
    end
    
    -- Clear all stored data
    hiddenParts = {}
    
    print("👻 Invisible Steal: DESACTIVADO")
    print("🧠 Visibilidad completamente restaurada!")
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
    mainFrame.Size = UDim2.new(0, 280, 0, 220)
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
    infoLabel.Size = UDim2.new(0.9, 0, 0, 80)
        infoLabel.Position = UDim2.new(0.05, 0, 0, 130)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "🧠 Te hace COMPLETAMENTE invisible\na ti y al brainrot equipado\n👻 Invisible para TODOS los jugadores\n🎯 Método múltiple para máxima efectividad"
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
    
    -- Clear stored data
    hiddenParts = {}
    invisibleStealEnabled = false
end)

-- Restore when character respawns
player.CharacterAdded:Connect(function()
    wait(2) -- Wait for character to fully load
    if invisibleStealEnabled then
        -- Auto-restart if it was enabled
        startInvisibleSteal()
    end
end)

-- Clean up when player leaves
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        if invisibilityConnection then
            invisibilityConnection:Disconnect()
            invisibilityConnection = nil
        end
        hiddenParts = {}
    end
end)

-- Initialize panel
local panel = createInvisibleStealPanel()

print("👻 Invisible Steal Panel V2 cargado!")
print("🧠 Método múltiple para invisibilidad COMPLETA")
print("🎯 Invisible para TODOS los jugadores")
print("🔧 Incluye backup underground + ReplicatedStorage hiding")
