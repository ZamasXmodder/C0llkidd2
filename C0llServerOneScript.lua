-- Game Speed Timer x30 para Roblox
-- Acelera TODO el juego 30 veces (como GameGuardian)
-- Coloca este script en StarterGui como LocalScript

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameSpeedGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Crear Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Borde brillante
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 100, 255)
stroke.Thickness = 2
stroke.Transparency = 0.5
stroke.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.Text = "⚡ GAME SPEED HACK"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BorderSizePixel = 0
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = title

-- Info multiplier
local multiplierLabel = Instance.new("TextLabel")
multiplierLabel.Size = UDim2.new(1, -20, 0, 40)
multiplierLabel.Position = UDim2.new(0, 10, 0, 55)
multiplierLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
multiplierLabel.Text = "Velocidad: x30"
multiplierLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
multiplierLabel.Font = Enum.Font.GothamBold
multiplierLabel.TextSize = 20
multiplierLabel.BorderSizePixel = 0
multiplierLabel.Parent = mainFrame

local multCorner = Instance.new("UICorner")
multCorner.CornerRadius = UDim.new(0, 10)
multCorner.Parent = multiplierLabel

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 35)
statusLabel.Position = UDim2.new(0, 10, 0, 105)
statusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
statusLabel.Text = "🔴 VELOCIDAD NORMAL"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.BorderSizePixel = 0
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- Botón Toggle
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 130, 0, 38)
toggleButton.Position = UDim2.new(0.5, -65, 1, -48)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
toggleButton.Text = "ACTIVAR x30"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = toggleButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 255, 255)
buttonStroke.Thickness = 2
buttonStroke.Transparency = 0.8
buttonStroke.Parent = toggleButton

-- Variables del Speed Hack
local isActive = false
local speedMultiplier = 30
local normalSpeed = 1

-- Función para activar speed hack
local function activateSpeedHack()
	-- Modificar la velocidad del workspace (afecta físicas y tiempo del juego)
	local success = pcall(function()
		-- Cambiar settings de física para acelerar el juego
		settings().Physics.AllowSleep = false
		settings().Physics.ThrottleAdjustTime = 0
		
		-- Modificar el Workspace para acelerar tiempo
		game:GetService("Workspace"):SetAttribute("TimeScale", speedMultiplier)
		
		-- Acelerar animaciones del personaje
		if player.Character then
			for _, v in pairs(player.Character:GetDescendants()) do
				if v:IsA("AnimationTrack") then
					v:AdjustSpeed(speedMultiplier)
				end
			end
		end
	end)
	
	if success then
		-- Actualizar UI
		statusLabel.Text = "🟢 ACELERANDO x30"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
		toggleButton.Text = "DESACTIVAR"
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		stroke.Color = Color3.fromRGB(0, 255, 100)
		
		isActive = true
		
		-- Loop para mantener el speed activo
		spawn(function()
			while isActive do
				wait(0.1)
				-- Acelerar todas las animaciones activas
				if player.Character then
					for _, v in pairs(player.Character:GetDescendants()) do
						if v:IsA("AnimationTrack") and v.IsPlaying then
							pcall(function()
								v:AdjustSpeed(speedMultiplier)
							end)
						end
					end
				end
			end
		end)
	end
end

-- Función para desactivar speed hack
local function deactivateSpeedHack()
	pcall(function()
		-- Restaurar configuración normal
		settings().Physics.AllowSleep = true
		game:GetService("Workspace"):SetAttribute("TimeScale", normalSpeed)
		
		-- Restaurar velocidad de animaciones
		if player.Character then
			for _, v in pairs(player.Character:GetDescendants()) do
				if v:IsA("AnimationTrack") then
					v:AdjustSpeed(normalSpeed)
				end
			end
		end
	end)
	
	-- Actualizar UI
	statusLabel.Text = "🔴 VELOCIDAD NORMAL"
	statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
	toggleButton.Text = "ACTIVAR x30"
	toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
	stroke.Color = Color3.fromRGB(100, 100, 255)
	
	isActive = false
end

-- Conectar botón
toggleButton.MouseButton1Click:Connect(function()
	if isActive then
		deactivateSpeedHack()
	else
		activateSpeedHack()
	end
end)

-- Mantener activo al respawnear
player.CharacterAdded:Connect(function()
	if isActive then
		wait(1)
		activateSpeedHack()
	end
end)

-- Hacer el frame arrastrable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

print("Game Speed Hack x30 cargado correctamente!")
