--// Anti-Hit con botón (10s) — versión robusta para executor

-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Personaje
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Estado
local antiHitActive = false
local hbConn, bodyVelocity

-- UI parent seguro (CoreGui -> gethui() -> PlayerGui)
local function getUiParent()
    local ok, _ = pcall(function()
        local probe = Instance.new("Folder")
        probe.Parent = game:GetService("CoreGui")
        probe:Destroy()
    end)
    if ok then
        return game:GetService("CoreGui")
    elseif typeof(gethui) == "function" then
        return gethui()
    else
        return player:WaitForChild("PlayerGui")
    end
end

-- Crear GUI simple
local gui = Instance.new("ScreenGui")
gui.Name = "AntiHitGUI"
gui.ResetOnSpawn = false
gui.Parent = getUiParent()

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 70)
frame.Position = UDim2.new(0.5, -90, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = gui
local fcorner = Instance.new("UICorner", frame) fcorner.CornerRadius = UDim.new(0,12)

-- Draggable básico
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(80,120,200)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.Text = "Anti-Hit (10s)"
button.Parent = frame
local bcorner = Instance.new("UICorner", button) bcorner.CornerRadius = UDim.new(0,8)

-- Anti-hit 10s (sin RemoteEvents)
local function activateAntiHit10s()
    if antiHitActive then return end
    antiHitActive = true
    button.Text = "Anti-Hit ON"

    -- 1) BodyVelocity para anular knockback
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    -- 2) Forzar velocidades a 0 cada frame
    hbConn = RunService.Heartbeat:Connect(function()
        if not antiHitActive then return end
        if rootPart and rootPart.Parent then
            rootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
            rootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
            if bodyVelocity then bodyVelocity.Velocity = Vector3.new(0,0,0) end
        end
    end)

    -- Auto-off a los 10s
    task.delay(10, function()
        if not antiHitActive then return end
        antiHitActive = false
        if hbConn then hbConn:Disconnect() hbConn = nil end
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if button and button.Parent then button.Text = "Anti-Hit (10s)" end
    end)
end

button.MouseButton1Click:Connect(activateAntiHit10s)

-- Reasignar si respawneas
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    antiHitActive = false
    if hbConn then hbConn:Disconnect() hbConn = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if button and button.Parent then button.Text = "Anti-Hit (10s)" end
end)

print("[Anti-Hit] Listo. Usa el botón para 10s de invulnerabilidad al knockback.")
