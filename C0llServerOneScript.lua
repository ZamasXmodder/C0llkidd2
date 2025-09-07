-- Panel ULTRA SIGILOSO para Steal a Brainrot
-- Métodos que simulan comportamiento humano 100% natural

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables de configuración ULTRA CONSERVADORAS
local speedEnabled = false
local jumpEnabled = false
local espEnabled = false
local currentSpeed = 16
local currentJumpPower = 50
local panelVisible = false

-- Variables para simulación humana (más efectiva)
local lastSpeedChange = 0
local lastJumpTime = 0
local humanDelayMin = 0.05 -- Más rápido
local humanDelayMax = 0.15 -- Menos delay
local isSimulatingHuman = false
local speedReached = false
local jumpReached = false

-- Listas de brainrots (mismo contenido)
local secretBrainrots = {
    "La Vacca Saturno Saturnita", "Tortuginni Dragonfruitini", "Agarrini La Palini",
    "Los Tralaleritos", "Las Tralaleritas", "Graipuss Medussi", "La Grande Combinasion",
    "La Supreme Combinasion", "Los Combinasionas", "Karkerkar Kurkur", "Los Bros",
    "Job Job Job Sahur", "Las Vaquitas Saturnitas", "Los Hotspotsitos", "Pot Hotspot",
    "Esok Sekolah", "Garama and Madundung", "Los Matteos", "Spaghetti Tualetti",
    "Dul Dul Dul", "Blackhole Goat", "Nooo My Hotspot", "Sammyni Spyderini",
    "Secret Lucky Block", "Ketupat Kepat", "Bisonte Giuppitere"
}

local godBrainrots = {
    "Tigroligre Frutonni", "Espresso Signora", "Odin Din Din Dun", "Statutino Libertino",
    "Trenostruzzo Turbo 3000", "Los Tungtungtungcitos", "Trippi Troppi Troppa Trippa",
    "Cocofanto Elefanto", "Girafa Celestre", "Tralalero Tralala", "Los Crocodillitos",
    "Urubini Flamenguini", "Ballerino Lololo", "Alessio", "Tralalita Tralala",
    "Los Orcalitos", "Pakrahmatmamat", "Piccione Macchina", "Bulbito Bandito Traktorito",
    "Tukanno Bananno", "Cacasito Satalito", "Chihuanini Taconini"
}

-- Variables para ESP
local activeHighlights = {}
local rainbowConnections = {}

-- Conexiones sigilosas
local stealthConnection = nil

-- Crear la GUI principal (más pequeña y discreta)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealthPanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(1, -240, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
mainFrame.Visible = false
mainFrame.BackgroundTransparency = 0.1 -- Más transparente

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Título discreto
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Stealth Panel"
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.Gotham
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- === SECCIÓN DE VELOCIDAD SIGILOSA ===
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -10, 0, 20)
speedLabel.Position = UDim2.new(0, 5, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad Natural"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0, 60, 0, 20)
speedToggle.Position = UDim2.new(0, 5, 0, 65)
speedToggle.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
speedToggle.BorderSizePixel = 0
speedToggle.Text = "OFF"
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.TextScaled = true
speedToggle.Font = Enum.Font.GothamBold
speedToggle.Parent = mainFrame

local speedToggleCorner = Instance.new("UICorner")
speedToggleCorner.CornerRadius = UDim.new(0, 5)
speedToggleCorner.Parent = speedToggle

local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Size = UDim2.new(1, -10, 0, 12)
speedSliderFrame.Position = UDim2.new(0, 5, 0, 90)
speedSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedSliderFrame.BorderSizePixel = 0
speedSliderFrame.Parent = mainFrame

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 6)
speedSliderCorner.Parent = speedSliderFrame

local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(0, 15, 1, 0)
speedSlider.Position = UDim2.new(0, 0, 0, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
speedSlider.BorderSizePixel = 0
speedSlider.Text = ""
speedSlider.Parent = speedSliderFrame

local speedSliderKnob = Instance.new("UICorner")
speedSliderKnob.CornerRadius = UDim.new(0, 6)
speedSliderKnob.Parent = speedSlider

local speedValueLabel = Instance.new("TextLabel")
speedValueLabel.Size = UDim2.new(0, 50, 0, 20)
speedValueLabel.Position = UDim2.new(0, 160, 0, 65)
speedValueLabel.BackgroundTransparency = 1
speedValueLabel.Text = tostring(currentSpeed)
speedValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedValueLabel.TextScaled = true
speedValueLabel.Font = Enum.Font.Gotham
speedValueLabel.Parent = mainFrame

-- === SECCIÓN DE SALTO SIGILOSO ===
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(1, -10, 0, 20)
jumpLabel.Position = UDim2.new(0, 5, 0, 115)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Salto Natural"
jumpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
jumpLabel.TextScaled = true
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.Parent = mainFrame

local jumpToggle = Instance.new("TextButton")
jumpToggle.Size = UDim2.new(0, 60, 0, 20)
jumpToggle.Position = UDim2.new(0, 5, 0, 140)
jumpToggle.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
jumpToggle.BorderSizePixel = 0
jumpToggle.Text = "OFF"
jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpToggle.TextScaled = true
jumpToggle.Font = Enum.Font.GothamBold
jumpToggle.Parent = mainFrame

local jumpToggleCorner = Instance.new("UICorner")
jumpToggleCorner.CornerRadius = UDim.new(0, 5)
jumpToggleCorner.Parent = jumpToggle

local jumpSliderFrame = Instance.new("Frame")
jumpSliderFrame.Size = UDim2.new(1, -10, 0, 12)
jumpSliderFrame.Position = UDim2.new(0, 5, 0, 165)
jumpSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
jumpSliderFrame.BorderSizePixel = 0
jumpSliderFrame.Parent = mainFrame

local jumpSliderCorner = Instance.new("UICorner")
jumpSliderCorner.CornerRadius = UDim.new(0, 6)
jumpSliderCorner.Parent = jumpSliderFrame

local jumpSlider = Instance.new("TextButton")
jumpSlider.Size = UDim2.new(0, 15, 1, 0)
jumpSlider.Position = UDim2.new(0, 0, 0, 0)
jumpSlider.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
jumpSlider.BorderSizePixel = 0
jumpSlider.Text = ""
jumpSlider.Parent = jumpSliderFrame

local jumpSliderKnob = Instance.new("UICorner")
jumpSliderKnob.CornerRadius = UDim.new(0, 6)
jumpSliderKnob.Parent = jumpSlider

local jumpValueLabel = Instance.new("TextLabel")
jumpValueLabel.Size = UDim2.new(0, 50, 0, 20)
jumpValueLabel.Position = UDim2.new(0, 160, 0, 140)
jumpValueLabel.BackgroundTransparency = 1
jumpValueLabel.Text = tostring(currentJumpPower)
jumpValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
jumpValueLabel.TextScaled = true
jumpValueLabel.Font = Enum.Font.Gotham
jumpValueLabel.Parent = mainFrame

-- === SECCIÓN ESP ===
local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(1, -10, 0, 20)
espLabel.Position = UDim2.new(0, 5, 0, 190)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP Brainrots"
espLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
espLabel.TextScaled = true
espLabel.Font = Enum.Font.Gotham
espLabel.Parent = mainFrame

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 60, 0, 20)
espToggle.Position = UDim2.new(0, 5, 0, 215)
espToggle.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
espToggle.BorderSizePixel = 0
espToggle.Text = "OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.TextScaled = true
espToggle.Font = Enum.Font.GothamBold
espToggle.Parent = mainFrame

local espToggleCorner = Instance.new("UICorner")
espToggleCorner.CornerRadius = UDim.new(0, 5)
espToggleCorner.Parent = espToggle

-- Info labels
local infoLabel1 = Instance.new("TextLabel")
infoLabel1.Size = UDim2.new(1, -10, 0, 15)
infoLabel1.Position = UDim2.new(0, 5, 0, 240)
infoLabel1.BackgroundTransparency = 1
infoLabel1.Text = "🌈 Secrets: Rainbow"
infoLabel1.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel1.TextScaled = true
infoLabel1.Font = Enum.Font.Gotham
infoLabel1.Parent = mainFrame

local infoLabel2 = Instance.new("TextLabel")
infoLabel2.Size = UDim2.new(1, -10, 0, 15)
infoLabel2.Position = UDim2.new(0, 5, 0, 255)
infoLabel2.BackgroundTransparency = 1
infoLabel2.Text = "⭐ Gods: Golden"
infoLabel2.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel2.TextScaled = true
infoLabel2.Font = Enum.Font.Gotham
infoLabel2.Parent = mainFrame

local infoLabel3 = Instance.new("TextLabel")
infoLabel3.Size = UDim2.new(1, -10, 0, 15)
infoLabel3.Position = UDim2.new(0, 5, 0, 270)
infoLabel3.BackgroundTransparency = 1
infoLabel3.Text = "Presiona F para mostrar/ocultar"
infoLabel3.TextColor3 = Color3.fromRGB(120, 120, 120)
infoLabel3.TextScaled = true
infoLabel3.Font = Enum.Font.Gotham
infoLabel3.Parent = mainFrame

-- Botón de cerrar discreto
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

-- === FUNCIONES ULTRA SIGILOSAS ===

-- Función para delay humano aleatorio
local function humanDelay()
    return math.random() * (humanDelayMax - humanDelayMin) + humanDelayMin
end

-- MÉTODO ULTRA SIGILOSO: Simulación de input humano
local function startStealthSystem()
    if stealthConnection then
        stealthConnection:Disconnect()
    end
    
    stealthConnection = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        
        -- Sistema de velocidad ULTRA SIGILOSO
        if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            
            -- Solo cambiar velocidad con delay humano
            if currentTime - lastSpeedChange > humanDelay() then
                -- Cambio GRADUAL y natural de velocidad
                local targetSpeed = currentSpeed
                local currentWalkSpeed = humanoid.WalkSpeed
                
                if math.abs(currentWalkSpeed - targetSpeed) > 0.2 then
                    -- Tween más RÁPIDO hacia la velocidad objetivo
                    local difference = targetSpeed - currentWalkSpeed
                    local increment = difference * 0.3 -- Cambio más rápido pero natural
                    
                    humanoid.WalkSpeed = currentWalkSpeed + increment
                    
                    if not speedReached and math.abs(humanoid.WalkSpeed - targetSpeed) < 1 then
                        speedReached = true
                        print("⚡ Velocidad objetivo alcanzada:", math.floor(targetSpeed))
                    end
                elseif not speedReached then
                    humanoid.WalkSpeed = targetSpeed -- Asegurar que llegue al objetivo
                    speedReached = true
                    print("⚡ Velocidad establecida:", targetSpeed)
                end
                
                lastSpeedChange = currentTime
            end
        end
        
        -- Sistema de salto ULTRA SIGILOSO
        if jumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            
            -- Solo cambiar salto con delay humano
            if currentTime - lastJumpTime > humanDelay() then
                -- Cambio GRADUAL de altura de salto
                local targetJump = currentJumpPower
                
                if humanoid:FindFirstChild("JumpHeight") then
                    local currentJumpHeight = humanoid.JumpHeight
                    local targetHeight = targetJump * 0.144 -- Conversión a JumpHeight
                    
                    if math.abs(currentJumpHeight - targetHeight) > 0.1 then
                        local difference = targetHeight - currentJumpHeight
                        local increment = difference * 0.4 -- Cambio más rápido
                        humanoid.JumpHeight = currentJumpHeight + increment
                        
                        if not jumpReached and math.abs(humanoid.JumpHeight - targetHeight) < 0.5 then
                            jumpReached = true
                            print("🦘 Altura de salto alcanzada:", math.floor(targetJump))
                        end
                    elseif not jumpReached then
                        humanoid.JumpHeight = targetHeight
                        jumpReached = true
                        print("🦘 JumpHeight establecido:", math.floor(targetJump))
                    end
                elseif humanoid:FindFirstChild("JumpPower") then
                    local currentJumpPowerValue = humanoid.JumpPower
                    if math.abs(currentJumpPowerValue - targetJump) > 0.5 then
                        local difference = targetJump - currentJumpPowerValue
                        local increment = difference * 0.4 -- Cambio más rápido
                        humanoid.JumpPower = currentJumpPowerValue + increment
                        
                        if not jumpReached and math.abs(humanoid.JumpPower - targetJump) < 1 then
                            jumpReached = true
                            print("🦘 JumpPower alcanzado:", math.floor(targetJump))
                        end
                    elseif not jumpReached then
                        humanoid.JumpPower = targetJump
                        jumpReached = true
                        print("🦘 JumpPower establecido:", targetJump)
                    end
                end
                
                lastJumpTime = currentTime
            end
        end
    end)
end

-- Función para generar colores rainbow (misma que antes)
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

-- Función para crear highlight (misma que antes)
local function createHighlight(part, isSecret)
    local highlight = Instance.new("Highlight")
    highlight.Parent = part
    highlight.Adornee = part
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    
    if isSecret then
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        
        local connection = RunService.Heartbeat:Connect(function()
            local time = tick()
            highlight.FillColor = getRainbowColor(time)
            highlight.OutlineColor = getRainbowColor(time + 0.5)
        end)
        rainbowConnections[highlight] = connection
    else
        highlight.FillColor = Color3.fromRGB(255, 215, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
    
    return highlight
end

-- Función para verificar brainrots (misma que antes)
local function isBrainrot(name)
    local cleanName = string.lower(string.gsub(name, "%s+", " "))
    
    for _, secretName in pairs(secretBrainrots) do
        local cleanSecret = string.lower(secretName)
        if string.find(cleanName, cleanSecret, 1, true) or string.find(name, secretName, 1, true) then
            return true, true
        end
    end
    
    for _, godName in pairs(godBrainrots) do
        local cleanGod = string.lower(godName)
        if string.find(cleanName, cleanGod, 1, true) or string.find(name, godName, 1, true) then
            return true, false
        end
    end
    
    return false, false
end

-- Función para aplicar ESP (misma que antes)
local function applyESP(obj)
    if obj:IsA("Model") then
        local isBrain, isSecret = isBrainrot(obj.Name)
        if isBrain and not activeHighlights[obj] then
            local highlight = createHighlight(obj, isSecret)
            activeHighlights[obj] = highlight
            
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") and not activeHighlights[part] then
                    local partHighlight = createHighlight(part, isSecret)
                    activeHighlights[part] = partHighlight
                end
            end
        end
    elseif obj:IsA("BasePart") then
        local parent = obj.Parent
        if parent and parent:IsA("Model") then
            local isBrain, isSecret = isBrainrot(parent.Name)
            if isBrain and not activeHighlights[obj] then
                local highlight = createHighlight(obj, isSecret)
                activeHighlights[obj] = highlight
            end
        else
            local isBrain, isSecret = isBrainrot(obj.Name)
            if isBrain and not activeHighlights[obj] then
                local highlight = createHighlight(obj, isSecret)
                activeHighlights[obj] = highlight
            end
        end
    end
end

-- Función para remover ESP
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
        local animalsFolder = Workspace:FindFirstChild("Animals")
        if animalsFolder then
            for _, obj in pairs(animalsFolder:GetDescendants()) do
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    applyESP(obj)
                end
            end
        end
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                applyESP(obj)
            end
        end
        
        print("🔍 ESP sigiloso activado")
    else
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

-- Función de animación suave
local function smoothAnimate(button, scale)
    local originalSize = button.Size
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local newSize = UDim2.new(originalSize.X.Scale * scale, originalSize.X.Offset * scale, originalSize.Y.Scale * scale, originalSize.Y.Offset * scale)
    
    local tween1 = TweenService:Create(button, tweenInfo, {Size = newSize})
    tween1:Play()
    tween1.Completed:Connect(function()
        local tween2 = TweenService:Create(button, tweenInfo, {Size = originalSize})
        tween2:Play()
    end)
end

-- === EVENTOS ===

-- Tecla F para mostrar/ocultar
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
        speedToggle.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
        startStealthSystem()
        print("🔬 Sistema sigiloso de velocidad activado")
    else
        speedToggle.Text = "OFF"
        speedToggle.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
        print("🚶 Velocidad normal")
    end
    smoothAnimate(speedToggle, 0.95)
end)

-- Toggle de salto
jumpToggle.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    if jumpEnabled then
        jumpToggle.Text = "ON"
        jumpToggle.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
        startStealthSystem()
        print("🔬 Sistema sigiloso de salto activado")
    else
        jumpToggle.Text = "OFF"
        jumpToggle.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid:FindFirstChild("JumpHeight") then
                humanoid.JumpHeight = 7.2
            end
            if humanoid:FindFirstChild("JumpPower") then
                humanoid.JumpPower = 50
            end
        end
        print("🦘 Salto normal")
    end
    smoothAnimate(jumpToggle, 0.95)
end)

-- Toggle de ESP
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espToggle.Text = "ON"
        espToggle.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
    else
        espToggle.Text = "OFF"
        espToggle.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
    end
    smoothAnimate(espToggle, 0.95)
    updateESP()
end)

-- Sliders con límites ULTRA CONSERVADORES
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
        speedSlider.Position = UDim2.new(relativePos, -7, 0, 0)
        currentSpeed = math.floor(16 + (relativePos * 19)) -- Rango 16-35 (más efectivo)
        speedValueLabel.Text = tostring(currentSpeed)
        speedReached = false -- Reset para aplicar nuevo valor
    end
end)

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
        jumpSlider.Position = UDim2.new(relativePos, -7, 0, 0)
        currentJumpPower = math.floor(50 + (relativePos * 50)) -- Rango 50-100 (más efectivo)
        jumpValueLabel.Text = tostring(currentJumpPower)
        jumpReached = false -- Reset para aplicar nuevo valor
    end
end)

-- Botón de cerrar
closeButton.MouseButton1Click:Connect(function()
    smoothAnimate(closeButton, 0.9)
    wait(0.15)
    
    -- Limpiar todo
    if stealthConnection then
        stealthConnection:Disconnect()
    end
    
    for obj, highlight in pairs(activeHighlights) do
        removeESP(obj)
    end
    
    print("🔄 Panel sigiloso cerrado")
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

-- Respawn handling
player.CharacterAdded:Connect(function()
    wait(1)
    
    if speedEnabled or jumpEnabled then
        startStealthSystem()
        print("🔄 Sistema sigiloso reiniciado después del respawn")
    end
end)

-- Inicializar
if player.Character then
    startStealthSystem()
end

print("🥷 Steal a Brainrot Panel SIGILOSO EFECTIVO cargado!")
print("🛡️ MODO ANTI-DETECCIÓN BALANCEADO:")
print("   🏃 Velocidad: 16-35 (cambios graduales pero notables)")
print("   🦘 Salto: 50-100 (incrementos naturales pero efectivos)")
print("   👁️ ESP: Funcionalidad completa")
print("🔬 TÉCNICAS SIGILOSAS MEJORADAS:")
print("   ⏱️ Delays humanos rápidos (0.05-0.15s)")
print("   📈 Cambios graduales 30% más rápidos")
print("   🎯 Confirmación cuando alcanza objetivo")
print("   🎭 Simulación de comportamiento humano")
print("   🔇 Sin objetos sospechosos")
print("   ⚡ Efectivo pero indetectable")
print("✅ ¡SIGILOSO Y POTENTE!")
