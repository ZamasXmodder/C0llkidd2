-- Panel de Invisibilidad Básico
-- LocalScript dentro de StarterGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Net = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages").Net)

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InvisibilityPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Crear Frame (contenedor del panel)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50) -- Centrado en pantalla
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Estilo básico del Frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0, 255, 0)
uiStroke.Parent = frame

-- Crear botón Invisible Steal
local button = Instance.new("TextButton")
button.Name = "InvisibleStealButton"
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Invisible Steal"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

-- Funcionalidad del botón
button.MouseButton1Click:Connect(function()
	print("[Panel] Activando invisibilidad...")

	-- Llamamos al RemoteFunction RF/UseItem
	local success
	local ok, err = pcall(function()
		success = Net:Invoke("UseItem")
	end)

	if ok and success then
		print("[Panel] Ahora eres invisible!")
	else
		warn("[Panel] No se pudo activar la invisibilidad:", err or "El servidor no devolvió nada")
	end
end)
