-- LocalScript: DebugHackPanel
-- Solo para pruebas en TU juego en Studio

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

if not RunService:IsStudio() then
	script:Destroy()
	return
end

local player = Players.LocalPlayer

-- ============ CONFIG TEST ============

local FLY_SPEED = 60

-- Estos deben coincidir con tus valores default del juego:
local DEFAULT_WALKSPEED = 16
local DEFAULT_JUMPPOWER = 50

-- Valores de hack
local SPEED_HACK_WALKSPEED = 60
local JUMP_HACK_POWER = 120

-- ============ ESTADO ============

local wallhackEnabled = false
local flyEnabled = false
local noclipFlyEnabled = false
local speedHackEnabled = false
local jumpHackEnabled = false

local wallhackConn
local flyConn

local flyVerticalInput = 0

local baseWalkSpeed = DEFAULT_WALKSPEED
local baseJumpPower = DEFAULT_JUMPPOWER

-- ============ UI ============

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DebugHackPanel"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.AnchorPoint = Vector2.new(0, 0)
frame.Position = UDim2.fromOffset(20, 100)
frame.Size = UDim2.fromOffset(240, 230)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Parent = frame
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(10, 6)
title.Size = UDim2.new(1, -20, 0, 20)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Debug Hack Panel"

local function createButton(y, text)
	local btn = Instance.new("TextButton")
	btn.Parent = frame
	btn.Position = UDim2.fromOffset(10, y)
	btn.Size = UDim2.new(1, -20, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.AutoButtonColor = false

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = btn

	return btn
end

local wallhackButton = createButton(34, "Wallhack: OFF")
local flyButton      = createButton(68, "Fly: OFF")
local noclipFlyButton= createButton(102, "Noclip Fly: OFF")
local speedHackButton= createButton(136, "Speed Hack: OFF")
local jumpHackButton = createButton(170, "Jump Hack: OFF")

local hint = Instance.new("TextLabel")
hint.Parent = frame
hint.BackgroundTransparency = 1
hint.Position = UDim2.fromOffset(10, 204)
hint.Size = UDim2.new(1, -20, 0, 20)
hint.Font = Enum.Font.Gotham
hint.TextSize = 12
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.TextColor3 = Color3.fromRGB(180, 180, 180)
hint.Text = "Fly: WASD + Espacio (subir) + Ctrl/Shift (bajar)"

-- ============ UTIL ============

local function getHumanoid()
	local char = player.Character
	if not char then return nil, nil end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	return humanoid, hrp
end

local function applyCharacterCollision()
	local char = player.Character
	if not char then return end

	local shouldNoclip = wallhackEnabled or noclipFlyEnabled

	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not shouldNoclip
		end
	end
end

local function updateButtons()
	-- Wallhack
	if wallhackEnabled then
		wallhackButton.Text = "Wallhack: ON"
		wallhackButton.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
	else
		wallhackButton.Text = "Wallhack: OFF"
		wallhackButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
	end

	-- Fly
	if flyEnabled and not noclipFlyEnabled then
		flyButton.Text = "Fly: ON"
		flyButton.BackgroundColor3 = Color3.fromRGB(70, 140, 200)
	elseif flyEnabled and noclipFlyEnabled then
		flyButton.Text = "Fly: ON (Noclip)"
		flyButton.BackgroundColor3 = Color3.fromRGB(120, 160, 220)
	else
		flyButton.Text = "Fly: OFF"
		flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
	end

	-- Noclip Fly
	if noclipFlyEnabled then
		noclipFlyButton.Text = "Noclip Fly: ON"
		noclipFlyButton.BackgroundColor3 = Color3.fromRGB(180, 100, 60)
	else
		noclipFlyButton.Text = "Noclip Fly: OFF"
		noclipFlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
	end

	-- Speed Hack
	if speedHackEnabled then
		speedHackButton.Text = "Speed Hack: ON"
		speedHackButton.BackgroundColor3 = Color3.fromRGB(90, 180, 90)
	else
		speedHackButton.Text = "Speed Hack: OFF"
		speedHackButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
	end

	-- Jump Hack
	if jumpHackEnabled then
		jumpHackButton.Text = "Jump Hack: ON"
		jumpHackButton.BackgroundColor3 = Color3.fromRGB(200, 140, 60)
	else
		jumpHackButton.Text = "Jump Hack: OFF"
		jumpHackButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
	end
end

-- ============ HACKS DE PROPIEDAD (SPEED/JUMP) ============

local function applySpeedHack()
	local humanoid = getHumanoid()
	if not humanoid then return end

	if speedHackEnabled then
		humanoid.WalkSpeed = SPEED_HACK_WALKSPEED
	else
		humanoid.WalkSpeed = baseWalkSpeed
	end
end

local function applyJumpHack()
	local humanoid = getHumanoid()
	if not humanoid then return end

	if jumpHackEnabled then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = JUMP_HACK_POWER
	else
		humanoid.UseJumpPower = true
		humanoid.JumpPower = baseJumpPower
	end
end

-- ============ WALLHACK / FLY ============

local function setWallhack(enabled)
	wallhackEnabled = enabled
	updateButtons()

	if wallhackConn then
		wallhackConn:Disconnect()
		wallhackConn = nil
	end

	if enabled then
		wallhackConn = RunService.Stepped:Connect(function()
			applyCharacterCollision()
		end)
	else
		if not noclipFlyEnabled then
			applyCharacterCollision()
		end
	end
end

local function stopFlyMovement()
	local humanoid, hrp = getHumanoid()
	if humanoid then
		humanoid.PlatformStand = false
	end
	if hrp then
		hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	end
end

local function setFly(enabled)
	flyEnabled = enabled
	if not enabled then
		noclipFlyEnabled = false
	end
	updateButtons()

	if flyConn then
		flyConn:Disconnect()
		flyConn = nil
	end

	if not enabled then
		stopFlyMovement()
		applyCharacterCollision()
		return
	end

	flyConn = RunService.RenderStepped:Connect(function()
		local humanoid, hrp = getHumanoid()
		if not humanoid or not hrp then return end

		humanoid.PlatformStand = true

		local horizontal = humanoid.MoveDirection
		local dir = horizontal

		if flyVerticalInput ~= 0 then
			dir = Vector3.new(horizontal.X, flyVerticalInput, horizontal.Z)
		end

		if dir.Magnitude > 0 then
			dir = dir.Unit
			hrp.AssemblyLinearVelocity = dir * FLY_SPEED
		else
			hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		end

		if noclipFlyEnabled or wallhackEnabled then
			applyCharacterCollision()
		end
	end)
end

local function setNoclipFly(enabled)
	noclipFlyEnabled = enabled

	if enabled and not flyEnabled then
		setFly(true)
	else
		updateButtons()
		applyCharacterCollision()
	end
end

-- ============ INPUT VERTICAL FLY ============

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.KeyCode == Enum.KeyCode.Space then
		flyVerticalInput = 1
	elseif input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.LeftShift then
		flyVerticalInput = -1
	end
end)

UserInputService.InputEnded:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.Space
		or input.KeyCode == Enum.KeyCode.LeftControl
		or input.KeyCode == Enum.KeyCode.LeftShift then
		flyVerticalInput = 0
	end
end)

-- ============ BOTONES ============

wallhackButton.MouseButton1Click:Connect(function()
	setWallhack(not wallhackEnabled)
end)

flyButton.MouseButton1Click:Connect(function()
	setFly(not flyEnabled)
end)

noclipFlyButton.MouseButton1Click:Connect(function()
	setNoclipFly(not noclipFlyEnabled)
end)

speedHackButton.MouseButton1Click:Connect(function()
	speedHackEnabled = not speedHackEnabled
	applySpeedHack()
	updateButtons()
end)

jumpHackButton.MouseButton1Click:Connect(function()
	jumpHackEnabled = not jumpHackEnabled
	applyJumpHack()
	updateButtons()
end)

-- ============ CHARACTER HANDLER ============

player.CharacterAdded:Connect(function(char)
	task.wait(0.2)
	local humanoid = char:WaitForChild("Humanoid", 5)
	if humanoid then
		baseWalkSpeed = humanoid.WalkSpeed
		if humanoid.UseJumpPower then
			baseJumpPower = humanoid.JumpPower
		else
			humanoid.UseJumpPower = true
			baseJumpPower = DEFAULT_JUMPPOWER
			humanoid.JumpPower = baseJumpPower
		end
	end

	applyCharacterCollision()
	applySpeedHack()
	applyJumpHack()

	if wallhackEnabled then
		setWallhack(true)
	end
	if flyEnabled then
		setFly(true)
	end
end)

-- Inicial si ya existe character
if player.Character then
	player.CharacterAdded:Wait()
end

updateButtons()
