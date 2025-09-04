local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables para funciones
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyAngularVelocity = nil
local autoEquipSword = false
local infiniteReach = false
local originalReach = {}

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrazyPanel"
screenGui.Parent = playerGui

-- Frame principal (aumentado el tamaño)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 500)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "🚀 CRAZY PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Función para crear botones
local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    -- Efecto hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    
    return button
end

-- Función de vuelo
local function toggleFly()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local rootPart = player.Character.HumanoidRootPart
    
    if flying then
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyAngularVelocity then
            bodyAngularVelocity:Destroy()
            bodyAngularVelocity = nil
        end
    else
        flying = true
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
        bodyAngularVelocity.Parent = rootPart
    end
end

-- Función para fling players
local function flingPlayers()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < 50 then
                local bodyVel = Instance.new("BodyVelocity")
                bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVel.Velocity = Vector3.new(math.random(-100, 100), 100, math.random(-100, 100))
                bodyVel.Parent = otherPlayer.Character.HumanoidRootPart
                
                game:GetService("Debris"):AddItem(bodyVel, 1)
            end
        end
    end
end

-- Función de super velocidad
local function toggleSpeed()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if humanoid.WalkSpeed == 16 then
            humanoid.WalkSpeed = 100
        else
            humanoid.WalkSpeed = 16
        end
    end
end

-- Función de super salto
local function toggleJump()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if humanoid.JumpPower == 50 then
            humanoid.JumpPower = 200
        else
            humanoid.JumpPower = 50
        end
    end
end

-- Función de invisibilidad
local function toggleInvisibility()
    if not player.Character then return end
    
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if part.Transparency == 0 then
                part.Transparency = 1
            else
                part.Transparency = 0
            end
        elseif part:IsA("Accessory") then
            if part.Handle.Transparency == 0 then
                part.Handle.Transparency = 1
            else
                part.Handle.Transparency = 0
            end
        end
    end
    
    if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("face") then
        local face = player.Character.Head.face
        if face.Transparency == 0 then
            face.Transparency = 1
        else
            face.Transparency = 0
        end
    end
end

-- Función de noclip
local noclipping = false
local function toggleNoclip()
    noclipping = not noclipping
    
    if noclipping then
        RunService.Stepped:Connect(function()
            if noclipping and player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Función para encontrar espadas
local function findSword()
    if not player.Character then return nil end
    
    -- Buscar en el inventario del jugador
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (string.find(tool.Name:lower(), "sword") or 
                                   string.find(tool.Name:lower(), "blade") or
                                   string.find(tool.Name:lower(), "katana") or
                                   tool:FindFirstChild("Handle")) then
                return tool
            end
        end
    end
    
    -- Buscar en las manos del jugador
    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") and (string.find(tool.Name:lower(), "sword") or 
                               string.find(tool.Name:lower(), "blade") or
                               string.find(tool.Name:lower(), "katana") or
                               tool:FindFirstChild("Handle")) then
            return tool
        end
    end
    
    return nil
end

-- Función de auto-equip sword
local function toggleAutoEquipSword()
    autoEquipSword = not autoEquipSword
    
    if autoEquipSword then
        spawn(function()
            while autoEquipSword do
                wait(0.1)
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    local sword = findSword()
                    if sword and sword.Parent ~= player.Character then
                        player.Character.Humanoid:EquipTool(sword)
                    end
                end
            end
        end)
    end
end

-- Función de rango infinito para espadas
local function toggleInfiniteReach()
    infiniteReach = not infiniteReach
    
    if infiniteReach then
        -- Modificar todas las espadas existentes
        local function modifySword(tool)
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                local handle = tool.Handle
                
                -- Guardar el tamaño original
                if not originalReach[tool] then
                    originalReach[tool] = handle.Size
                end
                
                -- Hacer el handle gigante para alcance infinito
                handle.Size = Vector3.new(2048, 2048, 2048)
                handle.Transparency = 1
                handle.CanCollide = false
                
                -- Modificar scripts de daño si existen
                for _, script in pairs(tool:GetDescendants()) do
                    if script:IsA("LocalScript") or script:IsA("Script") then
                        if script.Source and string.find(script.Source:lower(), "damage") then
                            -- Intentar modificar el daño
                            script.Source = script.Source:gsub("damage%s*=%s*%d+", "damage = 100")
                        end
                    end
                end
            end
        end
        
        -- Modificar espadas en backpack
        if player:FindFirstChild("Backpack") then
            for _, tool in pairs(player.Backpack:GetChildren()) do
                modifySword(tool)
            end
        end
        
        -- Modificar espadas equipadas
        if player.Character then
            for _, tool in pairs(player.Character:GetChildren()) do
                modifySword(tool)
            end
        end
        
        -- Conectar para nuevas espadas
        player.CharacterAdded:Connect(function(character)
            if infiniteReach then
                character.ChildAdded:Connect(function(child)
                    if infiniteReach then
                        wait(0.1)
                        modifySword(child)
                    end
                end)
            end
        end)
        
        if player:FindFirstChild("Backpack") then
            player.Backpack.ChildAdded:Connect(function(child)
                if infiniteReach then
                    wait(0.1)
                    modifySword(child)
                end
            end)
        end
        
    else
        -- Restaurar tamaños originales
        for tool, originalSize in pairs(originalReach) do
            if tool and tool:FindFirstChild("Handle") then
                tool.Handle.Size = originalSize
                tool.Handle.Transparency = 0
            end
        end
        originalReach = {}
    end
end

-- Función para matar a todos los jugadores
local function killAllPlayers()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local sword = findSword()
    if not sword then
        print("No se encontró espada para usar")
        return
    end
    
    -- Equipar la espada si no está equipada
    if sword.Parent ~= player.Character then
        player.Character.Humanoid:EquipTool(sword)
        wait(0.5)
    end
    
    -- Atacar a todos los jugadores
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Teletransportarse cerca del jugador
            local originalPos = player.Character.HumanoidRootPart.CFrame
            player.Character.HumanoidRootPart.CFrame = otherPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            
            wait(0.1)
            
            -- Simular ataque
            if sword:FindFirstChild("Handle") then
                sword:Activate()
                
                -- Intentar dañar directamente
                if otherPlayer.Character:FindFirstChild("Humanoid") then
                    otherPlayer.Character.Humanoid.Health = 0
                end
            end
            
            wait(0.1)
            
            -- Volver a la posición original
            player.Character.HumanoidRootPart.CFrame = originalPos
        end
    end
end

-- Crear botones (posiciones actualizadas)
createButton("✈️ Toggle Fly", UDim2.new(0.05, 0, 0, 60), toggleFly)
createButton("💥 Fling Players", UDim2.new(0.05, 0, 0, 105), flingPlayers)
createButton("⚡ Toggle Speed", UDim2.new(0.05, 0, 0, 150), toggleSpeed)
createButton("🦘 Super Jump", UDim2.new(0.05, 0, 0, 195), toggleJump)
createButton("👻 Invisibility", UDim2.new(0.05, 0, 0, 240), toggleInvisibility)
createButton("🚪 Noclip", UDim2.new(0.05, 0, 0, 285), toggleNoclip)
createButton("⚔️ Auto Equip Sword", UDim2.new(0.05, 0, 0, 330), toggleAutoEquipSword)
createButton("🌟 Infinite Reach", UDim2.new(0.05, 0, 0, 375), toggleInfiniteReach)
createButton("💀 Kill All Players", UDim2.new(0.05, 0, 0, 420), killAllPlayers)

-- Botón de cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Hacer el panel arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

title.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Controles de vuelo
RunService.Heartbeat:Connect(function()
    if flying and bodyVelocity and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local camera = workspace.CurrentCamera
        local moveVector = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveVector * flySpeed
    end
end)

-- Sistema de notificaciones
local function createNotification(text, color)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 250, 0, 50)
    notification.Position = UDim2.new(1, -270, 0, 20)
    notification.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -10, 1, 0)
    notifText.Position = UDim2.new(0, 5, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextScaled = true
    notifText.Font = Enum.Font.Gotham
    notifText.Parent = notification
    
    -- Animación de entrada
    notification:TweenPosition(UDim2.new(1, -270, 0, 20), "Out", "Quad", 0.3, true)
    
    -- Desaparecer después de 3 segundos
    wait(3)
    notification:TweenPosition(UDim2.new(1, 0, 0, 20), "In", "Quad", 0.3, true)
    wait(0.3)
    notification:Destroy()
end

-- Conectar eventos para notificaciones
player.CharacterAdded:Connect(function()
    wait(1)
    if autoEquipSword then
        spawn(function()
            createNotification("🗡️ Auto-equip activado", Color3.fromRGB(0, 255, 0))
        end)
    end
end)

-- Función mejorada de detección de espadas
local function getSwordTools()
    local swords = {}
    local backpack = player:FindFirstChild("Backpack")
    
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local toolName = tool.Name:lower()
                if string.find(toolName, "sword") or 
                   string.find(toolName, "blade") or
                   string.find(toolName, "katana") or
                   string.find(toolName, "knife") or
                   string.find(toolName, "dagger") or
                   tool:FindFirstChild("Handle") then
                    table.insert(swords, tool)
                end
            end
        end
    end
    
    return swords
end

-- Función de auto-ataque mejorada
local autoAttack = false
local function toggleAutoAttack()
    autoAttack = not autoAttack
    
    if autoAttack then
        spawn(function()
            while autoAttack do
                wait(0.1)
                if player.Character then
                    for _, tool in pairs(player.Character:GetChildren()) do
                        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                            tool:Activate()
                        end
                    end
                end
            end
        end)
        createNotification("⚔️ Auto-ataque activado", Color3.fromRGB(255, 100, 0))
    else
        createNotification("⚔️ Auto-ataque desactivado", Color3.fromRGB(255, 0, 0))
    end
end

-- Agregar botón de auto-ataque
createButton("⚔️ Auto Attack", UDim2.new(0.05, 0, 0, 465), toggleAutoAttack)

print("🚀 Crazy Panel cargado completamente!")
print("📋 Funciones disponibles:")
print("✈️ Vuelo - Usa WASD + Espacio/Shift")
print("💥 Fling Players - Lanza jugadores cercanos")
print("⚡ Super Velocidad - Velocidad aumentada")
print("🦘 Super Salto - Salto mejorado")
print("👻 Invisibilidad - Hazte invisible")
print("🚪 Noclip - Atraviesa paredes")
print("⚔️ Auto Equip Sword - Equipa espadas automáticamente")
print("🌟 Infinite Reach - Rango infinito de espada")
print("💀 Kill All Players - Elimina a todos los jugadores")
print("⚔️ Auto Attack - Ataque automático continuo")
