-- Grow a Garden INSTANT ESP - Captura nombres al momento exacto

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local eggESPs = {}
local espEnabled = false
local connection = nil
local readyEggs = {} -- Para trackear huevos que acaban de estar listos

-- Función para crear GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InstantEggESP"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Botón principal
    local mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(0, 120, 0, 40)
    mainButton.Position = UDim2.new(0, 10, 0.5, -20)
    mainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mainButton.BorderSizePixel = 0
    mainButton.Text = "⚡ INSTANT ESP"
    mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainButton.TextScaled = true
    mainButton.Font = Enum.Font.GothamBold
    mainButton.Parent = screenGui
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = mainButton
    
    -- Panel
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 220, 0, 100)
    panel.Position = UDim2.new(0, 140, 0.5, -50)
    panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.Parent = screenGui
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 10)
    panelCorner.Parent = panel
    
    -- Toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.9, 0, 0.4, 0)
    toggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "🔥 INSTANT ESP: OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = panel
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
    statusLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
    statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    statusLabel.BorderSizePixel = 0
    statusLabel.Text = "⏰ Waiting for eggs..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = panel
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 4)
    statusCorner.Parent = statusLabel
    
    -- Toggle panel
    mainButton.MouseButton1Click:Connect(function()
        panel.Visible = not panel.Visible
    end)
    
    -- Toggle ESP
    toggleButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        
        if espEnabled then
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            toggleButton.Text = "🔥 INSTANT ESP: ON"
            statusLabel.Text = "👀 Scanning eggs..."
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            startInstantESP()
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            toggleButton.Text = "🔥 INSTANT ESP: OFF"
            statusLabel.Text = "⏰ Waiting for eggs..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            stopInstantESP()
        end
    end)
    
    return screenGui, statusLabel
end

-- Función para obtener info INSTANTÁNEA del huevo
local function getInstantEggInfo(egg)
    local info = {
        petName = nil,
        isReady = false,
        justBecameReady = false,
        eggType = "Unknown"
    }
    
    -- ESCANEO ULTRA RÁPIDO - Múltiples métodos
    pcall(function()
        -- Método 1: StringValues
        for _, child in pairs(egg:GetDescendants()) do
            if child:IsA("StringValue") then
                local name = child.Name:lower()
                if name:find("pet") or name:find("animal") or name:find("creature") then
                    info.petName = child.Value
                end
            end
            
            -- Buscar estado de ready
            if child:IsA("BoolValue") and child.Name:lower():find("ready") then
                info.isReady = child.Value
            end
            
            if child:IsA("NumberValue") and child.Name:lower():find("time") then
                info.isReady = child.Value <= 0
            end
        end
        
        -- Método 2: Atributos
        info.petName = info.petName or egg:GetAttribute("Pet") or egg:GetAttribute("PetName") or egg:GetAttribute("Animal")
        info.isReady = info.isReady or egg:GetAttribute("Ready") or (egg:GetAttribute("TimeLeft") and egg:GetAttribute("TimeLeft") <= 0)
        
        -- Método 3: Buscar en GUI del huevo (si tiene)
        local gui = egg:FindFirstChildOfClass("BillboardGui") or egg:FindFirstChildOfClass("SurfaceGui")
        if gui then
            for _, label in pairs(gui:GetDescendants()) do
                if label:IsA("TextLabel") and label.Text and label.Text ~= "" then
                    local text = label.Text:lower()
                    if not text:find("time") and not text:find("incubat") and not text:find("wait") then
                        -- Posible nombre de mascota
                        local cleanText = label.Text:gsub("🐾", ""):gsub("🥚", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
                        if cleanText and cleanText ~= "" and #cleanText > 2 then
                            info.petName = cleanText
                        end
                    end
                end
            end
        end
        
        -- Determinar tipo de huevo
        local eggName = egg.Name:lower()
        if eggName:find("paradise") then info.eggType = "Paradise"
        elseif eggName:find("forest") then info.eggType = "Forest"
        elseif eggName:find("ocean") then info.eggType = "Ocean"
        elseif eggName:find("desert") then info.eggType = "Desert"
        elseif eggName:find("volcano") then info.eggType = "Volcano"
        elseif eggName:find("crystal") then info.eggType = "Crystal"
        elseif eggName:find("golden") then info.eggType = "Golden"
        end
        
        -- Verificar si acaba de estar listo
        if info.isReady and not readyEggs[egg] then
            info.justBecameReady = true
            readyEggs[egg] = true
        end
    end)
    
    return info
end

-- Función para crear/actualizar ESP
local function createInstantESP(egg, info)
    local espData = eggESPs[egg]
    
    if not espData then
        -- Crear nuevo ESP
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Size = UDim2.new(0, 200, 0, 80)
        billboardGui.StudsOffset = Vector3.new(0, 4, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.Parent = egg
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 0
        frame.Parent = billboardGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        -- Tipo de huevo
        local typeLabel = Instance.new("TextLabel")
        typeLabel.Size = UDim2.new(1, 0, 0.4, 0)
        typeLabel.BackgroundTransparency = 1
        typeLabel.Text = "🥚 " .. info.eggType .. " Egg"
        typeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        typeLabel.TextScaled = true
        typeLabel.Font = Enum.Font.GothamBold
        typeLabel.Parent = frame
        
        -- Info label
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, 0, 0.6, 0)
        infoLabel.Position = UDim2.new(0, 0, 0.4, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextScaled = true
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.Parent = frame
        
        espData = {
            gui = billboardGui,
            frame = frame,
            infoLabel = infoLabel,
            typeLabel = typeLabel
        }
        eggESPs[egg] = espData
    end
    
    -- Actualizar información
    if info.petName and info.isReady then
        espData.infoLabel.Text = "🔥 " .. info.petName .. " 🔥"
        espData.infoLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Dorado
        espData.frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Verde brillante
        
        -- Si acaba de estar listo, hacer efecto especial
        if info.justBecameReady then
            -- Efecto de parpadeo
            spawn(function()
                for i = 1, 6 do
                    espData.frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    wait(0.1)
                    espData.frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    wait(0.1)
                end
            end)
            
            -- Notificación
            print("🔥🔥🔥 " .. info.eggType .. " EGG READY: " .. info.petName .. " 🔥🔥🔥")
        end
    else
        espData.infoLabel.Text = "⏰ Incubating..."
        espData.infoLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        espData.frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end
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

-- Función principal de actualización ULTRA RÁPIDA
local function instantUpdate()
    if not espEnabled then return end
    
    local eggs = findEggs()
    local readyCount = 0
    
    for _, egg in pairs(eggs) do
        if egg and egg.Parent then
            local info = getInstantEggInfo(egg)
            createInstantESP(egg, info)
            
            if info.isReady and info.petName then
                readyCount = readyCount + 1
            end
        end
    end
    
    -- Limpiar ESP obsoletos
    for egg, espData in pairs(eggESPs) do
        if not egg or not egg.Parent then
            if espData.gui then espData.gui:Destroy() end
            eggESPs[egg] = nil
            readyEggs[egg] = nil
        end
    end
    
    -- Actualizar status
    if statusLabel then
        if readyCount > 0 then
            statusLabel.Text = "🔥 " .. readyCount .. " eggs ready!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        else
            statusLabel.Text = "👀 Scanning " .. #eggs .. " eggs..."
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
end

-- Funciones de control
function startInstantESP()
    if connection then connection:Disconnect() end
    connection = RunService.Heartbeat:Connect(instantUpdate) -- MÁXIMA VELOCIDAD
end

function stopInstantESP()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    for egg, espData in pairs(eggESPs) do
        if espData.gui then espData.gui:Destroy() end
    end
    eggESPs = {}
    readyEggs = {}
end

-- Crear GUI
local gui, statusLabel = createGUI()

print("⚡ INSTANT EGG ESP LOADED! ⚡")
print("🔥 Captura nombres AL INSTANTE cuando los huevos estén listos!")
print("💀 Prepárate para dominar el jardín...")
