local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Configuración del ESP
local ESPConfig = {
    enabled = false,
    toggleKey = Enum.KeyCode.T, -- Tecla para activar/desactivar (puedes cambiarla)
    textColor = Color3.fromRGB(0, 255, 255), -- Color cyan para frutas tranquil
    textSize = 16,
    maxDistance = 500, -- Distancia máxima para mostrar el ESP
    showDistance = true
}

-- Tabla para almacenar las conexiones del ESP
local espConnections = {}
local espObjects = {}

-- Función para crear el texto del ESP
local function createESPText()
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = ESPConfig.textColor
    textLabel.TextSize = ESPConfig.textSize
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboardGui
    
    return billboardGui, textLabel
end

-- Función para verificar si una fruta tiene la mutación tranquil
local function hasTranquilMutation(fruit)
    -- Buscar en los atributos o propiedades de la fruta
    if fruit:GetAttribute("Mutation") == "tranquil" then
        return true
    end
    
    -- Verificar en StringValues o configuraciones
    local mutationValue = fruit:FindFirstChild("Mutation")
    if mutationValue and mutationValue.Value == "tranquil" then
        return true
    end
    
    -- Verificar en el nombre si contiene "tranquil"
    if string.lower(fruit.Name):find("tranquil") then
        return true
    end
    
    -- Verificar en configuración de la fruta si existe
    local config = fruit:FindFirstChild("Config")
    if config then
        local mutation = config:FindFirstChild("Mutation")
        if mutation and mutation.Value == "tranquil" then
            return true
        end
    end
    
    return false
end

-- Función para obtener información de la fruta
local function getFruitInfo(fruit)
    local fruitName = fruit.Name
    local mutation = "Tranquil"
    
    -- Intentar obtener más información específica
    local config = fruit:FindFirstChild("Config")
    if config then
        local nameValue = config:FindFirstChild("FruitName")
        if nameValue then
            fruitName = nameValue.Value
        end
    end
    
    return fruitName, mutation
end

-- Función para calcular la distancia
local function getDistance(fruit)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    local fruitPos = fruit.Position
    return (playerPos - fruitPos).Magnitude
end

-- Función para actualizar el ESP de una fruta
local function updateFruitESP(fruit, billboardGui, textLabel)
    if not fruit.Parent then
        return false
    end
    
    local distance = getDistance(fruit)
    
    -- Ocultar si está muy lejos
    if distance > ESPConfig.maxDistance then
        billboardGui.Enabled = false
        return true
    end
    
    billboardGui.Enabled = ESPConfig.enabled
    
    if ESPConfig.enabled then
        local fruitName, mutation = getFruitInfo(fruit)
        local text = string.format("[%s] %s", mutation, fruitName)
        
        if ESPConfig.showDistance then
            text = text .. string.format(" (%.0fm)", distance)
        end
        
        textLabel.Text = text
        
        -- Cambiar opacidad basada en la distancia
        local alpha = math.max(0.3, 1 - (distance / ESPConfig.maxDistance))
        textLabel.TextTransparency = 1 - alpha
    end
    
    return true
end

-- Función para agregar ESP a una fruta
local function addFruitESP(fruit)
    if espObjects[fruit] then
        return
    end
    
    local billboardGui, textLabel = createESPText()
    billboardGui.Parent = fruit
    
    espObjects[fruit] = {
        gui = billboardGui,
        label = textLabel
    }
    
    -- Conexión para actualizar el ESP
    local connection = RunService.Heartbeat:Connect(function()
        if not updateFruitESP(fruit, billboardGui, textLabel) then
            -- La fruta fue eliminada, limpiar
            if espObjects[fruit] then
                espObjects[fruit] = nil
            end
            connection:Disconnect()
        end
    end)
    
    table.insert(espConnections, connection)
end

-- Función para escanear frutas con mutación tranquil
local function scanForTranquilFruits()
    -- Buscar en diferentes ubicaciones posibles
    local searchAreas = {
        Workspace:FindFirstChild("Fruits"),
        Workspace:FindFirstChild("Items"),
        Workspace:FindFirstChild("Drops"),
        Workspace
    }
    
    for _, area in pairs(searchAreas) do
        if area then
            for _, obj in pairs(area:GetDescendants()) do
                if obj:IsA("BasePart") and hasTranquilMutation(obj) then
                    addFruitESP(obj)
                end
            end
        end
    end
end

-- Función para limpiar todos los ESP
local function clearAllESP()
    for fruit, espData in pairs(espObjects) do
        if espData.gui then
            espData.gui:Destroy()
        end
    end
    espObjects = {}
    
    for _, connection in pairs(espConnections) do
        connection:Disconnect()
    end
    espConnections = {}
end

-- Función para toggle del ESP
local function toggleESP()
    ESPConfig.enabled = not ESPConfig.enabled
    
    if ESPConfig.enabled then
        print("🍎 Tranquil Fruit ESP: ACTIVADO")
        scanForTranquilFruits()
        
        -- Escanear continuamente por nuevas frutas
        local scanConnection = RunService.Heartbeat:Connect(function()
            if ESPConfig.enabled then
                scanForTranquilFruits()
            end
        end)
        table.insert(espConnections, scanConnection)
    else
        print("🍎 Tranquil Fruit ESP: DESACTIVADO")
        clearAllESP()
    end
end

-- Detectar cuando se agregan nuevas frutas
local function onChildAdded(child)
    if ESPConfig.enabled and child:IsA("BasePart") and hasTranquilMutation(child) then
        wait(0.1) -- Pequeña espera para asegurar que la fruta esté completamente cargada
        addFruitESP(child)
    end
end

-- Conectar eventos
Workspace.ChildAdded:Connect(onChildAdded)
if Workspace:FindFirstChild("Fruits") then
    Workspace.Fruits.ChildAdded:Connect(onChildAdded)
end

-- Input para toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == ESPConfig.toggleKey then
        toggleESP()
    end
end)

-- Limpiar al salir
Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        clearAllESP()
    end
end)

-- Mensaje inicial
print("🍎 Tranquil Fruit ESP cargado!")
print("📋 Presiona '" .. ESPConfig.toggleKey.Name .. "' para activar/desactivar")
print("⚙️ Configuración:")
print("   - Distancia máxima: " .. ESPConfig.maxDistance .. "m")
print("   - Color: Cyan")
print("   - Mostrar distancia: " .. (ESPConfig.showDistance and "Sí" or "No"))

-- Función para cambiar configuración (opcional)
_G.TranquilESPConfig = function(setting, value)
    if setting == "toggleKey" then
        ESPConfig.toggleKey = value
        print("🔧 Tecla de toggle cambiada a: " .. value.Name)
    elseif setting == "maxDistance" then
        ESPConfig.maxDistance = value
        print("🔧 Distancia máxima cambiada a: " .. value .. "m")
    elseif setting == "textColor" then
        ESPConfig.textColor = value
        print("🔧 Color del texto cambiado")
    elseif setting == "showDistance" then
        ESPConfig.showDistance = value
        print("🔧 Mostrar distancia: " .. (value and "Activado" or "Desactivado"))
    end
end

return {
    toggle = toggleESP,
    clear = clearAllESP,
    config = _G.TranquilESPConfig
}
