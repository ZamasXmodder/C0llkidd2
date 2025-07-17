local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables para las funcionalidades
local isFloating = false
local espEnabled = false
local backpackForced = false
local instantPrompts = false
local autoHit = false
local noClipEnabled = false
local floatSpeed = 16
local floatConnection = nil
local espConnections = {}
local autoHitConnection = nil
local noClipConnection = nil
local originalPromptSettings = {}

-- Crear la GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedCheatPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Advanced Cheat Panel - F4 to Toggle"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Scroll Frame para contener todos los elementos
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollFrame.Parent = mainFrame

-- Función para crear botones
local function createButton(name, text, position, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button
    
    return button
end

-- Función para crear sliders
local function createSlider(name, text, minValue, maxValue, defaultValue, position, parent)
    local frame = Instance.new("Frame")
    frame.Name = name .. "Frame"
    frame.Size = UDim2.new(0.9, 0, 0, 60)
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
    sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = sliderBack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
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
            
            if name == "SpeedSlider" then
                floatSpeed = currentValue
            end
        end
    end)
    
    return frame, currentValue
end

-- Crear elementos de la interfaz
local floatButton = createButton("FloatButton", "Float: OFF", UDim2.new(0.05, 0, 0, 10), scrollFrame)
local speedSlider, speedValue = createSlider("SpeedSlider", "Float Speed", 1, 50, 16, UDim2.new(0.05, 0, 0, 55), scrollFrame)
local noClipButton = createButton("NoClipButton", "NoClip: OFF", UDim2.new(0.05, 0, 0, 125), scrollFrame)
local espButton = createButton("ESPButton", "ESP: OFF", UDim2.new(0.05, 0, 0, 170), scrollFrame)
local backpackButton = createButton("BackpackButton", "Force Backpack: OFF", UDim2.new(0.05, 0, 0, 215), scrollFrame)
local promptButton = createButton("PromptButton", "Instant Prompts: OFF", UDim2.new(0.05, 0, 0, 260), scrollFrame)
local teleportButton = createButton("TeleportButton", "Teleport to All Players", UDim2.new(0.05, 0, 0, 305), scrollFrame)
local autoHitButton = createButton("AutoHitButton", "Auto Hit (Bat): OFF", UDim2.new(0.05, 0, 0, 350), scrollFrame)

-- Función para toggle del panel
local function togglePanel()
    mainFrame.Visible = not mainFrame.Visible
    
    if mainFrame.Visible then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 350, 0, 450)
        })
        tween:Play()
    end
end

-- Función de NoClip
local function toggleNoClip()
    noClipEnabled = not noClipEnabled
    
    if noClipEnabled then
        noClipButton.Text = "NoClip: ON"
        noClipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        noClipConnection = RunService.Stepped:Connect(function()
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noClipButton.Text = "NoClip: OFF"
        noClipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
        end
        
        -- Restaurar colisiones
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Función de Float mejorada
local function toggleFloat()
    isFloating = not isFloating
    
    if isFloating then
        floatButton.Text = "Float: ON"
        floatButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = humanoidRootPart
            
            floatConnection = RunService.Heartbeat:Connect(function()
                if character and character.Parent and humanoidRootPart and humanoidRootPart.Parent then
                    local camera = workspace.CurrentCamera
                    local moveVector = Vector3.new(0, 0, 0)
                    
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
                    
                    bodyVelocity.Velocity = moveVector * floatSpeed
                    
                    if humanoid then
                        humanoid.PlatformStand = true
                    end
                else
                    toggleFloat()
                end
            end)
        end
    else
        floatButton.Text = "Float: OFF"
        floatButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
            
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
end

-- Función de ESP
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    
    local function addESP()
        local character = targetPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local humanoidRootPart = character.HumanoidRootPart
        local head = character:FindFirstChild("Head")
        
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ESP_" .. targetPlayer.Name
        billboardGui.Adornee = head or humanoidRootPart
        billboardGui.Size = UDim2.new(0, 200, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 2, 0)
        billboardGui.Parent = character
        
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
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = character
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
        local esp = targetPlayer.Character:FindFirstChild("ESP_" .. targetPlayer.Name)
        local highlight = targetPlayer.Character:FindFirstChild("ESP_Highlight")
        
        if esp then esp:Destroy() end
        if highlight then highlight:Destroy() end
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
        espButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            removeESP(targetPlayer)
        end
        
        if espConnections.playerAdded then
            espConnections.playerAdded:Disconnect()
            espConnections.playerAdded = nil
        end
    end
end

-- Función de Force Backpack
local function toggleBackpack()
    backpackForced = not backpackForced
    
    if backpackForced then
        backpackButton.Text = "Force Backpack: ON"
        backpackButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local starterGui = game:GetService("StarterGui")
        starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
        
        spawn(function()
            while backpackForced do
                wait(1)
                starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
            end
        end)
    else
        backpackButton.Text = "Force Backpack: OFF"
        backpackButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end

-- Función de Instant Prompts
local function toggleInstantPrompts()
    instantPrompts = not instantPrompts
    
    if instantPrompts then
        promptButton.Text = "Instant Prompts: ON"
        promptButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Modificar todos los ProximityPrompts existentes
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                if not originalPromptSettings[prompt] then
                    originalPromptSettings[prompt] = {
                        HoldDuration = prompt.HoldDuration,
                        KeyboardKeyCode = prompt.KeyboardKeyCode
                    }
                end
                prompt.HoldDuration = 0
            end
        end
        
        -- Conectar para nuevos ProximityPrompts
        workspace.DescendantAdded:Connect(function(descendant)
            if instantPrompts and descendant:IsA("ProximityPrompt") then
                originalPromptSettings[descendant] = {
                    HoldDuration = descendant.HoldDuration,
                    KeyboardKeyCode = descendant.KeyboardKeyCode
                }
                descendant.HoldDuration = 0
            end
        end)
    else
        promptButton.Text = "Instant Prompts: OFF"
        promptButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        -- Restaurar configuraciones originales
        for prompt, settings in pairs(originalPromptSettings) do
            if prompt and prompt.Parent then
                prompt.HoldDuration = settings.HoldDuration
            end
        end
    end
end

-- Función de Teleport a todos los jugadores
local function teleportToAllPlayers()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoidRootPart = character.HumanoidRootPart
    local players = Players:GetPlayers()
    local teleportIndex = 1
    
    spawn(function()
        for _, targetPlayer in pairs(players) do
            if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                humanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                wait(0.5) -- Esperar medio segundo entre teleports
            end
        end
    end)
end

-- Función de Auto Hit para el bate
local function toggleAutoHit()
    autoHit = not autoHit
    
    if autoHit then
        autoHitButton.Text = "Auto Hit (Bat): ON"
        autoHitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        autoHitConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:lower():find("bat") or tool.Name:lower():find("bate")) then
                    -- Buscar el RemoteEvent o función de golpe
                    local remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Hit") or tool:FindFirstChild("Swing")
                    if remote and remote:IsA("RemoteEvent") then
                        remote:FireServer()
                    end
                    
                    -- También intentar activar la herramienta
                    if tool:FindFirstChild("Handle") then
                        tool:Activate()
                    end
                end
            end
        end)
    else
        autoHitButton.Text = "Auto Hit (Bat): OFF"
        autoHitButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        if autoHitConnection then
            autoHitConnection:Disconnect()
            autoHitConnection = nil
        end
    end
end

-- Conectar eventos de los botones
floatButton.MouseButton1Click:Connect(toggleFloat)
noClipButton.MouseButton1Click:Connect(toggleNoClip)
espButton.MouseButton1Click:Connect(toggleESP)
backpackButton.MouseButton1Click:Connect(toggleBackpack)
promptButton.MouseButton1Click:Connect(toggleInstantPrompts)
teleportButton.MouseButton1Click:Connect(teleportToAllPlayers)
autoHitButton.MouseButton1Click:Connect(toggleAutoHit)

-- Conectar la tecla F4 para toggle del panel
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F4 then
        togglePanel()
    end
end)

-- Limpiar conexiones cuando el jugador se va
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if espConnections[leavingPlayer] then
        espConnections[leavingPlayer]:Disconnect()
        espConnections[leavingPlayer] = nil
    end
end)

-- Limpiar cuando el personaje del jugador local respawnea
player.CharacterAdded:Connect(function()
    wait(1)
    if isFloating then
        isFloating = false
        toggleFloat()
    end
    if noClipEnabled then
        noClipEnabled = false
        toggleNoClip()
    end
end)

print("Advanced Cheat Panel cargado exitosamente!")
print("Controles:")
print("- F4: Abrir/Cerrar panel")
print("- Float: WASD + Space/Shift para movimiento 3D")
print("- NoClip: Atraviesa paredes y collision boxes")
print("- ESP: Muestra nombres y highlights de jugadores")
print("- Instant Prompts: Elimina delays de ProximityPrompts")
print("- Auto Hit: Golpea automáticamente con el bate")
print("- Teleport: Se teleporta a todos los jugadores secuencialmente")
