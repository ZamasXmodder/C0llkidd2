-- GameSpeedServer (ServerScriptService)
-- Controla un "Game Speed x30" global (no local) usando RemoteEvents.
-- El cliente SOLO tiene la UI; toda la lógica de velocidad está aquí.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")

-- ================== CONFIG ==================

local SPEED_MULTIPLIER = 30      -- x30
local NORMAL_MULTIPLIER = 1
local ONLY_OWNER = false         -- true = solo el dueño puede togglear
local OWNER_USERID = 0           -- pon aquí tu UserId si usas ONLY_OWNER = true

-- ================== REMOTE EVENTS ==================

local toggleRE = ReplicatedStorage:FindFirstChild("GameSpeed_Toggle")
if not toggleRE then
    toggleRE = Instance.new("RemoteEvent")
    toggleRE.Name = "GameSpeed_Toggle"
    toggleRE.Parent = ReplicatedStorage
end

local stateRE = ReplicatedStorage:FindFirstChild("GameSpeed_State")
if not stateRE then
    stateRE = Instance.new("RemoteEvent")
    stateRE.Name = "GameSpeed_State"
    stateRE.Parent = ReplicatedStorage
end

-- ================== ESTADO GLOBAL ==================

local isActive = false
-- Guardamos velocidades originales por jugador
-- originalSpeeds[player] = { WalkSpeed = n, JumpPower = n }
local originalSpeeds = {}

-- ================== UTIL: GUARDAR / RESTAURAR ==================

local function saveOriginalState(player, humanoid)
    originalSpeeds[player] = originalSpeeds[player] or {}

    local data = originalSpeeds[player]
    if humanoid then
        if data.WalkSpeed == nil then
            data.WalkSpeed = humanoid.WalkSpeed
        end
        if humanoid.UseJumpPower then
            if data.JumpPower == nil then
                data.JumpPower = humanoid.JumpPower
            end
        else
            if data.JumpHeight == nil then
                data.JumpHeight = humanoid.JumpHeight
            end
        end
    end
end

local function applyMultiplierToHumanoid(humanoid, multiplier)
    if not humanoid then return end

    -- Velocidad de movimiento
    humanoid.WalkSpeed = humanoid.WalkSpeed * multiplier

    -- Salto
    if humanoid.UseJumpPower then
        humanoid.JumpPower = humanoid.JumpPower * multiplier
    else
        humanoid.JumpHeight = humanoid.JumpHeight * multiplier
    end

    -- Acelerar animaciones que ya están reproduciéndose
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(multiplier)
        end
    end
end

local function restoreHumanoidFromSaved(player, humanoid)
    if not humanoid then return end
    local data = originalSpeeds[player]
    if not data then return end

    if data.WalkSpeed then
        humanoid.WalkSpeed = data.WalkSpeed
    end

    if humanoid.UseJumpPower then
        if data.JumpPower then
            humanoid.JumpPower = data.JumpPower
        end
    else
        if data.JumpHeight then
            humanoid.JumpHeight = data.JumpHeight
        end
    end

    -- Restaurar velocidad de animaciones
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(NORMAL_MULTIPLIER)
        end
    end
end

-- ================== APLICAR SPEED A TODOS ==================

local function setGameSpeed(active)
    isActive = active

    -- Guardamos un atributo por si otros scripts quieren leerlo
    Workspace:SetAttribute("GameSpeedMultiplier", active and SPEED_MULTIPLIER or NORMAL_MULTIPLIER)

    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            if active then
                saveOriginalState(player, humanoid)
                -- calculamos multiplicador relativo respecto a estado normal
                -- si quieres que siempre sea EXACTAMENTE x30, mejor usa los guardados:
                local data = originalSpeeds[player]
                if data and data.WalkSpeed then
                    humanoid.WalkSpeed = data.WalkSpeed * SPEED_MULTIPLIER
                end
                if humanoid.UseJumpPower then
                    if data and data.JumpPower then
                        humanoid.JumpPower = data.JumpPower * SPEED_MULTIPLIER
                    end
                else
                    if data and data.JumpHeight then
                        humanoid.JumpHeight = data.JumpHeight * SPEED_MULTIPLIER
                    end
                end

                -- Animaciones
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        track:AdjustSpeed(SPEED_MULTIPLIER)
                    end
                end
            else
                restoreHumanoidFromSaved(player, humanoid)
            end
        end
    end

    -- Avisar a TODOS los clientes para que actualicen la UI
    stateRE:FireAllClients(isActive, SPEED_MULTIPLIER)
end

-- ================== REMOTE: TOGGLE DESDE CLIENTE ==================

toggleRE.OnServerEvent:Connect(function(player)
    if ONLY_OWNER and OWNER_USERID ~= 0 then
        if player.UserId ~= OWNER_USERID then
            warn(("[GameSpeed] %s intentó togglear pero no es el owner."):format(player.Name))
            return
        end
    end

    setGameSpeed(not isActive)
end)

-- ================== HANDLE PLAYER / CHARACTER ==================

local function onCharacterAdded(player, character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then return end

    -- Guardar estado base
    saveOriginalState(player, humanoid)

    -- Si el modo speed ya está activo cuando respawnea,
    -- aplicar multiplicador inmediatamente:
    if isActive then
        local data = originalSpeeds[player]
        if data and data.WalkSpeed then
            humanoid.WalkSpeed = data.WalkSpeed * SPEED_MULTIPLIER
        end
        if humanoid.UseJumpPower then
            if data and data.JumpPower then
                humanoid.JumpPower = data.JumpPower * SPEED_MULTIPLIER
            end
        else
            if data and data.JumpHeight then
                humanoid.JumpHeight = data.JumpHeight * SPEED_MULTIPLIER
            end
        end

        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(SPEED_MULTIPLIER)
            end
        end
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(char)
        onCharacterAdded(player, char)
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- Por si ya había jugadores en testing
for _, plr in ipairs(Players:GetPlayers()) do
    onPlayerAdded(plr)
    if plr.Character then
        onCharacterAdded(plr, plr.Character)
    end
end

print("[GameSpeedServer] Sistema de velocidad global listo. x" .. SPEED_MULTIPLIER)
