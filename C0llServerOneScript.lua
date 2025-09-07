-- Panel de Control para Steal a Brainrot
-- Funciones: Velocidad, Salto y ESP para brainrots

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables de configuración
local speedEnabled = false
local jumpEnabled = false
local espEnabled = false
local currentSpeed = 16 -- Velocidad normal de Roblox
local currentJumpPower = 50 -- Altura de salto normal de Roblox
local panelVisible = false

-- Listas de brainrots
local secretBrainrots = {
    "La Vacca Saturno Saturnita",
    "Tortuginni Dragonfruitini",
    "Agarrini La Palini",
    "Los Tralaleritos",
    "Las Tralaleritas",
    "Graipuss Medussi",
    "La Grande Combinasion",
    "La Supreme Combinasion",
    "Los Combinasionas",
    "Karkerkar Kurkur",
    "Los Bros",
    "Job Job Job Sahur",
    "Las Vaquitas Saturnitas",
    "Los Hotspotsitos",
    "Pot Hotspot",
    "Esok Sekolah",
    "Garama and Madundung",
    "Los Matteos",
    "Spaghetti Tualetti",
    "Dul Dul Dul",
    "Blackhole Goat",
    "Nooo My Hotspot",
    "Sammyni Spyderini",
    "Secret Lucky Block",
    "Ketupat Kepat",
    "Bisonte Giuppitere"
}

local godBrainrots = {
    "Tigroligre Frutonni",
    "Espresso Signora",
    "Odin Din Din Dun",
    "Statutino Libertino",
    "Trenostruzzo Turbo 3000",
    "Los Tungtungtungcitos",
    "Trippi Troppi Troppa Trippa",
    "Cocofanto Elefanto",
    "Girafa Celestre",
    "Tralalero Tralala",
    "Los Crocodillitos",
    "Urubini Flamenguini",
    "Ballerino Lololo",
    "Alessio",
    "Tralalita Tralala",
    "Los Orcalitos",
    "Pakrahmatmamat",
    "Piccione Macchina",
    "Bulbito Bandito Traktorito",
    "Tukanno Bananno",
    "Cacasito Satalito",
    "Chihuanini Taconini"
}

-- Tabla para almacenar highlights activos
local activeHighlights = {}
local rainbowConnections = {}

-- Conexiones para el sistema continuo
local speedConnection = nil
local jumpConnection = nil

-- Crear la GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MovementPanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal del panel (más pequeño y en esquina superior derecha)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 450)
mainFrame.Position = UDim2.new(1, -270, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
mainFrame.Visible = false -- Inicialmente oculto

-- Esquinas redondeadas para el frame principal
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Steal a Brainrot Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Esquinas redondeadas para el título
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- === SECCIÓN DE VELOCIDAD ===

-- Label para velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 55)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad de Correr"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

-- Toggle para activar/desactivar velocidad
local speedToggle = Instance.new("TextButton")
speedToggle.Name = "SpeedToggle"
speedToggle.Size = UDim2.new(0, 70, 0, 25)
speedToggle.Position = UDim2.new(0, 10, 0, 85)
speedToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
speedToggle.BorderSizePixel = 0
speedToggle.Text = "OFF"
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.TextScaled = true
speedToggle.Font = Enum.Font.GothamBold
speedToggle.Parent = mainFrame

local speedToggleCorner = Instance.new("UICorner")
speedToggleCorner.CornerRadius = UDim.new(0, 8)
speedToggleCorner.Parent = speedToggle

-- Slider de velocidad
local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Name = "SpeedSliderFrame"
speedSliderFrame.Size = UDim2.new(1, -20, 0, 15)
speedSliderFrame.Position = UDim2.new(0, 10, 0, 115)
speedSliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSliderFrame.BorderSizePixel = 0
speedSliderFrame.Parent = mainFrame

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 10)
speedSliderCorner.Parent = speedSliderFrame

local speedSlider = Instance.new("TextButton")
speedSlider.Name = "SpeedSlider"
speedSlider.Size = UDim2.new(0, 20, 1, 0)
speedSlider.Position = UDim2.new(0, 0, 0, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
speedSlider.BorderSizePixel = 0
speedSlider.Text = ""
speedSlider.Parent = speedSliderFrame

local speedSliderKnob = Instance.new("UICorner")
speedSliderKnob.CornerRadius = UDim.new(0, 10)
speedSliderKnob.Parent = speedSlider

-- Label para mostrar valor de velocidad
local speedValueLabel = Instance.new("TextLabel")
speedValueLabel.Name = "SpeedValue"
speedValueLabel.Size = UDim2.new(0, 60, 0, 25)
speedValueLabel.Position = UDim2.new(0, 170, 0, 85)
speedValueLabel.BackgroundTransparency = 1
speedValueLabel.Text = tostring(currentSpeed)
speedValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedValueLabel.TextScaled = true
speedValueLabel.Font = Enum.Font.Gotham
speedValueLabel.Parent = mainFrame

-- === SECCIÓN DE SALTO ===

-- Label para salto
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Name = "JumpLabel"
jumpLabel.Size = UDim2.new(1, -20, 0, 25)
jumpLabel.Position = UDim2.new(0, 10, 0, 145)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Altura de Salto"
jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpLabel.TextScaled = true
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.Parent = mainFrame

-- Toggle para activar/desactivar salto
local jumpToggle = Instance.new("TextButton")
jumpToggle.Name = "JumpToggle"
jumpToggle.Size = UDim2.new(0, 70, 0, 25)
jumpToggle.Position = UDim2.new(0, 10, 0, 175)
jumpToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
jumpToggle.BorderSizePixel = 0
jumpToggle.Text = "OFF"
jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpToggle.TextScaled = true
jumpToggle.Font = Enum.Font.GothamBold
jumpToggle.Parent = mainFrame

local jumpToggleCorner = Instance.new("UICorner")
jumpToggleCorner.CornerRadius = UDim.new(0, 8)
jumpToggleCorner.Parent = jumpToggle

-- Slider de salto
local jumpSliderFrame = Instance.new("Frame")
jumpSliderFrame.Name = "JumpSliderFrame"
jumpSliderFrame.Size = UDim2.new(1, -20, 0, 15)
jumpSliderFrame.Position = UDim2.new(0, 10, 0, 205)
jumpSliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jumpSliderFrame.BorderSizePixel = 0
jumpSliderFrame.Parent = mainFrame

local jumpSliderCorner = Instance.new("UICorner")
jumpSliderCorner.CornerRadius = UDim.new(0, 10)
jumpSliderCorner.Parent = jumpSliderFrame

local jumpSlider = Instance.new("TextButton")
jumpSlider.Name = "JumpSlider"
jumpSlider.Size = UDim2.new(0, 20, 1, 0)
jumpSlider.Position = UDim2.new(0, 0, 0, 0)
jumpSlider.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
jumpSlider.BorderSizePixel = 0
jumpSlider.Text = ""
jumpSlider.Parent = jumpSliderFrame

local jumpSliderKnob = Instance.new("UICorner")
jumpSliderKnob.CornerRadius = UDim.new(0, 10)
jumpSliderKnob.Parent = jumpSlider

-- Label para mostrar valor de salto
local jumpValueLabel = Instance.new("TextLabel")
jumpValueLabel.Name = "JumpValue"
jumpValueLabel.Size = UDim2.new(0, 60, 0, 25)
jumpValueLabel.Position = UDim2.new(0, 170, 0, 175)
jumpValueLabel.BackgroundTransparency = 1
jumpValueLabel.Text = tostring(currentJumpPower)
jumpValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpValueLabel.TextScaled = true
jumpValueLabel.Font = Enum.Font.Gotham
jumpValueLabel.Parent = mainFrame

-- === SECCIÓN DE ESP ===

-- Label para ESP
local espLabel = Instance.new("TextLabel")
espLabel.Name = "ESPLabel"
espLabel.Size = UDim2.new(1, -20, 0, 25)
espLabel.Position = UDim2.new(0, 10, 0, 235)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP Brainrots"
espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
espLabel.TextScaled = true
espLabel.Font = Enum.Font.Gotham
espLabel.Parent = mainFrame

-- Toggle para activar/desactivar ESP
local espToggle = Instance.new("TextButton")
espToggle.Name = "ESPToggle"
espToggle.Size = UDim2.new(0, 70, 0, 25)
espToggle.Position = UDim2.new(0, 10, 0, 265)
espToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
espToggle.BorderSizePixel = 0
espToggle.Text = "OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.TextScaled = true
espToggle.Font = Enum.Font.GothamBold
espToggle.Parent = mainFrame

local espToggleCorner = Instance.new("UICorner")
espToggleCorner.CornerRadius = UDim.new(0, 8)
espToggleCorner.Parent = espToggle

-- Labels informativos
local secretLabel = Instance.new("TextLabel")
secretLabel.Name = "SecretLabel"
secretLabel.Size = UDim2.new(1, -20, 0, 20)
secretLabel.Position = UDim2.new(0, 10, 0, 295)
secretLabel.BackgroundTransparency = 1
secretLabel.Text = "🌈 Secrets: Rainbow Highlight"
secretLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
secretLabel.TextScaled = true
secretLabel.Font = Enum.Font.Gotham
secretLabel.Parent = mainFrame

local godLabel = Instance.new("TextLabel")
godLabel.Name = "GodLabel"
godLabel.Size = UDim2.new(1, -20, 0, 20)
godLabel.Position = UDim2.new(0, 10, 0, 315)
godLabel.BackgroundTransparency = 1
godLabel.Text = "⭐ Gods: Golden Highlight"
godLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
godLabel.TextScaled = true
godLabel.Font = Enum.Font.Gotham
godLabel.Parent = mainFrame

-- Info de activación
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(1, -20, 0, 25)
infoLabel.Position = UDim2.new(0, 10, 0, 340)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Presiona F para mostrar/ocultar"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.Parent = mainFrame

-- Botón para cerrar el panel
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton

-- === FUNCIONES ===

-- Sistema continuo para velocidad (se ejecuta cada frame)
local function startSpeedLoop()
    if speedConnection then
        speedConnection:Disconnect()
    end
    
    speedConnection = RunService.Heartbeat:Connect(function()
        if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.WalkSpeed ~= currentSpeed then
                humanoid.WalkSpeed = currentSpeed
            end
        end
    end)
end

-- Sistema continuo para salto (se ejecuta cada frame)
local function startJumpLoop()
    if jumpConnection then
        jumpConnection:Disconnect()
    end
    
    jumpConnection = RunService.Heartbeat:Connect(function()
        if jumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            
            -- Intentar ambos sistemas de salto para máxima compatibilidad
            if humanoid:FindFirstChild("JumpHeight") then
                local targetHeight = currentJumpPower * 0.35
                if humanoid.JumpHeight ~= targetHeight then
                    humanoid.JumpHeight = targetHeight
                end
            end
            
            if humanoid:FindFirstChild("JumpPower") then
                if humanoid.JumpPower ~= currentJumpPower then
                    humanoid.JumpPower = currentJumpPower
                end
            end
        end
    end)
end

-- Función para actualizar velocidad
local function updateSpeed()
    if speedEnabled then
        startSpeedLoop()
        print("🏃 Sistema de velocidad continuo activado:", currentSpeed)
    else
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        -- Restaurar velocidad normal
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
        print("🚶 Velocidad normal restaurada")
    end
end

-- Función para actualizar salto
local function updateJump()
    if jumpEnabled then
        startJumpLoop()
        print("🦘 Sistema de salto continuo activado:", currentJumpPower)
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
        -- Restaurar salto normal
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid:FindFirstChild("JumpHeight") then
                humanoid.JumpHeight = 7.2
            end
            if humanoid:FindFirstChild("JumpPower") then
                humanoid.JumpPower = 50
            end
        end
        print("🦘 Salto normal restaurado")
    end
end

-- Función para generar colores rainbow
local function getRainbowColor(time)
    local hue = (time * 2) % 1
    local function hslToRgb(h, s, l)
        local function hue2rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end
        
        local r, g, b
        if s == 0 then
            r, g, b = l, l, l
        else
            local q = l < 0.5 and l * (1 + s) or l + s - l * s
            local p = 2 * l - q
            r = hue2rgb(p, q, hue + 1/3)
            g = hue2rgb(p, q, hue)
            b = hue2rgb(p, q, hue - 1/3)
        end
        return Color3.new(r, g, b)
    end
    return hslToRgb(hue, 1, 0.5)
end

-- Función para crear highlight
local function createHighlight(part, isSecret)
    local highlight = Instance.new("Highlight")
    highlight.Parent = part
    highlight.Adornee = part
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    
    if isSecret then
        -- Rainbow para secrets
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        
        -- Animación rainbow
        local connection = RunService.Heartbeat:Connect(function()
            local time = tick()
            highlight.FillColor = getRainbowColor(time)
            highlight.OutlineColor = getRainbowColor(time + 0.5)
        end)
        rainbowConnections[highlight] = connection
    else
        -- Dorado para gods
        highlight.FillColor = Color3.fromRGB(255, 215, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
    
    return highlight
end

-- Función para verificar si es un brainrot especial
local function isBrainrot(name)
    -- Limpiar el nombre (quitar espacios extra y convertir a lowercase para comparación)
    local cleanName = string.lower(string.gsub(name, "%s+", " "))
    
    -- Verificar si es secret
    for _, secretName in pairs(secretBrainrots) do
        local cleanSecret = string.lower(secretName)
        if string.find(cleanName, cleanSecret, 1, true) or string.find(name, secretName, 1, true) then
            return true, true -- es brainrot, es secret
        end
    end
    
    -- Verificar si es god
    for _, godName in pairs(godBrainrots) do
        local cleanGod = string.lower(godName)
        if string.find(cleanName, cleanGod, 1, true) or string.find(name, godName, 1, true) then
            return true, false -- es brainrot, no es secret (es god)
        end
    end
    
    return false, false -- no es brainrot especial
end

-- Función para aplicar ESP a un objeto (busca en Models y Parts)
local function applyESP(obj)
    -- Si es un Model, aplicar highlight a todas sus partes
    if obj:IsA("Model") then
        local isBrain, isSecret = isBrainrot(obj.Name)
        if isBrain and not activeHighlights[obj] then
            -- Crear highlight para el model completo
            local highlight = createHighlight(obj, isSecret)
            activeHighlights[obj] = highlight
            
            -- También destacar las partes individuales del model
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") and not activeHighlights[part] then
                    local partHighlight = createHighlight(part, isSecret)
                    activeHighlights[part] = partHighlight
                end
            end
        end
    elseif obj:IsA("BasePart") then
        -- Verificar si la parte pertenece a un brainrot
        local parent = obj.Parent
        if parent and parent:IsA("Model") then
            local isBrain, isSecret = isBrainrot(parent.Name)
            if isBrain and not activeHighlights[obj] then
                local highlight = createHighlight(obj, isSecret)
                activeHighlights[obj] = highlight
            end
        else
            -- Verificar si la parte en sí es un brainrot
            local isBrain, isSecret = isBrainrot(obj.Name)
            if isBrain and not activeHighlights[obj] then
                local highlight = createHighlight(obj, isSecret)
                activeHighlights[obj] = highlight
            end
        end
    end
end

-- Función para remover ESP de un objeto
local function removeESP(obj)
    if activeHighlights[obj] then
        if rainbowConnections[activeHighlights[obj]] then
            rainbowConnections[activeHighlights[obj]]:Disconnect()
            rainbowConnections[activeHighlights[obj]] = nil
        end
        activeHighlights[obj]:Destroy()
        activeHighlights[obj] = nil
    end
end

-- Función para actualizar ESP
local function updateESP()
    if espEnabled then
        -- Buscar en carpeta Animals si existe
        local animalsFolder = Workspace:FindFirstChild("Animals")
        if animalsFolder then
            for _, obj in pairs(animalsFolder:GetDescendants()) do
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    applyESP(obj)
                end
            end
        end
        
        -- También buscar en todo el workspace por si acaso
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                applyESP(obj)
            end
        end
        
        print("🔍 ESP activado - Buscando brainrots...")
    else
        -- Remover todos los highlights
        for obj, highlight in pairs(activeHighlights) do
            removeESP(obj)
        end
        print("❌ ESP desactivado")
    end
end

-- Función para toggle del panel
local function togglePanel()
    panelVisible = not panelVisible
    mainFrame.Visible = panelVisible
end

-- Función para crear efecto de animación en botones
local function animateButton(button, scale)
    local originalSize = button.Size
    local newSize = UDim2.new(originalSize.X.Scale * scale, originalSize.X.Offset * scale, originalSize.Y.Scale * scale, originalSize.Y.Offset * scale)
    local tween = TweenService:Create(button, TweenInfo.new(0.1), {Size = newSize})
    tween:Play()
    tween.Completed:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize}):Play()
    end)
end

-- === EVENTOS ===

-- Evento para la tecla F (mostrar/ocultar panel)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        togglePanel()
    end
end)

-- Toggle de velocidad
speedToggle.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedToggle.Text = "ON"
        speedToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        speedToggle.Text = "OFF"
        speedToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
    animateButton(speedToggle, 0.9)
    updateSpeed()
end)

-- Toggle de salto
jumpToggle.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    if jumpEnabled then
        jumpToggle.Text = "ON"
        jumpToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        jumpToggle.Text = "OFF"
        jumpToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
    animateButton(jumpToggle, 0.9)
    updateJump()
end)

-- Toggle de ESP
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espToggle.Text = "ON"
        espToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        
        -- Debug: mostrar estructura del workspace
        print("🔍 Explorando workspace...")
        local animalsFolder = Workspace:FindFirstChild("Animals")
        if animalsFolder then
            print("✅ Carpeta Animals encontrada!")
            print("📁 Contenido de Animals:")
            for _, child in pairs(animalsFolder:GetChildren()) do
                print("  - " .. child.Name .. " (" .. child.ClassName .. ")")
                if child:IsA("Model") then
                    local isBrain, isSecret = isBrainrot(child.Name)
                    if isBrain then
                        print("    🎯 ¡BRAINROT DETECTADO! Secret:", isSecret)
                    end
                end
            end
        else
            print("❌ Carpeta Animals no encontrada")
            print("📁 Explorando workspace completo...")
            for _, child in pairs(Workspace:GetChildren()) do
                print("  - " .. child.Name .. " (" .. child.ClassName .. ")")
            end
        end
    else
        espToggle.Text = "OFF"
        espToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
    animateButton(espToggle, 0.9)
    updateESP()
end)

-- Slider de velocidad
local speedDragging = false
speedSlider.MouseButton1Down:Connect(function()
    speedDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = false
    end
end)

RunService.Heartbeat:Connect(function()
    if speedDragging then
        local mouse = Players.LocalPlayer:GetMouse()
        local relativePos = math.clamp((mouse.X - speedSliderFrame.AbsolutePosition.X) / speedSliderFrame.AbsoluteSize.X, 0, 1)
        speedSlider.Position = UDim2.new(relativePos, -10, 0, 0)
        currentSpeed = math.floor(16 + (relativePos * 184)) -- Rango de 16 a 200
        speedValueLabel.Text = tostring(currentSpeed)
        -- El sistema continuo se encarga automáticamente de aplicar el nuevo valor
    end
end)

-- Slider de salto
local jumpDragging = false
jumpSlider.MouseButton1Down:Connect(function()
    jumpDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        jumpDragging = false
    end
end)

RunService.Heartbeat:Connect(function()
    if jumpDragging then
        local mouse = Players.LocalPlayer:GetMouse()
        local relativePos = math.clamp((mouse.X - jumpSliderFrame.AbsolutePosition.X) / jumpSliderFrame.AbsoluteSize.X, 0, 1)
        jumpSlider.Position = UDim2.new(relativePos, -10, 0, 0)
        currentJumpPower = math.floor(50 + (relativePos * 450)) -- Rango de 50 a 500
        jumpValueLabel.Text = tostring(currentJumpPower)
        -- El sistema continuo se encarga automáticamente de aplicar el nuevo valor
    end
end)

-- Botón de cerrar
closeButton.MouseButton1Click:Connect(function()
    animateButton(closeButton, 0.8)
    wait(0.2)
    
    -- Limpiar todas las conexiones antes de cerrar
    if speedConnection then
        speedConnection:Disconnect()
    end
    if jumpConnection then
        jumpConnection:Disconnect()
    end
    
    -- Limpiar ESP
    for obj, highlight in pairs(activeHighlights) do
        removeESP(obj)
    end
    
    print("🔄 Panel cerrado - Todos los sistemas desactivados")
    screenGui:Destroy()
end)

-- Detectar nuevos objetos para ESP
Workspace.DescendantAdded:Connect(function(obj)
    if espEnabled and (obj:IsA("Model") or obj:IsA("BasePart")) then
        applyESP(obj)
    end
end)

-- Limpiar highlights cuando se eliminan objetos
Workspace.DescendantRemoving:Connect(function(obj)
    if activeHighlights[obj] then
        removeESP(obj)
    end
end)

-- Actualizar cuando el jugador respawnea
player.CharacterAdded:Connect(function()
    wait(1) -- Esperar a que el personaje se cargue completamente
    
    -- Reiniciar los sistemas si estaban activos
    if speedEnabled then
        startSpeedLoop()
        print("🔄 Sistema de velocidad reiniciado después del respawn")
    end
    
    if jumpEnabled then
        startJumpLoop()
        print("🔄 Sistema de salto reiniciado después del respawn")
    end
end)

-- Inicializar
if player.Character then
    updateSpeed()
    updateJump()
end

print("🎮 Steal a Brainrot Panel cargado exitosamente!")
print("📋 Funciones disponibles:")
print("   🏃 Velocidad ajustable: 16-200")
print("   🦘 Altura de salto ajustable: 50-500")
print("   👁️ ESP para brainrots especiales")
print("🔧 Controles:")
print("   ⌨️ Presiona F para mostrar/ocultar el panel")
print("   🖱️ Panel arrastrable con animaciones")
print("🌈 ESP Secrets: Highlight rainbow animado")
print("⭐ ESP Gods: Highlight dorado")
print("✅ ¡Listo para usar!")
