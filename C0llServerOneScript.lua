local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local isFloating = false
local espEnabled = false
local infiniteReach = false
local floatSpeed = 16
local floatConnection = nil
local espConnections = {}
local reachConnection = nil

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleCheatPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Cheat Panel - F4 to Toggle"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Función para crear botones
local function createButton(name, text, position, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0.85, 0, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    return button
end

-- Función para crear slider
local function createSlider(name, text, minValue, maxValue, defaultValue, position, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.85, 0, 0, 60)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultValue
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Parent = frame
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, 0, 0, 20)
    sliderBack.Position = UDim2.new(0, 0, 0, 25)
    sliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = sliderBack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 10)
    fillCorner.Parent = sliderFill
    
    local dragging = false
    local currentValue = defaultValue
    
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderBack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = Players.LocalPlayer:GetMouse()
            local relativeX = mouse.X - sliderBack.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderBack.AbsoluteSize.X, 0, 1)
            
            currentValue = minValue + (maxValue - minValue) * percentage
            currentValue = math.floor(currentValue + 0.5)
            
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            label.Text = text .. ": " .. currentValue
            
            floatSpeed = currentValue
        end
    end)
    
    return frame
end

-- Crear elementos
local floatButton = createButton("FloatButton", "Float: OFF", UDim2.new(0.075, 0, 0, 50), mainFrame)
local speedSlider = createSlider("SpeedSlider", "Float Speed", 5, 50, 16, UDim2.new(0.075, 0, 0, 95), mainFrame)
local espButton = createButton("ESPButton", "ESP: OFF", UDim2.new(0.075, 0, 0, 165), mainFrame)
local reachButton = createButton("ReachButton", "Infinite Reach: OFF", UDim2.new(0.075, 0, 0, 210), mainFrame)

-- Función toggle panel
local function togglePanel()
    mainFrame.Visible = not mainFrame.Visible
    
    if mainFrame.Visible then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 300, 0, 350)
        })
        tween:Play()
    end
end

-- Función Float con simulación de caminar
local function toggleFloat()
    isFloating = not isFloating
    
    if isFloating then
        floatButton.Text = "Float: ON"
        floatButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            -- Crear BodyVelocity
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = humanoidRootPart
            
            floatConnection = RunService.Heartbeat:Connect(function()
                if character and character.Parent and humanoidRootPart and humanoidRootPart.Parent then
                    local camera = workspace.CurrentCamera
                    local moveVector = Vector3.new(0, 0, 0)
                    local isMoving = false
                    
                    -- Controles de movimiento
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveVector = moveVector + camera.CFrame.LookVector
                        isMoving = true
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveVector = moveVector - camera.CFrame.LookVector
                        isMoving = true
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveVector = moveVector - camera.CFrame.RightVector
                        isMoving = true
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveVector = moveVector + camera.CFrame.RightVector
                        isMoving = true
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveVector = moveVector + Vector3.new(0, 1, 0)
                        isMoving = true
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveVector = moveVector - Vector3.new(0, 1, 0)
                        isMoving = true
                    end
                    
                    -- Aplicar velocidad
                    bodyVelocity.Velocity = moveVector * floatSpeed
                    
                    -- Simular caminar (animaciones y sonidos)
                    if humanoid then
                        if isMoving then
                            humanoid.WalkSpeed = floatSpeed
                            -- Simular que está caminando
                            humanoid:Move(moveVector, true)
                        else
                            humanoid.WalkSpeed = 0
                        end
                        humanoid.PlatformStand = true
                    end
                else
                    toggleFloat()
                end
            end)
        end
    else
        floatButton.Text = "Float: OFF"
        floatButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            -- Remover BodyVelocity
            local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
            
            -- Restaurar movimiento normal
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.WalkSpeed = 16
            end
        end
    end
end

-- Función ESP
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    
    local function addESP()
        local character = targetPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        -- Crear highlight
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        
        -- Crear nombre flotante
        local head = character:FindFirstChild("Head")
        if head then
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "ESP_Name"
            billboardGui.Adornee = head
            billboardGui.Size = UDim2.new(0, 200, 0, 50)
            billboardGui.StudsOffset = Vector3.new(0, 2, 0)
            billboardGui.Parent = head
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = targetPlayer.DisplayName or targetPlayer.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.Parent = billboardGui
        end
    end
    
    if targetPlayer.Character then
        addESP()
    end
    
    local connection = targetPlayer.CharacterAdded:Connect(addESP)
    espConnections[targetPlayer] = connection
end

local function removeESP(targetPlayer)
    if espConnections[targetPlayer] then
        espConnections[targetPlayer]:Disconnect()
        espConnections[targetPlayer] = nil
    end
    
    if targetPlayer.Character then
        local highlight = targetPlayer.Character:FindFirstChild("ESP_Highlight")
        local head = targetPlayer.Character:FindFirstChild("Head")
        
        if highlight then highlight:Destroy() end
        if head then
            local nameGui = head:FindFirstChild("ESP_Name")
            if nameGui then nameGui:Destroy() end
        end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        espButton.Text = "ESP: ON"
        espButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            createESP(targetPlayer)
        end
        
        espConnections.playerAdded = Players.PlayerAdded:Connect(createESP)
    else
        espButton.Text = "ESP: OFF"
        espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            removeESP(targetPlayer)
        end
        
        if espConnections.playerAdded then
            espConnections.playerAdded:Disconnect()
            espConnections.playerAdded = nil
        end
    end
end

-- Función Infinite Reach para bate
local function toggleInfiniteReach()
    infiniteReach = not infiniteReach
    
    if infiniteReach then
        reachButton.Text = "Infinite Reach: ON"
        reachButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        reachConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character then
                -- Buscar bate equipado
                local tool = character:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:lower():find("bat") or tool.Name:lower():find("bate")) then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then
                        -- Extender el alcance del bate
                        local originalSize = handle.Size
                        handle.Size = Vector3.new(originalSize.X, originalSize.Y, 50) -- Alcance de 50 studs
                        handle.Transparency = 0.9 -- Hacer casi invisible la extensión
                        
                        -- Buscar jugadores cercanos para golpear automáticamente
                        for _, targetPlayer in pairs(Players:GetPlayers()) do
                            if targetPlayer ~= player and targetPlayer.Character then
                                local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                                local playerHRP = character:FindFirstChild("HumanoidRootPart")
                                
                                if targetHRP and playerHRP then
                                    local distance = (targetHRP.Position - playerHRP.Position).Magnitude
                                    
                                    -- Si está dentro del rango extendido (50 studs)
                                    if distance <= 50 then
                                        -- Activar el bate
                                        tool:Activate()
                                        
                                        -- Buscar RemoteEvents del bate
                                        for _, remote in pairs(tool:GetDescendants()) do
                                            if remote:IsA("RemoteEvent") then
                                                pcall(function()
                                                    remote:FireServer(targetPlayer.Character)
                                                end)
                                                pcall(function()
                                                    remote:FireServer(targetHRP)
                                                end)
                                                pcall(function()
                                                    remote:FireServer()
                                                end)
                                            end
                                        end
                                        
                                        -- Intentar diferentes métodos de golpe
                                        pcall(function()
                                            if handle:FindFirstChild("ClickDetector") then
                                                handle.ClickDetector:FireServer()
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
                
                -- También buscar en el backpack
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    for _, tool in pairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("bate")) then
                            -- Auto-equipar el bate
                            local humanoid = character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end
            end
        end)
    else
        reachButton.Text = "Infinite Reach: OFF"
        reachButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        if reachConnection then
            reachConnection:Disconnect()
            reachConnection = nil
        end
        
        -- Restaurar tamaño original del bate
        local character = player.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                local handle = tool.Handle
                handle.Transparency = 0
                -- Restaurar tamaño original (esto puede variar según el juego)
                handle.Size = Vector3.new(1, 4, 1) -- Tamaño típico de un bate
            end
        end
    end
end

-- Conectar eventos de botones
floatButton.MouseButton1Click:Connect(toggleFloat)
espButton.MouseButton1Click:Connect(toggleESP)
reachButton.MouseButton1Click:Connect(toggleInfiniteReach)

-- Conectar tecla F4 para toggle del panel
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F4 then
        togglePanel()
    end
end)

-- Limpiar conexiones cuando jugadores se van
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if espConnections[leavingPlayer] then
        espConnections[leavingPlayer]:Disconnect()
        espConnections[leavingPlayer] = nil
    end
end)

-- Limpiar cuando el personaje respawnea
player.CharacterAdded:Connect(function()
    wait(1)
    -- Resetear estados
    if isFloating then
        isFloating = false
        toggleFloat()
    end
    if infiniteReach then
        infiniteReach = false
        toggleInfiniteReach()
    end
end)

-- Mensaje de confirmación
print("Simple Cheat Panel cargado!")
print("Controles:")
print("- F4: Abrir/Cerrar panel")
print("- Float: WASD + Space/Shift para volar")
print("- ESP: Ver jugadores a través de paredes")
print("- Infinite Reach: Golpear con el bate desde cualquier distancia")
print("- El float simula caminar normalmente")
