local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Configuración del ESP
local ESPConfig = {
    enabled = false,
    toggleKey = Enum.KeyCode.T,
    tranquilColor = Color3.fromRGB(0, 255, 255), -- Cyan brillante
    maxDistance = 500,
    updateRate = 0.5
}

-- Almacenamiento
local espObjects = {}
local lastUpdate = 0
local updateConnection = nil

-- Función para verificar si tiene mutación tranquil
local function hasTranquilMutation(obj)
    -- Lista exhaustiva de verificaciones para encontrar "tranquil"
    local checks = {
        -- Atributos (todas las variantes)
        function() return obj:GetAttribute("Mutation") end,
        function() return obj:GetAttribute("mutation") end,
        function() return obj:GetAttribute("MUTATION") end,
        function() return obj:GetAttribute("Tranquil") end,
        function() return obj:GetAttribute("tranquil") end,
        function() return obj:GetAttribute("TRANQUIL") end,
        
        -- StringValues/IntValues
        function() 
            local mut = obj:FindFirstChild("Mutation")
            return mut and mut.Value
        end,
        function() 
            local mut = obj:FindFirstChild("mutation")
            return mut and mut.Value
        end,
        function() 
            local mut = obj:FindFirstChild("MUTATION")
            return mut and mut.Value
        end,
        function() 
            local mut = obj:FindFirstChild("Tranquil")
            return mut and mut.Value
        end,
        function() 
            local mut = obj:FindFirstChild("tranquil")
            return mut and mut.Value
        end,
        
        -- En carpetas de configuración
        function()
            local config = obj:FindFirstChild("Config")
            if config then
                for _, child in pairs(config:GetChildren()) do
                    if child.Name:lower():find("mutation") or child.Name:lower():find("tranquil") then
                        return child.Value
                    end
                end
            end
        end,
        
        -- En carpetas de datos
        function()
            local data = obj:FindFirstChild("Data")
            if data then
                for _, child in pairs(data:GetChildren()) do
                    if child.Name:lower():find("mutation") or child.Name:lower():find("tranquil") then
                        return child.Value
                    end
                end
            end
        end,
        
        -- En carpetas de stats
        function()
            local stats = obj:FindFirstChild("Stats")
            if stats then
                for _, child in pairs(stats:GetChildren()) do
                    if child.Name:lower():find("mutation") or child.Name:lower():find("tranquil") then
                        return child.Value
                    end
                end
            end
        end,
        
        -- Verificar en TODOS los hijos
        function()
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("StringValue") or child:IsA("IntValue") or child:IsA("NumberValue") then
                    local value = tostring(child.Value):lower()
                    if value:find("tranquil") then
                        return child.Value
                    end
                end
            end
        end,
        
        -- Verificar en el nombre del objeto
        function()
            if obj.Name:lower():find("tranquil") then
                return "tranquil"
            end
        end
    }
    
    -- Ejecutar todas las verificaciones
    for _, check in pairs(checks) do
        local success, result = pcall(check)
        if success and result then
            local resultStr = tostring(result):lower()
            if resultStr:find("tranquil") then
                return true
            end
        end
    end
    
    -- Verificar también en hijos si es un modelo
    if obj:IsA("Model") then
        for _, child in pairs(obj:GetDescendants()) do
            if child ~= obj then -- Evitar recursión infinita
                local childCheck = hasTranquilMutation(child)
                if childCheck then
                    return true
                end
            end
        end
    end
    
    return false
end

-- Función para crear highlight en objeto tranquil
local function createTranquilHighlight(obj)
    -- Crear Highlight para resaltar todo el objeto
    local highlight = Instance.new("Highlight")
    highlight.FillColor = ESPConfig.tranquilColor
    highlight.OutlineColor = ESPConfig.tranquilColor
    highlight.FillTransparency = 0.2
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = obj
    
    -- Crear texto informativo
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 150, 0, 30)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = obj
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = ESPConfig.tranquilColor
    textLabel.TextSize = 14
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Text = "🌿 TRANQUIL"
    textLabel.Parent = billboardGui
    
    return {
        highlight = highlight,
        billboard = billboardGui
    }
end

-- Función para obtener distancia
local function getDistance(obj)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    
    local objPos
    if obj:IsA("Model") then
        objPos = obj:GetModelCFrame().Position
    elseif obj:IsA("BasePart") then
        objPos = obj.Position
    else
        return math.huge
    end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    return (playerPos - objPos).Magnitude
end

-- Función para escanear objetos tranquil
local function scanTranquilObjects()
    -- Limpiar objetos eliminados
    for obj, espData in pairs(espObjects) do
        if not obj.Parent then
            if espData.highlight then espData.highlight:Destroy() end
            if espData.billboard then espData.billboard:Destroy() end
            espObjects[obj] = nil
        end
    end
    
    -- Escanear TODO el workspace de forma más amplia
    local function scanArea(area, areaName)
        if not area then return end
        
        -- Escanear hijos directos
        for _, obj in pairs(area:GetChildren()) do
            if not espObjects[obj] and getDistance(obj) <= ESPConfig.maxDistance then
                if hasTranquilMutation(obj) then
                    local espData = createTranquilHighlight(obj)
                    espObjects[obj] = espData
                    print("🌿 TRANQUIL encontrado en " .. areaName .. ": " .. obj.Name)
                end
            end
        end
        
        -- Escanear descendientes también
        for _, obj in pairs(area:GetDescendants()) do
            if not espObjects[obj] and getDistance(obj) <= ESPConfig.maxDistance then
                if (obj:IsA("Model") or obj:IsA("BasePart")) and hasTranquilMutation(obj) then
                    local espData = createTranquilHighlight(obj)
                    espObjects[obj] = espData
                    print("🌿 TRANQUIL encontrado en " .. areaName .. " (descendiente): " .. obj.Name)
                end
            end
        end
    end
    
    -- Escanear múltiples áreas
    local searchAreas = {
        {Workspace, "Workspace"},
        {Workspace:FindFirstChild("Plants"), "Plants"},
        {Workspace:FindFirstChild("Garden"), "Garden"},
        {Workspace:FindFirstChild("Farm"), "Farm"},
        {Workspace:FindFirstChild("Crops"), "Crops"},
        {Workspace:FindFirstChild("Fruits"), "Fruits"},
        {Workspace:FindFirstChild("Items"), "Items"},
        {Workspace:FindFirstChild("Drops"), "Drops"},
        {player.Character and player.Character.Parent, "PlayerArea"}
    }
    
    for _, areaData in pairs(searchAreas) do
        scanArea(areaData[1], areaData[2])
    end
end

-- Función para actualizar visibilidad
local function updateESPVisibility()
    for obj, espData in pairs(espObjects) do
        if obj.Parent then
            local distance = getDistance(obj)
            local shouldShow = ESPConfig.enabled and distance <= ESPConfig.maxDistance
            
            if espData.highlight then
                espData.highlight.Enabled = shouldShow
            end
            if espData.billboard then
                espData.billboard.Enabled = shouldShow
                
                -- Actualizar texto con distancia
                if shouldShow and espData.billboard:FindFirstChild("TextLabel") then
                    local alpha = math.max(0.4, 1 - (distance / ESPConfig.maxDistance))
                    espData.billboard.TextLabel.TextTransparency = 1 - alpha
                    espData.billboard.TextLabel.Text = string.format("🌿 TRANQUIL (%.0fm)", distance)
                end
            end
        else
            -- Objeto eliminado
            if espData.highlight then espData.highlight:Destroy() end
            if espData.billboard then espData.billboard:Destroy() end
            espObjects[obj] = nil
        end
    end
end

-- Función principal de actualización
local function updateESP()
    local currentTime = tick()
    if currentTime - lastUpdate >= ESPConfig.updateRate then
        scanTranquilObjects()
        updateESPVisibility()
        lastUpdate = currentTime
    end
end

-- Función para limpiar todo
local function clearAllESP()
    for obj, espData in pairs(espObjects) do
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
        print("🌿 TRANQUIL ESP: ACTIVADO")
        print("🔍 Buscando objetos con mutación tranquil...")
        
        scanTranquilObjects()
        updateConnection = RunService.Heartbeat:Connect(updateESP)
        
        -- Escaneo inicial más agresivo
        wait(1)
        scanTranquilObjects()
    else
        print("🌿 TRANQUIL ESP: DESACTIVADO")
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

-- Detectar nuevos objetos
local function onObjectAdded(child)
    if ESPConfig.enabled then
        wait(0.2) -- Esperar a que se cargue
        if child.Parent and getDistance(child) <= ESPConfig.maxDistance then
            if hasTranquilMutation(child) and not espObjects[child] then
                local espData = createTranquilHighlight(child)
                espObjects[child] = espData
                print("🌿 Nuevo TRANQUIL detectado: " .. child.Name)
            end
        end
    end
end

-- Conectar eventos a múltiples áreas
Workspace.ChildAdded:Connect(onObjectAdded)
local areas = {"Plants", "Garden", "Farm", "Crops", "Fruits", "Items", "Drops"}
for _, areaName in pairs(areas) do
    local area = Workspace:FindFirstChild(areaName)
    if area then
        area.ChildAdded:Connect(onObjectAdded)
        area.DescendantAdded:Connect(onObjectAdded)
    end
end

-- Cleanup al salir
Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        clearAllESP()
    end
end)

-- Mensaje inicial
print("🌿 TRANQUIL ESP v4.0 cargado!")
print("📋 Presiona 'T' para activar/desactivar")
print("🎯 Detecta CUALQUIER objeto con mutación 'tranquil'")
print("✨ Búsqueda exhaustiva en TODO el workspace")

-- API global
_G.TranquilESP = {
    toggle = toggleESP,
    clear = clearAllESP,
    forceRescan = function()
        print("🔄 Forzando re-escaneo...")
        scanTranquilObjects()
    end,
    setDistance = function(dist)
        ESPConfig.maxDistance = dist
        print("🔧 Distancia máxima: " .. dist .. "m")
    end,
    debugObject = function(obj)
        print("🔍 Debug de objeto: " .. obj.Name)
        print("   Tiene tranquil: " .. tostring(hasTranquilMutation(obj)))
        print("   Atributos:")
        for attr, value in pairs(obj:GetAttributes()) do
            print("     " .. attr .. " = " .. tostring(value))
        end
        print("   Hijos:")
        for _, child in pairs(obj:GetChildren()) do
            if child:IsA("StringValue") or child:IsA("IntValue") then
                print("     " .. child.Name .. " = " .. tostring(child.Value))
            end
        end
    end
}

-- Comando para debug manual
_G.debugTranquil = function(objName)
    local obj = Workspace:FindFirstChild(objName, true)
    if obj then
        _G.TranquilESP.debugObject(obj)
    else
        print("❌ Objeto no encontrado: " .. objName)
    end
end
