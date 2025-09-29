-- Steal A Brainrot - Sakura Panel GUI for Roblox
-- Este script debe ir en StarterPlayerScripts o ejecutarse con loadstring

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SakuraBrainrotPanel"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame de fondo completo (cubre toda la pantalla incluyendo topbar)
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Name = "Background"
backgroundFrame.Size = UDim2.new(1, 0, 1, 36) -- +36 para cubrir el topbar
backgroundFrame.Position = UDim2.new(0, 0, 0, -36) -- -36 para empezar arriba del topbar
backgroundFrame.BackgroundColor3 = Color3.fromRGB(255, 238, 248)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.Parent = screenGui

-- Gradiente de fondo
local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 238, 248)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(248, 215, 218)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 179, 217)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(230, 179, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 197, 249))
}
backgroundGradient.Rotation = 135
backgroundGradient.Parent = backgroundFrame

-- Container para pétalos
local sakuraContainer = Instance.new("Frame")
sakuraContainer.Name = "SakuraContainer"
sakuraContainer.Size = UDim2.new(1, 0, 1, 0)
sakuraContainer.Position = UDim2.new(0, 0, 0, 0)
sakuraContainer.BackgroundTransparency = 1
sakuraContainer.Parent = backgroundFrame

-- Panel principal
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 450, 0, 400)
mainPanel.Position = UDim2.new(0.5, -225, 0.5, -200)
mainPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainPanel.BackgroundTransparency = 0.85
mainPanel.BorderSizePixel = 0
mainPanel.Parent = screenGui

-- Corner radius para el panel
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 25)
panelCorner.Parent = mainPanel

-- Borde brillante del panel
local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(255, 105, 180)
panelStroke.Thickness = 2
panelStroke.Transparency = 0.7
panelStroke.Parent = mainPanel

-- Efecto de brillo en el borde
local strokeTween = TweenService:Create(panelStroke, 
    TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Transparency = 0.2}
)
strokeTween:Play()

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Steal A brainrot"
titleLabel.TextColor3 = Color3.fromRGB(255, 20, 147)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainPanel

-- Gradiente del título
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(218, 112, 214)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 105, 180))
}
titleGradient.Rotation = 45
titleGradient.Parent = titleLabel

-- Subtítulo
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(1, -40, 0, 25)
subtitleLabel.Position = UDim2.new(0, 20, 0, 85)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "FREEMIUM - PREMIUM PANEL"
subtitleLabel.TextColor3 = Color3.fromRGB(139, 90, 140)
subtitleLabel.TextScaled = true
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Parent = mainPanel

-- Label del input
local inputLabel = Instance.new("TextLabel")
inputLabel.Name = "InputLabel"
inputLabel.Size = UDim2.new(1, -40, 0, 20)
inputLabel.Position = UDim2.new(0, 20, 0, 140)
inputLabel.BackgroundTransparency = 1
inputLabel.Text = "🔑 Submit Key"
inputLabel.TextColor3 = Color3.fromRGB(139, 90, 140)
inputLabel.TextScaled = true
inputLabel.Font = Enum.Font.GothamMedium
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Parent = mainPanel

-- Input de la clave
local keyInput = Instance.new("TextBox")
keyInput.Name = "KeyInput"
keyInput.Size = UDim2.new(1, -40, 0, 50)
keyInput.Position = UDim2.new(0, 20, 0, 170)
keyInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keyInput.BackgroundTransparency = 0.1
keyInput.BorderSizePixel = 0
keyInput.Text = ""
keyInput.PlaceholderText = "Sorpréndeme con tu clave mágica..."
keyInput.TextColor3 = Color3.fromRGB(139, 90, 140)
keyInput.PlaceholderColor3 = Color3.fromRGB(216, 167, 216)
keyInput.TextScaled = true
keyInput.Font = Enum.Font.Gotham
keyInput.Parent = mainPanel

-- Corner radius para el input
local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 15)
inputCorner.Parent = keyInput

-- Padding del input
local inputPadding = Instance.new("UIPadding")
inputPadding.PaddingLeft = UDim.new(0, 15)
inputPadding.PaddingRight = UDim.new(0, 15)
inputPadding.Parent = keyInput

-- Botón Submit
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(1, -40, 0, 55)
submitButton.Position = UDim2.new(0, 20, 0, 250)
submitButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
submitButton.BorderSizePixel = 0
submitButton.Text = "🌸 SUBMIT KEY 🌸"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextScaled = true
submitButton.Font = Enum.Font.GothamBold
submitButton.Parent = mainPanel

-- Corner radius para el botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 15)
buttonCorner.Parent = submitButton

-- Gradiente del botón
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(218, 112, 214)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 105, 180))
}
buttonGradient.Rotation = 135
buttonGradient.Parent = submitButton

-- Mensaje de éxito
local successMessage = Instance.new("Frame")
successMessage.Name = "SuccessMessage"
successMessage.Size = UDim2.new(0, 350, 0, 80)
successMessage.Position = UDim2.new(0.5, -175, 0.5, -40)
successMessage.BackgroundColor3 = Color3.fromRGB(152, 251, 152)
successMessage.BorderSizePixel = 0
successMessage.Visible = false
successMessage.Parent = screenGui

local successCorner = Instance.new("UICorner")
successCorner.CornerRadius = UDim.new(0, 20)
successCorner.Parent = successMessage

local successLabel = Instance.new("TextLabel")
successLabel.Size = UDim2.new(1, 0, 1, 0)
successLabel.BackgroundTransparency = 1
successLabel.Text = "🎉 ¡Clave activada con éxito! 🌸"
successLabel.TextColor3 = Color3.fromRGB(45, 90, 45)
successLabel.TextScaled = true
successLabel.Font = Enum.Font.GothamBold
successLabel.Parent = successMessage

-- Función para crear pétalos de sakura
local function createSakuraPetal()
    local petal = Instance.new("Frame")
    petal.Name = "SakuraPetal"
    petal.Size = UDim2.new(0, 12, 0, 12)
    petal.Position = UDim2.new(math.random(), 0, 0, -20)
    petal.BackgroundColor3 = Color3.fromRGB(255, 179, 217)
    petal.BorderSizePixel = 0
    petal.Parent = sakuraContainer
    
    -- Corner para hacer el pétalo redondeado
    local petalCorner = Instance.new("UICorner")
    petalCorner.CornerRadius = UDim.new(0.5, 0)
    petalCorner.Parent = petal
    
    -- Colores aleatorios para los pétalos
    local colors = {
        Color3.fromRGB(255, 179, 217),
        Color3.fromRGB(255, 192, 203),
        Color3.fromRGB(221, 160, 221),
        Color3.fromRGB(240, 230, 140)
    }
    petal.BackgroundColor3 = colors[math.random(1, #colors)]
    
    -- Animación de caída
    local fallTween = TweenService:Create(petal,
        TweenInfo.new(math.random(5, 13), Enum.EasingStyle.Linear),
        {
            Position = UDim2.new(petal.Position.X.Scale + math.random(-20, 20)/100, 0, 1.2, 0),
            Rotation = math.random(0, 360),
            BackgroundTransparency = 1
        }
    )
    fallTween:Play()
    
    -- Eliminar pétalo después de la animación
    fallTween.Completed:Connect(function()
        petal:Destroy()
    end)
end

-- Función para crear efectos especiales
local function createSpecialEffect()
    for i = 1, 20 do
        task.wait(0.05)
        createSakuraPetal()
    end
    
    -- Efecto de brillo en el fondo
    local brightTween = TweenService:Create(backgroundFrame,
        TweenInfo.new(1, Enum.EasingStyle.Sine),
        {BackgroundColor3 = Color3.fromRGB(255, 240, 248)}
    )
    brightTween:Play()
    
    brightTween.Completed:Connect(function()
        local normalTween = TweenService:Create(backgroundFrame,
            TweenInfo.new(1, Enum.EasingStyle.Sine),
            {BackgroundColor3 = Color3.fromRGB(255, 238, 248)}
        )
        normalTween:Play()
    end)
end

-- Animación flotante del panel
local function animatePanel()
    local floatTween = TweenService:Create(mainPanel,
        TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(0.5, -225, 0.5, -210)}
    )
    floatTween:Play()
end

-- Generar pétalos continuamente
local petalConnection
petalConnection = RunService.Heartbeat:Connect(function()
    if math.random() > 0.97 then -- Probabilidad baja para no saturar
        createSakuraPetal()
    end
end)

-- Efectos del input
keyInput.Focused:Connect(function()
    local focusTween = TweenService:Create(keyInput,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -30, 0, 55)}
    )
    focusTween:Play()
end)

keyInput.FocusLost:Connect(function()
    local unfocusTween = TweenService:Create(keyInput,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {Size = UDim2.new(1, -40, 0, 50)}
    )
    unfocusTween:Play()
end)

-- Efectos del botón
submitButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(submitButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {
            Size = UDim2.new(1, -30, 0, 60),
            BackgroundColor3 = Color3.fromRGB(255, 0, 128)
        }
    )
    hoverTween:Play()
end)

submitButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(submitButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Back),
        {
            Size = UDim2.new(1, -40, 0, 55),
            BackgroundColor3 = Color3.fromRGB(255, 20, 147)
        }
    )
    leaveTween:Play()
end)

-- Función del botón submit
submitButton.MouseButton1Click:Connect(function()
    local key = keyInput.Text:match("^%s*(.-)%s*$") -- Trim whitespace
    
    if key and key ~= "" then
        -- Efecto de click
        local clickTween = TweenService:Create(submitButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Back),
            {Size = UDim2.new(1, -50, 0, 50)}
        )
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            local releaseTween = TweenService:Create(submitButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Back),
                {Size = UDim2.new(1, -40, 0, 55)}
            )
            releaseTween:Play()
        end)
        
        -- Crear efecto especial
        createSpecialEffect()
        
        -- Mostrar mensaje de éxito
        successMessage.Visible = true
        successMessage.Size = UDim2.new(0, 0, 0, 0)
        
        local showTween = TweenService:Create(successMessage,
            TweenInfo.new(0.5, Enum.EasingStyle.Back),
            {Size = UDim2.new(0, 350, 0, 80)}
        )
        showTween:Play()
        
        -- Limpiar input
        task.wait(0.3)
        keyInput.Text = ""
        keyInput.PlaceholderText = '"' .. key .. '" - ¡Clave registrada! ✨'
        
        -- Ocultar mensaje después de 3 segundos
        task.wait(3)
        local hideTween = TweenService:Create(successMessage,
            TweenInfo.new(0.5, Enum.EasingStyle.Back),
            {Size = UDim2.new(0, 0, 0, 0)}
        )
        hideTween:Play()
        
        hideTween.Completed:Connect(function()
            successMessage.Visible = false
            keyInput.PlaceholderText = "Sorpréndeme con tu clave mágica..."
        end)
        
        -- Log de la clave (puedes cambiar esto por tu lógica)
        print("🌸 Clave enviada:", key)
        
        -- Aquí puedes agregar tu lógica para manejar la clave
        -- Por ejemplo: enviar a un webhook, validar, etc.
    end
end)

-- Iniciar animaciones
animatePanel()

-- Crear pétalos iniciales
for i = 1, 15 do
    task.wait(0.2)
    createSakuraPetal()
end

-- Función para limpiar la GUI (opcional)
local function cleanup()
    if petalConnection then
        petalConnection:Disconnect()
    end
    screenGui:Destroy()
end

-- Retornar tabla con funciones útiles
return {
    GUI = screenGui,
    Cleanup = cleanup,
    CreatePetal = createSakuraPetal,
    SpecialEffect = createSpecialEffect
}
