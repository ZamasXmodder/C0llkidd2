--// LocalToolDuplicatorUI (LocalScript) - StarterPlayerScripts
--// DUPLICACION SOLO LOCAL: no replica al servidor ni a otros jugadores.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =========================
-- UI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "LocalToolDuplicatorUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Panel"
frame.AnchorPoint = Vector2.new(0.5, 1)
frame.Position = UDim2.fromScale(0.5, 0.92)
frame.Size = UDim2.fromOffset(360, 150)
frame.BackgroundTransparency = 0.15
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
frame.Visible = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Transparency = 0.35
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(14, 10)
title.Size = UDim2.new(1, -28, 0, 26)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Duplicar Tool (solo local)"
title.Parent = frame

local hint = Instance.new("TextLabel")
hint.Name = "Hint"
hint.BackgroundTransparency = 1
hint.Position = UDim2.fromOffset(14, 38)
hint.Size = UDim2.new(1, -28, 0, 20)
hint.Font = Enum.Font.Gotham
hint.TextSize = 13
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.TextColor3 = Color3.fromRGB(200, 200, 210)
hint.Text = "RightShift: mostrar/ocultar"
hint.Parent = frame

local selectedLabel = Instance.new("TextLabel")
selectedLabel.Name = "SelectedLabel"
selectedLabel.BackgroundTransparency = 1
selectedLabel.Position = UDim2.fromOffset(14, 62)
selectedLabel.Size = UDim2.new(1, -28, 0, 22)
selectedLabel.Font = Enum.Font.GothamMedium
selectedLabel.TextSize = 14
selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
selectedLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
selectedLabel.Text = "Tool seleccionado: (ninguno)"
selectedLabel.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.fromOffset(14, 86)
statusLabel.Size = UDim2.new(1, -28, 0, 18)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextColor3 = Color3.fromRGB(170, 170, 185)
statusLabel.Text = "Estado: listo"
statusLabel.Parent = frame

local dupBtn = Instance.new("TextButton")
dupBtn.Name = "DuplicateButton"
dupBtn.AnchorPoint = Vector2.new(0.5, 1)
dupBtn.Position = UDim2.new(0.5, 0, 1, -14)
dupBtn.Size = UDim2.fromOffset(330, 38)
dupBtn.AutoButtonColor = true
dupBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
dupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dupBtn.Font = Enum.Font.GothamBold
dupBtn.TextSize = 15
dupBtn.Text = "DUPLICAR TOOL SELECCIONADO (LOCAL)"
dupBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = dupBtn

-- =========================
-- Logica de Tool seleccionado
-- =========================
local function getCharacter()
	return player.Character
end

local function getBackpack()
	return player:FindFirstChildOfClass("Backpack")
end

local function getSelectedTool()
	-- “Seleccionado” = Tool equipado (en Character). Si no hay, toma uno del Backpack.
	local char = getCharacter()
	if char then
		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("Tool") then
				return child
			end
		end
	end

	local bp = getBackpack()
	if bp then
		for _, child in ipairs(bp:GetChildren()) do
			if child:IsA("Tool") then
				return child
			end
		end
	end

	return nil
end

local function getUniqueName(backpack, baseName)
	if not backpack:FindFirstChild(baseName) then
		return baseName
	end
	local i = 2
	while backpack:FindFirstChild(string.format("%s (Copia %d)", baseName, i)) do
		i += 1
	end
	return string.format("%s (Copia %d)", baseName, i)
end

local lastDup = 0
local DUP_COOLDOWN = 0.35

dupBtn.MouseButton1Click:Connect(function()
	local now = os.clock()
	if now - lastDup < DUP_COOLDOWN then
		statusLabel.Text = "Estado: espera un momento…"
		return
	end
	lastDup = now

	local tool = getSelectedTool()
	local bp = getBackpack()

	if not bp then
		statusLabel.Text = "Estado: no se encontro Backpack."
		return
	end
	if not tool then
		statusLabel.Text = "Estado: no hay Tool para duplicar."
		return
	end

	-- Clonado local
	local ok, cloneOrErr = pcall(function()
		tool.Archivable = true
		local clone = tool:Clone()
		clone.Name = getUniqueName(bp, tool.Name)
		clone.Parent = bp
		return clone
	end)

	if ok then
		statusLabel.Text = "Estado: duplicado local -> " .. cloneOrErr.Name
	else
		statusLabel.Text = "Estado: error duplicando -> " .. tostring(cloneOrErr)
	end
end)

-- UI: actualizar label en vivo
RunService.RenderStepped:Connect(function()
	local tool = getSelectedTool()
	if tool then
		selectedLabel.Text = "Tool seleccionado: " .. tool.Name
	else
		selectedLabel.Text = "Tool seleccionado: (ninguno)"
	end
end)

-- Toggle panel
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)