-- Auto Captura Mobile - Solo con botones GUI
-- Steal a Brainrot - Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables principales
local autoCaptureEnabled = false
local captureConnection = nil
local basePosition = nil
local isCapturing = false
local gui = nil

-- Función para encontrar la base del jugador
local function findPlayerBase()
    -- Método 1: Buscar spawn location
    if player.RespawnLocation then
        return player.RespawnLocation.CFrame + Vector3.new(0, 5, 0)
    end
    
    -- Método 2: Buscar por bases en workspace
    for _, obj in pairs(workspace:GetChildren()) do
        local objName = obj.Name:lower()
        if (string.find(objName, "base") or string.find(objName, "spawn")) then
            if player.Team then
                local teamName = player.Team.Name:lower()
                if string.find(objName, teamName) or string.find(objName, player.Name:lower()) then
                    local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildOfClass("Part")) or obj
                    if part then
                        return part.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end
    
    return nil
end

-- Función para teletransportarse a la base
local function teleportToBase()
    if isCapturing then return end
    isCapturing = true
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        isCapturing = false
        return
    end
    
    local rootPart = character.HumanoidRootPart
    
    if not basePosition then
        basePosition = findPlayerBase()
    end
    
    if basePosition then
        showNotification("📍 Yendo a la base...", 2)
        rootPart.CFrame = basePosition
        wait(1)
        showNotification("✅ ¡Llegaste a la base!", 2)
    else
        showNotification("❌ Base no encontrada", 2)
    end
    
    isCapturing = false
end

-- Función para detectar cuando el jugador agarra un tool
local function onToolAdded(tool)
    if autoCaptureEnabled and tool:IsA("Tool") then
        showNotification("🎯 Objeto detectado: " .. tool.Name, 1)
        wait(0.2)
        teleportToBase()
    end
end

-- Función para mostrar notificaciones
local function showNotification(text, duration)
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "Notification"
    notificationGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 50)
    frame.Position = UDim2.new(0.5, -140, 0, -60)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = notificationGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    -- Animación
    frame:TweenPosition(UDim2.new(0.5, -140, 0, 20), "Out", "Quad", 0.5, true)
    
    game:GetService("Debris"):AddItem(notificationGui, duration or 3)
    
    spawn(function()
        wait((duration or 3) - 0.5)
        frame:TweenPosition(UDim2.new(0.5, -140, 0, -60), "In", "Quad", 0.5, true)
    end)
end

-- Función para activar/desactivar auto captura
local function toggleAutoCapture()
    autoCaptureEnabled = not autoCaptureEnabled
    
    if autoCaptureEnabled then
        if player.Character then
            captureConnection = player.Character.ChildAdded:Connect(onToolAdded)
        end
        
        player.CharacterAdded:Connect(function(character)
            if autoCaptureEnabled then
                character.ChildAdded:Connect(onToolAdded)
            end
        end)
        
        showNotification("🔄 Auto captura ACTIVADO", 2)
        basePosition = findPlayerBase()
        if basePosition then
            showNotification("✅ Base encontrada!", 2)
        else
            showNotification("⚠️ Establece tu base manualmente", 3)
        end
    else
        if captureConnection then
            captureConnection:Disconnect()
            captureConnection = nil
        end
        showNotification("🔄 Auto captura DESACTIVADO", 2)
    end
end

-- Función para establecer base manualmente
local function setBaseHere()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        basePosition = character.HumanoidRootPart.CFrame
        showNotification("📍 Base establecida aquí!", 2)
    else
        showNotification("❌ No se pudo establecer base", 2)
    end
end

-- Crear GUI principal
local function createMobileGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoCaptureMobile"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "🎯 AUTO CAPTURE MOBILE"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleLabel
    
    -- Botón cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    -- Contenedor de botones
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -20, 1, -60)
    buttonContainer.Position = UDim2.new(0, 10, 0, 50)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = buttonContainer
    
    -- Función para crear botones
    local function createButton(text, color, callback, layoutOrder)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = color
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.Gotham
        button.LayoutOrder = layoutOrder
        button.Parent = buttonContainer
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button
        
        -- Efecto de presión
        button.MouseButton1Down:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 36)}):Play()
        end)
        
        button.MouseButton1Up:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
        end)
        
        button.MouseButton1Click:Connect(callback)
        return button
    end
    
    -- Botón toggle auto capture
    local toggleButton = createButton("🔄 ACTIVAR AUTO CAPTURE", Color3.fromRGB(100, 100, 100), function()
        toggleAutoCapture()
        if autoCaptureEnabled then
            toggleButton.Text = "🔄 DESACTIVAR AUTO CAPTURE"
            toggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        else
            toggleButton.Text = "🔄 ACTIVAR AUTO CAPTURE"
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
    end, 1)
    
    -- Botón establecer base
    local baseButton = createButton("📍 ESTABLECER BASE AQUÍ", Color3.fromRGB(60, 120, 200), function()
        setBaseHere()
    end, 2)
    
    -- Botón ir a base manualmente
    local goBaseButton = createButton("🚀 IR A BASE AHORA", Color3.fromRGB(60, 180, 60), function()
        teleportToBase()
    end, 3)
    
    -- Evento cerrar
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        gui = nil
    end)
    
    return screenGui
end

-- Crear botón flotante para abrir GUI
local function createFloatingButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloatingButton"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local floatingButton = Instance.new("TextButton")
    floatingButton.Size = UDim2.new(0, 60, 0, 60)
    floatingButton.Position = UDim2.new(0, 10, 0.5, -30)
    floatingButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    floatingButton.BorderSizePixel = 0
    floatingButton.Text = "🎯"
    floatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    floatingButton.TextScaled = true
    floatingButton.Font = Enum.Font.GothamBold
    floatingButton.Active = true
    floatingButton.Draggable = true
    floatingButton.Parent = screenGui
    
    local floatingCorner = Instance.new("UICorner")
    floatingCorner.CornerRadius = UDim.new(0.5, 0)
    floatingCorner.Parent = floatingButton
    
    -- Efecto de pulsación
    floatingButton.MouseButton1Down:Connect(function()
        TweenService:Create(floatingButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 55, 0, 55)}):Play()
    end)
    
    floatingButton.MouseButton1Up:Connect(function()
        TweenService:Create(floatingButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    end)
    
    floatingButton.MouseButton1Click:Connect(function()
        if gui then
            gui:Destroy()
            gui = nil
        else
            gui = createMobileGUI()
        end
    end)
    
    return screenGui
end

-- Conectar para nuevos personajes
player.CharacterAdded:Connect(function(character)
    if autoCaptureEnabled then
        wait(1)
        character.ChildAdded:Connect(onToolAdded)
    end
end)

-- Conectar para el personaje actual
if player.Character then
    player.Character.ChildAdded:Connect(onToolAdded)
end

-- Crear botón flotante inicial
createFloatingButton()

-- Mostrar notificación de carga
showNotification("🎯 AUTO CAPTURE MOBILE CARGADO!", 3)
showNotification("📱 Toca el botón 🎯 para abrir el panel", 4)

print("🎯 ===== AUTO CAPTURE MOBILE =====")
print("📱 Toca el botón flotante 🎯 para abrir")
print("✅ Funciona completamente con botones")
print("🎯 ===============================")
