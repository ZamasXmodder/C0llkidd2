-- Brainrot Helper (detector robusto) - Pega en LocalScript (StarterPlayerScripts)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Estado
local carryingBrainrot = false
local prevCarrying = false
local baseCFrame = nil
local autoTP = true

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotHelper"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0,1)
panel.Position = UDim2.new(0,20,1,-20)
panel.Size = UDim2.new(0,320,0,180)
panel.BackgroundColor3 = Color3.fromRGB(20,20,28)
panel.BorderSizePixel = 0
panel.Parent = screenGui
local corner = Instance.new("UICorner", panel) corner.CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-40,0,28)
title.Position = UDim2.new(0,12,0,8)
title.BackgroundTransparency = 1
title.Text = "🧠 Brainrot Helper"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-36,0,8)
closeBtn.Text = "F"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(50,50,70)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = panel
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-24,0,22)
status.Position = UDim2.new(0,12,0,44)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(210,210,210)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

local baseLbl = status:Clone()
baseLbl.Position = UDim2.new(0,12,0,68)
baseLbl.Parent = panel

local hint = status:Clone()
hint.Position = UDim2.new(0,12,0,92)
hint.Text = "V: TP ahora  |  F: mostrar/ocultar"
hint.TextColor3 = Color3.fromRGB(160,170,255)
hint.Parent = panel

local row = Instance.new("Frame")
row.Size = UDim2.new(1,-24,0,56)
row.Position = UDim2.new(0,12,0,112)
row.BackgroundTransparency = 1
row.Parent = panel

local function mkBtn(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.5,-6,1,0)
    b.BackgroundColor3 = Color3.fromRGB(60,70,100)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

local regBtn = mkBtn("📍 Registrar base (aquí)")
regBtn.Position = UDim2.new(0,0,0,0)
regBtn.Parent = row

local tpBtn = mkBtn("⚡ TP ahora (V)")
tpBtn.Position = UDim2.new(0.5,6,0,0)
tpBtn.Parent = row

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1,-24,0,26)
autoBtn.Position = UDim2.new(0,12,1,-30)
autoBtn.BackgroundColor3 = Color3.fromRGB(70,100,70)
autoBtn.BorderSizePixel = 0
autoBtn.Text = "🚀 Smart TP: ON"
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoBtn.Font = Enum.Font.GothamMedium
autoBtn.TextSize = 14
autoBtn.Parent = panel
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0,8)

local function setAutoBtn()
    autoBtn.Text = autoTP and "🚀 Smart TP: ON" or "🚀 Smart TP: OFF"
    autoBtn.BackgroundColor3 = autoTP and Color3.fromRGB(70,100,70) or Color3.fromRGB(140,60,60)
end

local function updateStatusUI()
    status.Text = carryingBrainrot and "Estado: ✅ Brainrot cargado" or "Estado: Sin brainrot"
    status.TextColor3 = carryingBrainrot and Color3.fromRGB(0,255,130) or Color3.fromRGB(210,210,210)
    if baseCFrame then
        baseLbl.Text = "Base: Registrada"
        baseLbl.TextColor3 = Color3.fromRGB(0,200,255)
    else
        baseLbl.Text = "Base: No registrada"
        baseLbl.TextColor3 = Color3.fromRGB(210,210,210)
    end
end
updateStatusUI(); setAutoBtn()

-- === Heurísticas de detección ===

-- 1) ¿Tiene el personaje una etiqueta "STOLEN/ROBADO" en su GUI?
local function hasStolenBadge(character)
    for _,d in ipairs(character:GetDescendants()) do
        if d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
            for _,t in ipairs(d:GetDescendants()) do
                if (t:IsA("TextLabel") or t:IsA("TextButton")) and t.Text and type(t.Text) == "string" then
                    local txt = t.Text:lower()
                    if txt:find("stolen") or txt:find("robado") then
                        return true
                    end
                end
            end
        elseif (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Text and type(d.Text) == "string" then
            local txt = d.Text:lower()
            if txt:find("stolen") or txt:find("robado") then
                return true
            end
        end
    end
    return false
end

-- 2) ¿Ese modelo parece un brainrot? (busca guis con $/s, o texto visible de ganancias)
local function looksLikeBrainrotModel(m)
    if not m or not m:IsA("Model") then return false end
    for _,d in ipairs(m:GetDescendants()) do
        if (d:IsA("BillboardGui") or d:IsA("SurfaceGui")) then
            for _,t in ipairs(d:GetDescendants()) do
                if (t:IsA("TextLabel") or t:IsA("TextButton")) and t.Text and type(t.Text) == "string" then
                    local s = t.Text
                    if s:find("%$") and s:lower():find("/s") then
                        return true
                    end
                    -- si el texto contiene palabras tipo "tralal" o repetición corta (heurística)
                    local sl = s:lower()
                    if sl:match("tralal") or sl:match("tung") or sl:match("tralala") then
                        return true
                    end
                end
            end
        elseif (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Text then
            if d.Text:find("%$") and d.Text:lower():find("/s") then
                return true
            end
        end
    end
    -- si el modelo tiene PrimaryPart con un BillboardGui -> probable brainrot
    local p = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
    if p then
        for _,g in ipairs(p:GetChildren()) do
            if g:IsA("BillboardGui") then
                for _,t in ipairs(g:GetDescendants()) do
                    if (t:IsA("TextLabel") or t:IsA("TextButton")) and t.Text and t.Text:find("%$") and t.Text:lower():find("/s") then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function nearestPartPos(m)
    local p = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
    return p and p.Position or nil
end

-- 3) ¿Hay un brainrot muy cerca de mi personaje (ej. al cargarlo se pega)?
local function brainrotNearCharacter(character, radius)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local origin = hrp.Position
    for _,obj in ipairs(Workspace:GetChildren()) do
        if obj ~= character and obj:IsA("Model") and looksLikeBrainrotModel(obj) then
            local pos = nearestPartPos(obj)
            if pos and (pos - origin).Magnitude <= radius then
                return true
            end
        end
    end
    return false
end

-- 4) ¿El modelo del brainrot fue parentado al character? (a veces se parentan)
local function modelParentedToCharacter(character)
    for _,child in ipairs(character:GetChildren()) do
        if child:IsA("Model") and looksLikeBrainrotModel(child) then
            return true
        end
    end
    return false
end

-- 5) ¿Atributo directo que el juego ponga? (por si existe)
local function characterHasAttributeFlag(character)
    if character:GetAttribute("CarryingBrainrot") then
        return true
    end
    return false
end

-- Revisa varias heurísticas y actualiza carryingBrainrot
local function computeCarryingState()
    local char = player.Character
    if not char then return false end
    if characterHasAttributeFlag(char) then return true end
    if hasStolenBadge(char) then return true end
    if modelParentedToCharacter(char) then return true end
    if brainrotNearCharacter(char, 3) then return true end
    return false
end

-- === Teleport y comportamiento ===
local function smartTeleport()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not baseCFrame then return end
    -- Teleport suave
    char.HumanoidRootPart.CFrame = baseCFrame
    carryingBrainrot = false
    updateStatusUI()
    print("🚀 Teleport a la base realizado.")
end

-- === Eventos GUI ===
regBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        baseCFrame = char.HumanoidRootPart.CFrame
        updateStatusUI()
        print("✅ Base registrada.")
        -- feedback visual (pequeño tween)
        local orig = regBtn.BackgroundColor3
        regBtn.BackgroundColor3 = Color3.fromRGB(30,130,200)
        delay(0.25, function() regBtn.BackgroundColor3 = orig end)
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    smartTeleport()
end)

autoBtn.MouseButton1Click:Connect(function()
    autoTP = not autoTP
    setAutoBtn()
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- Teclas
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.V then
        smartTeleport()
    elseif input.KeyCode == Enum.KeyCode.F then
        panel.Visible = not panel.Visible
    end
end)

-- Loop de actualización (ligero)
RunService.Heartbeat:Connect(function()
    local newState = computeCarryingState()
    if newState ~= carryingBrainrot then
        -- cambio de estado
        prevCarrying = carryingBrainrot
        carryingBrainrot = newState
        updateStatusUI()
        -- si acabo de agarrar y autoTP on -> teleporto tras pequeño delay
        if carryingBrainrot and not prevCarrying and autoTP and baseCFrame then
            delay(0.5, function()
                -- confirmar que siga cargando
                if computeCarryingState() then
                    smartTeleport()
                end
            end)
        end
    end
end)

-- Inicial
updateStatusUI()
print("[BrainrotHelper] cargado. -> Registra base, luego roba y prueba.")
