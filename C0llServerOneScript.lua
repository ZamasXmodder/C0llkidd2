-- 🥚 Grow a Garden Egg ESP Panel GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local espEnabled = false
local connection = nil
local espObjects = {}

-- 🧠 Buscar nombre de la mascota si existe
local function getPetName(egg)
	for _, v in pairs(egg:GetDescendants()) do
		if v:IsA("StringValue") and (v.Name == "Pet" or v.Name == "PetName" or v.Name == "Animal") then
			return v.Value
		end
	end
	local attr = egg:GetAttribute("Pet") or egg:GetAttribute("PetName") or egg:GetAttribute("Animal")
	if attr then return attr end
	if egg.Name:lower():find("egg") then return "?" end
	return nil
end

-- 🎯 Crear ESP sobre el huevo
local function createESP(egg)
	if espObjects[egg] then return end
	local petName = getPetName(egg)
	if not petName then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "EggESP"
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = egg

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = "🐣 " .. petName
	text.TextColor3 = Color3.fromRGB(255, 255, 0)
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold
	text.Parent = billboard

	espObjects[egg] = billboard
end

-- 🔁 Detectar huevos
local function updateESP()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
			createESP(obj)
		end
	end

	-- Limpiar huevos eliminados
	for egg, gui in pairs(espObjects) do
		if not egg or not egg:IsDescendantOf(workspace) then
			if gui then gui:Destroy() end
			espObjects[egg] = nil
		end
	end
end

-- ✅ Iniciar ESP
local function startESP()
	if not connection then
		connection = RunService.Heartbeat:Connect(updateESP)
	end
end

-- ⛔ Detener ESP
local function stopESP()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	for egg, gui in pairs(espObjects) do
		if gui then gui:Destroy() end
	end
	espObjects = {}
end

-- 📦 Crear GUI
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "EggESP_GUI"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 70)
mainFrame.Position = UDim2.new(0, 20, 0.5, -35)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.9, 0, 0.6, 0)
toggle.Position = UDim2.new(0.05, 0, 0.2, 0)
toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggle.Text = "Egg ESP: OFF"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBold
toggle.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 4)
toggleCorner.Parent = toggle

-- 🎛️ Botón flotante para abrir/ocultar el panel
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 100, 0, 35)
openButton.Position = UDim2.new(0, 10, 0.5, -17)
openButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openButton.Text = "🥚 ESP"
openButton.TextColor3 = Color3.new(1,1,1)
openButton.TextScaled = true
openButton.Font = Enum.Font.GothamBold
openButton.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 6)
openCorner.Parent = openButton

-- 🔘 Toggle Panel
openButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- 🔘 Toggle ESP
toggle.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	toggle.Text = "Egg ESP: " .. (espEnabled and "ON" or "OFF")
	toggle.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)

	if espEnabled then
		startESP()
	else
		stopESP()
	end
end)

print("✅ Panel ESP de huevos cargado.")
