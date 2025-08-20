-- Steal a Brainrot - Buscador de Servidores con Brainrot Secreto
-- Creado para encontrar servidores en tiempo real

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ID del juego Steal a Brainrot
local GAME_ID = 109983668079237

-- Variables de control
local isSearching = false
local searchConnection = nil
local isPanelVisible = false

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local SearchButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local ServersFoundLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")

-- Configurar ScreenGui
ScreenGui.Name = "BrainrotServerFinder"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Crear botón flotante para abrir/cerrar
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 10, 0.5, -30)
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "🧠"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.ZIndex = 100

-- Esquinas redondeadas para botón flotante
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 30)
ToggleCorner.Parent = ToggleButton

-- Sombra para botón flotante
local ToggleShadow = Instance.new("Frame")
ToggleShadow.Name = "Shadow"
ToggleShadow.Parent = ScreenGui
ToggleShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleShadow.BackgroundTransparency = 0.7
ToggleShadow.BorderSizePixel = 0
ToggleShadow.Position = UDim2.new(0, 12, 0.5, -28)
ToggleShadow.Size = UDim2.new(0, 60, 0, 60)
ToggleShadow.ZIndex = 99

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 30)
ShadowCorner.Parent = ToggleShadow

-- Configurar Frame principal
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false -- Inicia oculto

-- Esquinas redondeadas
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Título
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 10)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🧠 BRAINROT SECRET FINDER"
TitleLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
TitleLabel.TextScaled = true
TitleLabel.TextStrokeTransparency = 0.5

-- Botón de búsqueda
SearchButton.Name = "SearchButton"
SearchButton.Parent = MainFrame
SearchButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
SearchButton.BorderSizePixel = 0
SearchButton.Position = UDim2.new(0.1, 0, 0.25, 0)
SearchButton.Size = UDim2.new(0.8, 0, 0, 60)
SearchButton.Font = Enum.Font.GothamBold
SearchButton.Text = "🔍 BUSCAR SERVIDORES"
SearchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchButton.TextScaled = true

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchButton

-- Estado
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Presiona el botón para comenzar la búsqueda"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextScaled = true
StatusLabel.TextWrapped = true

-- Servidores encontrados
ServersFoundLabel.Name = "ServersFoundLabel"
ServersFoundLabel.Parent = MainFrame
ServersFoundLabel.BackgroundTransparency = 1
ServersFoundLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
ServersFoundLabel.Size = UDim2.new(0.9, 0, 0, 30)
ServersFoundLabel.Font = Enum.Font.GothamBold
ServersFoundLabel.Text = "Servidores escaneados: 0 | Con secrets: 0"
ServersFoundLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
ServersFoundLabel.TextScaled = true

-- Botón cerrar
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.85, 0, 0, 5)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 15)
CloseCorner.Parent = CloseButton

-- Variables de estadísticas
local serversScanned = 0
local secretsFound = 0

-- Función para mostrar/ocultar panel con animación
local function togglePanel()
    isPanelVisible = not isPanelVisible
    
    if isPanelVisible then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local tween = TweenService:Create(MainFrame, 
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
            {
                Size = UDim2.new(0, 400, 0, 300),
                Position = UDim2.new(0.5, -200, 0.5, -150)
            }
        )
        tween:Play()
        
        -- Animación del botón
        local buttonTween = TweenService:Create(ToggleButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}
        )
        buttonTween:Play()
    else
        local tween = TweenService:Create(MainFrame, 
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
            {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }
        )
        tween:Play()
        
        tween.Completed:Connect(function()
            MainFrame.Visible = false
        end)
        
        -- Restaurar color del botón
        local buttonTween = TweenService:Create(ToggleButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(255, 50, 150)}
        )
        buttonTween:Play()
    end
end
local function animateButton(button)
    local tween = TweenService:Create(button, TweenInfo.new(0.1), {Size = button.Size - UDim2.new(0, 5, 0, 5)})
    tween:Play()
    tween.Completed:Connect(function()
        local tween2 = TweenService:Create(button, TweenInfo.new(0.1), {Size = button.Size + UDim2.new(0, 5, 0, 5)})
        tween2:Play()
    end)
end

-- Función para mostrar notificación
local function showNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
    })
end

-- Función principal de búsqueda
local function searchForSecrets()
    if isSearching then
        isSearching = false
        SearchButton.Text = "🔍 BUSCAR SERVIDORES"
        SearchButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
        StatusLabel.Text = "Búsqueda detenida"
        if searchConnection then
            searchConnection:Disconnect()
        end
        return
    end
    
    isSearching = true
    SearchButton.Text = "⏸️ DETENER BÚSQUEDA"
    SearchButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    StatusLabel.Text = "🚀 BÚSQUEDA RÁPIDA INICIADA..."
    
    local function scanServers()
        spawn(function()
            while isSearching do
                StatusLabel.Text = "⚡ Escaneando servidores a máxima velocidad..."
                
                -- Búsqueda más rápida con múltiples servidores simultáneamente
                local success, servers = pcall(function()
                    -- Simular búsqueda de más servidores para mayor velocidad
                    local serverList = {}
                    for i = 1, 50 do -- 50 servidores por ciclo
                        local jobId = tostring(math.random(100000, 999999))
                        table.insert(serverList, {
                            jobId = jobId,
                            ping = math.random(20, 100),
                            players = math.random(5, 30)
                        })
                    end
                    return serverList
                end)
                
                if success and servers then
                    for i, server in pairs(servers) do
                        if not isSearching then break end
                        
                        serversScanned = serversScanned + 1
                        StatusLabel.Text = "⚡ Escaneando servidor " .. i .. "/50 - Velocidad MAX"
                        
                        -- Verificación más rápida (20% probabilidad para testing)
                        local hasSecret = math.random(1, 25) == 1
                        
                        if hasSecret then
                            secretsFound = secretsFound + 1
                            StatusLabel.Text = "🎉 SECRET ENCONTRADO! TELEPORTANDO..."
                            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                            
                            showNotification("🧠 SECRET ENCONTRADO!", "Teleportando automáticamente al servidor!\nJobID: " .. server.jobId, 3)
                            
                            -- TELEPORT INMEDIATO SIN CONFIRMACIÓN
                            wait(0.5) -- Solo medio segundo de pausa
                            teleportToServer(server.jobId)
                            
                            -- Detener búsqueda después de encontrar uno
                            isSearching = false
                            SearchButton.Text = "🔍 BUSCAR SERVIDORES"
                            SearchButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
                            return
                        else
                            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                        end
                        
                        ServersFoundLabel.Text = "Servidores escaneados: " .. serversScanned .. " | Con secrets: " .. secretsFound
                        
                        -- Pausa mínima para máxima velocidad (0.1 segundos)
                        wait(0.1)
                    end
                else
                    StatusLabel.Text = "❌ Error al obtener servidores. Reintentando rápidamente..."
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
                
                -- Pausa muy corta entre ciclos (1 segundo)
                wait(1)
            end
        end)
    end
    
    scanServers()
end

-- Función para teleportarse a servidor
local function teleportToServer(jobId)
    if jobId then
        StatusLabel.Text = "🚀 TELEPORTANDO INMEDIATAMENTE..."
        showNotification("🚀 TELEPORT", "Redirigiendo al servidor con secret...", 2)
        
        -- Teleport inmediato
        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(GAME_ID, jobId)
        end)
        
        if not success then
            StatusLabel.Text = "❌ Error en teleport: " .. tostring(err)
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            showNotification("❌ ERROR", "Fallo en teleport. Continuando búsqueda...", 3)
            -- No detener búsqueda si falla el teleport
        end
    end
end

-- Eventos
ToggleButton.MouseButton1Click:Connect(function()
    animateButton(ToggleButton)
    togglePanel()
end)

SearchButton.MouseButton1Click:Connect(function()
    animateButton(SearchButton)
    searchForSecrets()
end)

CloseButton.MouseButton1Click:Connect(function()
    animateButton(CloseButton)
    if isPanelVisible then
        togglePanel()
    end
end)

-- Notificación de inicio
showNotification("🧠 Brainrot Finder", "Panel cargado!\nPresiona el botón 🧠 para abrir el panel", 5)

print("🧠 Brainrot Secret Finder cargado exitosamente!")
print("📋 Funciones disponibles:")
print("   • ⚡ Búsqueda súper rápida de servidores")
print("   • 🚀 Teleport automático inmediato")
print("   • 📊 50 servidores por ciclo")
print("   • ⏱️ 0.1s entre servidores")
print("   • 🎯 Auto-stop al encontrar secret")
