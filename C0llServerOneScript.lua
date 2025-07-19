local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Configuración del ESP
local ESPConfig = {
    enabled = false,
    toggleKey = Enum.KeyCode.T,
    textColor = Color3.fromRGB(0, 255, 255),
    textSize = 14,
    maxDistance = 300,
    updateRate = 0.5 -- Actualizar cada 0.5 segundos para reducir lag
}

-- Almacenamiento optimizado
local espObjects = {}
local lastUpdate = 0
local updateConnection = nil

-- Función para crear ESP más ligero
local function createESP(plant)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 150, 0, 30)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = plant
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = ESPConfig.textColor
    textLabel.TextSize = ESPConfig.textSize
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSans
    textLabel.Text = "🌿 TRANQUIL"
    textLabel.Parent = billboardGui
    
    return billboardGui
end

-- Función optimizada para detectar mutación tranquil
local function isTranquilPlant(obj)
    -- Verificar si es una planta primero
    if not obj:IsA("Model") and not obj:IsA("BasePart") then
        return false
    end
    
    -- Buscar en diferentes formatos de la mutación
    local function checkForTranquil(item)
        -- Verificar atributos
        local mutation = item:GetAttribute("Mutation")
        if mutation then
            local mutStr = tostring(mutation):lower()
            if mutStr:find("tranquil") then
                return true
            end
        end
        
        -- Verificar StringValues/IntValues
        for _, child in pairs(item:GetChildren()) do
            if child:IsA("StringValue") or child:IsA("IntValue") then
                local value = tostring(child.Value):lower()
                if value:find("tranquil") then
                    return true
                end
            end
        end
        
        return false
    end
    
    -- Verificar el objeto principal
    if checkForTranquil(obj) then
        return true
    end
    
    -- Verificar hijos si es un modelo
    if obj:IsA("Model") then
        for _, child in pairs(obj:GetChildren()) do
            if checkForTranquil(child) then
                return true
            end
        end
    end
    
    return false
end

-- Función para obtener distancia
local function getDistance(plant)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    
    local plantPos
    if plant:IsA("Model") then
        plantPos = plant:GetModelCFrame().Position
    else
        plantPos = plant.Position
    end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    return (playerPos - plantPos).Magnitude
end

-- Función para escanear plantas (optimizada)
local function scanPlants()
    -- Limpiar ESPs de plantas que ya no existen
    for plant, esp in pairs(espObjects) do
        if not plant.Parent then
            esp:Destroy()
            espObjects[plant] = nil
        end
    end
    
    -- Buscar en las ubicaciones más comunes de plantas en Grow a Garden
    local searchAreas = {
        Workspace:FindFirstChild("Plants"),
        Workspace:FindFirstChild("Garden"),
        Workspace:FindFirstChild("Crops"),
        player.Character and player.Character.Parent -- Área del jugador
    }
    
    for _, area in pairs(searchAreas) do
        if area then
            for _, obj in pairs(area:GetChildren()) do
                -- Solo procesar si no tiene ESP ya y está cerca
                if not espObjects[obj] and getDistance(obj) <= ESPConfig.maxDistance then
                    if isTranquilPlant(obj) then
                        local esp = createESP(obj)
                        espObjects[obj] = esp
                    end
                end
            end
        end
    end
end

-- Función para actualizar visibilidad (optimizada)
local function updateESPVisibility()
    for plant, esp in pairs(espObjects) do
        if plant.Parent then
            local distance = getDistance(plant)
            local shouldShow = ESPConfig.enabled and distance <= ESPConfig.maxDistance
            
            if esp and esp.Parent then
                esp.Enabled = shouldShow
                
                -- Actualizar opacidad basada en distancia
                if shouldShow and esp:FindFirstChild("TextLabel") then
                    local alpha = math.max(0.4, 1 - (distance / ESPConfig.maxDistance))
                    esp.TextLabel.TextTransparency = 1 - alpha
                end
            end
        else
            -- Planta eliminada
            if esp then
                esp:Destroy()
            end
            espObjects[plant] = nil
        end
    end
end

-- Función principal de actualización (con rate limiting)
local function updateESP()
    local currentTime = tick()
    if currentTime - lastUpdate >= ESPConfig.updateRate then
        scanPlants()
        updateESPVisibility()
        lastUpdate = currentTime
    end
end

-- Función para limpiar todo
local function clearAllESP()
    for plant, esp in pairs(espObjects) do
        if esp then
            esp:Destroy()
        end
    end
    espObjects = {}
    
    if updateConnection then
        updateConnection:Disconnect()
        updateConnection = nil
    end
end

-- Toggle del ESP
local function toggleESP()
    ESPConfig.enabled = not ESPConfig.enabled
    
    if ESPConfig.enabled then
        print("🌿 Tranquil Plant ESP: ACTIVADO")
        
        -- Escaneo inicial
        scanPlants()
        
        -- Conexión optimizada para actualizaciones
        updateConnection = RunService.Heartbeat:Connect(updateESP)
    else
        print("🌿 Tranquil Plant ESP: DESACTIVADO")
        clearAllESP()
    end
end

-- Input handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == ESPConfig.toggleKey then
        toggleESP()
    end
end)

-- Cleanup al salir
Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        clearAllESP()
    end
end)

-- Detectar nuevas plantas de forma eficiente
local function onPlantAdded(child)
    if ESPConfig.enabled then
        wait(0.2) -- Esperar a que se cargue completamente
        if child.Parent and isTranquilPlant(child) and getDistance(child) <= ESPConfig.maxDistance then
            if not espObjects[child] then
                local esp = createESP(child)
                espObjects[child] = esp
            end
        end
    end
end

-- Conectar a áreas comunes donde aparecen plantas
local plantAreas = {"Plants", "Garden", "Crops"}
for _, areaName in pairs(plantAreas) do
    local area = Workspace:FindFirstChild(areaName)
    if area then
        area.ChildAdded:Connect(onPlantAdded)
    end
end

-- También conectar al workspace principal
Workspace.ChildAdded:Connect(function(child)
    if child.Name:lower():find("plant") or child.Name:lower():find("crop") or child.Name:lower():find("garden") then
        onPlantAdded(child)
    end
end)

-- Mensaje inicial
print("🌿 Tranquil Plant ESP v2.0 cargado!")
print("📋 Presiona 'T' para activar/desactivar")
print("⚡ Optimizado para mejor rendimiento")
print("🎯 Detecta: Tranquil, TRANQUIL, tranquil")

-- Función de configuración rápida
_G.TranquilESP = {
    toggle = toggleESP,
    clear = clearAllESP,
    setDistance = function(dist)
        ESPConfig.maxDistance = dist
        print("🔧 Distancia máxima: " .. dist .. "m")
    end,
    setUpdateRate = function(rate)
        ESPConfig.updateRate = rate
        print("🔧 Rate de actualización: " .. rate .. "s")
    end
}
