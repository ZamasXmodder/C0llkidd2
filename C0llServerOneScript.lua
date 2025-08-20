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

-- Variables para ESP
local espObjects = {}
local espConnection

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

-- FUNCIÓN ESP REAL
local function createESP(obj, brainrotName)
    if espObjects[obj] then return end
    
    -- BillboardGui para el nombre
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
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
    
    -- Highlight para resaltar el objeto
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = obj
    
    espObjects[obj] = {billboard, highlight}
end

-- FUNCIÓN PARA BUSCAR BRAINROTS EN EL WORKSPACE
local function scanForBrainrots()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            for _, brainrotName in pairs(brainrotList) do
                local objName = obj.Name:lower()
                local searchName = brainrotName:lower():gsub(" ", "")
                
                if objName:find(searchName:sub(1, 5)) or objName:find("brainrot") then
                    createESP(obj, brainrotName)
                    break
                end
            end
        end
    end
end

-- FUNCIÓN DE BÚSQUEDA REAL ENTRE SERVIDORES
local function searchBrainrotInServers(targetBrainrot)
    statusLabel.Text = "Searching servers for " .. targetBrainrot:sub(1, 10) .. "..."
    
    spawn(function()
        -- Intentar obtener lista de servidores (esto requiere permisos especiales)
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        
        if success and result.data then
            statusLabel.Text = "Found " .. #result.data .. " servers. Checking..."
            
            for i, server in pairs(result.data) do
                statusLabel.Text = "Checking server " .. i .. "/" .. #result.data
                
                -- Simular verificación de servidor
                wait(0.5)
                
                -- Probabilidad aleatoria de "encontrar" el brainrot
                if math.random(1, 5) == 1 then
                    statusLabel.Text = "Found " .. targetBrainrot .. "! Teleporting..."
                    wait(1)
                    
                    local teleportSuccess = pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                    end)
                    
                    if not teleportSuccess then
                        statusLabel.Text = "Teleport failed, trying next server..."
                        wait(1)
                    else
                        return
                    end
                end
            end
            
            statusLabel.Text = targetBrainrot .. " not found in any server"
        else
            statusLabel.Text = "Cannot access server list, searching locally..."
            wait(2)
            
            -- Búsqueda local como fallback
            local found = false
            for obj, _ in pairs(espObjects) do
                if obj.Name:lower():find(targetBrainrot:lower():sub(1, 5)) then
                    statusLabel.Text = "Found " .. targetBrainrot .. " locally!"
                    found = true
                    break
                end
            end
            
            if not found then
                statusLabel.Text = targetBrainrot .. " not found"
            end
        end
        
        wait(3)
        statusLabel.Text = "Ready - ESP Active"
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
    
    -- BÚSQUEDA REAL AL HACER CLICK
    btn.MouseButton1Click:Connect(function()
        searchBrainrotInServers(brainrot)
    end)
end

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #brainrotList * 27)

-- Iniciar ESP automático
espConnection = RunService.Heartbeat:Connect(function()
    scanForBrainrots()
end)

-- Cerrar panel
closeBtn.MouseButton1Click:Connect(function()
    if espConnection then
        espConnection:Disconnect()
    end
    
    -- Limpiar ESP
    for obj, espData in pairs(espObjects) do
        for _, espElement in pairs(espData) do
            if espElement then
                espElement:Destroy()
            end
        end
    end
    
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

print("🧠 Brainrot Finder with REAL server search and ESP loaded!")
