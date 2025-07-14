local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- ID del jugador que verá el GUI
local AUTHORIZED_USER_ID = 4622374080

-- ID de imagen personalizada
local CUSTOM_IMAGE_ID = "rbxassetid://122516441342599"

-- Función para detener todos los sonidos
local function stopAllSounds()
	for _, obj in pairs(workspace:GetChildren()) do
		if obj:IsA("Sound") then
			obj:Stop()
			obj:Destroy()
		end
	end
end

-- Función para crear el GUI solo para el jugador autorizado
local function createGUIForPlayer(player)
	if player.UserId ~= AUTHORIZED_USER_ID then
		return
	end

	local playerGui = player:WaitForChild("PlayerGui")

	-- Crear el ScreenGui principal
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "c00lkiddGUI"
	screenGui.Parent = playerGui
	screenGui.ResetOnSpawn = false

	-- Frame principal (estilo clásico c00lkidd)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 300, 0, 450)
	mainFrame.Position = UDim2.new(0, 50, 0, 50)
	mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
	mainFrame.BorderSizePixel = 2
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui

	-- Header del GUI (estilo original)
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 25)
	header.Position = UDim2.new(0, 0, 0, 0)
	header.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	header.BorderSizePixel = 0
	header.Parent = mainFrame

	-- Título original
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -50, 1, 0)
	titleLabel.Position = UDim2.new(0, 5, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "c00lkidd's GUI"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.Arial
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header

	-- Botón X clásico
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "Close"
	closeButton.Size = UDim2.new(0, 20, 0, 20)
	closeButton.Position = UDim2.new(1, -22, 0, 2)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 12
	closeButton.Font = Enum.Font.Arial
	closeButton.BorderSizePixel = 1
	closeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	closeButton.Parent = header

	-- ScrollingFrame para los botones (estilo original)
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollFrame"
	scrollFrame.Size = UDim2.new(1, -10, 1, -35)
	scrollFrame.Position = UDim2.new(0, 5, 0, 30)
	scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	scrollFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	scrollFrame.BorderSizePixel = 1
	scrollFrame.ScrollBarThickness = 10
	scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
	scrollFrame.Parent = mainFrame

	-- Layout vertical
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = scrollFrame

	-- Función para crear botones estilo c00lkidd
	local function createButton(text, callback, layoutOrder)
		local button = Instance.new("TextButton")
		button.Name = text
		button.Size = UDim2.new(1, -10, 0, 25)
		button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		button.BorderSizePixel = 1
		button.Text = text
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextSize = 12
		button.Font = Enum.Font.Arial
		button.LayoutOrder = layoutOrder or 1
		button.Parent = scrollFrame

		-- Efecto hover clásico
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end)

		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		end)

		button.MouseButton1Click:Connect(callback)

		return button
	end

	-- Botones originales del c00lkidd GUI con funciones del servidor
	createButton("Kick All", function()
		for _, targetPlayer in pairs(Players:GetPlayers()) do
			if targetPlayer ~= player then
				targetPlayer:Kick("Kicked by c00lkidd")
			end
		end
		print("Kick All ejecutado por " .. player.Name)
	end, 1)

	createButton("Ban All", function()
		for _, targetPlayer in pairs(Players:GetPlayers()) do
			if targetPlayer ~= player then
				targetPlayer:Kick("Banned by c00lkidd")
			end
		end
		print("Ban All ejecutado por " .. player.Name)
	end, 2)

	createButton("Shutdown", function()
		for _, targetPlayer in pairs(Players:GetPlayers()) do
			targetPlayer:Kick("Server shutdown by c00lkidd")
		end
		print("Shutdown ejecutado por " .. player.Name)
	end, 3)

	createButton("Disco", function()
		spawn(function()
			for i = 1, 50 do
				Lighting.Ambient = Color3.fromHSV(math.random(), 1, 1)
				wait(0.1)
			end
			Lighting.Ambient = Color3.fromRGB(138, 138, 138)
		end)
		print("Disco ejecutado por " .. player.Name)
	end, 4)

	createButton("It's Raining Tacos", function()
		stopAllSounds()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://142376088"
		sound.Volume = 0.8
		sound.Looped = true
		sound.Parent = workspace
		sound:Play()
		print("It's Raining Tacos ejecutado por " .. player.Name)
	end, 5)

	createButton("Caramelldansen", function()
		stopAllSounds()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://2303479932"
		sound.Volume = 0.8
		sound.Looped = true
		sound.Parent = workspace
		sound:Play()
		print("Caramelldansen ejecutado por " .. player.Name)
	end, 6)

	createButton("Nyan Cat", function()
		stopAllSounds()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://130781067130"
		sound.Volume = 0.8
		sound.Looped = true
		sound.Parent = workspace
		sound:Play()
		print("Nyan Cat ejecutado por " .. player.Name)
	end, 7)

	createButton("Trololo", function()
		stopAllSounds()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://131961136"
		sound.Volume = 0.8
		sound.Looped = true
		sound.Parent = workspace
		sound:Play()
		print("Trololo ejecutado por " .. player.Name)
	end, 8)

	createButton("Stop Music", function()
		stopAllSounds()
		print("Música detenida por " .. player.Name)
	end, 9)

	createButton("Decalspam", function()
		for i = 1, 15 do
			local part = Instance.new("Part")
			part.Size = Vector3.new(10, 10, 1)
			part.Position = Vector3.new(math.random(-50, 50), 10, math.random(-50, 50))
			part.Anchored = true
			part.Parent = workspace

			for _, face in pairs(Enum.NormalId:GetEnumItems()) do
				local decal = Instance.new("Decal")
				decal.Texture = CUSTOM_IMAGE_ID
				decal.Face = face
				decal.Parent = part
			end
		end
		print("Decalspam ejecutado por " .. player.Name)
	end, 10)

	createButton("Skybox", function()
		local sky = Instance.new("Sky")
		sky.SkyboxBk = CUSTOM_IMAGE_ID
		sky.SkyboxDn = CUSTOM_IMAGE_ID
		sky.SkyboxFt = CUSTOM_IMAGE_ID
		sky.SkyboxLf = CUSTOM_IMAGE_ID
		sky.SkyboxRt = CUSTOM_IMAGE_ID
		sky.SkyboxUp = CUSTOM_IMAGE_ID
		sky.Parent = Lighting
		print("Skybox ejecutado por " .. player.Name)
	end, 11)

	createButton("Hint", function()
		local hint = Instance.new("Hint")
		hint.Text = "c00lkidd was here!"
		hint.Parent = workspace
		game:GetService("Debris"):AddItem(hint, 5)
		print("Hint ejecutado por " .. player.Name)
	end, 12)

	createButton("Message", function()
		local message = Instance.new("Message")
		message.Text = "Server has been c00lkidd'd!"
		message.Parent = workspace
		game:GetService("Debris"):AddItem(message, 5)
		print("Message ejecutado por " .. player.Name)
	end, 13)

	createButton("Particles", function()
		for _, part in pairs(workspace:GetChildren()) do
			if part:IsA("BasePart") then
				local attachment = Instance.new("Attachment")
				attachment.Parent = part

				local particles = Instance.new("ParticleEmitter")
				particles.Texture = CUSTOM_IMAGE_ID
				particles.Lifetime = NumberRange.new(2, 5)
				particles.Rate = 100
				particles.SpreadAngle = Vector2.new(45, 45)
				particles.Speed = NumberRange.new(5, 15)
				particles.Size = NumberSequence.new{
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				}
				particles.Parent = attachment
			end
		end
		print("Particles ejecutado por " .. player.Name)
	end, 14)

	createButton("UnAnchor All", function()
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				obj.Anchored = false
			end
		end
		print("UnAnchor All ejecutado por " .. player.Name)
	end, 15)

	createButton("Clear Workspace", function()
		for _, obj in pairs(workspace:GetChildren()) do
			if obj ~= workspace.CurrentCamera and not Players:GetPlayerFromCharacter(obj) then
				obj:Destroy()
			end
		end
		print("Clear Workspace ejecutado por " .. player.Name)
	end, 16)

	createButton("Baseplate", function()
		local baseplate = Instance.new("Part")
		baseplate.Name = "Baseplate"
		baseplate.Size = Vector3.new(512, 20, 512)
		baseplate.Position = Vector3.new(0, -10, 0)
		baseplate.Anchored = true
		baseplate.BrickColor = BrickColor.new("Bright green")
		baseplate.Material = Enum.Material.Grass
		baseplate.Parent = workspace
		print("Baseplate ejecutado por " .. player.Name)
	end, 17)

	createButton("Spam Bricks", function()
		for i = 1, 20 do
			local brick = Instance.new("Part")
			brick.Size = Vector3.new(4, 4, 4)
			brick.Position = Vector3.new(math.random(-50, 50), 20, math.random(-50, 50))
			brick.BrickColor = BrickColor.Random()
			brick.Parent = workspace

			for _, face in pairs(Enum.NormalId:GetEnumItems()) do
				local decal = Instance.new("Decal")
				decal.Texture = CUSTOM_IMAGE_ID
				decal.Face = face
				decal.Transparency = 0.3
				decal.Parent = brick
			end
		end
		print("Spam Bricks ejecutado por " .. player.Name)
	end, 18)

	createButton("Image Flood", function()
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
				for _, face in pairs(Enum.NormalId:GetEnumItems()) do
					local decal = Instance.new("Decal")
					decal.Texture = CUSTOM_IMAGE_ID
					decal.Face = face
					decal.Parent = obj
				end
			end
		end
		print("Image Flood ejecutado por " .. player.Name)
	end, 19)

	createButton("Image Rain", function()
		spawn(function()
			for i = 1, 30 do
				local part = Instance.new("Part")
				part.Size = Vector3.new(2, 2, 0.1)
				part.Position = Vector3.new(math.random(-100, 100), 100, math.random(-100, 100))
				part.CanCollide = false
				part.Parent = workspace

				local decal = Instance.new("Decal")
				decal.Texture = CUSTOM_IMAGE_ID
				decal.Face = Enum.NormalId.Front
				decal.Parent = part

				local bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
				bodyVelocity.Velocity = Vector3.new(0, -50, 0)
				bodyVelocity.Parent = part

				game:GetService("Debris"):AddItem(part, 10)
				wait(0.1)
			end
		end)
		print("Image Rain ejecutado por " .. player.Name)
	end, 20)

	createButton("Replace Sun", function()
		Lighting.SunAngularSize = 50
		Lighting.SunSize = 50

		local fakeSun = Instance.new("Part")
		fakeSun.Name = "CustomSun"
		fakeSun.Size = Vector3.new(100, 100, 100)
		fakeSun.Shape = Enum.PartType.Ball
		fakeSun.Material = Enum.Material.Neon
		fakeSun.BrickColor = BrickColor.new("Bright yellow")
		fakeSun.Anchored = true
		fakeSun.CanCollide = false
		fakeSun.Position = Vector3.new(0, 500, 0)
		fakeSun.Parent = workspace

		for _, face in pairs(Enum.NormalId:GetEnumItems()) do
			local decal = Instance.new("Decal")
			decal.Texture = CUSTOM_IMAGE_ID
			decal.Face = face
			decal.Transparency = 0.3
			decal.Parent = fakeSun
		end

		local pointLight = Instance.new("PointLight")
		pointLight.Brightness = 2
		pointLight.Range = 1000
		pointLight.Color = Color3.fromRGB(255, 255, 0)
		pointLight.Parent = fakeSun

		spawn(function()
			while fakeSun.Parent do
				fakeSun.CFrame = fakeSun.CFrame * CFrame.Angles(0, math.rad(1), 0)
				wait(0.1)
			end
		end)

		Lighting.Brightness = 3
		Lighting.Ambient = Color3.fromRGB(255, 200, 100)
		Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 0)
		print("Replace Sun ejecutado por " .. player.Name)
	end, 21)

	createButton("Solar Eclipse", function()
		local originalBrightness = Lighting.Brightness
		local originalAmbient = Lighting.Ambient

		spawn(function()
			for i = 1, 20 do
				Lighting.Brightness = originalBrightness * (1 - i/20)
				Lighting.Ambient = Color3.lerp(originalAmbient, Color3.fromRGB(50, 0, 50), i/20)
				wait(0.2)
			end

			local eclipse = Instance.new("Part")
			eclipse.Name = "Eclipse"
			eclipse.Size = Vector3.new(200, 200, 1)
			eclipse.Position = Vector3.new(0, 300, 0)
			eclipse.Anchored = true
			eclipse.CanCollide = false
			eclipse.Transparency = 0.3
			eclipse.BrickColor = BrickColor.new("Really black")
			eclipse.Parent = workspace

			local eclipseDecal = Instance.new("Decal")
			eclipseDecal.Texture = CUSTOM_IMAGE_ID
			eclipseDecal.Face = Enum.NormalId.Front
			eclipseDecal.Parent = eclipse

			local selectionBox = Instance.new("SelectionBox")
			selectionBox.Adornee = eclipse
			selectionBox.Color3 = Color3.fromRGB(255, 0, 0)
			selectionBox.LineThickness = 5
			selectionBox.Transparency = 0.5
			selectionBox.Parent = eclipse

			wait(5)

			for i = 1, 20 do
				Lighting.Brightness = originalBrightness * (i/20)
				Lighting.Ambient = Color3.lerp(Color3.fromRGB(50, 0, 50), originalAmbient, i/20)
				wait(0.2)
			end

			eclipse:Destroy()
		end)
		print("Solar Eclipse ejecutado por " .. player.Name)
	end, 22)

	createButton("Sun Explosion", function()
		for i = 1, 8 do
			local explodingSun = Instance.new("Part")
			explodingSun.Name = "ExplodingSun" .. i
			explodingSun.Size = Vector3.new(50, 50, 50)
			explodingSun.Shape = Enum.PartType.Ball
			explodingSun.Material = Enum.Material.Neon
			explodingSun.BrickColor = BrickColor.new("Bright orange")
			explodingSun.Anchored = true
			explodingSun.CanCollide = false
			explodingSun.Position = Vector3.new(0, 400, 0)
			explodingSun.Parent = workspace

			for _, face in pairs(Enum.NormalId:GetEnumItems()) do
				local decal = Instance.new("Decal")
				decal.Texture = CUSTOM_IMAGE_ID
				decal.Face = face
				decal.Parent = explodingSun
			end

			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

			local angle = (i / 8) * math.pi * 2
			local direction = Vector3.new(
				math.cos(angle) * 100,
				math.random(-20, 50),
				math.sin(angle) * 100
			)

			bodyVelocity.Velocity = direction
			bodyVelocity.Parent = explodingSun

			spawn(function()
				while explodingSun.Parent do
					explodingSun.CFrame = explodingSun.CFrame * CFrame.Angles(
						math.rad(10), math.rad(10), math.rad(10)
					)
					explodingSun.Size = explodingSun.Size + Vector3.new(0.5, 0.5, 0.5)
					wait(0.1)
				end
			end)

			game:GetService("Debris"):AddItem(explodingSun, 10)
		end

		spawn(function()
			for i = 1, 30 do
				Lighting.Brightness = math.random(0, 5)
				Lighting.Ambient = Color3.fromHSV(math.random(), 1, 1)
				wait(0.1)
			end
			Lighting.Brightness = 2
			Lighting.Ambient = Color3.fromRGB(138, 138, 138)
		end)
		print("Sun Explosion ejecutado por " .. player.Name)
	end, 23)

	createButton("Image Tornado", function()
		local center = Vector3.new(0, 10, 0)
		local radius = 20
		local height = 50

		spawn(function()
			for i = 1, 50 do
				local angle = (i / 50) * math.pi * 4
				local x = center.X + math.cos(angle) * radius
				local z = center.Z + math.sin(angle) * radius
				local y = center.Y + (i / 50) * height

				local part = Instance.new("Part")
				part.Size = Vector3.new(3, 3, 0.1)
				part.Position = Vector3.new(x, y, z)
				part.Anchored = true
				part.CanCollide = false
				part.Parent = workspace

				local decal = Instance.new("Decal")
				decal.Texture = CUSTOM_IMAGE_ID
				decal.Face = Enum.NormalId.Front
				decal.Parent = part

				spawn(function()
					while part.Parent do
						part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(5), 0)
						wait(0.1)
					end
				end)

				game:GetService("Debris"):AddItem(part, 15)
				wait(0.1)
			end
		end)
		print("Image Tornado ejecutado por " .. player.Name)
	end, 24)

	createButton("Image Explosion", function()
		local center = Vector3.new(0, 20, 0)

		for i = 1, 30 do
			local part = Instance.new("Part")
			part.Size = Vector3.new(2, 2, 0.1)
			part.Position = center
			part.CanCollide = false
			part.Parent = workspace

			local decal = Instance.new("Decal")
			decal.Texture = CUSTOM_IMAGE_ID
			decal.Face = Enum.NormalId.Front
			decal.Parent = part

			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

			local direction = Vector3.new(
				math.random(-100, 100),
				math.random(20, 100),
				math.random(-100, 100)
			).Unit * math.random(30, 80)

			bodyVelocity.Velocity = direction
			bodyVelocity.Parent = part

			spawn(function()
				while part.Parent do
					part.CFrame = part.CFrame * CFrame.Angles(
						math.rad(math.random(-10, 10)),
						math.rad(math.random(-10, 10)),
						math.rad(math.random(-10, 10))
					)
					wait(0.1)
				end
			end)

			game:GetService("Debris"):AddItem(part, 8)
		end
		print("Image Explosion ejecutado por " .. player.Name)
	end, 25)

	createButton("Replace All Textures", function()
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Texture = CUSTOM_IMAGE_ID
			elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
				obj.Image = CUSTOM_IMAGE_ID
			elseif obj:IsA("Sky") then
				obj.SkyboxBk = CUSTOM_IMAGE_ID
				obj.SkyboxDn = CUSTOM_IMAGE_ID
				obj.SkyboxFt = CUSTOM_IMAGE_ID
				obj.SkyboxLf = CUSTOM_IMAGE_ID
				obj.SkyboxRt = CUSTOM_IMAGE_ID
				obj.SkyboxUp = CUSTOM_IMAGE_ID
			end
		end
		print("Replace All Textures ejecutado por " .. player.Name)
	end, 26)

	createButton("666", function()
		Lighting.Ambient = Color3.fromRGB(255, 0, 0)
		Lighting.Brightness = 0

		stopAllSounds()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://131961136"
		sound.Volume = 1
		sound.Parent = workspace
		sound:Play()

		-- Crear efectos visuales para todos los jugadores
		for _, targetPlayer in pairs(Players:GetPlayers()) do
			if targetPlayer.Character then
				spawn(function()
					local targetPlayerGui = targetPlayer:FindFirstChild("PlayerGui")
					if targetPlayerGui then
						for i = 1, 5 do
							local gui = Instance.new("ScreenGui")
							gui.Parent = targetPlayerGui

							local imageLabel = Instance.new("ImageLabel")
							imageLabel.Size = UDim2.new(0.3, 0, 0.3, 0)
							imageLabel.Position = UDim2.new(math.random(0, 70)/100, 0, math.random(0, 70)/100, 0)
							imageLabel.Image = CUSTOM_IMAGE_ID
							imageLabel.BackgroundTransparency = 1
							imageLabel.Parent = gui

							spawn(function()
								while imageLabel.Parent do
									for rotation = 0, 360, 10 do
										if imageLabel.Parent then
											imageLabel.Rotation = rotation
											wait(0.05)
										end
									end
								end
							end)

							game:GetService("Debris"):AddItem(gui, 10)
						end
					end
				end)
			end
		end
		print("666 ejecutado por " .. player.Name)
	end, 27)

	-- Actualizar tamaño del scroll
	local function updateScrollSize()
		local contentSize = listLayout.AbsoluteContentSize
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 10)
	end

	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollSize)
	updateScrollSize()

	-- Funcionalidad del botón cerrar
	closeButton.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)

	-- Mensaje de bienvenida con tu imagen (solo para el jugador autorizado)
	local welcomeGui = Instance.new("ScreenGui")
	welcomeGui.Parent = playerGui

	local welcomeFrame = Instance.new("Frame")
	welcomeFrame.Size = UDim2.new(0, 350, 0, 150)
	welcomeFrame.Position = UDim2.new(0.5, -175, 0.5, -75)
	welcomeFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	welcomeFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
	welcomeFrame.BorderSizePixel = 2
	welcomeFrame.Parent = welcomeGui

	local welcomeImage = Instance.new("ImageLabel")
	welcomeImage.Size = UDim2.new(0, 80, 0, 80)
	welcomeImage.Position = UDim2.new(0, 10, 0, 10)
	welcomeImage.Image = CUSTOM_IMAGE_ID
	welcomeImage.BackgroundTransparency = 1
	welcomeImage.Parent = welcomeFrame

	local welcomeText = Instance.new("TextLabel")
	welcomeText.Size = UDim2.new(1, -100, 1, 0)
	welcomeText.Position = UDim2.new(0, 100, 0, 0)
	welcomeText.BackgroundTransparency = 1
	welcomeText.Text = "c00lkidd's GUI Loaded!\nPress buttons to hack!\nCustom image ready!\nServer-side functions active!"
	welcomeText.TextColor3 = Color3.fromRGB(255, 0, 0)
	welcomeText.TextSize = 12
	welcomeText.Font = Enum.Font.Arial
	welcomeText.TextWrapped = true
	welcomeText.Parent = welcomeFrame

	spawn(function()
		while welcomeImage.Parent do
			for i = 0, 360, 5 do
				if welcomeImage.Parent then
					welcomeImage.Rotation = i
					wait(0.02)
				end
			end
		end
	end)

	game:GetService("Debris"):AddItem(welcomeGui, 5)

	print("c00lkidd's GUI loaded successfully for " .. player.Name .. " (ID: " .. player.UserId .. ")")
	print("Custom image: " .. CUSTOM_IMAGE_ID)
	print("All functions affect the entire server!")
end

-- Conectar eventos para cuando los jugadores se unan
Players.PlayerAdded:Connect(function(player)
	-- Esperar a que el jugador cargue completamente
	player.CharacterAdded:Connect(function()
		wait(2) -- Esperar un poco para asegurar que PlayerGui esté listo
		createGUIForPlayer(player)
	end)

	-- Si el jugador ya tiene un personaje cuando se conecta
	if player.Character then
		wait(2)
		createGUIForPlayer(player)
	end
end)

-- Para jugadores que ya están en el servidor cuando se ejecuta el script
for _, player in pairs(Players:GetPlayers()) do
	spawn(function()
		wait(1)
		createGUIForPlayer(player)
	end)
end

print("c00lkidd Server Script iniciado")
print("GUI solo visible para el jugador con ID: " .. AUTHORIZED_USER_ID)
print("Todas las funciones afectan al servidor completo")
print("Esperando jugadores...")
