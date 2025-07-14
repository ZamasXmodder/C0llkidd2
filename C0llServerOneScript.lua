-- Grow a Garden Light ESP - Sin interferencias, sin lag

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local eggESPs = {}
local espEnabled = false
local connection = nil
local updateCounter = 0

-- Función para crear GUI simple
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LightEggESP"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Botón pequeño
    local mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(0, 80, 0, 30)
    mainButton.Position = UDim2.new(0, 10, 0.5, -15)
    mainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mainButton.BorderSizePixel = 0
    mainButton.Text = "ESP"
    mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainButton.TextScaled = true
    mainButton.Font = Enum.Font.Gotham
    mainButton.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = mainButton
    
    -- Toggle ESP
    mainButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        
        if espEnabled then
            mainButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            mainButton.Text = "ESP ON"
            startLightESP()
        else
            mainButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            mainButton.Text = "ESP OFF"
            stopLightESP()
        end
    end)
    
    return screenGui
end

-- Función para obtener info básica del huevo
local function getBasicEggInfo(egg)
    local info = {
        eggType = "Unknown",
        isReady = false,
        timeLeft = nil
    }
    
    -- Solo buscar info básica, SIN interferir
    pcall(function()
        -- Tipo de huevo por nombre
        local eggName = egg.Name:lower()
        if eggName:find("paradise") then info.eggType = "Paradise"
        elseif eggName:find("forest") then info.eggType = "Forest"
        elseif eggName:find("ocean") then info.eggType = "Ocean"
        elseif eggName:find("desert") then info.eggType = "Desert"
        elseif eggName:find("volcano") then info.eggType = "Volcano"
        elseif eggName:find("crystal") then info.eggType = "Crystal"
        elseif eggName:find("golden") then info.eggType = "Golden"
        end
        
        -- Buscar tiempo SOLO en NumberValues obvios
        for _, child in pairs(egg:GetChildren()) do
            if child:IsA("NumberValue") and child.Name:lower():find("time") then
                info.timeLeft = child.Value
                info.isReady = child.Value <= 0
                break
            end
        end
        
        -- Buscar en atributos básicos
        local timeAttr = egg:GetAttribute("TimeLeft") or egg:GetAttribute("HatchTime")
        if timeAttr then
            info.timeLeft = timeAttr
            info.isReady = timeAttr <= 0
        end
    end)
    
    return info
end

-- Función para formatear tiempo
local function formatTime(seconds)
    if not seconds or seconds <= 0 then return "READY!" end
    
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    
    if hours > 0 then
        return string.format("%dh %dm", hours, minutes)
    else
        return string.format("%dm", minutes)
    end
end

-- Función para crear ESP ligero
local function createLightESP(egg)
    if eggESPs[egg] then return end
    
    local info = getBasicEggInfo(egg)
    
    -- BillboardGui MUY simple
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 120, 0, 40)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = egg
    
    -- Frame simple
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = billboardGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    -- Solo UN label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    -- Texto según estado
    if info.isReady then
        label.Text = "✅ " .. info.eggType
        label.TextColor3 = Color3.fromRGB(0, 255, 0)
        frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    else
        label.Text = info.eggType .. "\n" .. formatTime(info.timeLeft)
        label.TextColor3 = Color3.fromRGB(255, 255, 0)
    end
    
    eggESPs[egg] = {gui = billboardGui, label = label, frame = frame}
end

-- Función para encontrar huevos (método simple)
local function findEggs()
    local eggs = {}
    
    -- Buscar solo en workspace, método simple
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("egg") and obj.Parent then
            table.insert(eggs, obj)
        end
    end
    
    return eggs
end

-- Función de actualización LIGERA (cada 120 frames = 2 segundos)
local function lightUpdate()
    if not espEnabled then return end
    
    updateCounter = updateCounter + 1
    if updateCounter < 120 then return end -- Actualizar cada 2 segundos
    updateCounter = 0
    
    local eggs = findEggs()
    
    -- Crear ESP para huevos nuevos
    for _, egg in pairs(eggs) do
        if egg and egg.Parent and not eggESPs[egg] then
            createLightESP(egg)
        end
    end
    
    -- Actualizar huevos existentes
    for egg, espData in pairs(eggESPs) do
        if egg and egg.Parent then
            local info = getBasicEggInfo(egg)
            
            if info.isReady then
                espData.label.Text = "✅ " .. info.eggType .. " READY!"
                espData.label.TextColor3 = Color3.fromRGB(0, 255, 0)
                espData.frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            else
                espData.label.Text = info.eggType .. "\n" .. formatTime(info.timeLeft)
                espData.label.TextColor3 = Color3.fromRGB(255, 255, 0)
                espData.frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        else
            -- Limpiar ESP obsoletos
            if espData.gui then espData.gui:Destroy() end
            eggESPs[egg] = nil
        end
    end
end

-- Funciones de control
function startLightESP()
    if connection then connection:Disconnect() end
    connection = RunService.Heartbeat:Connect(lightUpdate)
end

function stopLightESP()
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

print("🥚 Light Egg ESP loaded!")
print("- No lag, no interference")
print("- Shows egg type and ready status")
print("- Click ESP button to toggle")
