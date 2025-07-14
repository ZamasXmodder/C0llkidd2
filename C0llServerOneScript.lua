-- Grow a Garden FORCE READ ESP - Lectura agresiva de datos

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local eggESPs = {}
local espEnabled = false
local connection = nil

-- Función para crear GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ForceReadESP"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(0, 100, 0, 35)
    mainButton.Position = UDim2.new(0, 10, 0.5, -17)
    mainButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    mainButton.BorderSizePixel = 0
    mainButton.Text = "FORCE ESP"
    mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainButton.TextScaled = true
    mainButton.Font = Enum.Font.GothamBold
    mainButton.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = mainButton
    
    mainButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        
        if espEnabled then
            mainButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            mainButton.Text = "FORCE ON"
            startForceESP()
        else
            mainButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            mainButton.Text = "FORCE OFF"
            stopForceESP()
        end
    end)
    
    return screenGui
end

-- Función AGRESIVA para leer datos del huevo
local function forceReadEggData(egg)
    local petName = nil
    local foundData = {}
    
    -- MÉTODO 1: Escaneo COMPLETO de todos los descendientes
    for _, obj in pairs(egg:GetDescendants()) do
        -- StringValues
        if obj:IsA("StringValue") then
            foundData[obj.Name] = obj.Value
            if obj.Value and obj.Value ~= "" and not obj.Value:lower():find("egg") then
                petName = obj.Value
            end
        end
        
        -- TextLabels en GUIs
        if obj:IsA("TextLabel") and obj.Text and obj.Text ~= "" then
            foundData["TextLabel_" .. obj.Name] = obj.Text
            if not obj.Text:lower():find("time") and not obj.Text:lower():find("incubat") then
                petName = obj.Text:gsub("🐾", ""):gsub("🥚", ""):match("^%s*(.-)%s*$")
            end
        end
        
        -- RemoteEvents/Functions (pueden contener datos)
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            foundData["Remote_" .. obj.Name] = "Found"
        end
        
        -- ModuleScripts (pueden tener datos)
        if obj:IsA("ModuleScript") then
            pcall(function()
                local module = require(obj)
                if type(module) == "table" then
                    for k, v in pairs(module) do
                        foundData["Module_" .. k] = tostring(v)
                        if type(v) == "string" and v ~= "" then
                            petName = v
                        end
                    end
                end
            end)
        end
    end
    
    -- MÉTODO 2: Todos los atributos
    for _, attrName in pairs(egg:GetAttributeNames()) do
        local value = egg:GetAttribute(attrName)
        foundData["Attr_" .. attrName] = tostring(value)
        if type(value) == "string" and value ~= "" then
            petName = value
        end
    end
    
    -- MÉTODO 3: Buscar en el workspace por conexiones
    pcall(function()
        local connections = getconnections and getconnections(egg.MouseButton1Click) or {}
        for _, connection in pairs(connections) do
            if connection.Function then
                foundData["Connection"] = "Found function"
            end
        end
    end)
    
    -- MÉTODO 4: Intentar acceder a datos privados (si es posible)
    pcall(function()
        if egg:FindFirstChild("_data") then
            foundData["PrivateData"] = "Found _data"
        end
        if egg:FindFirstChild("Data") then
            foundData["Data"] = "Found Data"
        end
    end)
    
    return petName, foundData
end

-- Función para crear ESP con datos encontrados
local function createForceESP(egg)
    if eggESPs[egg] then return end
    
    local petName, foundData = forceReadEggData(egg)
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 250, 0, 100)
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
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Label principal
    local mainLabel = Instance.new("TextLabel")
    mainLabel.Size = UDim2.new(1, 0, 0.5, 0)
    mainLabel.BackgroundTransparency = 1
    mainLabel.TextScaled = true
    mainLabel.Font = Enum.Font.GothamBold
    mainLabel.Parent = frame
    
    if petName and petName ~= "" then
        mainLabel.Text = "🔥 " .. petName .. " 🔥"
        mainLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        print("🔥 FOUND PET: " .. petName .. " in " .. egg.Name)
    else
        mainLabel.Text = "❌ NO PET DATA"
        mainLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
    
    -- Label de debug
    local debugLabel = Instance.new("TextLabel")
    debugLabel.Size = UDim2.new(1, 0, 0.5, 0)
    debugLabel.Position = UDim2.new(0, 0, 0.5, 0)
    debugLabel.BackgroundTransparency = 1
    debugLabel.TextScaled = true
    debugLabel.Font = Enum.Font.Gotham
    debugLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    debugLabel.Parent = frame
    
    -- Mostrar datos encontrados
    local dataCount = 0
    for k, v in pairs(foundData) do
        dataCount = dataCount + 1
    end
    
    debugLabel.Text = "Data found: " .. dataCount
    
    -- Imprimir todos los datos en consola
    print("=== EGG DATA DEBUG: " .. egg.Name .. " ===")
    for k, v in pairs(foundData) do
        print(k .. " = " .. tostring(v))
    end
    print("=====================================")
    
    eggESPs[egg] = billboardGui
end

-- Función para encontrar huevos
local function findEggs()
    local eggs = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
            table.insert(eggs, obj)
        end
    end
    return eggs
end

-- Función de actualización
local function forceUpdate()
    if not espEnabled then return end
    
    local eggs = findEggs()
    
    for _, egg in pairs(eggs) do
        if egg and egg.Parent and not eggESPs[egg] then
            createForceESP(egg)
        end
    end
    
    -- Limpiar obsoletos
    for egg, gui in pairs(eggESPs) do
        if not egg or not egg.Parent then
            if gui then gui:Destroy() end
            eggESPs[egg] = nil
        end
    end
end

-- Funciones de control
function startForceESP()
    if connection then connection:Disconnect() end
    connection = RunService.Heartbeat:Connect(forceUpdate)
end

function stopForceESP()
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
createGUI()

print("🔥 FORCE READ ESP LOADED!")
print("This will scan EVERYTHING in the eggs and print debug info")
print("Check console for detailed data found in each egg")
