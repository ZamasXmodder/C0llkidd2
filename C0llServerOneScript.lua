-- Panel Invisibilidad Anti-Hit para Roblox
-- Advertencia: Usar scripts en Roblox puede resultar en baneos

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables del script
local invisibilityEnabled = false
local originalTransparencies = {}
local panelOpen = false

-- Crear la GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InvisibilityPanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Botón flotante para abrir/cerrar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 20, 0.5, -30)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "👁"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 30)
toggleCorner.Parent = toggleButton

-- Panel principal (pantalla completa)
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(1, 0, 1, 0)
mainPanel.Position = UDim2.new(0, 0, 0, 0)
mainPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainPanel.BackgroundTransparency = 0.3
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Parent = screenGui

-- Contenedor central del panel
local centerFrame = Instance.new("Frame")
centerFrame.Size = UDim2.new(0, 450, 0, 350)
centerFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
centerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
centerFrame.BorderSizePixel = 0
centerFrame.Parent = mainPanel

local centerCorner = Instance.new("UICorner")
centerCorner.CornerRadius = UDim.new(0, 15)
centerCorner.Parent = centerFrame

-- Barra superior del panel
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 60)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
topBar.BorderSizePixel = 0
topBar.Parent = centerFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 15)
topCorner.Parent = topBar

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Position = UDim2.new(0.1, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "INVISIBILIDAD ANTI-HIT"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = topBar

-- Botón cerrar (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 20)
closeCorner.Parent = closeButton

-- Contenido del panel
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -40, 1, -100)
contentFrame.Position = UDim2.new(0, 20, 0, 80)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = centerFrame

-- Botón principal Invisibilidad
local invisButton = Instance.new("TextButton")
invisButton.Size = UDim2.new(0.8, 0, 0, 80)
invisButton.Position = UDim2.new(0.1, 0, 0.1, 0)
invisButton.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
invisButton.BorderSizePixel = 0
invisButton.Text = "INVISIBILIDAD: OFF"
invisButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisButton.TextScaled = true
invisButton.Font = Enum.Font.GothamBold
invisButton.Parent = contentFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = invisButton

-- Estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 40)
statusLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Visible"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = contentFrame

-- Descripción
local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(0.8, 0, 0, 80)
descLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
descLabel.BackgroundTransparency = 1
descLabel.Text = "Te vuelve invisible pero mantiene el HumanoidRootPart\nvisible para evitar golpes\n\nTecla rápida: V"
descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
descLabel.TextScaled = true
descLabel.Font = Enum.Font.Gotham
descLabel.Parent = contentFrame

-- Función para guardar transparencias originales
local function saveOriginalTransparencies(character)
    originalTransparencies = {}
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            originalTransparencies[part] = part.Transparency
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                originalTransparencies[handle] = handle.Transparency
            end
        end
    end
end

-- Función para hacer invisible (excepto HumanoidRootPart)
local function makeInvisible(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 1
            -- Ocultar decals/textures
            for _, child in pairs(part:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 1
                end
            end
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 1
                for _, child in pairs(handle:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SpecialMesh") then
                        if child:IsA("SpecialMesh") then
                            child.TextureId = ""
                        else
                            child.Transparency = 1
                        end
                    end
                end
            end
        end
    end
    
    -- Hacer visible solo el HumanoidRootPart (como un cuadrado)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.Transparency = 0.5 -- Semi-transparente para que se vea
        humanoidRootPart.BrickColor = BrickColor.new("Bright red") -- Color rojo para identificarlo
    end
end

-- Función para restaurar visibilidad
local function makeVisible(character)
    for part, transparency in pairs(originalTransparencies) do
        if part and part.Parent then
            part.Transparency = transparency
            -- Restaurar decals/textures
            for _, child in pairs(part:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 0
                end
            end
        end
    end
    
    -- Restaurar HumanoidRootPart
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.Transparency = 1 -- Volver a ser invisible
        humanoidRootPart.BrickColor = BrickColor.new("Medium stone grey") -- Color original
    end
end

-- Función principal de invisibilidad
local function toggleInvisibility()
    if not player.Character then return end
    
    invisibilityEnabled = not invisibilityEnabled
    
    if invisibilityEnabled then
        -- Activar invisibilidad
        invisButton.Text = "INVISIBILIDAD: ON"
        invisButton.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
        statusLabel.Text = "Estado: Invisible (Solo HumanoidRootPart visible)"
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
        
        saveOriginalTransparencies(player.Character)
        makeInvisible(player.Character)
        
    else
        -- Desactivar invisibilidad
        invisButton.Text = "INVISIBILIDAD: OFF"
        invisButton.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
        statusLabel.Text = "Estado: Visible"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        makeVisible(player.Character)
    end
end

-- Función para abrir/cerrar panel
local function togglePanel()
    panelOpen = not panelOpen
    
    if panelOpen then
        mainPanel.Visible = true
        toggleButton.Text = "✕"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Animación de entrada
        centerFrame.Size = UDim2.new(0, 0, 0, 0)
        centerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local tween = TweenService:Create(centerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 450, 0, 350),
            Position = UDim2.new(0.5, -225, 0.5, -175)
        })
        tween:Play()
    else
        toggleButton.Text = "👁"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        -- Animación de salida
        local tween = TweenService:Create(centerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            mainPanel.Visible = false
        end)
    end
end

-- Auto-aplicar invisibilidad cuando respawneas
player.CharacterAdded:Connect(function(character)
    if invisibilityEnabled then
        character:WaitForChild("HumanoidRootPart")
        wait(0.1) -- Esperar un poco para que cargue todo
        saveOriginalTransparencies(character)
        makeInvisible(character)
    end
end)

-- Conectar eventos
toggleButton.MouseButton1Click:Connect(togglePanel)
closeButton.MouseButton1Click:Connect(togglePanel)
invisButton.MouseButton1Click:Connect(toggleInvisibility)

-- Cerrar panel al hacer clic en el fondo
mainPanel.MouseButton1Click:Connect(function()
    if panelOpen then
        togglePanel()
    end
end)

-- Evitar que el clic en el centro frame cierre el panel
centerFrame.MouseButton1Click:Connect(function()
    -- No hacer nada
end)

-- Animaciones de hover
invisButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(invisButton, TweenInfo.new(0.2), {Size = UDim2.new(0.85, 0, 0, 85)})
    tween:Play()
end)

invisButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(invisButton, TweenInfo.new(0.2), {Size = UDim2.new(0.8, 0, 0, 80)})
    tween:Play()
end)

-- Teclas rápidas
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.V then
            toggleInvisibility()
        elseif input.KeyCode == Enum.KeyCode.Insert then
            togglePanel()
        end
    end
end)

print("Panel Invisibilidad Anti-Hit cargado!")
print("- INSERT: Abrir/cerrar panel")
print("- V: Activar/desactivar invisibilidad")
print("- Solo el HumanoidRootPart será visible como un cuadrado rojo")
print("- Automáticamente se aplica al respawnear si está activado")
