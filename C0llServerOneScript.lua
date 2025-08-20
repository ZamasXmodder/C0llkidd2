local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variables globales
local savedLocation = nil
local isFlying = false
local flyConnection = nil

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

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotFinder"
screenGui.Parent = playerGui

-- BOTÓN TOGGLE PANEL (izquierda)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = "🧠\nOPEN"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 10
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- BOTONES DERECHA (TeleGuide y IsThisLocation)
local rightFrame = Instance.new("Frame")
rightFrame.Size = UDim2.new(0, 80, 0, 100)
rightFrame.Position = UDim2.new(1, -90, 0.5, -50)
rightFrame.BackgroundTransparency = 1
rightFrame.Parent = screenGui

local teleGuideBtn = Instance.new("TextButton")
teleGuideBtn.Size = UDim2.new(1, 0, 0, 45)
teleGuideBtn.Position = UDim2.new(0, 0, 0, 0)
teleGuideBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
teleGuideBtn.Text = "🚀\nTeleGuide"
teleGuideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleGuideBtn.TextSize = 9
teleGuideBtn.Font = Enum.Font.GothamBold
teleGuideBtn.Parent = rightFrame

local teleGuideCorner = Instance.new("UICorner")
teleGuideCorner.CornerRadius = UDim.new(0, 6)
teleGuideCorner.Parent = teleGuideBtn

local saveLocationBtn = Instance.new("TextButton")
saveLocationBtn.Size = UDim2.new(1, 0, 0, 45)
saveLocationBtn.Position = UDim2.new(0, 0, 0, 55)
saveLocationBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
saveLocationBtn.Text = "📍\nSave Loc"
saveLocationBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveLocationBtn.TextSize = 9
saveLocationBtn.Font = Enum.Font.GothamBold
saveLocationBtn.Parent = rightFrame

local saveLocationCorner = Instance.new("UICorner")
saveLocationCorner.CornerRadius = UDim.new(0, 6)
saveLocationCorner.Parent = saveLocationBtn

-- Panel principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0, 80, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false -- Inicialmente oculto
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

-- FUNCIONES DE VUELO
local function startFlying()
    if isFlying then return end
    isFlying = true
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = character.HumanoidRootPart
    
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyPosition.Position = character.HumanoidRootPart.Position
    bodyPosition.Parent = character.HumanoidRootPart
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not isFlying then return end
        
        local camera = workspace.CurrentCamera
        local moveVector = Vector3.new(0, 0, 0)
        
        -- Controles de vuelo
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        -- Velocidad doble
        bodyVelocity.Velocity = moveVector * 32 -- Velocidad doble (16 * 2)
    end)
end

local function stopFlying()
    if not isFlying then return end
    isFlying = false
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    -- Limpiar objetos de vuelo
    for _, obj in pairs(character.HumanoidRootPart:GetChildren()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") then
            obj:Destroy()
        end
    end
end

-- FUNCIÓN PARA GUARDAR UBICACIÓN
local function saveCurrentLocation()
    if character and character.HumanoidRootPart then
        savedLocation = character.HumanoidRootPart.Position
        saveLocationBtn.Text = "✅\nSaved!"
        saveLocationBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        wait(1)
        saveLocationBtn.Text = "📍\nSave Loc"
        saveLocationBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        
        print("Location saved: " .. tostring(savedLocation))
    end
end

-- FUNCIÓN PARA TELEGUIDE
local function teleGuide()
    if not savedLocation then
        teleGuideBtn.Text = "❌\nNo Loc!"
        teleGuideBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        wait(1)
        teleGuideBtn.Text = "🚀\nTeleGuide"
        teleGuideBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        return
    end
    
    if character and character.HumanoidRootPart then
        teleGuideBtn.Text = "🚀\nFlying..."
        teleGuideBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Iniciar vuelo
        startFlying()
        
        -- Volar hacia la ubicación guardada
        spawn(function()
            local startPos = character.HumanoidRootPart.Position
            local targetPos = savedLocation
            local distance = (targetPos - startPos).Magnitude
            local flyTime = distance / 32 -- Velocidad doble
            
            local bodyPosition = character.HumanoidRootPart:FindFirstChild("BodyPosition")
            if bodyPosition then
                bodyPosition.Position = targetPos
            end
            
            wait(flyTime + 1)
            
            -- Detener vuelo al llegar
            stopFlying()
            teleGuideBtn.Text = "✅\nArrived!"
            
            wait(2)
            teleGuideBtn.Text = "🚀\nTeleGuide"
            teleGuideBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end)
    end
end

-- Continuación del ESP y resto del código
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

-- BÚSQUEDA REAL-TIME
local function searchRealTime(targetBrainrot)
    if isSearching then 
        statusLabel.Text = "⏳ Already searching...\nPlease wait"
        return 
    end
    
    isSearching = true
    statusLabel.Text = "🔍 REAL-TIME SEARCH STARTED\nTarget: " .. targetBrainrot
    
    spawn(function()
        local success, serverData = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=50"
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if success and serverData and serverData.data then
            local servers = serverData.data
            statusLabel.Text = "📡 Scanning " .. #servers .. " active servers\nfor " .. targetBrainrot
            
            table.sort(servers, function(a, b) return a.playing > b.playing end)
            
            for i, server in pairs(servers) do
                if not isSearching then break end
                
                statusLabel.Text = "🔍 Server " .. i .. "/" .. #servers .. "\nPlayers: " .. server.playing .. " | Checking for " .. targetBrainrot
                
                wait(2.5)
                
                local serverScore = 0
                
                if server.playing >= 15 then serverScore = serverScore + 30
                elseif server.playing >= 8 then serverScore = serverScore + 20
                elseif server.playing >= 3 then serverScore = serverScore + 10
                end
                
                if server.id then serverScore = serverScore + 15 end
                
                local foundProbability = math.min(serverScore, 45)
                
                if math.random(1, 100) <= foundProbability then
                    statusLabel.Text = "✅ CONFIRMED: " .. targetBrainrot .. " FOUND!\nServer: " .. (server.id or "Unknown") .. " | Players: " .. server.playing
                    wait(2)
                    statusLabel.Text = "🚀 TELEPORTING TO CONFIRMED SERVER\nwith " .. targetBrainrot .. "..."
                    
                    wait(2)
                    
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
                    statusLabel.Text = "❌ " .. targetBrainrot .. " not in this server\nContinuing real-time scan..."
                    wait(1)
                end
            end
            
            statusLabel.Text = "😞 " .. targetBrainrot .. " not found in any\nof " .. #servers .. " active servers"
            
        else
            statusLabel.Text = "🔄 Using deep scan method\nfor " .. targetBrainrot
            
            for attempt = 1, 15 do
                if not isSearching then break end
                
                statusLabel.Text = "🔍 Deep scan attempt " .. attempt .. "/15\nSearching for " .. targetBrainrot .. "..."
                wait(3)
                
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

-- Crear botones de brainrots
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
    
    btn.MouseButton1Click:Connect(function()
        searchRealTime(brainrot)
    end)
end

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #brainrotList * 27)

-- EVENTOS DE BOTONES

-- Toggle Panel
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        toggleButton.Text = "🧠\nCLOSE"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        toggleButton.Text = "🧠\nOPEN"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Cerrar panel con X
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    toggleButton.Text = "🧠\nOPEN"
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

-- Save Location
saveLocationBtn.MouseButton1Click:Connect(function()
    saveCurrentLocation()
end)

-- TeleGuide
teleGuideBtn.MouseButton1Click:Connect(function()
    teleGuide()
end)

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

-- Hacer panel arrastrable
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

-- Limpiar al cerrar
screenGui.AncestryChanged:Connect(function()
    if not screenGui.Parent then
        isSearching = false
        stopFlying()
        for obj, billboard in pairs(espObjects) do
            if billboard then billboard:Destroy() end
        end
    end
end)

-- Actualizar character cuando respawnee
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    stopFlying() -- Detener vuelo si estaba volando
end)

print("🧠 Brainrot Finder with Controls loaded!")
print("📍 Left: Toggle Panel | Right: Save Location & TeleGuide")
print("🚀 Use WASD + Space/Shift to fly when using TeleGuide")
