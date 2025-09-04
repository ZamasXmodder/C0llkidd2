local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

-- RemoteEvent create/ensure
local event = ReplicatedStorage:FindFirstChild("AutoFloorEvent")
if not event then
    event = Instance.new("RemoteEvent")
    event.Name = "AutoFloorEvent"
    event.Parent = ReplicatedStorage
end

-- Client LocalScript source (will be placed in StarterPlayerScripts)
local clientSource = [[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remote = ReplicatedStorage:WaitForChild("AutoFloorEvent")

-- UI ----
local screen = Instance.new("ScreenGui")
screen.Name = "AutoFloorGui"
screen.ResetOnSpawn = false
screen.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 120)
frame.Position = UDim2.new(0, 16, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
frame.BorderSizePixel = 0
frame.Parent = screen
local corner = Instance.new("UICorner", frame); corner.CornerRadius = UDim.new(0,12)
local stroke = Instance.new("UIStroke", frame); stroke.Color = Color3.fromRGB(60,60,70); stroke.Thickness = 1
local grad = Instance.new("UIGradient", frame); grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(38,38,45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(22,22,28))})
grad.Rotation = 90

local shadow = Instance.new("ImageLabel", screen)
shadow.Size = frame.Size + UDim2.new(0,8,0,8)
shadow.Position = frame.Position + UDim2.new(0, -4, 0, 4)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://3570695787"
shadow.ImageColor3 = Color3.fromRGB(0,0,0)
shadow.ImageTransparency = 0.8
shadow.ZIndex = 0
shadow.Name = "Shadow"
local shadowCorner = Instance.new("UICorner", shadow); shadowCorner.CornerRadius = UDim.new(1,0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -12, 0, 28)
title.Position = UDim2.new(0,6,0,6)
title.BackgroundTransparency = 1
title.Text = "AutoFloor"
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(235,235,235)
title.TextXAlignment = Enum.TextXAlignment.Left

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0,110,0,34)
toggle.Position = UDim2.new(0,12,0,40)
toggle.BackgroundColor3 = Color3.fromRGB(70,150,240)
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.Font = Enum.Font.GothamSemibold
toggle.TextSize = 16
toggle.Text = "Activar"
local togCorner = Instance.new("UICorner", toggle); togCorner.CornerRadius = UDim.new(0,8)
local togStroke = Instance.new("UIStroke", toggle); togStroke.Thickness = 1; togStroke.Color = Color3.fromRGB(40,110,200)

local distLabel = Instance.new("TextLabel", frame)
distLabel.Size = UDim2.new(0,140,0,20)
distLabel.Position = UDim2.new(0,130,0,44)
distLabel.BackgroundTransparency = 1
distLabel.Text = "Altura (studs)"
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 12
distLabel.TextColor3 = Color3.fromRGB(200,200,200)
distLabel.TextXAlignment = Enum.TextXAlignment.Left

local distBox = Instance.new("TextBox", frame)
distBox.Size = UDim2.new(0,150,0,28)
distBox.Position = UDim2.new(0,12,0,78)
distBox.BackgroundColor3 = Color3.fromRGB(20,20,24)
distBox.TextColor3 = Color3.fromRGB(210,210,210)
distBox.Text = "10"
distBox.Font = Enum.Font.Gotham
distBox.TextSize = 14
distBox.ClearTextOnFocus = false
local dbCorner = Instance.new("UICorner", distBox); dbCorner.CornerRadius = UDim.new(0,8)
local dbStroke = Instance.new("UIStroke", distBox); dbStroke.Thickness = 1; dbStroke.Color = Color3.fromRGB(40,40,48)

local hint = Instance.new("TextLabel", frame)
hint.Size = UDim2.new(1, -24, 0, 18)
hint.Position = UDim2.new(0,12,0,104)
hint.BackgroundTransparency = 1
hint.Text = "F para alternar | Plataforma visible para todos"
hint.Font = Enum.Font.Gotham
hint.TextSize = 11
hint.TextColor3 = Color3.fromRGB(160,160,160)
hint.TextXAlignment = Enum.TextXAlignment.Left

-- preview part
local previewPart
local function createPreview()
    previewPart = Instance.new("Part")
    previewPart.Name = "AutoFloorPreviewClient"
    previewPart.Size = Vector3.new(6,0.8,6)
    previewPart.Anchored = true
    previewPart.CanCollide = false
    previewPart.Transparency = 0.45
    previewPart.Material = Enum.Material.Neon
    previewPart.Color = Color3.fromRGB(100,170,255)
    previewPart.Parent = workspace
end

-- state
local enabled = false
local desiredDistance = 10

local function clamp(n, a, b) if n < a then return a elseif n > b then return b else return n end end

local function applyToggleState(newEnabled)
    enabled = newEnabled
    toggle.Text = enabled and "Desactivar" or "Activar"
    if enabled then
        desiredDistance = clamp(tonumber(distBox.Text) or desiredDistance, 2, 200)
        remote:FireServer("Toggle", true, desiredDistance)
        if not previewPart then createPreview() end
        previewPart.Transparency = 0.45
    else
        remote:FireServer("Toggle", false)
        if previewPart then previewPart.Transparency = 1 end
    end
end

toggle.MouseButton1Click:Connect(function()
    applyToggleState(not enabled)
end)

distBox.FocusLost:Connect(function(enter)
    local v = tonumber(distBox.Text)
    if v then
        desiredDistance = clamp(v, 2, 200)
        distBox.Text = tostring(desiredDistance)
        if enabled then
            remote:FireServer("SetDistance", desiredDistance)
        end
    else
        distBox.Text = tostring(desiredDistance)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        applyToggleState(not enabled)
    end
end)

RunService.RenderStepped:Connect(function()
    if not enabled then return end
    if not previewPart then createPreview() end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local targetY = hrp.Position.Y - desiredDistance
    local desiredCFrame = CFrame.new(hrp.Position.X, targetY - (previewPart.Size.Y/2), hrp.Position.Z)
    previewPart.CFrame = desiredCFrame
end)

player.CharacterRemoving:Connect(function()
    if previewPart then previewPart:Destroy(); previewPart = nil end
end)
]]

-- place LocalScript in StarterPlayerScripts (one-time)
do
    local sp = StarterPlayer:WaitForChild("StarterPlayerScripts")
    local existing = sp:FindFirstChild("AutoFloorClient")
    if existing then existing:Destroy() end
    local ls = Instance.new("LocalScript")
    ls.Name = "AutoFloorClient"
    ls.Source = clientSource
    ls.Parent = sp
end

-- Server-side platform management
local platforms = {} -- player -> { part = Part, distance = number, enabled = bool, lastReq = number}
local MIN_DIST, MAX_DIST = 2, 200
local SMOOTH = 8 -- mayor = más suave

local function clamp(n, a, b) if n < a then return a elseif n > b then return b else return n end end

local function makePlatform(player, distance)
    local part = Instance.new("Part")
    part.Name = "AutoFloor_"..player.UserId
    part.Size = Vector3.new(6, 1, 6)
    part.Anchored = true
    part.CanCollide = true
    part.CanQuery = true
    part.Transparency = 0.25
    part.Material = Enum.Material.SmoothPlastic
    part.Color = Color3.fromRGB(120,160,255)
    part.CastShadow = false
    part.Parent = workspace
    part:SetAttribute("OwnerUserId", player.UserId)
    return part
end

local function removePlatform(player)
    local data = platforms[player]
    if data and data.part and data.part.Parent then
        data.part:Destroy()
    end
    platforms[player] = nil
end

-- Handle client requests
event.OnServerEvent:Connect(function(player, action, ...)
    local now = tick()
    local data = platforms[player] or { lastReq = 0 }
    if now - (data.lastReq or 0) < 0.15 then return end
    data.lastReq = now

    if action == "Toggle" then
        local enable = select(1, ...)
        local distance = tonumber(select(2, ...)) or 10
        distance = clamp(distance, MIN_DIST, MAX_DIST)
        if enable then
            if not platforms[player] then
                local p = makePlatform(player, distance)
                platforms[player] = { part = p, distance = distance, enabled = true, lastReq = now }
            else
                platforms[player].enabled = true
                platforms[player].distance = distance
            end
        else
            removePlatform(player)
        end
    elseif action == "SetDistance" then
        local d = clamp(tonumber(select(1, ...)) or 10, MIN_DIST, MAX_DIST)
        if platforms[player] then
            platforms[player].distance = d
        end
    end
end)

-- update loop: mueve plataformas hacia la posición bajo el jugador (suavizado)
RunService.Heartbeat:Connect(function(dt)
    for player,data in pairs(platforms) do
        if not data.enabled then goto continue end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not data.part then
            removePlatform(player)
            goto continue
        end
        local targetY = hrp.Position.Y - data.distance
        local targetCFrame = CFrame.new(hrp.Position.X, targetY - (data.part.Size.Y/2), hrp.Position.Z)
        local current = data.part.CFrame
        data.part.CFrame = current:Lerp(targetCFrame, math.clamp(SMOOTH * dt, 0, 1))
        ::continue::
    end
end)

-- cleanup on player leave
Players.PlayerRemoving:Connect(function(player)
    removePlatform(player)
end)

-- safety: destroy any leftover parts on server start matching naming pattern
for _,v in ipairs(workspace:GetChildren()) do
    if v:IsA("BasePart") and v.Name:match("^AutoFloor_%d+$") then
        v:Destroy()
    end
end
