-- Grow a Garden SMART ESP - Información útil real

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local eggESPs = {}
local espEnabled = false
local connection = nil
local updateCounter = 0

-- Función para crear GUI simple
local function createGUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SmartEggESP"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Botón principal
	local mainButton = Instance.new("TextButton")
	mainButton.Size = UDim2.new(0, 120, 0, 40)
	mainButton.Position = UDim2.new(0, 10, 0.5, -20)
	mainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	mainButton.BorderSizePixel = 0
	mainButton.Text = "SMART ESP"
	mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	mainButton.TextScaled = true
	mainButton.Font = Enum.Font.GothamBold
	mainButton.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = mainButton

	-- Toggle ESP
	mainButton.MouseButton1Click:Connect(function()
		espEnabled = not espEnabled

		if espEnabled then
			mainButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
			mainButton.Text = "ESP ON"
			startSmartESP()
		else
			mainButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
			mainButton.Text = "ESP OFF"
			stopSmartESP()
		end
	end)

	return screenGui
end

-- Función para obtener información REAL del huevo
local function getSmartEggInfo(egg)
	local info = {
		eggType = "Unknown",
		isReady = false,
		timeLeft = nil,
		rarity = "Common",
		status = "Incubating"
	}

	pcall(function()
		-- Determinar tipo por nombre
		local eggName = egg.Name:lower()
		if eggName:find("paradise") then 
			info.eggType = "Paradise"
			info.rarity = "Legendary"
		elseif eggName:find("crystal") then 
			info.eggType = "Crystal"
			info.rarity = "Epic"
		elseif eggName:find("golden") then 
			info.eggType = "Golden"
			info.rarity = "Rare"
		elseif eggName:find("volcano") then 
			info.eggType = "Volcano"
			info.rarity = "Epic"
		elseif eggName:find("ocean") then 
			info.eggType = "Ocean"
			info.rarity = "Uncommon"
		elseif eggName:find("forest") then 
			info.eggType = "Forest"
			info.rarity = "Common"
		elseif eggName:find("desert") then 
			info.eggType = "Desert"
			info.rarity = "Uncommon"
		end

		-- Buscar tiempo de incubación
		for _, child in pairs(egg:GetDescendants()) do
			if child:IsA("NumberValue") then
				if child.Name:lower():find("time") or child.Name:lower():find("hatch") then
					info.timeLeft = child.Value
					info.isReady = child.Value <= 0
					break
				end
			end
		end

		-- Buscar en atributos
		for _, attrName in pairs(egg:GetAttributeNames()) do
			local value = egg:GetAttribute(attrName)
			if attrName:lower():find("time") and type(value) == "number" then
				info.timeLeft = value
				info.isReady = value <= 0
			end
		end

		-- Determinar estado
		if info.isReady then
			info.status = "READY!"
		elseif info.timeLeft and info.timeLeft > 0 then
			info.status = "Incubating"
		else
			info.status = "Unknown"
		end

		-- Buscar ClickDetector para saber si es clickeable
		if egg:FindFirstChildOfClass("ClickDetector") then
			if info.isReady then
				info.status = "CLICK TO HATCH!"
			end
		end
	end)

	return info
end

-- Función para formatear tiempo
local function formatTime(seconds)
	if not seconds or seconds <= 0 then return "READY!" end

	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = math.floor(seconds % 60)

	if hours > 0 then
		return string.format("%dh %dm", hours, minutes)
	elseif minutes > 0 then
		return string.format("%dm %ds", minutes, secs)
	else
		return string.format("%ds", secs)
	end
end

-- Función para obtener color por rareza
local function getRarityColor(rarity)
	if rarity == "Legendary" then return Color3.fromRGB(255, 215, 0) -- Dorado
	elseif rarity == "Epic" then return Color3.fromRGB(128, 0, 128) -- Púrpura
	elseif rarity == "Rare" then return Color3.fromRGB(0, 100, 255) -- Azul
	elseif rarity == "Uncommon" then return Color3.fromRGB(0, 255, 0) -- Verde
	else return Color3.fromRGB(255, 255, 255) -- Blanco
	end
end

-- Función para crear ESP inteligente
local function createSmartESP(egg)
	if eggESPs[egg] then return end

	local info = getSmartEggInfo(egg)

	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(0, 180, 0, 70)
	billboardGui.StudsOffset = Vector3.new(0, 2, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = egg

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.3
	frame.BorderSizePixel = 0
	frame.Parent = billboardGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	-- Label del tipo y rareza
	local typeLabel = Instance.new("TextLabel")
	typeLabel.Size = UDim2.new(1, 0, 0.5, 0)
	typeLabel.BackgroundTransparency = 1
	typeLabel.Text = "🥚 " .. info.eggType .. " (" .. info.rarity .. ")"
	typeLabel.TextColor3 = getRarityColor(info.rarity)
	typeLabel.TextScaled = true
	typeLabel.Font = Enum.Font.GothamBold
	typeLabel.Parent = frame

	-- Label del estado
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(1, 0, 0.5, 0)
	statusLabel.Position = UDim2.new(0, 0, 0.5, 0)
	statusLabel.BackgroundTransparency = 1
	statusLabel.TextScaled = true
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.Parent = frame

	-- Configurar según estado
	if info.isReady then
		statusLabel.Text = "✅ " .. info.status
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)

		-- Efecto de brillo para huevos listos
		local glow = Instance.new("ImageLabel")
		glow.Size = UDim2.new(1.2, 0, 1.2, 0)
		glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
		glow.BackgroundTransparency = 1
		glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
		glow.ImageColor3 = Color3.fromRGB(0, 255, 0)
		glow.ImageTransparency = 0.7
		glow.Parent = frame

		-- Animación de brillo
		spawn(function()
			while glow.Parent do
				glow.ImageTransparency = 0.7
				wait(0.5)
				glow.ImageTransparency = 0.9
				wait(0.5)
			end
		end)

	elseif info.timeLeft then
		statusLabel.Text = "⏰ " .. formatTime(info.timeLeft)
		statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		frame.BackgroundColor3 = Color3.fromRGB(50, 50, 0)
	else
		statusLabel.Text = "❓ " .. info.status
		statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
		frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end

	eggESPs[egg] = {
		gui = billboardGui,
		typeLabel = typeLabel,
		statusLabel = statusLabel,
		frame = frame,
		lastInfo = info
	}

	print("📊 ESP Created: " .. info.eggType .. " (" .. info.rarity .. ") - " .. info.status)
end

-- Función para encontrar huevos
local function findEggs()
	local eggs = {}

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name:lower():find("egg") and obj.Parent then
			table.insert(eggs, obj)
		end
	end

	return eggs
end

-- Función de actualización inteligente
local function smartUpdate()
	if not espEnabled then return end

	updateCounter = updateCounter + 1
	if updateCounter < 60 then return end -- Actualizar cada segundo
	updateCounter = 0

	local eggs = findEggs()

	-- Crear ESP para huevos nuevos
	for _, egg in pairs(eggs) do
		if egg and egg.Parent and not eggESPs[egg] then
			createSmartESP(egg)
		end
	end

	-- Actualizar huevos existentes
	for egg, espData in pairs(eggESPs) do
		if egg and egg.Parent then
			local info = getSmartEggInfo(egg)

			-- Actualizar si cambió el estado
			if info.status ~= espData.lastInfo.status or info.timeLeft ~= espData.lastInfo.timeLeft then

				if info.isReady then
					espData.statusLabel.Text = "✅ " .. info.status
					espData.statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
					espData.frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)

					print("🔥 EGG READY: " .. info.eggType .. " is ready to hatch!")

				elseif info.timeLeft then
					espData.statusLabel.Text = "⏰ " .. formatTime(info.timeLeft)
					espData.statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
					espData.frame.BackgroundColor3 = Color3.fromRGB(50, 50, 0)
				else
					espData.statusLabel.Text = "❓ " .. info.status
					espData.statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
					espData.frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				end

				espData.lastInfo = info
			end
		else
			-- Limpiar ESP obsoletos
			if espData.gui then espData.gui:Destroy() end
			eggESPs[egg] = nil
		end
	end
end

-- Funciones de control
function startSmartESP()
	if connection then connection:Disconnect() end
	connection = RunService.Heartbeat:Connect(smartUpdate)
	print("🧠 SMART ESP STARTED!")
	print("Features:")
	print("- Shows egg type and rarity")
	print("- Real-time countdown timers")
	print("- Highlights ready eggs with glow effect")
	print("- Color-coded by rarity")
end

function stopSmartESP()
	if connection then
		connection:Disconnect()
		connection = nil
	end

	for egg, espData in pairs(eggESPs) do
		if espData.gui then espData.gui:Destroy() end
	end
	eggESPs = {}
	print("❌ SMART ESP STOPPED!")
end

-- Crear GUI
createGUI()

print("🧠🥚 SMART EGG ESP LOADED! 🥚🧠")
print("")
print("✅ WHAT THIS ESP SHOWS:")
print("🥚 Egg Type (Paradise, Crystal, Golden, etc.)")
print("💎 Rarity (Common, Rare, Epic, Legendary)")
print("⏰ Real countdown timers")
print("✅ Ready status with glow effect")
print("🎨 Color-coded by rarity")
print("")
print("🔥 RARITY COLORS:")
print("⚪ Common = White")
print("🟢 Uncommon = Green") 
print("🔵 Rare = Blue")
print("🟣 Epic = Purple")
print("🟡 Legendary = Gold")
print("")
print("💡 Since pet names aren't stored until hatching,")
print("this ESP shows USEFUL info you can actually see!")
print("")
print("🎯 Click 'SMART ESP' to toggle on/off")
