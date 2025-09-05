-- Invisibility Panel (LocalScript -> StarterGui)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Intentamos require del módulo Net si existe
local NetModule
pcall(function()
    if ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net") then
        NetModule = require(ReplicatedStorage.Packages.Net)
    end
end)

-- Crear o reutilizar ScreenGui
local screenGui = playerGui:FindFirstChild("InvisibilityPanel") or Instance.new("ScreenGui")
screenGui.Name = "InvisibilityPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame (esquina superior derecha)
local frame = screenGui:FindFirstChild("PanelFrame") or Instance.new("Frame")
frame.Name = "PanelFrame"
frame.Size = UDim2.new(0, 220, 0, 64)
frame.AnchorPoint = Vector2.new(1, 0)                 -- anchor derecha arriba
frame.Position = UDim2.new(1, -10, 0, 10)             -- 10px desde la esquina derecha-arriba
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Estética
local corner = frame:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local stroke = frame:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(0, 200, 80)
stroke.Parent = frame

-- Título
local title = frame:FindFirstChild("Title") or Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -20, 0, 20)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Invisible Steal"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Botón
local button = frame:FindFirstChild("ActivateButton") or Instance.new("TextButton")
button.Name = "ActivateButton"
button.Size = UDim2.new(1, -20, 0, 30)
button.Position = UDim2.new(0, 10, 0, 30)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 15
button.Text = "Invisible Steal"
button.Parent = frame

local btnCorner = button:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = button

-- Debounce para no spamear
local busy = false

-- Busca RemoteFunction/RemoteEvent por varios lugares (fallback)
local function findRemoteFunction(name)
    -- Buscamos cualquier RemoteFunction en ReplicatedStorage que se llame "RF/UseItem" o "UseItem"
    local targetNames = { "RF/"..name, name }
    for _, inst in ipairs(ReplicatedStorage:GetDescendants()) do
        if inst:IsA("RemoteFunction") then
            for _,t in ipairs(targetNames) do
                if inst.Name == t then
                    return inst
                end
            end
        end
    end
    return nil
end

local function findRemoteEvent(name)
    local targetNames = { "RE/"..name, name }
    for _, inst in ipairs(ReplicatedStorage:GetDescendants()) do
        if inst:IsA("RemoteEvent") then
            for _,t in ipairs(targetNames) do
                if inst.Name == t then
                    return inst
                end
            end
        end
    end
    return nil
end

local function tryActivateUseItem()
    if busy then return end
    busy = true
    local originalText = button.Text
    button.Text = "Activando..."

    -- 1) Intentamos usar el Net module (Invoke)
    if NetModule then
        local ok, res = pcall(function()
            return NetModule:Invoke("UseItem")
        end)
        if ok and (res == nil or res == true) then
            button.Text = "Hecho"
            task.wait(1)
            button.Text = originalText
            busy = false
            return true
        else
            -- guardamos el error para fallback
            if not ok then
                warn("[Panel] Net:Invoke falló:", res)
            end
        end
    end

    -- 2) Fallback: buscar RemoteFunction directamente y call :InvokeServer()
    local rf = findRemoteFunction("UseItem")
    if rf then
        local ok, res = pcall(function()
            return rf:InvokeServer()
        end)
        if ok then
            button.Text = "Hecho"
            task.wait(1)
            button.Text = originalText
            busy = false
            return true
        else
            warn("[Panel] Invocation directo a RemoteFunction falló:", res)
        end
    end

    -- 3) Último recurso: buscar RemoteEvent y FireServer (por si el servidor espera evento)
    local re = findRemoteEvent("UseItem")
    if re then
        local ok, res = pcall(function()
            re:FireServer()
        end)
        if ok then
            button.Text = "Hecho"
            task.wait(1)
            button.Text = originalText
            busy = false
            return true
        else
            warn("[Panel] FireServer a RemoteEvent falló:", res)
        end
    end

    -- Si llegamos aquí, falló todo
    warn("[Panel] No se pudo activar la invisibilidad. Revisa que exista RF/UseItem o RE/UseItem en ReplicatedStorage o que el módulo Net funcione.")
    button.Text = originalText
    busy = false
    return false
end

button.MouseButton1Click:Connect(function()
    tryActivateUseItem()
end)
