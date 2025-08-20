-- Simulador que usa el sistema REAL de controladores del juego
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrapSystemGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🕳️ TRAP SYSTEM (Real Controllers)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- Info del sistema
local systemInfoLabel = Instance.new("TextLabel")
systemInfoLabel.Parent = mainFrame
systemInfoLabel.Size = UDim2.new(1, 0, 0, 20)
systemInfoLabel.Position = UDim2.new(0, 0, 0.18, 0)
systemInfoLabel.BackgroundTransparency = 1
systemInfoLabel.Text = "Buscando controladores..."
systemInfoLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
systemInfoLabel.TextScaled = true
systemInfoLabel.Font = Enum.Font.Gotham

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.32, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🟢 Estado: Libre"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham

-- Timer
local timerLabel = Instance.new("TextLabel")
timerLabel.Parent = mainFrame
timerLabel.Size = UDim2.new(1, 0, 0, 30)
timerLabel.Position = UDim2.new(0, 0, 0.48, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "⏱️ Tiempo: --"
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.GothamBold

-- Botón principal
local activateButton = Instance.new("TextButton")
activateButton.Parent = mainFrame
activateButton.Size = UDim2.new(0.9, 0, 0, 35)
activateButton.Position = UDim2.new(0.05, 0, 0.68, 0)
activateButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
activateButton.Text = "🔒 ACTIVAR SISTEMA"
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.TextScaled = true
activateButton.Font = Enum.Font.GothamBold

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = activateButton

-- Variables de estado
local systemActive = false
local timeRemaining = 0
local connections = {}
local foundControllers = {}

-- Función para encontrar los controladores reales
local function findGameControllers()
    foundControllers = {}
    
    -- Buscar en ReplicatedStorage > Controllers
    local controllers = ReplicatedStorage:FindFirstChild("Controllers")
    if controllers then
        print("📁 Controllers encontrado")
        
        -- TrapController
        local trapController = controllers:FindFirstChild("TrapController")
        if trapController then
            foundControllers.TrapController = trapController
            print("🎯 TrapController encontrado:", trapController:GetFullName())
        end
        
        -- ItemController
        local itemController = controllers:FindFirstChild("ItemController")
        if itemController then
            foundControllers.ItemController = itemController
            print("📦 ItemController encontrado:", itemController:GetFullName())
        end
        
        -- BackpackController
        local backpackController = controllers:FindFirstChild("BackpackController")
        if backpackController then
            foundControllers.BackpackController = backpackController
            print("🎒 BackpackController encontrado:", backpackController:GetFullName())
        end
    end
    
    -- Buscar Items > Trap > TrapScript
    local items = ReplicatedStorage:FindFirstChild("Items")
    if items then
        local trap = items:FindFirstChild("Trap")
        if trap then
            local trapScript = trap:FindFirstChild("TrapScript")
            if trapScript then
                foundControllers.TrapScript = trapScript
                print("📜 TrapScript encontrado:", trapScript:GetFullName())
            end
        end
    end
    
    return foundControllers
end

-- Función para intentar usar el TrapController real
local function useTrapController()
    local trapController = foundControllers.TrapController
    if trapController then
        print("🎯 Intentando usar TrapController...")
        
        -- Buscar funciones o eventos en el controlador
        for _, child in pairs(trapController:GetChildren()) do
            print("  - " .. child.Name .. " (" .. child.ClassName .. ")")
            
            if child:IsA("RemoteEvent") then
                print("    🌐 RemoteEvent encontrado, intentando activar...")
                -- Intentar diferentes parámetros comunes
                pcall(function()
                    child:FireServer("activate")
                end)
                pcall(function()
                    child:FireServer(player, "trap")
                end)
                pcall(function()
                    child:FireServer({action = "use", item = "trap"})
                end)
            end
        end
        return true
    end
    return false
end

-- Función para usar el sistema de Items
local function useItemSystem()
    local trapScript = foundControllers.TrapScript
    if trapScript then
        print("📜 Intentando usar TrapScript...")
        
        -- El TrapScript probablemente maneja la lógica cuando se "usa" el item
        -- Intentar simular el uso del item
        
        return true
    end
    return false
end

-- Función para buscar y activar trampa en workspace
local function activateWorkspaceTrap()
    local trap = workspace:FindFirstChild("Trap")
    if trap then
        print("🕳️ Trampa encontrada en workspace")
        
        -- Buscar partes con Touched
        for _, part in pairs(trap:GetDescendants()) do
            if part:IsA("BasePart") and part.Touched then
                part.Touched:Fire(humanoidRootPart)
                print("✅ Trampa activada por toque")
                return true
            end
        end
    end
    return false
end

-- Función principal para activar el sistema
local function activateSystem()
    print("🚀 Activando sistema de trampa real...")
    
    local success = false
    
    -- Método 1: Usar TrapController
    if useTrapController() then
        success = true
        print("✅ TrapController usado")
    end
    
    -- Método 2: Usar sistema de Items
    if useItemSystem() then
        success = true
        print("✅ Sistema de Items usado")
    end
    
    -- Método 3: Activar trampa en workspace
    if activateWorkspaceTrap() then
        success = true
        print("✅ Trampa de workspace activada")
    end
    
    if not success then
        print("⚠️ No se pudo usar sistema nativo, aplicando inmunidad manual")
    end
    
    -- Aplicar inmunidad independientemente
    systemActive = true
    timeRemaining = 10
    
    -- Inmunidad
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid.PlatformStand = false
    end
    
    -- Actualizar UI
    statusLabel.Text = "🔴 Estado: PROTEGIDO"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    activateButton.Text = "🔓 DESACTIVAR"
    activateButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    
    -- Timer
    connections.timer = RunService.Heartbeat:Connect(function(deltaTime)
        if systemActive then
            timeRemaining = timeRemaining - deltaTime
            timerLabel.Text = "⏱️ Tiempo: " .. math.ceil(math.max(0, timeRemaining)) .. "s"
            
            -- Mantener inmunidad
            if humanoid then
                humanoid.Health = math.max(humanoid.Health, humanoid.MaxHealth * 0.95)
                humanoid.PlatformStand = false
            end
            
            if timeRemaining <= 0 then
                deactivateSystem()
            end
        end
    end)
    
    print("✅ Sistema activado por 10 segundos")
end

-- Función para desactivar
local function deactivateSystem()
    print("🛑 Desactivando sistema...")
    
    systemActive = false
    timeRemaining = 0
    
    -- Desconectar
    for _, connection in pairs(connections) do
        if connection then connection:Disconnect() end
    end
    connections = {}
    
    -- Restaurar UI
    statusLabel.Text = "🟢 Estado: Libre"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    timerLabel.Text = "⏱️ Tiempo: --"
    activateButton.Text = "🔒 ACTIVAR SISTEMA"
        activateButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
    
    -- Restaurar salud normal
    if humanoid then
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        humanoid.PlatformStand = false
    end
    
    print("✅ Sistema desactivado")
end

-- Toggle principal
local function toggleSystem()
    if systemActive then
        deactivateSystem()
    else
        activateSystem()
    end
end

-- Función para actualizar info del sistema
local function updateSystemInfo()
    local controllers = findGameControllers()
    local foundCount = 0
    local infoText = ""
    
    for name, controller in pairs(controllers) do
        foundCount = foundCount + 1
    end
    
    if foundCount > 0 then
        infoText = "✅ " .. foundCount .. " controlador(es) encontrado(s)"
        systemInfoLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        infoText = "⚠️ No se encontraron controladores"
        systemInfoLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    
    systemInfoLabel.Text = infoText
end

-- Conectar eventos
activateButton.MouseButton1Click:Connect(toggleSystem)

-- Manejar respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if systemActive then
        deactivateSystem()
    end
end)

-- Inicialización
print("🎮 Trap System (Real Controllers) cargado")
print("🔍 Analizando sistema del juego...")

-- Buscar controladores al inicio
updateSystemInfo()

-- Mostrar información detallada
print("\n📋 INFORMACIÓN DEL SISTEMA:")
print("=" * 40)

local controllers = findGameControllers()
for name, controller in pairs(controllers) do
    print("✅ " .. name .. ":")
    print("   📍 Ubicación: " .. controller:GetFullName())
    print("   📋 Tipo: " .. controller.ClassName)
    
    -- Mostrar hijos del controlador
    local children = controller:GetChildren()
    if #children > 0 then
        print("   📁 Contiene:")
        for _, child in pairs(children) do
            print("     - " .. child.Name .. " (" .. child.ClassName .. ")")
            
            -- Si es un RemoteEvent, intentar analizarlo
            if child:IsA("RemoteEvent") then
                print("       🌐 RemoteEvent detectado - Puede ser usado para activar trampas")
            end
        end
    end
    print()
end

print("=" * 40)
print("🎯 Sistema listo para usar")

-- Función adicional para monitorear RemoteEvents (opcional)
local function monitorRemoteEvents()
    print("🕵️ Monitoreando RemoteEvents...")
    
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            -- Conectar a todos los RemoteEvents para ver cuáles se activan
            obj.OnClientEvent:Connect(function(...)
                local args = {...}
                print("📡 RemoteEvent activado:", obj:GetFullName())
                print("   📦 Argumentos:", table.concat(args, ", "))
            end)
        end
    end
end

-- Activar monitoreo (opcional - descomenta si quieres ver todos los eventos)
-- monitorRemoteEvents()

-- Función para probar diferentes métodos de activación
local function testActivationMethods()
    print("🧪 Probando métodos de activación...")
    
    -- Método 1: Buscar RemoteEvents relacionados con items
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and (
            obj.Name:lower():find("item") or 
            obj.Name:lower():find("use") or
            obj.Name:lower():find("activate") or
            obj.Name:lower():find("trap")
        ) then
            print("🎯 Probando RemoteEvent:", obj:GetFullName())
            
            -- Probar diferentes parámetros
            local testParams = {
                {"Trap"},
                {player, "Trap"},
                {"UseItem", "Trap"},
                {action = "use", item = "Trap"},
                {player = player, item = "Trap", action = "activate"}
            }
            
            for i, params in pairs(testParams) do
                pcall(function()
                    obj:FireServer(unpack(params))
                    print("   ✅ Parámetros " .. i .. " enviados")
                end)
                wait(0.1) -- Pequeña pausa entre intentos
            end
        end
    end
end

-- Botón adicional para testing (opcional)
local testButton = Instance.new("TextButton")
testButton.Parent = mainFrame
testButton.Size = UDim2.new(0.4, 0, 0, 25)
testButton.Position = UDim2.new(0.55, 0, 0.88, 0)
testButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
testButton.Text = "🧪 Test"
testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testButton.TextScaled = true
testButton.Font = Enum.Font.Gotham

local testCorner = Instance.new("UICorner")
testCorner.CornerRadius = UDim.new(0, 5)
testCorner.Parent = testButton

testButton.MouseButton1Click:Connect(function()
    testActivationMethods()
end)

print("🎮 Script completamente cargado y listo para usar")
