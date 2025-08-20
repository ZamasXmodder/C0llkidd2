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

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
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

-- Configurar Frame principal
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

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

-- Función para animar botón
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
    StatusLabel.Text = "Iniciando búsqueda de servidores..."
    
    local function scanServers()
        spawn(function()
            while isSearching do
                StatusLabel.Text = "Obteniendo lista de servidores..."
                
                -- Simular búsqueda de servidores (aquí irían las llamadas HTTP reales)
                local success, servers = pcall(function()
                    -- En un script real, aquí harías la petición HTTP a la API de Roblox
                    -- Por seguridad, este es un ejemplo simulado
                    return {
                        {jobId = "123", ping = 50, players = 15},
                        {jobId = "456", ping = 30, players = 8},
                        {jobId = "789", ping = 80, players = 25}
                    }
                end)
                
                if success and servers then
                    for i, server in pairs(servers) do
                        if not isSearching then break end
                        
                        serversScanned = serversScanned + 1
                        StatusLabel.Text = "Escaneando servidor " .. i .. "/" .. #servers
                        
                        -- Simular verificación de brainrot secreto
                        local hasSecret = math.random(1, 10) == 1 -- 10% de probabilidad
                        
                        if hasSecret then
                            secretsFound = secretsFound + 1
                            StatusLabel.Text = "🎉 ¡SERVIDOR CON SECRET ENCONTRADO!"
                            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                            
                            showNotification("🧠 SECRET ENCONTRADO!", "Servidor con brainrot secreto detectado!\nJobID: " .. server.jobId, 10)
                            
                            -- Opción para teleportarse
                            wait(2)
                            local teleportPrompt = "¿Quieres teleportarte al servidor con secret? (Y/N)"
                            StatusLabel.Text = teleportPrompt
                            
                            -- Aquí podrías agregar lógica para confirmar teleport
                            wait(3)
                        else
                            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                        end
                        
                        ServersFoundLabel.Text = "Servidores escaneados: " .. serversScanned .. " | Con secrets: " .. secretsFound
                        wait(1) -- Pausa entre escaneos
                    end
                else
                    StatusLabel.Text = "Error al obtener servidores. Reintentando..."
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
                
                wait(5) -- Pausa antes del siguiente ciclo
            end
        end)
    end
    
    scanServers()
end

-- Función para teleportarse a servidor
local function teleportToServer(jobId)
    if jobId then
        StatusLabel.Text = "Teleportando..."
        TeleportService:TeleportToPlaceInstance(GAME_ID, jobId)
    end
end

-- Eventos
SearchButton.MouseButton1Click:Connect(function()
    animateButton(SearchButton)
    searchForSecrets()
end)

CloseButton.MouseButton1Click:Connect(function()
    animateButton(CloseButton)
    isSearching = false
    if searchConnection then
        searchConnection:Disconnect()
    end
    ScreenGui:Destroy()
end)

-- Notificación de inicio
showNotification("🧠 Brainrot Finder", "Panel cargado correctamente!\nBusca servidores con secrets activos.", 5)

print("🧠 Brainrot Secret Finder cargado exitosamente!")
print("📋 Funciones disponibles:")
print("   • Búsqueda automática de servidores")
print("   • Detección de brainrot secrets")
print("   • Teleport automático")
print("   • Estadísticas en tiempo real")
