-- Panel Funcional para Steal a Brainrot - Roblox
-- Versión mejorada con funciones que realmente funcionan

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables principales
local panel = nil
local isVisible = false
local autoStealEnabled = false
local autoStealConnection = nil
local invisibleEnabled = false
local invisibleConnection = nil
local espEnabled = false
local espObjects = {}
local noclipEnabled = false
local noclipConnection = nil

-- Variables para detectar brainrots
local brainrotNames = {
	"Brainrot", "brainrot", "BRAINROT",
	"Skibidi", "skibidi", "SKIBIDI",
	"Sigma", "sigma", "SIGMA",
	"Ohio", "ohio", "OHIO",
	"Gyat", "gyat", "GYAT",
	"Rizz", "rizz", "RIZZ",
	"Fanum", "fanum", "FANUM"
}

-- Función para encontrar brainrots reales
local function findBrainrots()
	local brainrots = {}

	-- Buscar en workspace
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
			for _, name in pairs(brainrotNames) do
				if string.find(obj.Name:lower(), name:lower()) then
					table.insert(brainrots, obj)
					break
				end
			end
		end
	end

	-- Buscar modelos que contengan brainrots
	for _, model in pairs(Workspace:GetChildren()) do
		if model:IsA("Model") then
			for _, name in pairs(brainrotNames) do
				if string.find(model.Name:lower(), name:lower()) then
					local primaryPart = model.PrimaryPart or model:FindFirstChild("Part") or model:FindFirstChildOfClass("Part")
					if primaryPart then
						table.insert(brainrots, primaryPart)
					end
					break
				end
			end
		end
	end

	return brainrots
end

-- Función para crear la interfaz
local function createPanel()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BrainrotPanel"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 320, 0, 450)
	mainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame

	-- Título con gradiente
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 0, 45)
	titleLabel.Position = UDim2.new(0, 0, 0, 0)
	titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = "🧠 BRAINROT STEALER PRO"
	titleLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
	titleLabel.TextScaled = true
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = mainFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 12)
	titleCorner.Parent = titleLabel

	-- Botón cerrar mejorado
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 35, 0, 35)
	closeButton.Position = UDim2.new(1, -40, 0, 5)
	closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	closeButton.BorderSizePixel = 0
	closeButton.Text = "✕"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextScaled = true
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = mainFrame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeButton

	-- Contenedor con scroll
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollFrame"
	scrollFrame.Size = UDim2.new(1, -20, 1, -65)
	scrollFrame.Position = UDim2.new(0, 10, 0, 55)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
	scrollFrame.Parent = mainFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = scrollFrame

	-- Función para crear botones mejorados
	local function createButton(text, color, callback, layoutOrder)
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, 0, 0, 45)
		button.BackgroundColor3 = color
		button.BorderSizePixel = 0
		button.Text = text
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextScaled = true
		button.Font = Enum.Font.Gotham
		button.LayoutOrder = layoutOrder or 1
		button.Parent = scrollFrame

		local buttonCorner = Instance.new("UICorner")
		buttonCorner.CornerRadius = UDim.new(0, 8)
		buttonCorner.Parent = button

		-- Efecto hover
		button.MouseEnter:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(color.R + 0.1, color.G + 0.1, color.B + 0.1)}):Play()
		end)

		button.MouseLeave:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
		end)

		button.MouseButton1Click:Connect(callback)
		return button
	end

	-- Botones funcionales
	local stealAllButton = createButton("🎯 STEAL ALL BRAINROTS", Color3.fromRGB(60, 180, 60), function()
		stealAllBrainrots()
	end, 1)

	local autoStealButton = createButton("🔄 AUTO STEAL: OFF", Color3.fromRGB(120, 120, 120), function()
		toggleAutoSteal()
		autoStealButton.Text = autoStealEnabled and "🔄 AUTO STEAL: ON" or "🔄 AUTO STEAL: OFF"
		autoStealButton.BackgroundColor3 = autoStealEnabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(120, 120, 120)
	end, 2)

	local teleportButton = createButton("📍 TELEPORT TO BRAINROTS", Color3.fromRGB(60, 120, 220), function()
		teleportToBrainrots()
	end, 3)

	local invisibleButton = createButton("👻 INVISIBLE MODE: OFF", Color3.fromRGB(120, 120, 120), function()
		toggleInvisible()
		invisibleButton.Text = invisibleEnabled and "👻 INVISIBLE MODE: ON" or "👻 INVISIBLE MODE: OFF"
		invisibleButton.BackgroundColor3 = invisibleEnabled and Color3.fromRGB(180, 60, 180) or Color3.fromRGB(120, 120, 120)
	end, 4)

	local speedButton = createButton("⚡ SPEED BOOST", Color3.fromRGB(220, 180, 60), function()
		toggleSpeed()
	end, 5)

	local jumpButton = createButton("🦘 SUPER JUMP", Color3.fromRGB(180, 60, 220), function()
		toggleJump()
	end, 6)

	local noclipButton = createButton("🚪 NOCLIP: OFF", Color3.fromRGB(120, 120, 120), function()
		toggleNoclip()
		noclipButton.Text = noclipEnabled and "🚪 NOCLIP: ON" or "🚪 NOCLIP: OFF"
		noclipButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(220, 60, 180) or Color3.fromRGB(120, 120, 120)
	end, 7)

	local espButton = createButton("👁️ BRAINROT ESP: OFF", Color3.fromRGB(120, 120, 120), function()
		toggleESP()
		espButton.Text = espEnabled and "👁️ BRAINROT ESP: ON" or "👁️ BRAINROT ESP: OFF"
		espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(60, 220, 180) or Color3.fromRGB(120, 120, 120)
	end, 8)

	-- Actualizar tamaño del scroll
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
	end)

	closeButton.MouseButton1Click:Connect(function()
		togglePanel()
	end)

	return screenGui
end

-- Función mejorada para robar brainrots
function stealAllBrainrots()
	local brainrots = findBrainrots()
	local stolen = 0

	for _, brainrot in pairs(brainrots) do
		if brainrot and brainrot.Parent then
			-- Intentar diferentes métodos de interacción
			if brainrot:FindFirstChild("ClickDetector") then
				fireclickdetector(brainrot.ClickDetector)
				stolen = stolen + 1
			elseif brainrot:FindFirstChild("ProximityPrompt") then
				fireproximityprompt(brainrot.ProximityPrompt)
				stolen = stolen + 1
			elseif brainrot.Parent:FindFirstChild("ClickDetector") then
				fireclickdetector(brainrot.Parent.ClickDetector)
				stolen = stolen + 1
			elseif brainrot.Parent:FindFirstChild("ProximityPrompt") then
				fireproximityprompt(brainrot.Parent.ProximityPrompt)
				stolen = stolen + 1
			else
				-- Teletransportarse y tocar el objeto
				if rootPart then
					local originalPos = rootPart.CFrame
					rootPart.CFrame = brainrot.CFrame + Vector3.new(0, 3, 0)
					wait(0.1)
					-- Simular toque
					if brainrot.Touched then
						brainrot.Touched:Fire(rootPart)
					end
					stolen = stolen + 1
					wait(0.1)
				end
			end
			wait(0.05)
		end
	end

	print("🧠 Intenté robar " .. stolen .. " brainrots!")
end

-- Auto steal mejorado
function toggleAutoSteal()
	autoStealEnabled = not autoStealEnabled

	if autoStealEnabled then
		autoStealConnection = RunService.Heartbeat:Connect(function()
			stealAllBrainrots()
			wait(2)
		end)
		print("🔄 Auto steal ACTIVADO")
	else
		if autoStealConnection then
			autoStealConnection:Disconnect()
			autoStealConnection = nil
		end
		print("🔄 Auto steal DESACTIVADO")
	end
end

-- Teletransporte mejorado
function teleportToBrainrots()
	local brainrots = findBrainrots()

	if #brainrots > 0 then
		for i, brainrot in pairs(brainrots) do
			if brainrot and brainrot.Parent and rootPart then
				rootPart.CFrame = brainrot.CFrame + Vector3.new(0, 5, 0)
				wait(0.3)

				-- Intentar robar inmediatamente
				if brainrot:FindFirstChild("ClickDetector") then
					fireclickdetector(brainrot.ClickDetector)
				elseif brainrot:FindFirstChild("ProximityPrompt") then
					fireproximityprompt(brainrot.ProximityPrompt)
				end

				if i >= 5 then break end -- Limitar a 5 teletransportes
			end
		end
		print("📍 Teletransportado a " .. math.min(#brainrots, 5) .. " brainrots")
	else
		print("📍 No se encontraron brainrots")
	end
end

-- Continuación del código anterior...

-- Modo invisible FUNCIONAL
function toggleInvisible()
	invisibleEnabled = not invisibleEnabled

	if invisibleEnabled then
		invisibleConnection = RunService.Heartbeat:Connect(function()
			if player.Character then
				for _, part in pairs(player.Character:GetChildren()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						part.Transparency = 1
						part.CanCollide = false
					elseif part:IsA("Accessory") then
						local handle = part:FindFirstChild("Handle")
						if handle then
							handle.Transparency = 1
						end
					end
				end

				-- Hacer invisible el brainrot en la mano
				for _, tool in pairs(player.Character:GetChildren()) do
					if tool:IsA("Tool") then
						for _, name in pairs(brainrotNames) do
							if string.find(tool.Name:lower(), name:lower()) then
								local handle = tool:FindFirstChild("Handle")
								if handle then
									handle.Transparency = 1
								end
								break
							end
						end
					end
				end

				-- Hacer invisible brainrots en el backpack
				for _, tool in pairs(player.Backpack:GetChildren()) do
					if tool:IsA("Tool") then
						for _, name in pairs(brainrotNames) do
							if string.find(tool.Name:lower(), name:lower()) then
								local handle = tool:FindFirstChild("Handle")
								if handle then
									handle.Transparency = 1
								end
								break
							end
						end
					end
				end

				-- Ocultar nombre y health bar
				if player.Character:FindFirstChild("Head") then
					local head = player.Character.Head
					for _, gui in pairs(head:GetChildren()) do
						if gui:IsA("BillboardGui") then
							gui.Enabled = false
						end
					end
				end
			end
		end)
		print("👻 Modo invisible ACTIVADO - Tú y tus brainrots son invisibles")
	else
		if invisibleConnection then
			invisibleConnection:Disconnect()
			invisibleConnection = nil
		end

		-- Restaurar visibilidad
		if player.Character then
			for _, part in pairs(player.Character:GetChildren()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.Transparency = 0
					if part.Name ~= "Head" then
						part.CanCollide = true
					end
				elseif part:IsA("Accessory") then
					local handle = part:FindFirstChild("Handle")
					if handle then
						handle.Transparency = 0
					end
				end
			end

			-- Restaurar brainrots
			for _, tool in pairs(player.Character:GetChildren()) do
				if tool:IsA("Tool") then
					local handle = tool:FindFirstChild("Handle")
					if handle then
						handle.Transparency = 0
					end
				end
			end

			for _, tool in pairs(player.Backpack:GetChildren()) do
				if tool:IsA("Tool") then
					local handle = tool:FindFirstChild("Handle")
					if handle then
						handle.Transparency = 0
					end
				end
			end

			-- Restaurar GUI
			if player.Character:FindFirstChild("Head") then
				local head = player.Character.Head
				for _, gui in pairs(head:GetChildren()) do
					if gui:IsA("BillboardGui") then
						gui.Enabled = true
					end
				end
			end
		end
		print("👻 Modo invisible DESACTIVADO")
	end
end

-- Speed boost FUNCIONAL
local originalWalkSpeed = 16
function toggleSpeed()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		local humanoid = player.Character.Humanoid
		if humanoid.WalkSpeed == originalWalkSpeed then
			humanoid.WalkSpeed = 100
			print("⚡ Speed boost ACTIVADO (100)")
		else
			humanoid.WalkSpeed = originalWalkSpeed
			print("⚡ Speed boost DESACTIVADO")
		end
	end
end

-- Jump boost FUNCIONAL
local originalJumpPower = 50
function toggleJump()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		local humanoid = player.Character.Humanoid
		if humanoid.JumpPower == originalJumpPower then
			humanoid.JumpPower = 150
			print("🦘 Super jump ACTIVADO (150)")
		else
			humanoid.JumpPower = originalJumpPower
			print("🦘 Super jump DESACTIVADO")
		end
	end
end

-- Noclip FUNCIONAL
function toggleNoclip()
	noclipEnabled = not noclipEnabled

	if noclipEnabled then
		noclipConnection = RunService.Stepped:Connect(function()
			if player.Character then
				for _, part in pairs(player.Character:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then
						part.CanCollide = false
					end
				end
			end
		end)
		print("🚪 Noclip ACTIVADO")
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end

		if player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.CanCollide = true
				end
			end
		end
		print("🚪 Noclip DESACTIVADO")
	end
end

-- ESP FUNCIONAL mejorado
function toggleESP()
	espEnabled = not espEnabled

	if espEnabled then
		-- Limpiar ESP anterior
		for _, highlight in pairs(espObjects) do
			if highlight and highlight.Parent then
				highlight:Destroy()
			end
		end
		espObjects = {}

		-- Crear nuevo ESP
		local function createESP(obj)
			if obj and obj.Parent then
				local highlight = Instance.new("Highlight")
				highlight.FillColor = Color3.fromRGB(255, 0, 255)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.FillTransparency = 0.5
				highlight.OutlineTransparency = 0
				highlight.Parent = obj
				table.insert(espObjects, highlight)

				-- Crear BillboardGui para mostrar distancia
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Size = UDim2.new(0, 100, 0, 50)
				billboardGui.StudsOffset = Vector3.new(0, 3, 0)
				billboardGui.Parent = obj

				local textLabel = Instance.new("TextLabel")
				textLabel.Size = UDim2.new(1, 0, 1, 0)
				textLabel.BackgroundTransparency = 1
				textLabel.Text = obj.Name
				textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel.TextScaled = true
				textLabel.Font = Enum.Font.GothamBold
				textLabel.TextStrokeTransparency = 0
				textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
				textLabel.Parent = billboardGui

				table.insert(espObjects, billboardGui)

				-- Actualizar distancia
				spawn(function()
					while espEnabled and obj.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
						local distance = (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude
						textLabel.Text = obj.Name .. "\n[" .. math.floor(distance) .. "m]"
						wait(0.5)
					end
				end)
			end
		end

		-- Aplicar ESP a brainrots existentes
		local brainrots = findBrainrots()
		for _, brainrot in pairs(brainrots) do
			createESP(brainrot)
		end

		-- ESP para nuevos brainrots
		Workspace.DescendantAdded:Connect(function(obj)
			if espEnabled then
				wait(0.1)
				for _, name in pairs(brainrotNames) do
					if string.find(obj.Name:lower(), name:lower()) and (obj:IsA("Part") or obj:IsA("MeshPart")) then
						createESP(obj)
						break
					end
				end
			end
		end)

		print("👁️ ESP ACTIVADO - " .. #brainrots .. " brainrots detectados")
	else
		-- Limpiar ESP
		for _, highlight in pairs(espObjects) do
			if highlight and highlight.Parent then
				highlight:Destroy()
			end
		end
		espObjects = {}
		print("👁️ ESP DESACTIVADO")
	end
end

-- Función para mostrar/ocultar panel
function togglePanel()
	if panel then
		panel:Destroy()
		panel = nil
		isVisible = false
		print("📋 Panel ocultado")
	else
		panel = createPanel()
		isVisible = true
		print("📋 Panel mostrado")
	end
end

-- Función para limpiar al cambiar de personaje
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")

	-- Resetear valores
	originalWalkSpeed = humanoid.WalkSpeed
	originalJumpPower = humanoid.JumpPower

	-- Reactivar funciones si estaban activas
	if invisibleEnabled then
		invisibleEnabled = false
		toggleInvisible()
	end

	if noclipEnabled then
		noclipEnabled = false
		toggleNoclip()
	end
end)

-- Crear panel inicial
panel = createPanel()
isVisible = true

-- Controles de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed then
		if input.KeyCode == Enum.KeyCode.Insert then
			togglePanel()
		elseif input.KeyCode == Enum.KeyCode.F1 then
			stealAllBrainrots()
		elseif input.KeyCode == Enum.KeyCode.F2 then
			toggleAutoSteal()
		elseif input.KeyCode == Enum.KeyCode.F3 then
			toggleInvisible()
		elseif input.KeyCode == Enum.KeyCode.F4 then
			teleportToBrainrots()
		end
	end
end)

-- Notificación de carga
local function showNotification(text, duration)
	local notificationGui = Instance.new("ScreenGui")
	notificationGui.Name = "Notification"
	notificationGui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 60)
	frame.Position = UDim2.new(0.5, -150, 0, -70)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.BorderSizePixel = 0
	frame.Parent = notificationGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.Font = Enum.Font.Gotham
	label.Parent = frame

	-- Animación de entrada
	frame:TweenPosition(UDim2.new(0.5, -150, 0, 20), "Out", "Quad", 0.5, true)

	-- Eliminar después del tiempo especificado
	game:GetService("Debris"):AddItem(notificationGui, duration or 3)

	-- Animación de salida
	spawn(function()
		wait((duration or 3) - 0.5)
		frame:TweenPosition(UDim2.new(0.5, -150, 0, -70), "In", "Quad", 0.5, true)
	end)
end

-- Mostrar notificación de carga
showNotification("🧠 BRAINROT STEALER PRO CARGADO!\n📋 INSERT para abrir/cerrar", 4)

print("🧠 ===== BRAINROT STEALER PRO =====")
print("📋 INSERT - Mostrar/ocultar panel")
print("🎯 F1 - Steal all brainrots")
print("🔄 F2 - Toggle auto steal")
print("👻 F3 - Toggle invisible mode")
print("📍 F4 - Teleport to brainrots")
print("⚠️ USAR BAJO TU PROPIA RESPONSABILIDAD")
print("🧠 ================================")
