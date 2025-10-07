--// Roblox — Single Script Halloween Login (Luau)
--// Title: "Lennon X Zamas - Steal a brainrot v1.4"
--// Un solo script (cliente) para ejecutarse vía loadstring().
--// Panel con 1 contraseña (key), botones: [Get Key] y [Submit], temática Halloween.
--// NOTA: Validación 100% cliente. Para seguridad real, valida en servidor.

-- =============== CONFIG ==================
local TITLE = "Lennon X Zamas - Steal a brainrot v1.4"
local VALID_KEY = "TRICK-OR-TREAT-2025" -- Cambia tu key aquí
local GET_KEY_URL = "https://example.com/getkey" -- Pon tu URL de key aquí
-- =========================================

-- Utilidades seguras (compatibles con ejecutores y vanilla)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

local function safeParent()
	-- Prioriza PlayerGui; si el ejecutor lo permite, podría usar CoreGui
	local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui")
	return pg
end

local function setClipboard(text)
	-- intenta usar setclipboard si existe
	local ok, err = pcall(function()
		(local setcb or setclipboard or (typeof(Syn ~= nil) and Syn ~= nil and Syn.setclipboard)) (text)
	end)
	return ok
end

-- Limpia instancias previas
local guiName = "HalloweenLogin_v14"
for _,g in ipairs(safeParent():GetChildren()) do
	if g:IsA("ScreenGui") and g.Name == guiName then g:Destroy() end
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
if gethui then
	-- si el ejecutor soporta gethui(), evita interferencias
	gui.Parent = gethui()
else
	gui.Parent = safeParent()
end
gui.Name = guiName

-- Contenedor raíz
local root = Instance.new("Frame")
root.Size = UDim2.fromScale(1,1)
root.BackgroundColor3 = Color3.new(0,0,0)
root.BackgroundTransparency = 1
root.Parent = gui

-- Fondo cielo
local sky = Instance.new("Frame")
sky.Size = UDim2.fromScale(1,1)
sky.BackgroundColor3 = Color3.fromRGB(5,5,14)
sky.Parent = root

local skyGrad = Instance.new("UIGradient")
skyGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(11,11,20)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,0,0))
})
skyGrad.Rotation = 270
skyGrad.Parent = sky

-- Relámpagos
local flash = Instance.new("Frame")
flash.Size = UDim2.fromScale(1,1)
flash.BackgroundColor3 = Color3.new(1,1,1)
flash.BackgroundTransparency = 1
flash.ZIndex = 5
flash.Parent = root

-- Suelo
local ground = Instance.new("Frame")
ground.Size = UDim2.new(1,0,0,110)
ground.Position = UDim2.new(0,0,1,-110)
ground.BackgroundColor3 = Color3.fromRGB(10,10,10)
local ggrad = Instance.new("UIGradient", ground)
ggrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(18,18,18)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(5,5,5)),
}

ground.Parent = root

-- Casas (siluetas)
local village = Instance.new("Frame")
village.BackgroundTransparency = 1
village.Size = UDim2.new(1,0,0,180)
village.Position = UDim2.new(0,0,1,-(110+180))
village.Parent = root

local function makeHouse(x, w, h)
	local base = Instance.new("Frame")
	base.BackgroundColor3 = Color3.fromRGB(12,12,12)
	base.Size = UDim2.new(0,w,0,h)
	base.Position = UDim2.new(0,x,1,-h)
	base.BorderSizePixel = 0
	base.Parent = village
	local roof = Instance.new("Frame")
	roof.BackgroundColor3 = Color3.fromRGB(15,15,15)
	roof.Size = UDim2.new(0,w+20,0,36)
	roof.Position = UDim2.new(0,x-10,1,-(h+36))
	roof.BorderSizePixel = 0
	roof.Parent = village
	local uic = Instance.new("UICorner", base); uic.CornerRadius = UDim.new(0,2)
end

makeHouse(40,120,110)
makeHouse(220,140,120)
makeHouse(420,120,112)
makeHouse(700,160,128)
makeHouse(860,140,118)

-- Lluvia
local rainFolder = Instance.new("Folder", root)
rainFolder.Name = "Rain"
local drops = {}
local function newDrop()
	local d = Instance.new("Frame")
	d.Size = UDim2.new(0,1,0,math.random(10,28))
	d.Position = UDim2.new(0, math.random(-10, sky.AbsoluteSize.X+10), 0, math.random(-sky.AbsoluteSize.Y, -10))
	d.BackgroundColor3 = Color3.fromRGB(220,220,255)
	d.BackgroundTransparency = 0.35
	d.BorderSizePixel = 0
	d.Parent = rainFolder
	return d
end
for i=1,220 do drops[i] = newDrop() end

-- Fantasmas
local ghostsFolder = Instance.new("Folder", root)
local function makeGhost(x, y, s)
	local g = Instance.new("Frame")
	g.Size = UDim2.new(0, 60*s, 0, 70*s)
	g.Position = UDim2.new(0, x, 0, y)
	g.BackgroundColor3 = Color3.fromRGB(235,239,250)
	g.BorderSizePixel = 0
	g.BackgroundTransparency = 0.1
	g.Parent = ghostsFolder
	local corner = Instance.new("UICorner", g); corner.CornerRadius = UDim.new(0, 28)
	local eyeL = Instance.new("Frame", g); eyeL.Size = UDim2.new(0,8*s,0,12*s); eyeL.Position = UDim2.new(0,18*s,0,22*s); eyeL.BackgroundColor3 = Color3.new(0,0,0)
	local eyeR = eyeL:Clone(); eyeR.Parent = g; eyeR.Position = UDim2.new(1,-(18*s+8*s),0,22*s)
	local mouth = Instance.new("Frame", g); mouth.Size = UDim2.new(0,14*s,0,10*s); mouth.Position = UDim2.new(0.5,-7*s,0,40*s); mouth.BackgroundColor3 = Color3.new(0,0,0); local mc=Instance.new("UICorner", mouth); mc.CornerRadius=UDim.new(0,8)
	return g
end
local ghost1 = makeGhost(80, 180, 1)
local ghost2 = makeGhost(680, 210, 0.9)
local ghost3 = makeGhost(420, 230, 1.1)

-- Calabazas
local pumpkinsFolder = Instance.new("Folder", root)
local function makePumpkin(x, s)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(0, 70*s, 0, 50*s)
	p.Position = UDim2.new(0, x, 1, - (110 + 50*s))
	p.BackgroundColor3 = Color3.fromRGB(247,127,0)
	p.BorderSizePixel = 0
	p.Parent = pumpkinsFolder
	local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(1,0)
	local glow = Instance.new("Frame", p); glow.BackgroundColor3 = Color3.fromRGB(255, 217, 74); glow.BackgroundTransparency = 0.5; glow.Size = UDim2.new(0, 60*s, 0, 40*s); glow.Position = UDim2.new(0.5, -30*s, 0.5, -20*s); local gc=Instance.new("UICorner", glow); gc.CornerRadius = UDim.new(1,0)
	local eyeL = Instance.new("Frame", p); eyeL.Size = UDim2.new(0,12*s,0,12*s); eyeL.Position = UDim2.new(0, 14*s, 0, 14*s); eyeL.BackgroundColor3 = Color3.fromRGB(255, 217, 74); eyeL.BorderSizePixel = 0
	local eyeR = eyeL:Clone(); eyeR.Parent = p; eyeR.Position = UDim2.new(0, 44*s, 0, 14*s)
	local mouth = Instance.new("Frame", p); mouth.Size = UDim2.new(0, 36*s, 0, 12*s); mouth.Position = UDim2.new(0.5, -18*s, 1, - (10*s + 12*s)); mouth.BackgroundColor3 = Color3.fromRGB(255,217,74); mouth.BorderSizePixel = 0
	return p
end
makePumpkin(120, 1.0)
makePumpkin(320, 1.2)
makePumpkin(640, 0.95)
makePumpkin(840, 1.1)

-- Panel de Login
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 460, 0, 240)
panel.Position = UDim2.new(0.5, -230, 0.5, -120)
panel.BackgroundColor3 = Color3.fromRGB(0,0,0)
panel.BackgroundTransparency = 0.22
panel.BorderSizePixel = 0
panel.Parent = root
local pc = Instance.new("UICorner", panel); pc.CornerRadius = UDim.new(0,16)
local ps = Instance.new("UIStroke", panel); ps.Thickness = 1; ps.Color = Color3.fromRGB(255,255,255); ps.Transparency = 0.92

-- Luces alrededor
local bulbsFolder = Instance.new("Folder", panel)
for i=0, math.floor(460/26) do
	local bulb = Instance.new("Frame")
	bulb.Size = UDim2.new(0,8,0,8)
	bulb.Position = UDim2.new(0, 14 + i*26, 0, 10)
	bulb.BackgroundColor3 = Color3.fromRGB(255, 217, 74)
	bulb.BorderSizePixel = 0
	bulb.Parent = bulbsFolder
	local bcorner = Instance.new("UICorner", bulb); bcorner.CornerRadius = UDim.new(1,0)
	TweenService:Create(bulb, TweenInfo.new(2.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.2}):Play()
end

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -32, 0, 36)
title.Position = UDim2.new(0,16,0,12)
title.BackgroundTransparency = 1
title.Text = TITLE
title.TextColor3 = Color3.fromRGB(255,120,26)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
local ts = Instance.new("UIStroke", title); ts.Color = Color3.fromRGB(139,0,0); ts.Thickness = 1.2
title.Parent = panel

-- Campo KEY
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0, 60, 0, 20)
keyLabel.Position = UDim2.new(0,24,0,72)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Key:"
keyLabel.TextColor3 = Color3.fromRGB(235,235,240)
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextSize = 16
keyLabel.Parent = panel

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -94, 0, 38)
keyBox.Position = UDim2.new(0, 70, 0, 66)
keyBox.BackgroundColor3 = Color3.fromRGB(23,23,23)
keyBox.Text = ""
keyBox.PlaceholderText = "Introduce tu key..."
keyBox.PlaceholderColor3 = Color3.fromRGB(160,160,170)
keyBox.TextColor3 = Color3.fromRGB(245,245,245)
keyBox.ClearTextOnFocus = false
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 18
keyBox.TextXAlignment = Enum.TextXAlignment.Left
keyBox.TextScaled = false
keyBox.Parent = panel
local kc = Instance.new("UICorner", keyBox); kc.CornerRadius = UDim.new(0,10)
local ks = Instance.new("UIStroke", keyBox); ks.Color = Color3.fromRGB(255,122,24); ks.Transparency = 0.6; ks.Thickness = 1

-- Mensaje
local message = Instance.new("TextLabel")
message.BackgroundTransparency = 1
message.Size = UDim2.new(1, -32, 0, 24)
message.Position = UDim2.new(0,16,1,-92)
message.Text = ""
message.TextColor3 = Color3.fromRGB(255,255,255)
message.Font = Enum.Font.Gotham
message.TextSize = 16
message.TextWrapped = true
message.Parent = panel

-- Botones
local function makeBtn(txt, x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,130,0,40)
	b.Position = UDim2.new(0, x, 1, -56)
	b.BackgroundColor3 = Color3.fromRGB(250,167,74)
	b.Text = txt
	b.TextColor3 = Color3.fromRGB(10,10,10)
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 18
	b.AutoButtonColor = false
	local bc = Instance.new("UICorner", b); bc.CornerRadius = UDim.new(0,10)
	local bs = Instance.new("UIStroke", b); bs.Color = Color3.fromRGB(0,0,0); bs.Transparency = 0.15
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {Position = b.Position - UDim2.new(0,0,0,1)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {Position = b.Position + UDim2.new(0,0,0,1)}):Play()
	end)
	return b
end

local btnGet = makeBtn("GET KEY", panel.AbsoluteSize.X) -- Pos luego
local btnSub = makeBtn("SUBMIT", panel.AbsoluteSize.X)
btnGet.Parent, btnSub.Parent = panel, panel

-- Posiciona botones tras 1 frame (panel.AbsoluteSize listo)
RunService.Heartbeat:Wait()
btnGet.Position = UDim2.new(1, -(130*2 + 16 + 24), 1, -56)
btnSub.Position = UDim2.new(1, -(130 + 24), 1, -56)

-- Animación relámpagos aleatorios
spawn(function()
	while gui.Parent do
		wait(math.random(6,12)/2)
		for i=1,2 do
			TweenService:Create(flash, TweenInfo.new(0.06), {BackgroundTransparency = 0.15}):Play()
			wait(0.08)
			flash.BackgroundTransparency = 1
			wait(0.06)
		end
	end
end)

-- Animación fantasmas flotando
spawn(function()
	local t = 0
	while gui.Parent do
		RunService.Heartbeat:Wait()
		t = t + 0.016
		for i,g in ipairs(ghostsFolder:GetChildren()) do
			local base = g.Position
			g.Position = UDim2.new(base.X.Scale, base.X.Offset, base.Y.Scale, base.Y.Offset + math.sin(t*1.5 + i)*0.8)
		end
	end
end)

-- Lluvia en bucle
spawn(function()
	while gui.Parent do
		RunService.Heartbeat:Wait()
		for _,d in ipairs(drops) do
			local pos = d.Position
			local newY = pos.Y.Offset + 720*0.016
			local newX = pos.X.Offset + 80*0.016
			if newY > sky.AbsoluteSize.Y + 10 or newX > sky.AbsoluteSize.X + 10 then
				d.Position = UDim2.new(0, math.random(-10, sky.AbsoluteSize.X), 0, math.random(-sky.AbsoluteSize.Y, -10))
			else
				d.Position = UDim2.new(0, newX, 0, newY)
			end
		end
	end
end)

-- Efecto shake panel
local function shake()
	local o = panel.Position
	for i=1,8 do
		TweenService:Create(panel, TweenInfo.new(0.04), {Position = o + UDim2.new(0, (i%2==0 and -6 or 6), 0, 0)}):Play()
		RunService.Heartbeat:Wait()
	end
	panel.Position = o
end

-- Acciones botones
btnGet.MouseButton1Click:Connect(function()
	local ok = setClipboard(GET_KEY_URL)
	message.Text = ok and "Link copiado al portapapeles" or ("Key URL: "..GET_KEY_URL)
end)

local function grantAccess()
	message.Text = "✔ Acceso concedido — Bienvenido"
	message.TextColor3 = Color3.fromRGB(50,255,150)
	TweenService:Create(panel, TweenInfo.new(0.25), {BackgroundTransparency = 0.6}):Play()
	wait(0.35)
	gui:Destroy()
	-- Aquí ejecuta tu payload
	-- pcall(loadstring(game:HttpGet("https://tu.repo/script.lua")))
end

btnSub.MouseButton1Click:Connect(function()
	local key = keyBox.Text or ""
	if #key == 0 then
		message.Text = "Ingresa una key primero"
		message.TextColor3 = Color3.fromRGB(255,230,120)
		shake()
		return
	end
	if key == VALID_KEY then
		grantAccess()
	else
		message.Text = "✖ Key incorrecta"
		message.TextColor3 = Color3.fromRGB(255,120,120)
		shake()
	end
end)

-- QoL: Enter para enviar
keyBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then btnSub:Activate() end
end)

-- Centrar panel si cambia la pantalla
local function center()
	panel.Position = UDim2.new(0.5, -panel.AbsoluteSize.X/2, 0.5, -panel.AbsoluteSize.Y/2)
end
center()
root:GetPropertyChangedSignal("AbsoluteSize"):Connect(center)

-- Fin del script
