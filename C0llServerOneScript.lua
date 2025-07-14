-- Grow a Garden ULTIMATE ESP - Versión corregida

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
local deepScanComplete = false
local gameData = {}

-- Función para escaneo profundo del juego COMPLETO (DEFINIDA PRIMERO)
local function deepScanGame(statusLabel)
	spawn(function()
		print("🔥🔥🔥 STARTING ULTIMATE DEEP SCAN 🔥🔥🔥")

		local totalData = 0
		local petData = {}
		local eggData = {}

		-- ESCANEAR REPLICATEDSTORAGE
		statusLabel.Text = "📁 Scanning ReplicatedStorage..."
		wait(0.1)

		pcall(function()
			for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
				if obj:IsA("ModuleScript") then
					pcall(function()
						local module = require(obj)
						if type(module) == "table" then
							for k, v in pairs(module) do
								totalData = totalData + 1
								if type(k) == "string" and (k:lower():find("pet") or k:lower():find("animal")) then
									petData[k] = v
								end
								if type(k) == "string" and k:lower():find("egg") then
									eggData[k] = v
								end
							end
						end
					end)
				elseif obj:IsA("StringValue") or obj:IsA("Configuration") then
					if obj.Name:lower():find("pet") or obj.Name:lower():find("animal") then
						petData[obj.Name] = obj:IsA("StringValue") and obj.Value or "Configuration"
					end
				end
			end
		end)

		-- ESCANEAR WORKSPACE COMPLETO
		statusLabel.Text = "🌍 Scanning Workspace..."
		wait(0.1)

		pcall(function()
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("StringValue") or obj:IsA("NumberValue") or obj:IsA("BoolValue") then
					totalData = totalData + 1
					if obj.Name:lower():find("pet") or obj.Name:lower():find("animal") then
						petData[obj.Name] = obj.Value
					end
				end

				-- Buscar RemoteEvents/Functions relacionados con huevos
				if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
					if obj.Name:lower():find("egg") or obj.Name:lower():find("hatch") then
						eggData["Remote_" .. obj.Name] = obj.Parent.Name
					end
				end
			end
		end)

		-- ESCANEAR PLAYER DATA
		statusLabel.Text = "👤 Scanning Player Data..."
		wait(0.1)

		pcall(function()
			if player:FindFirstChild("leaderstats") then
				for _, stat in pairs(player.leaderstats:GetChildren()) do
					totalData = totalData + 1
					gameData["PlayerStat_" .. stat.Name] = stat.Value
				end
			end

			if player:FindFirstChild("PlayerGui") then
				for _, gui in pairs(player.PlayerGui:GetDescendants()) do
					if gui:IsA("TextLabel") and gui.Text and gui.Text ~= "" then
						if gui.Text:lower():find("pet") or gui.Text:lower():find("animal") then
							petData["GUI_" .. gui.Name] = gui.Text
						end
					end
				end
			end
		end)

		-- GUARDAR DATOS ENCONTRADOS
		gameData.petData = petData
		gameData.eggData = eggData
		gameData.totalScanned = totalData

		-- MOSTRAR RESULTADOS
		print("=== ULTIMATE SCAN RESULTS ===")
		print("Total data points scanned: " .. totalData)
		print("Pet-related data found:")
		for k, v in pairs(petData) do
			print("  " .. k .. " = " .. tostring(v))
		end

		print("Egg-related data found:")
		for k, v in pairs(eggData) do
			print("  " .. k .. " = " .. tostring(v))
		end

		deepScanComplete = true
		statusLabel.Text = "✅ Scan complete! " .. totalData .. " items"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

		print("🔥 ULTIMATE SCAN COMPLETE! Check console for all data found.")
	end)
end

-- Función para crear GUI
local function createGUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "UltimateEggESP"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Botón principal
	local mainButton = Instance.new("TextButton")
	mainButton.Size = UDim2.new(0, 140, 0, 45)
	mainButton.Position = UDim2.new(0, 10, 0.5, -22)
	mainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	mainButton.BorderSizePixel = 0
	mainButton.Text = "🔥 ULTIMATE ESP"
	mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	mainButton.TextScaled = true
	mainButton.Font = Enum.Font.GothamBold
	mainButton.Parent = screenGui

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 8)
	buttonCorner.Parent = mainButton

	-- Panel de control
	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(0, 280, 0, 150)
	panel.Position = UDim2.new(0, 160, 0.5, -75)
	panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = screenGui

	local panelCorner = Instance.new("UICorner")
	panelCorner.CornerRadius = UDim.new(0, 10)
	panelCorner.Parent = panel

	-- Botón ESP
	local espButton = Instance.new("TextButton")
	espButton.Size = UDim2.new(0.9, 0, 0.25, 0)
	espButton.Position = UDim2.new(0.05, 0, 0.05, 0)
	espButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	espButton.BorderSizePixel = 0
	espButton.Text = "🥚 ESP: OFF"
	espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	espButton.TextScaled = true
	espButton.Font = Enum.Font.GothamBold
	espButton.Parent = panel

	local espCorner = Instance.new("UICorner")
	espCorner.CornerRadius = UDim.new(0, 6)
	espCorner.Parent = espButton

	-- Botón Deep Scan
	local scanButton = Instance.new("TextButton")
	scanButton.Size = UDim2.new(0.9, 0, 0.25, 0)
	scanButton.Position = UDim2.new(0.05, 0, 0.35, 0)
	scanButton.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
	scanButton.BorderSizePixel = 0
	scanButton.Text = "🔍 DEEP SCAN GAME"
	scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	scanButton.TextScaled = true
	scanButton.Font = Enum.Font.GothamBold
	scanButton.Parent = panel

	local scanCorner = Instance.new("UICorner")
	scanCorner.CornerRadius = UDim.new(0, 6)
	scanCorner.Parent = scanButton

	-- Status label
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(0.9, 0, 0.25, 0)
	statusLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
	statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	statusLabel.BorderSizePixel = 0
	statusLabel.Text = "⏳ Ready to scan..."
	statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	statusLabel.TextScaled = true
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.Parent = panel

	local statusCorner = Instance.new("UICorner")
	statusCorner.CornerRadius = UDim.new(0, 4)
	statusCorner.Parent = statusLabel

	-- Toggle panel
	mainButton.MouseButton1Click:Connect(function()
		panel.Visible = not panel.Visible
	end)

	-- Toggle ESP
	espButton.MouseButton1Click:Connect(function()
		espEnabled = not espEnabled

		if espEnabled then
			espButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
			espButton.Text = "🥚 ESP: ON"
			startUltimateESP()
		else
			espButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
			espButton.Text = "🥚 ESP: OFF"
			stopUltimateESP()
		end
	end)

	-- Deep Scan (AHORA SÍ FUNCIONA)
	scanButton.MouseButton1Click:Connect(function()
		statusLabel.Text = "🔍 Scanning game..."
		statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		deepScanGame(statusLabel)
	end)

	return screenGui, statusLabel
end

-- Función ULTRA PROFUNDA para leer datos de huevos
local function ultimateEggRead(egg)
	local petName = nil
	local confidence = 0
	local allData = {}

	pcall(function()
		-- MÉTODO 1: Escaneo completo de descendientes
		for _, obj in pairs(egg:GetDescendants()) do
			if obj:IsA("StringValue") and obj.Value and obj.Value ~= "" then
				allData["StringValue_" .. obj.Name] = obj.Value

				if not obj.Value:lower():find("egg") and not obj.Value:lower():find("time") and #obj.Value > 2 then
					petName = obj.Value
					confidence = confidence + 1
				end
			end

			if obj:IsA("TextLabel") and obj.Text and obj.Text ~= "" then
				allData["TextLabel_" .. obj.Name] = obj.Text

				local cleanText = obj.Text:gsub("[🥚🐾⏰✅❌]", ""):match("^%s*(.-)%s*$")
				if cleanText and #cleanText > 2 and not cleanText:lower():find("incubat") and not cleanText:lower():find("time") then
					petName = cleanText
					confidence = confidence + 2
				end
			end
		end

		-- MÉTODO 2: Todos los atributos
		for _, attrName in pairs(egg:GetAttributeNames()) do
			local value = egg:GetAttribute(attrName)
			allData["Attribute_" .. attrName] = tostring(value)

			if type(value) == "string" and #value > 2 and not value:lower():find("egg") then
				petName = value
				confidence = confidence + 3
			end
		end

		-- MÉTODO 3: Usar datos del scan global
		if deepScanComplete and gameData.petData then
			for k, v in pairs(gameData.petData) do
				if type(v) == "string" and egg.Name:lower():find(k:lower()) then
					petName = v
					confidence = confidence + 5
				end
			end
		end
	end)

	return petName, confidence, allData
end

-- Función para crear ESP definitivo
local function createUltimateESP(egg)
	if eggESPs[egg] then return end

	local petName, confidence, allData = ultimateEggRead(egg)

	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(0, 200, 0, 80)
	billboardGui.StudsOffset = Vector3.new(0, 3, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = egg

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.Parent = billboardGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	-- Tipo de huevo
	local typeLabel = Instance.new("TextLabel")
	typeLabel.Size = UDim2.new(1, 0, 0.4, 0)
	typeLabel.BackgroundTransparency = 1
	typeLabel.TextScaled = true
	typeLabel.Font = Enum.Font.GothamBold
	typeLabel.Parent = frame

	-- Determinar tipo
	local eggType = "Unknown"
	local eggName = egg.Name:lower()
	if eggName:find("paradise") then eggType = "Paradise"
	elseif eggName:find("forest") then eggType = "Forest"
	elseif eggName:find("ocean") then eggType = "Ocean"
	elseif eggName:find("desert") then eggType = "Desert"
	elseif eggName:find("volcano") then eggType = "Volcano"
	elseif eggName:find("crystal") then eggType = "Crystal"
	elseif eggName:find("golden") then eggType = "Golden"
	end

	typeLabel.Text = "🥚 " .. eggType .. " Egg"
	typeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

	-- Info principal
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Size = UDim2.new(1, 0, 0.6, 0)
	infoLabel.Position = UDim2.new(0, 0, 0.4, 0)
	infoLabel.BackgroundTransparency = 1
	infoLabel.TextScaled = true
	infoLabel.Font = Enum.Font.GothamBold
	infoLabel.Parent = frame

	-- Mostrar resultado según confianza
	if petName and confidence >= 3 then
		infoLabel.Text = "🔥 " .. petName .. " 🔥"
		infoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
		print("🔥 HIGH CONFIDENCE PET FOUND: " .. petName .. " (Confidence: " .. confidence .. ")")
	elseif petName and confidence >= 1 then
		infoLabel.Text = "⚠️ " .. petName .. " ⚠️"
		infoLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		frame.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
		print("⚠️ LOW CONFIDENCE PET: " .. petName .. " (Confidence: " .. confidence .. ")")
	else
		infoLabel.Text = "❓ Scanning..."
		infoLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
		frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end

	-- Debug: imprimir todos los datos encontrados
	if next(allData) then
		print("=== EGG DEBUG: " .. egg.Name .. " ===")
		for k, v in pairs(allData) do
			print("  " .. k .. " = " .. tostring(v))
		end
		print("Pet found: " .. tostring(petName))
		print("Confidence: " .. confidence)
		print("===============================")
	end

	eggESPs[egg] = {
		gui = billboardGui,
		infoLabel = infoLabel,
		typeLabel = typeLabel,
		frame = frame,
		lastPetName = petName,
		lastConfidence = confidence
	}
end

-- Función para encontrar huevos
local function findEggs()
	local eggs = {}

	-- Buscar en múltiples ubicaciones
	local searchAreas = {workspace}

	if workspace:FindFirstChild("Garden") then
		table.insert(searchAreas, workspace.Garden)
	end
	if workspace:FindFirstChild("Eggs") then
		table.insert(searchAreas, workspace.Eggs)
	end
	if workspace:FindFirstChild("Map") then
		table.insert(searchAreas, workspace.Map)
	end

	for _, area in pairs(searchAreas) do
		for _, obj in pairs(area:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
				table.insert(eggs, obj)
			end
		end
	end

	return eggs
end

-- Función de actualización optimizada (sin lag)
local function ultimateUpdate()
	if not espEnabled then return end

	updateCounter = updateCounter + 1
	if updateCounter < 180 then return end -- Actualizar cada 3 segundos
	updateCounter = 0

	local eggs = findEggs()

	-- Crear ESP para huevos nuevos
	for _, egg in pairs(eggs) do
		if egg and egg.Parent and not eggESPs[egg] then
			createUltimateESP(egg)
		end
	end

	-- Actualizar huevos existentes (re-escanear por si cambiaron)
	for egg, espData in pairs(eggESPs) do
		if egg and egg.Parent then
			local petName, confidence, allData = ultimateEggRead(egg)

			-- Solo actualizar si encontramos algo nuevo o mejor
			if petName and (confidence > espData.lastConfidence or petName ~= espData.lastPetName) then
				if confidence >= 3 then
					espData.infoLabel.Text = "🔥 " .. petName .. " 🔥"
					espData.infoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
					espData.frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
				elseif confidence >= 1 then
					espData.infoLabel.Text = "⚠️ " .. petName .. " ⚠️"
					espData.infoLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
					espData.frame.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
				end

				espData.lastPetName = petName
				espData.lastConfidence = confidence

				print("🔄 UPDATED: " .. egg.Name .. " -> " .. petName .. " (Confidence: " .. confidence .. ")")
			end
		else
			-- Limpiar ESP obsoletos
			if espData.gui then espData.gui:Destroy() end
			eggESPs[egg] = nil
		end
	end
end

-- Funciones de control
function startUltimateESP()
	if connection then connection:Disconnect() end
	connection = RunService.Heartbeat:Connect(ultimateUpdate)
	print("🔥 ULTIMATE ESP STARTED!")
end

function stopUltimateESP()
	if connection then
		connection:Disconnect()
		connection = nil
	end

	for egg, espData in pairs(eggESPs) do
		if espData.gui then espData.gui:Destroy() end
	end
	eggESPs = {}
	print("❌ ULTIMATE ESP STOPPED!")
end

-- Crear GUI
local gui, statusLabel = createGUI()

-- Auto-scan al cargar (opcional)
spawn(function()
	wait(2)
	if not deepScanComplete then
		print("🔍 Starting automatic deep scan...")
		deepScanGame(statusLabel)
	end
end)

print("🔥🔥🔥 ULTIMATE EGG ESP LOADED! 🔥🔥🔥")
print("Features:")
print("- Deep scans ENTIRE game for pet data")
print("- Multiple detection methods with confidence levels")
print("- No lag (updates every 3 seconds)")
print("- Automatic game scan on startup")
print("- Detailed debug output in console")
print("")
print("🎯 Click 'ULTIMATE ESP' button to open controls")
print("🔍 Use 'DEEP SCAN GAME' to manually scan all game data")
print("🥚 Use 'ESP: ON/OFF' to toggle egg scanning")
print("")
print("✅ ERROR FIXED - Deep scan function now works properly!")
