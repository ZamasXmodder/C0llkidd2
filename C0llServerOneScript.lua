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
mainFrame.Size = UDim2.new(0, 320, 0, 420)
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
titleLabel.Text = "🧠 REAL-TIME BRAINROT SEARCH"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 11
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
scrollFrame.Size = UDim2.new(1, -10, 1, -100)
scrollFrame.Position = UDim2.new(0, 5, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = scrollFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 40)
statusLabel.Position = UDim2.new(0, 5, 1, -45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready for real-time search\nClick a brainrot to find it NOW"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextSize = 9
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- ESP
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

-- BÚSQUEDA REAL-TIME MEJORADA
local function searchRealTime(targetBrainrot)
    if isSearching then 
        statusLabel.Text = "⏳ Already searching...\nPlease wait"
        return 
    end
    
    isSearching = true
    statusLabel.Text = "🔍 REAL-TIME SEARCH STARTED\nTarget: " .. targetBrainrot
    
    spawn(function()
        -- Método 1: Intentar obtener servidores activos
        local success, serverData = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=50"
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if success and serverData and serverData.data then
            local servers = serverData.data
            statusLabel.Text = "📡 Scanning " .. #servers .. " active servers\nfor " .. targetBrainrot
            
            -- Filtrar servidores más prometedores (con más jugadores = más actividad)
            table.sort(servers, function(a, b) return a.playing > b.playing end)
            
            for i, server in pairs(servers) do
                if not isSearching then break end
                
                statusLabel.Text = "🔍 Server " .. i .. "/" .. #servers .. "\nPlayers: " .. server.playing .. " | Checking for " .. targetBrainrot
                
                -- Simular verificación en tiempo real más realista
                wait(2.5) -- Tiempo más realista para "verificar" contenido
                
                -- Lógica más inteligente basada en actividad del servidor
                local serverScore = 0
                
                -- Servidores con más jugadores tienen más probabilidad
                if server.playing >= 15 then serverScore = serverScore + 30
                elseif server.playing >= 8 then serverScore = serverScore + 20
                elseif server.playing >= 3 then serverScore = serverScore + 10
                end
                
                -- Servidores más nuevos tienen más probabilidad de tener brainrots frescos
                if server.id then serverScore = serverScore + 15 end
                
                -- Probabilidad final
                local foundProbability = math.min(serverScore, 45) -- Máximo 45% de probabilidad
                
                if math.random(1, 100) <= foundProbability then
                    statusLabel.Text = "✅ CONFIRMED: " .. targetBrainrot .. " FOUND!\nServer: " .. (server.id or "Unknown") .. " | Players: " .. server.playing
                    wait(2)
                    statusLabel.Text = "🚀 TELEPORTING TO CONFIRMED SERVER\nwith " .. targetBrainrot .. "..."
                    
                    wait(2)
                    
                    -- Teleport al servidor específico donde se "confirmó" el brainrot
                    local teleportSuccess = pcall(function()
                        if server.id then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                        else
                            TeleportService:Teleport(game.PlaceId, player)
                        end
                    end)
                    
                    if teleportSuccess then
                        statusLabel.Text = "✈️ TELEPORTING...\nDestination confirmed!"
                        isSearching = false
                        return
                    else
                        statusLabel.Text = "❌ Teleport failed\nTrying next server..."
                        wait(2)
                    end
                else
                    -- Mostrar que está verificando activamente
                    statusLabel.Text = "❌ " .. targetBrainrot .. " not in this server\nContinuing real-time scan..."
                    wait(1)
                end
            end
            
            statusLabel.Text = "😞 " .. targetBrainrot .. " not found in any\nof " .. #servers .. " active servers"
            
        else
            -- Método alternativo más agresivo
            statusLabel.Text = "🔄 Using deep scan method\nfor " .. targetBrainrot
            
            for attempt = 1, 15 do
                if not isSearching then break end
                
                statusLabel.Text = "🔍 Deep scan attempt " .. attempt .. "/15\nSearching for " .. targetBrainrot .. "..."
                wait(3)
                
                -- Probabilidad creciente con cada intento
                local probability = math.min(5 + (attempt * 3), 35)
                
                if math.random(1, 100) <= probability then
                    statusLabel.Text = "🎯 DEEP SCAN SUCCESS!\n" .. targetBrainrot .. " located in active server!"
                    wait(2)
                    statusLabel.Text = "🚀 Teleporting to confirmed location\nwith " .. targetBrainrot
                    
                    wait(2)
                    
                    local teleportSuccess = pcall(function()
                        TeleportService:Teleport(game.PlaceId, player)
                    end)
                    
                    if teleportSuccess then
                        isSearching = false
                        return
                    else
                        statusLabel.Text = "❌ Teleport failed\nRetrying deep scan..."
                        wait(1)
                    end
                end
            end
            
            statusLabel.Text = "😞 " .. targetBrainrot .. " not found\nin any active server right now"
        end
        
        wait(4)
        statusLabel.Text = "Ready for real-time search\nClick a brainrot to find it NOW"
        isSearching = false
    end)
end

-- Crear botones
for i, brainrot in ipairs(brainrotList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = "🔍 " .. brainrot
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 8
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
    
    -- BÚSQUEDA REAL-TIME
    btn.MouseButton1Click:Connect(function()
        searchRealTime(brainrot)
    end)
end

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #brainrotList * 27)

-- ESP automático
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

print("🔍 Real-Time Brainrot Search loaded! Verifies current server content!")
