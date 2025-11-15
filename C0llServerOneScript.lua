--// MOD DE PRUEBA ANTI-HACK (SOLO STUDIO / TU JUEGO)
-- ⚠️ SOLO PARA TESTEAR TU SISTEMA, NO LO USES EN JUEGOS AJENOS ⚠️
-- Teclas:
--   Z -> Toggle SUPER SPEED
--   X -> Toggle FLY / FLOTE
--   C -> Toggle TP SPAM (teleports locos hacia delante)
--   V -> Toggle NOCLIP (partes del personaje sin colisión)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

local character
local humanoid
local hrp

local superSpeedEnabled = false
local flyEnabled = false
local tpSpamEnabled = false
local noclipEnabled = false

local defaultWalkSpeed = 16
local lastTpTime = 0

local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")

	defaultWalkSpeed = humanoid.WalkSpeed

	superSpeedEnabled = false
	flyEnabled = false
	tpSpamEnabled = false
	noclipEnabled = false

	print("[TEST MOD] Character listo para testear anti-hack.")
end

if localPlayer.Character then
	setupCharacter(localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(setupCharacter)

-- Toggle helpers
local function toggleSuperSpeed()
	superSpeedEnabled = not superSpeedEnabled
	if not superSpeedEnabled and humanoid then
		humanoid.WalkSpeed = defaultWalkSpeed
	end
	print("[TEST MOD] SuperSpeed:", superSpeedEnabled)
end

local function toggleFly()
	flyEnabled = not flyEnabled
	print("[TEST MOD] Fly:", flyEnabled)
end

local function toggleTpSpam()
	tpSpamEnabled = not tpSpamEnabled
	lastTpTime = 0
	print("[TEST MOD] TP Spam:", tpSpamEnabled)
end

local function toggleNoclip()
	noclipEnabled = not noclipEnabled
	print("[TEST MOD] Noclip:", noclipEnabled)

	-- Cuando se apaga, intentamos restaurar colisiones básicas del character
	if not noclipEnabled and character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				-- En un rig R15 muchas partes ya vienen con CanCollide=false por defecto
				-- No pasa nada si queda así para pruebas.
				if part.Name == "HumanoidRootPart" then
					part.CanCollide = true
				end
			end
		end
	end
end

-- Input (Z, X, C, V)
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

	local key = input.KeyCode

	if key == Enum.KeyCode.Z then
		toggleSuperSpeed()
	elseif key == Enum.KeyCode.X then
		toggleFly()
	elseif key == Enum.KeyCode.C then
		toggleTpSpam()
	elseif key == Enum.KeyCode.V then
		toggleNoclip()
	end
end)

-- Loop principal del "mod hacker"
RunService.RenderStepped:Connect(function(dt)
	if not character or not humanoid or not hrp then
		return
	end

	-- SUPER SPEED (debería disparar tu anti-speed > 40)
	if superSpeedEnabled then
		-- mete una velocidad bestial
		humanoid.WalkSpeed = 80
	else
		humanoid.WalkSpeed = defaultWalkSpeed
	end

	-- NOCLIP (intenta atravesar paredes → tu anti-wallhack debería responder)
	if noclipEnabled then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end

	-- FLY / FLOTE (tu anti-fly debería tumbar esto si se queda flotando mucho)
	if flyEnabled then
		-- Lo mantenemos flotando suave
		local vel = hrp.AssemblyLinearVelocity
		hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 0.1, vel.Z)
	end

	-- TP SPAM (teleports rápidos hacia adelante, para ver si tu sistema los acepta o los corrige)
	if tpSpamEnabled then
		lastTpTime = lastTpTime + dt
		if lastTpTime >= 0.7 then
			lastTpTime = 0
			-- Teleport 20 studs hacia donde mira el player
			local forward = hrp.CFrame.LookVector
			hrp.CFrame = hrp.CFrame + forward * 20
			print("[TEST MOD] TP adelante 20 studs")
		end
	end
end)
