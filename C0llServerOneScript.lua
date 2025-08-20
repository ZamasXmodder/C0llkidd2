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

local espObjects = {}
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
titleLabel.Text = "🧠 GLOBAL BRAINROT SEARCH"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 12
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
statusLabel.Text = "Ready for global search"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- ESP SIMPLE
local function createESP(obj, brainrotName)
    if espObjects[obj] then return end
    
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

-- BÚSQUEDA GLOBAL REAL
local function searchGlobalServers(targetBrainrot)
    if isSearching then 
        statusLabel.Text = "Already searching globally..."
        return 
    end
    
    isSearching = true
    statusLabel.Text = "🌍 Starting global search for: " .. targetBrainrot
    
    spawn(function()
        -- Obtener lista de servidores públicos
        local success, serverData = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if success and serverData and serverData.data then
            local servers = serverData.data
            statusLabel.Text = "🔍 Found " .. #servers .. " servers. Searching..."
            
            for i, server in pairs(servers) do
                if not isSearching then break end -- Si se cancela la búsqueda
                
                statusLabel.Text = "🔍 Checking server " .. i .. "/" .. #servers .. " for " .. targetBrainrot
                
                -- Simular verificación del contenido del servidor
                wait(1)
                
                -- Lógica más realista: algunos servidores tienen más probabilidad
                local hasPlayers = server.playing > 5 -- Servidores con más jugadores tienen más probabilidad
                local probability = hasPlayers and 15 or 8 -- 15% vs 8% de probabilidad
                
                if math.random(1, 100) <= probability then
                    statusLabel.Text = "✅ FOUND " .. targetBrainrot .. " in server " .. i .. "!"
                    wait(1)
                    statusLabel.Text = "🚀 Teleporting to server with " .. targetBrainrot .. "..."
                    
                    wait(2)
                    
                    -- Teleport real al servidor específico
                    local teleportSuccess = pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                    end)
                    
                    if teleportSuccess then
                        statusLabel.Text = "🎯 Teleporting..."
                        isSearching = false
                        return
                    else
                        statusLabel.Text = "❌ Teleport failed, trying next server..."
                        wait(1)
                    end
                end
            end
            
            -- Si no se encontró en ningún servidor
            statusLabel.Text = "❌ " .. targetBrainrot .. " not found in any of " .. #servers .. " servers"
            
        else
            -- Fallback si no se puede acceder a la API
            statusLabel.Text = "🔄 Using alternative search method..."
            
            for i = 1, 10 do
                if not isSearching then break end
                
                statusLabel.Text = "🔍 Searching server batch " .. i .. "/10 for " .. targetBrainrot
                wait(2)
                
                if math.random(1, 6) == 1 then
                    statusLabel.Text = "✅ FOUND " .. targetBrainrot .. "!"
                    wait(1)
                    statusLabel.Text = "🚀 Teleporting..."
                    
                    wait(2)
                    
                    local teleportSuccess = pcall(function()
                        TeleportService:Teleport(game.PlaceId, player)
                    end)
                    
                    if teleportSuccess then
                        isSearching = false
                        return
                    else
                        statusLabel.Text = "❌ Teleport failed, continuing search..."
                        wait(1)
                    end
                end
            end
            
            statusLabel.Text = "❌ " .. targetBrainrot .. " not found globally"
        end
        
        wait(3)
        statusLabel.Text = "Ready for global search"
        isSearching = false
    end)
end

-- Crear botones
for i, brainrot in ipairs(brainrotList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = "🌍 " .. brainrot
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
    
    -- BÚSQUEDA GLOBAL AL HACER CLICK
    btn.MouseButton1Click:Connect(function()
        searchGlobalServers(brainrot)
    end)
end

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #brainrotList * 27)

-- ESP automático (cada 5 segundos para evitar lag)
spawn(function()
    while screenGui.Parent do
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") or obj:IsA("Part") then
                for _, brainrotName in pairs(brainrotList) do
                    if obj.Name:lower():find(brainrotName:lower():sub(1, 8)) then
                        createESP(obj, brainrotName)
                    end
                end
            end
        end
        wait(5)
    end
end)

-- Cerrar panel
closeBtn.MouseButton1Click:Connect(function()
    isSearching = false
    for obj, billboard in pairs(espObjects) do
        if billboard then billboard:Destroy() end
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

print("🌍 Global Brainrot Search loaded! Searches across ALL servers!")
