local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Configuración del ESP
local ESPConfig = {
    enabled = false,
    toggleKey = Enum.KeyCode.F, -- Tecla F para toggle
    maxDistance = 400,
    updateRate = 0.3,
    highlightTransparency = 0.3,
    outlineTransparency = 0
}

-- Colores para diferentes mutaciones
local MutationColors = {
    ["tranquil"] = Color3.fromRGB(0, 255, 255),      -- Cyan
    ["giant"] = Color3.fromRGB(255, 0, 0),           -- Rojo
    ["golden"] = Color3.fromRGB(255, 215, 0),        -- Dorado
    ["shiny"] = Color3.fromRGB(255, 0, 255),         -- Magenta
    ["rare"] = Color3.fromRGB(128, 0, 255),          -- Púrpura
    ["epic"] = Color3.fromRGB(255, 165, 0),          -- Naranja
    ["legendary"] = Color3.fromRGB(255, 20, 147),    -- Rosa intenso
    ["mythic"] = Color3.fromRGB(138, 43, 226),       -- Violeta
    ["divine"] = Color3.fromRGB(255, 255, 255),      -- Blanco
    ["cursed"] = Color3.fromRGB(139, 0, 0),          -- Rojo oscuro
    ["blessed"] = Color3.fromRGB(255, 255, 0),       -- Amarillo
    ["frozen"] = Color3.fromRGB(173, 216, 230),      -- Azul claro
    ["burning"] = Color3.fromRGB(255, 69, 0),        -- Rojo fuego
    ["toxic"] = Color3.fromRGB(0, 255, 0),           -- Verde
    ["shadow"] = Color3.fromRGB(64, 64, 64),         -- Gris oscuro
    ["crystal"] = Color3.fromRGB(224, 255, 255),     -- Azul cristal
    ["void"] = Color3.fromRGB(25, 25, 112),          -- Azul marino
    ["cosmic"] = Color3.fromRGB(72, 61, 139),        -- Azul cósmico
    ["ancient"] = Color3.fromRGB(160, 82, 45),       -- Marrón
    ["default"] = Color3.fromRGB(255, 255, 255)      -- Blanco por defecto
}

-- Almacenamiento
local espObjects = {}
local lastUpdate = 0
local updateConnection = nil

-- Función para detectar mutación en frutas
local function getMutationType(fruit)
    -- Lista de posibles ubicaciones donde se almacena la mutación
    local mutationSources = {
        -- Atributos directos
        function() return fruit:GetAttribute("Mutation") end,
        function() return fruit:GetAttribute("mutation") end,
        function() return fruit:GetAttribute("MUTATION") end,
        
        -- StringValues
        function() 
            local mut = fruit:FindFirstChild("Mutation")
            return mut and mut.Value
        end,
        function() 
            local mut = fruit:FindFirstChild("mutation")
            return mut and mut.Value
        end,
        
        -- En configuración
        function()
            local config = fruit:FindFirstChild("Config")
            if config then
                local mut = config:FindFirstChild("Mutation")
                return mut and mut.Value
            end
        end,
        
        -- En datos de la fruta
        function()
            local data = fruit:FindFirstChild("Data")
            if data then
                local mut = data:FindFirstChild("Mutation")
                return mut and mut.Value
            end
        end,
        
        -- En el nombre de la fruta
        function()
            local name = fruit.Name:lower()
            for mutationType, _ in pairs(MutationColors) do
                if name:find(mutationType) then
                    return mutationType
                end
            end
        end
    }
    
    -- Probar cada fuente de mutación
    for _, source in pairs(mutationSources) do
        local success, mutation = pcall(source)
        if success and mutation then
            local mutStr = tostring(mutation):lower()
            
            -- Verificar si coincide con alguna mutación conocida
            for mutationType, _ in pairs(MutationColors) do
                if mutStr:find(mutationType) then
                    return mutationType
                end
            end
            
            -- Si encontró algo pero no coincide, devolver como "unknown"
            if mutStr ~= "" and mutStr ~= "nil" then
                return "default"
            end
        end
    end
    
    return nil
end

-- Función para verificar si es una fruta
local function isFruit(obj)
    if not obj:IsA("BasePart") and not obj:IsA("Model") then
        return false
    end
    
    local name = obj.Name:lower()
    local fruitKeywords = {
        "fruit", "apple", "banana", "orange", "grape", "berry", 
        "cherry", "peach", "pear", "mango", "kiwi", "lemon",
        "lime", "coconut", "pineapple", "watermelon", "melon"
    }
    
    for _, keyword in pairs(fruitKeywords) do
        if name:find(keyword) then
            return true
        end
    end
    
    -- Verificar si tiene propiedades típicas de fruta
    return obj:FindFirstChild("FruitType") or 
           obj:FindFirstChild("Nutrition") or
           obj:GetAttribute("IsFruit")
end

-- Función para crear highlight en la fruta
local function createFruitHighlight(fruit, mutationType)
    -- Crear Highlight para resaltar toda la fruta
    local highlight = Instance.new("Highlight")
    highlight.FillColor = MutationColors[mutationType] or MutationColors["default"]
    highlight.OutlineColor = highlight.FillColor
    highlight.FillTransparency = ESPConfig.highlightTransparency
    highlight.OutlineTransparency = ESPConfig.outlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = fruit
    
    -- Crear texto informativo
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 120, 0, 25)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = fruit
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = highlight.FillColor
    textLabel.TextSize = 12
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Text = mutationType:upper()
    textLabel.Parent = billboardGui
    
    return {
        highlight = highlight,
        billboard = billboardGui,
        mutationType = mutationType
    }
end

-- Función para obtener distancia
local function getDistance(fruit)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    
    local fruitPos
    if fruit:IsA("Model") then
        fruitPos = fruit:GetModelCFrame().Position
    else
        fruitPos = fruit.Position
    end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    return (playerPos - fruitPos).Magnitude
end

-- Función para escanear frutas con mutaciones
local function scanMutatedFruits()
    -- Limpiar objetos eliminados
    for fruit, espData in pairs(espObjects) do
        if not fruit.Parent then
            if espData.highlight then espData.highlight:Destroy() end
            if espData.billboard then espData.billboard:Destroy() end
            espObjects[fruit] = nil
        end
    end
    
    -- Buscar en áreas comunes de frutas
    local searchAreas = {
        Workspace:FindFirstChild("Fruits"),
        Workspace:FindFirstChild("Items"),
        Workspace:FindFirstChild("Drops"),
        Workspace:FindFirstChild("Garden"),
        Workspace:FindFirstChild("Farm"),
        Workspace
    }
    
    for _, area in pairs(searchAreas) do
        if area then
            for _, obj in pairs(area:GetChildren()) do
                if not espObjects[obj] and getDistance(obj) <= ESPConfig.maxDistance then
                    if isFruit(obj) then
                        local mutationType = getMutationType(obj)
                        if mutationType then
                            local espData = createFruitHighlight(obj, mutationType)
                            espObjects[obj] = espData
                            print("🍎 Fruta con mutación detectada: " .. mutationType:upper())
                        end
                    end
                end
            end
            
            -- También buscar en descendientes para modelos complejos
            for _, obj in pairs(area:GetDescendants()) do
                if not espObjects[obj] and getDistance(obj) <= ESPConfig.maxDistance then
                    if isFruit(obj) then
                        local mutationType = getMutationType(obj)
                        if mutationType then
                            local espData = createFruitHighlight(obj, mutationType)
                            espObjects[obj] = espData
                            print("🍎 Fruta con mutación detectada: " .. mutationType:upper())
                        end
                    end
                end
            end
        end
    end
end

-- Función para actualizar visibilidad
local function updateESPVisibility()
    for fruit, espData in pairs(espObjects) do
        if fruit.Parent then
            local distance = getDistance(fruit)
            local shouldShow = ESPConfig.enabled and distance <= ESPConfig.maxDistance
            
            if espData.highlight then
                espData.highlight.Enabled = shouldShow
            end
            if espData.billboard then
                espData.billboard.Enabled = shouldShow
                
                -- Actualizar opacidad basada en distancia
                if shouldShow and espData.billboard:FindFirstChild("TextLabel") then
                    local alpha = math.max(0.3, 1 - (distance / ESPConfig.maxDistance))
                    espData.billboard.TextLabel.TextTransparency = 1 - alpha
                end
            end
        else
            -- Fruta eliminada
            if espData.highlight then espData.highlight:Destroy() end
            if espData.billboard then espData.billboard:Destroy() end
            espObjects[fruit] = nil
        end
    end
end

-- Función principal de actualización
local function updateESP()
    local currentTime = tick()
    if currentTime - lastUpdate >= ESPConfig.updateRate then
        scanMutatedFruits()
        updateESPVisibility()
        lastUpdate = currentTime
    end
end

-- Función para limpiar todo
local function clearAllESP()
    for fruit, espData in pairs(espObjects) do
        if espData.highlight then espData.highlight:Destroy() end
        if espData.billboard then espData.billboard:Destroy() end
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
        print("🍎 Mutation Fruit ESP: ACTIVADO")
        print("🌈 Colores por mutación:")
        for mutation, color in pairs(MutationColors) do
            if mutation ~= "default" then
                print("   " .. mutation:upper() .. ": RGB(" .. math.floor(color.R*255) .. ", " .. math.floor(color.G*255) .. ", " .. math.floor(color.B*255) .. ")")
            end
        end
        
        scanMutatedFruits()
        updateConnection = RunService.Heartbeat:Connect(updateESP)
    else
        print("🍎 Mutation Fruit ESP: DESACTIVADO")
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

-- Detectar nuevas frutas
local function onFruitAdded(child)
    if ESPConfig.enabled then
        wait(0.1)
        if child.Parent and isFruit(child) and getDistance(child) <= ESPConfig.maxDistance then
            local mutationType = getMutationType(child)
            if mutationType and not espObjects[child] then
                local espData = createFruitHighlight(child, mutationType)
                espObjects[child] = espData
                print("🍎 Nueva fruta con mutación: " .. mutationType:upper())
            end
        end
    end
end

-- Conectar eventos
Workspace.ChildAdded:Connect(onFruitAdded)
local fruitAreas = {"Fruits", "Items", "Drops", "Garden", "Farm"}
for _, areaName in pairs(fruitAreas) do
    local area = Workspace:FindFirstChild(areaName)
    if area then
        area.ChildAdded:Connect(onFruitAdded)
    end
end

-- Mensaje inicial
print("🍎 Mutation Fruit ESP v3.0 cargado!")
print("📋 Presiona 'F' para activar/desactivar")
print("🌈 Detecta TODAS las mutaciones con colores únicos")
print("✨ Resalta la fruta completa con Highlight")

-- API global
_G.MutationFruitESP = {
    toggle = toggleESP,
    clear = clearAllESP,
    setDistance = function(dist)
        ESPConfig.maxDistance = dist
        print("🔧 Distancia máxima: " .. dist .. "m")
    end,
    addMutationColor = function(mutation, color)
        MutationColors[mutation:lower()] = color
        print("🎨 Color agregado para " .. mutation .. ": " .. tostring(color))
    end,
    listMutations = function()
        print("🌈 Mutaciones detectables:")
        for mutation, color in pairs(MutationColors) do
            if mutation ~= "default" then
                print("   " .. mutation:upper())
            end
        end
    end
}
