-- Panel Anti-Hit Pantalla Completa para Roblox
-- Advertencia: Usar scripts en Roblox puede resultar en baneos

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables del script
local antiHitEnabled = false
local originalPosition = nil
local connection = nil
local panelOpen = false

-- Crear la GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiHitFullPanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Botón flotante para abrir/cerrar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 20, 0.5, -30)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "☰"
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
centerFrame.Size = UDim2.new(0, 400, 0, 300)
centerFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
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
titleLabel.Text = "ANTI-HIT PANEL"
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

-- Botón principal Anti-Hit
local antiHitButton = Instance.new("TextButton")
antiHitButton.Size = UDim2.new(0.8, 0, 0, 80)
antiHitButton.Position = UDim2.new(0.1, 0, 0.2, 0)
antiHitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
antiHitButton.BorderSizePixel = 0
antiHitButton.Text = "ANTI-HIT: DESACTIVADO"
antiHitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
antiHitButton.TextScaled = true
antiHitButton.Font = Enum.Font.GothamBold
antiHitButton.Parent = contentFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = antiHitButton

-- Estado y descripción
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 40)
statusLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Desactivado"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = contentFrame

local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(0.8, 0, 0, 60)
descLabel.Position = UDim2.new(0.1, 0, 0.65, 0)
descLabel.BackgroundTransparency = 1
descLabel.Text = "Presiona el botón para activar/desactivar\nTecla rápida: F"
descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
descLabel.TextScaled = true
descLabel.Font = Enum.Font.Gotham
descLabel.Parent = contentFrame

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
            Size = UDim2.new(0, 400, 0, 300),
            Position = UDim2.new(0.5, -200, 0.5, -150)
        })
        tween:Play()
    else
        toggleButton.Text = "☰"
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

-- Función Anti-Hit
local function toggleAntiHit()
    antiHitEnabled = not antiHitEnabled
    
    if antiHitEnabled then
        -- Activar Anti-Hit
        antiHitButton.Text = "ANTI-HIT: ACTIVADO"
        antiHitButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        statusLabel.Text = "Estado: Activado - Protección activa"
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            originalPosition = player.Character.HumanoidRootPart.CFrame
            
            connection = RunService.Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and originalPosition then
                    local humanoidRootPart = player.Character.HumanoidRootPart
                    local currentPos = humanoidRootPart.CFrame
                    
                    -- Si la posición cambió drásticamente (posible hit), restaurar
                    local distance = (currentPos.Position - originalPosition.Position).Magnitude
                    if distance > 5 then
                        humanoidRootPart.CFrame = originalPosition
                    else
                        originalPosition = currentPos
                    end
                end
            end)
        end
    else
        -- Desactivar Anti-Hit
        antiHitButton.Text = "ANTI-HIT: DESACTIVADO"
        antiHitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        statusLabel.Text = "Estado: Desactivado"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

-- Conectar eventos
toggleButton.MouseButton1Click:Connect(togglePanel)
closeButton.MouseButton1Click:Connect(togglePanel)
antiHitButton.MouseButton1Click:Connect(toggleAntiHit)

-- Cerrar panel al hacer clic en el fondo
mainPanel.MouseButton1Click:Connect(function()
    if panelOpen then
        togglePanel()
    end
end)

-- Evitar que el clic en el centro frame cierre el panel
centerFrame.MouseButton1Click:Connect(function()
    -- No hacer nada, solo evitar que se propague el evento
end)

-- Animaciones de hover
antiHitButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(antiHitButton, TweenInfo.new(0.2), {Size = UDim2.new(0.85, 0, 0, 85)})
    tween:Play()
end)

antiHitButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(antiHitButton, TweenInfo.new(0.2), {Size = UDim2.new(0.8, 0, 0, 80)})
    tween:Play()
end)

toggleButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 65, 0, 65)})
    tween:Play()
end)

toggleButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)})
    tween:Play()
end)

-- Teclas rápidas
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F then
            toggleAntiHit()
        elseif input.KeyCode == Enum.KeyCode.Insert then
            togglePanel()
        end
    end
end)

print("Panel Anti-Hit cargado!")
print("- Botón flotante para abrir/cerrar panel")
print("- INSERT: Abrir/cerrar panel")
print("- F: Activar/desactivar Anti-Hit")
