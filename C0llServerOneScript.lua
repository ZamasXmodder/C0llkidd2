-- Grow a Garden Egg ESP - Versión mejorada para huevos en incubación

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local eggESPs = {}
local espEnabled = false
local connection = nil
local updateDelay = 0
local maxUpdateDelay = 60 -- Actualizar cada 60 frames para reducir lag

-- Función para crear GUI
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
    
    -- Toggle panel
    mainButton.MouseButton1Click:Connect(function()
        panel.Visible = not panel.Visible
    end)
    
    -- Toggle ESP
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
    
    return screenGui
end

-- Función para obtener información del huevo
local function getEggInfo(egg)
    local info = {
        petName = nil,
        timeLeft = nil,
        isReady = false,
        eggType = nil
    }
    
    -- Buscar información en el huevo
    for _, child in pairs(egg:GetDescendants()) do
        -- Buscar nombre de mascota
        if child:IsA("StringValue") then
            if child.Name:lower():find("pet") or child.Name:lower():find("animal") then
                info.petName = child.Value
            elseif child.Name:lower():find("type") then
                info.eggType = child.Value
            end
        end
        
        -- Buscar tiempo restante
        if child:IsA("NumberValue") and child.Name:lower():find("time") then
            info.timeLeft = child.Value
            info.isReady = child.Value <= 0
        end
        
        -- Buscar BoolValue para estado
        if child:IsA("BoolValue") and child.Name:lower():find("ready") then
            info.isReady = child.Value
        end
    end
    
    -- Buscar en atributos
    info.petName = info.petName or egg:GetAttribute("Pet") or egg:GetAttribute("PetName")
    info.timeLeft = info.timeLeft or egg:GetAttribute("TimeLeft") or egg:GetAttribute("HatchTime")
    info.isReady = info.isReady or egg:GetAttribute("Ready") or false
    
    -- Determinar tipo de huevo por nombre
    if not info.eggType then
        local eggName = egg.Name:lower()
        if eggName:find("paradise") then info.eggType = "Paradise"
        elseif eggName:find("forest") then info.eggType = "Forest"
        elseif eggName:find("ocean") then info.eggType = "Ocean"
        elseif eggName:find("desert") then info.eggType = "Desert"
        elseif eggName:find("volcano") then info.eggType = "Volcano"
        else info.eggType = "Unknown"
        end
    end
    
    return info
end

-- Función para formatear tiempo
local function formatTime(seconds)
    if not seconds or seconds <= 0 then return "Ready!" end
    
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    
    if hours > 0 then
        return string.format("%dh %dm", hours, minutes)
    elseif minutes > 0 then
        return string.format("%dm %ds", minutes, secs)
    else
        return string.format("%ds", secs)
    end
end

-- Función para crear ESP en huevo
local function createEggESP(egg)
    if eggESPs[egg] then return end
    
    local info = getEggInfo(egg)
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 180, 0, 70)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = egg
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = billboardGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    -- Línea 1: Tipo de huevo
    local typeLabel = Instance.new("TextLabel")
    typeLabel.Size = UDim2.new(1, 0, 0.4, 0)
    typeLabel.Position = UDim2.new(0, 0, 0, 0)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Text = "🥚 " .. (info.eggType or "Unknown Egg")
    typeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    typeLabel.TextScaled = true
    typeLabel.Font = Enum.Font.GothamBold
    typeLabel.Parent = frame
    
    -- Línea 2: Mascota o tiempo
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0.6, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.4, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = frame
    
    if info.petName and info.isReady then
        infoLabel.Text = "🐾 " .. info.petName
        infoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    elseif info.timeLeft then
        infoLabel.Text = "⏰ " .. formatTime(info.timeLeft)
        infoLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    else
        infoLabel.Text = "❓ Incubating..."
        infoLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    end
    
    eggESPs[egg] = {gui = billboardGui, infoLabel = infoLabel}
end

-- Función para encontrar huevos
local function findEggs()
    local eggs = {}
    
    -- Buscar en diferentes ubicaciones
    local searchAreas = {workspace}
    
    -- Agregar áreas específicas si existen
    if workspace:FindFirstChild("Garden") then
        table.insert(searchAreas, workspace.Garden)
    end
    if workspace:FindFirstChild("Eggs") then
        table.insert(searchAreas, workspace.Eggs)
    end
    
    for _, area in pairs(searchAreas) do
        for _, obj in pairs(area:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
                table.insert(eggs, obj)
            end
        end
    end
    
    return eggs
end

-- Función para actualizar ESP (con delay para reducir lag)
local function updateESP()
    if not espEnabled then return end
    
    updateDelay = updateDelay + 1
    if updateDelay < maxUpdateDelay then return end
    updateDelay = 0
    
    local eggs = findEggs()
    
    -- Crear ESP para huevos nuevos
    for _, egg in pairs(eggs) do
        if egg and egg.Parent and not eggESPs[egg] then
            createEggESP(egg)
        end
    end
    
    -- Actualizar información existente
    for egg, espData in pairs(eggESPs) do
        if egg and egg.Parent and espData.infoLabel then
            local info = getEggInfo(egg)
            
            if info.petName and info.isReady then
                espData.infoLabel.Text = "🐾 " .. info.petName
                espData.infoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            elseif info.timeLeft then
                espData.infoLabel.Text = "⏰ " .. formatTime(info.timeLeft)
                espData.infoLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            end
        elseif not egg or not egg.Parent then
            -- Limpiar ESP obsoletos
            if espData.gui then espData.gui:Destroy() end
            eggESPs[egg] = nil
        end
    end
end

-- Funciones de control
function startESP()
    if connection then connection:Disconnect() end
    connection = RunService.Heartbeat:Connect(updateESP)
end

function stopESP()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    for egg, espData in pairs(eggESPs) do
        if espData.gui then espData.gui:Destroy() end
    end
    eggESPs = {}
end

-- Crear GUI
createGUI()

print("🥚 Egg ESP mejorado cargado!")
print("- Muestra tipo de huevo y tiempo restante")
print("- Muestra mascota cuando esté lista")
print("- Optimizado para reducir lag")
