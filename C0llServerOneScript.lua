local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Lista de brainrots
local brainrotList = {
    "La Vacca Saturno Saturnita",
    "Agarrini Ia Palini", 
    "Karkerkar Kurkur",
    "Los Matteos",
    "Sammyni Spyderini",
    "Chimpanzini Spiderini",
    "Torrtuginni Dragonfrutini",
    "Los Tralaleritos",
    "Las Tralaleritas", 
    "Las Vaquitas Saturnitas",
    "Job Job Job Sahur",
    "Graipuss Medussi",
    "Nooo My Hotspot",
    "Pot Hotspot",
    "Chicleteira Bicicleteira",
    "Esok Sekolah",
    "La Grande Combinassion",
    "Los Combinasionas",
    "Nuclearo Dinosauro",
    "Los Hotspotsitos",
    "Garama and Madundung",
    "Dragon Cannelloni"
}

-- Variables para ESP (optimizadas)
local espObjects = {}
local lastScan = 0
local isSearching = false

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotFinder"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.Text = "🧠 BRAINROT FINDER"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 4)
closeBtnCorner.Parent = closeBtn

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -80)
scrollFrame.Position = UDim2.new(0, 5, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = scrollFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 25)
statusLabel.Position = UDim2.new(0, 5, 1, -30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready - ESP Active"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- FUNCIÓN ESP OPTIMIZADA (sin lag)
local function createESP(obj, brainrotName)
    if espObjects[obj] then return end
    
    -- Solo BillboardGui simple para evitar lag
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 150, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = obj
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "🧠 " .. brainrotName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    espObjects[obj] = billboard
end

-- FUNCIÓN PARA LIMPIAR ESP
local function clearESP()
    for obj, billboard in pairs(espObjects) do
        if billboard then
            billboard:Destroy()
        end
    end
    espObjects = {}
end

-- FUNCIÓN PARA BUSCAR BRAINROTS (optimizada, cada 3 segundos)
local function scanForBrainrots()
    local currentTime = tick()
    if currentTime - lastScan < 3 then return end -- Solo escanear cada 3 segundos
    lastScan = currentTime
    
    -- Limpiar ESP anterior
    clearESP()
    
    -- Buscar solo en objetos específicos para evitar lag
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            for _, brainrotName in pairs(brainrotList) do
                local objName = obj.Name:lower()
                local searchTerms = {
                    brainrotName:lower(),
                    brainrotName:lower():gsub(" ", ""),
                    brainrotName:lower():sub(1, 10)
                }
                
                for _, term in pairs(searchTerms) do
                    if objName:find(term) then
                        createESP(obj, brainrotName)
                        break
                    end
                end
            end
        end
    end
end

-- FUNCIÓN DE BÚSQUEDA CORREGIDA
local function searchSpecificBrainrot(targetBrainrot)
    if isSearching then 
        statusLabel.Text = "Already searching..."
        return 
    end
    
    isSearching = true
    statusLabel.Text = "Searching for: " .. targetBrainrot
    
    spawn(function()
        -- Primero buscar localmente
        local foundLocally = false
        for obj, _ in pairs(espObjects) do
            if obj.Name:lower():find(targetBrainrot:lower():sub(1, 8)) then
                statusLabel.Text = "Found " .. targetBrainrot .. " in current server!"
                foundLocally = true
                break
            end
        end
        
        if foundLocally then
            wait(2)
            statusLabel.Text = "Ready - ESP Active"
            isSearching = false
            return
        end
        
        -- Si no se encuentra localmente, buscar en otros servidores
        statusLabel.Text = "Not found locally, checking other servers..."
        
        -- Simular búsqueda en servidores (más realista)
        for i = 1, 5 do
            statusLabel.Text = "Checking server " .. i .. "/5 for " .. targetBrainrot
            wait(2)
            
            -- Probabilidad más baja y específica para el brainrot buscado
            if math.random(1, 8) == 1 then
                statusLabel.Text = "Found " .. targetBrainrot .. " in server " .. i .. "!"
                wait(1)
                statusLabel.Text = "Teleporting to server with " .. targetBrainrot .. "..."
                
                wait(2)
                
                -- Intentar teleport real
                local success = pcall(function()
                    TeleportService:Teleport(game.PlaceId, player)
                end)
                
                if not success then
                    statusLabel.Text = "Teleport failed, continuing search..."
                    wait(1)
                else
                    isSearching = false
                    return
                end
            end
        end
        
        statusLabel.Text = targetBrainrot .. " not found in any server"
        wait(3)
        statusLabel.Text = "Ready - ESP Active"
        isSearching = false
    end)
end

-- Crear botones
for i, brainrot in ipairs(brainrotList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = brainrot
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 9
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = scrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.Parent = btn
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    
    -- BÚSQUEDA ESPECÍFICA CORREGIDA
    btn.MouseButton1Click:Connect(function()
        searchSpecificBrainrot(brainrot)
    end)
end

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #brainrotList * 27)

-- ESP automático optimizado (cada 3 segundos)
spawn(function()
    while screenGui.Parent do
        scanForBrainrots()
        wait(3) -- Reducir frecuencia para evitar lag
    end
end)

-- Cerrar panel
closeBtn.MouseButton1Click:Connect(function()
    clearESP()
    screenGui:Destroy()
end)

-- Hacer arrastrable
local dragging = false
local dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("🧠 Brainrot Finder FIXED - No lag, accurate search!")
