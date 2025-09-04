local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Config por defecto
local DEFAULT_DISTANCE = 10        -- distancia por defecto si no hay hit
local MAX_RAY_DISTANCE = 500       -- máximo para raycast hacia abajo
local FLOOR_SIZE = Vector3.new(50, 1, 50)
local FLOOR_COLOR = Color3.fromRGB(50,50,50)
local FLOOR_TRANSPARENCY = 0.35

-- Crear Part visual (no colisionable)
local function createFloorPart()
    local p = Instance.new("Part")
    p.Name = "AutoFloorPreview"
    p.Size = FLOOR_SIZE
    p.Anchored = true
    p.CanCollide = false
    p.CanQuery = false
    p.CanTouch = false
    p.Transparency = FLOOR_TRANSPARENCY
    p.Material = Enum.Material.SmoothPlastic
    p.Color = FLOOR_COLOR
    p.CastShadow = false
    p.Parent = workspace
    return p
end

-- Crear UI simple
local function createGui()
    local screen = Instance.new("ScreenGui")
    screen.Name = "AutoFloorGui"
    screen.ResetOnSpawn = false
    screen.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 110)
    frame.Position = UDim2.new(0, 16, 0, 80)
    frame.BackgroundTransparency = 0.25
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.Parent = screen

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -12, 0, 28)
    title.Position = UDim2.new(0,6,0,6)
    title.BackgroundTransparency = 1
    title.Text = "AutoFloor"
    title.TextColor3 = Color3.fromRGB(235,235,235)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 100, 0, 28)
    toggleBtn.Position = UDim2.new(0,6,0,40)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    toggleBtn.TextColor3 = Color3.fromRGB(200,200,200)
    toggleBtn.Text = "Activar"
    toggleBtn.Font = Enum.Font.SourceSans
    toggleBtn.TextSize = 18
    toggleBtn.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 140, 0, 28)
    label.Position = UDim2.new(0,116,0,40)
    label.BackgroundTransparency = 1
    label.Text = "Distancia (studs):"
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local distBox = Instance.new("TextBox")
    distBox.Size = UDim2.new(0, 120, 0, 26)
    distBox.Position = UDim2.new(0,6,0,72)
    distBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
    distBox.TextColor3 = Color3.fromRGB(220,220,220)
    distBox.Text = tostring(DEFAULT_DISTANCE)
    distBox.ClearTextOnFocus = false
    distBox.Font = Enum.Font.SourceSans
    distBox.TextSize = 16
    distBox.Parent = frame

    return {
        Screen = screen,
        Toggle = toggleBtn,
        DistBox = distBox,
    }
end

-- Lógica principal
local gui = createGui()
local enabled = false
local desiredDistance = DEFAULT_DISTANCE
local floorPart = createFloorPart()
floorPart.Transparency = 1 -- oculto hasta activar

-- Safe parse number
local function parseNumber(txt, fallback)
    local n = tonumber(txt)
    if n and n > 0 then return n end
    return fallback
end

-- Actualizar posición de la plataforma:
local function updateFloor(character)
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Raycast hacia abajo
    local origin = hrp.Position
    local direction = Vector3.new(0, -MAX_RAY_DISTANCE, 0)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {character}
    rayParams.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        -- Si hay superficie, pon la plataforma sobre ella
        local hitPos = result.Position
        local y = hitPos.Y + (floorPart.Size.Y / 2) + 0.05
        floorPart.CFrame = CFrame.new(Vector3.new(origin.X, y, origin.Z))
    else
        -- No hay superficie: usa distancia deseada
        local y = origin.Y - desiredDistance
        floorPart.CFrame = CFrame.new(Vector3.new(origin.X, y, origin.Z))
    end
end

-- RenderStepped loop cuando está activo
local conn
local function setEnabled(state)
    enabled = state
    gui.Toggle.Text = enabled and "Desactivar" or "Activar"
    floorPart.Transparency = enabled and FLOOR_TRANSPARENCY or 1

    if conn then
        conn:Disconnect()
        conn = nil
    end

    if enabled then
        conn = RunService.RenderStepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                updateFloor(character)
            end
        end)
    end
end

-- Interacciones UI
gui.Toggle.MouseButton1Click:Connect(function()
    setEnabled(not enabled)
end)

gui.DistBox.FocusLost:Connect(function(enterPressed)
    local n = parseNumber(gui.DistBox.Text, desiredDistance)
    desiredDistance = n
    gui.DistBox.Text = tostring(desiredDistance)
end)

-- Hotkey (F) para alternar
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        setEnabled(not enabled)
    end
end)

-- Mantener plataforma en caso de respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    -- pequeña espera para HRP
    char:WaitForChild("HumanoidRootPart", 5)
    if enabled then
        -- fuerza una actualización inmediata
        updateFloor(char)
    end
end)

-- Estado inicial
setEnabled(false)
