-- Grow a Garden Egg ESP - Detecta automáticamente nombres de mascotas en huevos

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local eggESPs = {}
local mainGui = nil
local miniPanel = nil
local isOpen = false
local espEnabled = false
local connection = nil

-- Función para crear el botón principal y mini panel
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EggESP"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Botón principal
    local mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(0, 100, 0, 35)
    mainButton.Position = UDim2.new(0, 10, 0.5, -17)
    mainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mainButton.BorderSizePixel = 0
    mainButton.Text = "🥚 ESP"
    mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainButton.TextScaled = true
    mainButton.Font = Enum.Font.GothamBold
    mainButton.Parent = screenGui
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = mainButton
    
    -- Mini panel
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 200, 0, 80)
    panel.Position = UDim2.new(0, 120, 0.5, -40)
    panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.Parent = screenGui
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 8)
    panelCorner.Parent = panel
    
    -- Toggle ESP button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.9, 0, 0.6, 0)
    toggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "Egg ESP: OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.Parent = panel
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleButton
    
    -- Función para toggle del panel
    mainButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        panel.Visible = isOpen
        
        if isOpen then
            panel:TweenPosition(UDim2.new(0, 120, 0.5, -40), "Out", "Quad", 0.3, true)
        end
    end)
    
    -- Función para toggle del ESP
    toggleButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        
        if espEnabled then
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            toggleButton.Text = "Egg ESP: ON"
            startESP()
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            toggleButton.Text = "Egg ESP: OFF"
            stopESP()
        end
    end)
    
    return screenGui, panel
end

-- Función para crear ESP en un huevo
local function createEggESP(egg)
    if eggESPs[egg] then return end
    
    -- Obtener el nombre de la mascota automáticamente
    local petName = getPetNameFromEgg(egg)
    if not petName then return end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 150, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = egg
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = billboardGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🐾 " .. petName
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    eggESPs[egg] = billboardGui
end

-- Función para obtener el nombre de la mascota del huevo
local function getPetNameFromEgg(egg)
    -- Buscar en StringValues
    for _, child in pairs(egg:GetDescendants()) do
        if child:IsA("StringValue") and (child.Name == "Pet" or child.Name == "PetName" or child.Name == "Animal") then
            return child.Value
        end
    end
    
    -- Buscar en atributos
    local petName = egg:GetAttribute("Pet") or egg:GetAttribute("PetName") or egg:GetAttribute("Animal")
    if petName then return petName end
    
    -- Buscar en el nombre del modelo o parte
    if egg.Name and egg.Name ~= "Part" and egg.Name ~= "MeshPart" then
        local name = egg.Name:gsub("Egg", ""):gsub("egg", ""):gsub("_", " ")
        if name ~= "" then return name end
    end
    
    return nil
end

-- Función para encontrar huevos
local function findEggs()
    local eggs = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- Identificar huevos por nombre o estructura
            if obj.Name:lower():find("egg") or obj:FindFirstChild("Pet") or obj:GetAttribute("Pet") then
                table.insert(eggs, obj)
            end
        end
    end
    
    return eggs
end

-- Función para actualizar ESP
local function updateESP()
    if not espEnabled then return end
    
    local eggs = findEggs()
    
    for _, egg in pairs(eggs) do
        if egg and egg.Parent then
            createEggESP(egg)
        end
    end
    
    -- Limpiar ESP obsoletos
    for egg, gui in pairs(eggESPs) do
        if not egg or not egg.Parent then
            if gui then gui:Destroy() end
            eggESPs[egg] = nil
        end
    end
end

-- Función para iniciar ESP
function startESP()
    if connection then connection:Disconnect() end
    connection = RunService.Heartbeat:Connect(updateESP)
end

-- Función para detener ESP
function stopESP()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    for egg, gui in pairs(eggESPs) do
        if gui then gui:Destroy() end
    end
    eggESPs = {}
end

-- Crear GUI
mainGui, miniPanel = createGUI()

-- Cleanup
game.Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        stopESP()
    end
end)

print("🥚 Grow a Garden Egg ESP cargado! Haz clic en el botón para abrir el panel.")
