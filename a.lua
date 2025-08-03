local Admins = {
    "kit_cynALT",
    "juju_dupix1302",
    "nolyhaha",
    "Ana123",
    "PlayerX",
    "GhostKing",
    "BK_FAXBR",
    "BrunaYT",
    "MAYCONPRO54"
}
local Commands = {}
local lagging = false

-- Serviços
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

-- Envia mensagem no chat (suporte TextChatService)
local function sendChat(message)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then channel:SendAsync(message) end
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
    end
end

-- Verifica se jogador é admin
local function isAdmin(player)
    for _, name in pairs(Admins) do
        if player.Name == name then return true end
    end
    return false
end

-- Encontra jogador por nome parcial
local function findPlayerByNameFragment(name)
    name = name:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():sub(1, #name) == name then
            return plr
        end
    end
end

-- Registrar comando
local function addCommand(trigger, callback)
    Commands[string.lower(trigger)] = callback
end

-- Executar comandos ao falar
local function setupAdminChat(player)
    player.Chatted:Connect(function(msg)
        if not isAdmin(player) then return end

        local message = msg:lower()

        -- Ordenar comandos por tamanho (para evitar conflitos)
        local sorted = {}
        for cmd in pairs(Commands) do table.insert(sorted, cmd) end
        table.sort(sorted, function(a, b) return #a > #b end)

        for _, cmd in ipairs(sorted) do
            if message:sub(1, #cmd) == cmd then
                local scripterRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                Commands[cmd](msg, player, scripterRoot)
                break
            end
        end
    end)
end

-- Conectar admins existentes e novos
for _, plr in pairs(Players:GetPlayers()) do
    if isAdmin(plr) then setupAdminChat(plr) end
end

Players.PlayerAdded:Connect(function(plr)
    if isAdmin(plr) then setupAdminChat(plr) end
end)

------------------------------------------------------------------
-- Comandos
------------------------------------------------------------------

addCommand(";bring all", function(_, admin, root)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= admin and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(3,0,0)
        end
    end
end)

addCommand(";sm ", function(msg, admin)
	local message = msg:sub(5)
	if message == "" then return end

	for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
		coroutine.wrap(function()
			if plr:FindFirstChild("PlayerGui") then
				local gui = Instance.new("ScreenGui")
				gui.Name = "CustomNotification"
				gui.ResetOnSpawn = false
				gui.IgnoreGuiInset = true
				gui.Parent = plr.PlayerGui

				local frame = Instance.new("Frame")
				frame.AnchorPoint = Vector2.new(1, 0)
				frame.Position = UDim2.new(1.2, 0, 0.05, 0)
				frame.Size = UDim2.new(0, 340, 0, 100)
				frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				frame.BackgroundTransparency = 0.05
				frame.BorderSizePixel = 0
				frame.ClipsDescendants = true
				frame.Parent = gui

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 14)
				corner.Parent = frame

				local title = Instance.new("TextLabel")
				title.Size = UDim2.new(1, -20, 0, 30)
				title.Position = UDim2.new(0, 10, 0, 10)
				title.BackgroundTransparency = 1
				title.Text = "MENSAGEM"
				title.Font = Enum.Font.GothamBold
				title.TextSize = 18
				title.TextColor3 = Color3.fromRGB(170, 170, 170)
				title.TextXAlignment = Enum.TextXAlignment.Left
				title.Parent = frame

				local messageLabel = Instance.new("TextLabel")
				messageLabel.Size = UDim2.new(1, -20, 0, 60)
				messageLabel.Position = UDim2.new(0, 10, 0, 40)
				messageLabel.BackgroundTransparency = 1
				messageLabel.Text = message
				messageLabel.Font = Enum.Font.Gotham
				messageLabel.TextSize = 16
				messageLabel.TextWrapped = true
				messageLabel.TextYAlignment = Enum.TextYAlignment.Top
				messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				messageLabel.TextXAlignment = Enum.TextXAlignment.Left
				messageLabel.Parent = frame

				game:GetService("TweenService"):Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = UDim2.new(1, -20, 0.05, 0)
				}):Play()

				task.delay(5, function()
					game:GetService("TweenService"):Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
						Position = UDim2.new(1.2, 0, 0.05, 0)
					}):Play()
					task.wait(0.6)
					gui:Destroy()
				end)
			end
		end)()
	end
end)

addCommand(";bring ", function(msg, admin, root)
    local target = findPlayerByNameFragment(msg:sub(8)) -- ajustado para pegar corretamente o nome após ";bring "

    if target and admin and target ~= admin and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local adminRoot = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
        if adminRoot then
            target.Character.HumanoidRootPart.CFrame = adminRoot.CFrame + Vector3.new(3, 0, 0) -- traz ao lado do admin
        end
    end
end)

addCommand(";jail ", function(msg, admin, root)
    local target = findPlayerByNameFragment(msg:sub(7))
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart

        -- Cria uma pasta para armazenar a jaula
        local jailFolder = Instance.new("Folder", workspace)
        jailFolder.Name = target.Name .. "_Jail"

        -- Tamanho e posição base
        local size = Vector3.new(6, 6, 6)
        local pos = hrp.Position

        -- Cria as 6 paredes da jaula
        local function createWall(offset, wallSize)
            local part = Instance.new("Part")
            part.Size = wallSize
            part.Anchored = true
            part.CanCollide = true
            part.Transparency = 0.5
            part.Position = pos + offset
            part.Color = Color3.fromRGB(0, 0, 0)
            part.Parent = jailFolder
        end

        -- Chão, teto, frente, trás, esquerda, direita
        createWall(Vector3.new(0, -3, 0), Vector3.new(6, 0.5, 6)) -- chão
        createWall(Vector3.new(0, 3, 0), Vector3.new(6, 0.5, 6))  -- teto
        createWall(Vector3.new(0, 0, -3), Vector3.new(6, 6, 0.5)) -- frente
        createWall(Vector3.new(0, 0, 3), Vector3.new(6, 6, 0.5))  -- trás
        createWall(Vector3.new(-3, 0, 0), Vector3.new(0.5, 6, 6)) -- esquerda
        createWall(Vector3.new(3, 0, 0), Vector3.new(0.5, 6, 6))  -- direita
    end
end)

addCommand(";unjail ", function(msg, admin, root)
    local target = findPlayerByNameFragment(msg:sub(9)) -- Pula ";unjail "
    if target then
        local jailFolder = workspace:FindFirstChild(target.Name .. "_Jail")
        if jailFolder then
            jailFolder:Destroy()
        end
    end
end)

addCommand(";kill all", function(_, admin)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= admin and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
end)

addCommand(";lag ", function(msg, admin)
    local nick = msg:sub(6):lower()

    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #nick) == nick and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart

            for i = 1, 1000 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(0.01, 0.01, 0.01)
                part.Anchored = true
                part.Transparency = 1
                part.CanCollide = false
                part.Position = hrp.Position + Vector3.new(math.random(-20, 20), math.random(5, 20), math.random(-20, 20))
                part.Parent = workspace
            end

            warn("Lag parts spawned near " .. p.Name)
            break
        end
    end
end)

addCommand(";MUNDO", function(msg, admin, root)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local Debris = game:GetService("Debris")

    local radius = 50
    local duration = 6

    -- Cria esfera de energia
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Material = Enum.Material.ForceField
    sphere.Color = Color3.fromRGB(255, 255, 0)
    sphere.Transparency = 0.4
    sphere.Size = Vector3.new(1,1,1)
    sphere.CFrame = admin.Character.HumanoidRootPart.CFrame
    sphere.Parent = workspace

    TweenService:Create(sphere, TweenInfo.new(0.3), {
        Size = Vector3.new(radius*2, radius*2, radius*2)
    }):Play()

    -- Cria texto flutuante 3D "ZA WARUDO!"
    local textPart = Instance.new("Part")
    textPart.Anchored = true
    textPart.CanCollide = false
    textPart.Transparency = 1
    textPart.CFrame = admin.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
    textPart.Parent = workspace

    local billboard = Instance.new("BillboardGui", textPart)
    billboard.Size = UDim2.new(10, 0, 3, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "ZA WARUDO!"
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.Arcade

    Debris:AddItem(textPart, 1.5)

    -- Som de parar o tempo
    local sound = Instance.new("Sound", sphere)
    sound.SoundId = "rbxassetid://7514417921" -- Som de ZA WARUDO (ou troque por outro)
    sound.Volume = 2
    sound:Play()
    Debris:AddItem(sound, 5)

    -- Congelar jogadores dentro da esfera e aplicar efeito de tela preta e branca
    local frozen = {}

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= admin and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local dist = (hrp.Position - sphere.Position).Magnitude
            if dist <= radius then
                -- Congelar
                hrp.Anchored = true
                table.insert(frozen, hrp)

                -- Efeito tela P&B
                local gui = Instance.new("ColorCorrectionEffect")
                gui.Name = "WorldFreezeEffect"
                gui.TintColor = Color3.fromRGB(200, 200, 200)
                gui.Saturation = -1
                gui.Contrast = 0.3
                gui.Brightness = -0.1
                gui.Parent = game:GetService("Lighting")
                Debris:AddItem(gui, duration)
            end
        end
    end

    -- Após tempo, desfaz tudo
    task.delay(duration, function()
        TweenService:Create(sphere, TweenInfo.new(0.3), {
            Size = Vector3.new(1,1,1),
            Transparency = 1
        }):Play()
        Debris:AddItem(sphere, 0.5)

        -- Descongela
        for _, hrp in ipairs(frozen) do
            if hrp and hrp.Parent then
                hrp.Anchored = false
            end
        end

        -- Remove efeito de Lighting (garantia extra)
        for _, v in ipairs(game:GetService("Lighting"):GetChildren()) do
            if v:IsA("ColorCorrectionEffect") and v.Name == "WorldFreezeEffect" then
                v:Destroy()
            end
        end
    end)
end)

addCommand(";freeze all", function(msg, admin)
    for _, target in pairs(game:GetService("Players"):GetPlayers()) do
        if target ~= admin and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart

            -- Criar o gelo visual
            local ice = Instance.new("Part")
            ice.Size = Vector3.new(5, 6, 5)
            ice.Anchored = true
            ice.CanCollide = false
            ice.Material = Enum.Material.Ice
            ice.Transparency = 0.3
            ice.Color = Color3.fromRGB(150, 255, 255)
            ice.CFrame = CFrame.new(hrp.Position)
            ice.Name = "FreezeBlock"
            ice.Parent = target.Character

            -- Congelar o player
            hrp.Anchored = true

            -- Desativar movimentação
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
            end
        end
    end

    warn("Todos os jogadores foram congelados!")
end)

addCommand(";unjail ", function(msg, admin, root)
    local arg = msg:sub(9):lower()

    local function unjailPlayer(target)
        if target then
            local jailFolder = workspace:FindFirstChild(target.Name .. "_Jail")
            if jailFolder then
                jailFolder:Destroy()
            end
        end
    end

    if arg == "all" then
        for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
            unjailPlayer(plr)
        end
    else
        local target = findPlayerByNameFragment(arg)
        if target then
            unjailPlayer(target)
        end
    end
end)

addCommand(";jail all", function(msg, admin, root)
    local Players = game:GetService("Players")

    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= admin and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart

            -- Cria uma pasta para armazenar a jaula
            local jailFolder = Instance.new("Folder", workspace)
            jailFolder.Name = target.Name .. "_Jail"

            -- Tamanho e posição base
            local size = Vector3.new(6, 6, 6)
            local pos = hrp.Position

            -- Cria as 6 paredes da jaula
            local function createWall(offset, wallSize)
                local part = Instance.new("Part")
                part.Size = wallSize
                part.Anchored = true
                part.CanCollide = true
                part.Transparency = 0.5
                part.Position = pos + offset
                part.Color = Color3.fromRGB(0, 0, 0)
                part.Parent = jailFolder
            end

            -- Chão, teto, frente, trás, esquerda, direita
            createWall(Vector3.new(0, -3, 0), Vector3.new(6, 0.5, 6)) -- chão
            createWall(Vector3.new(0, 3, 0), Vector3.new(6, 0.5, 6))  -- teto
            createWall(Vector3.new(0, 0, -3), Vector3.new(6, 6, 0.5)) -- frente
            createWall(Vector3.new(0, 0, 3), Vector3.new(6, 6, 0.5))  -- trás
            createWall(Vector3.new(-3, 0, 0), Vector3.new(0.5, 6, 6)) -- esquerda
            createWall(Vector3.new(3, 0, 0), Vector3.new(0.5, 6, 6))  -- direita
        end
    end
end)

addCommand(";maid all", function(msg, admin)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local WearPants = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("WearPants")
    local WearShirt = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("WearShirt")

    -- IDs da roupa de maid
    local pantsArgs = {8318917748}
    local shirtArgs = {6174796730}

    for _, target in pairs(game:GetService("Players"):GetPlayers()) do
        if target ~= admin and target.Character then
            pcall(function()
                WearPants:InvokeServer(unpack(pantsArgs))
                WearShirt:InvokeServer(unpack(shirtArgs))
            end)
        end
    end

    warn("Todos os jogadores receberam a roupa de maid!")
end)

addCommand(";domain expansion", function(msg, admin, root)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local Debris = game:GetService("Debris")

    local radius = 30
    local duration = 10

    -- Criar e tocar som
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6590147536" -- ID do som
    sound.Volume = 10
    sound.PlayOnRemove = false
    sound.Parent = workspace
    sound:Play()

    -- Criar esfera visual
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Material = Enum.Material.ForceField
    sphere.Color = Color3.fromRGB(100, 0, 200)
    sphere.Transparency = 0.4
    sphere.Size = Vector3.new(1, 1, 1)
    sphere.CFrame = admin.Character.HumanoidRootPart.CFrame
    sphere.Parent = workspace

    -- Anima esfera crescendo
    local growTween = TweenService:Create(sphere, TweenInfo.new(0.5), {
        Size = Vector3.new(radius * 2, radius * 2, radius * 2)
    })
    growTween:Play()
    growTween.Completed:Wait() -- Aguarda crescer antes de congelar

    -- Congelar jogadores dentro do raio
    local frozenPlayers = {}

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= admin and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local distance = (hrp.Position - sphere.Position).Magnitude
            if distance <= radius then
                hrp.Anchored = true
                table.insert(frozenPlayers, hrp)
            end
        end
    end

    -- Espera duração e desfaz
    task.delay(duration, function()
        TweenService:Create(sphere, TweenInfo.new(0.5), {
            Transparency = 1,
            Size = Vector3.new(1, 1, 1)
        }):Play()
        Debris:AddItem(sphere, 0.6)

        for _, hrp in ipairs(frozenPlayers) do
            if hrp and hrp.Parent then
                hrp.Anchored = false
            end
        end
    end)
end)

addCommand(";kill ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(6))
    if target and target ~= admin and target.Character and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = 0
    end
end)

addCommand(";mata ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(6))
    if target and target ~= admin and target.Character and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = 0
    end
end)

addCommand(";maid ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(7))
    if target and target.Character then
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local WearPants = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("WearPants")
        local WearShirt = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("WearShirt")

        -- ID da calça
        local pantsArgs = {8318917748}
        -- ID da camisa
        local shirtArgs = {6174796730}

        -- Enviar para o target
        local successPants, errPants = pcall(function()
            WearPants:InvokeServer(unpack(pantsArgs))
        end)

        local successShirt, errShirt = pcall(function()
            WearShirt:InvokeServer(unpack(shirtArgs))
        end)

        if successPants and successShirt then
            warn("Maid outfit aplicado em " .. target.Name)
        else
            warn("Erro ao aplicar roupa em " .. target.Name)
        end
    end
end)

addCommand(";freeze ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(9))
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart

        -- Criar o gelo visual
        local ice = Instance.new("Part")
        ice.Size = Vector3.new(5, 6, 5)
        ice.Anchored = true
        ice.CanCollide = false
        ice.Material = Enum.Material.Ice
        ice.Transparency = 0.3
        ice.Color = Color3.fromRGB(150, 255, 255)
        ice.CFrame = CFrame.new(hrp.Position) -- corrigido aqui
        ice.Name = "FreezeBlock"
        ice.Parent = target.Character

        -- Congelar o player (ancorar o HumanoidRootPart)
        hrp.Anchored = true

        -- Desativar movimentação
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end

        warn(target.Name .. " foi congelado!")
    end
end)

addCommand(";nothing ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(7))
    if target and target.Character then
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local WearPants = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("WearPants")
        local WearShirt = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("WearShirt")

        -- ID da calça
        local pantsArgs = {17271585340}
        -- ID da camisa
        local shirtArgs = {16802894236}

        -- Enviar para o target
        local successPants, errPants = pcall(function()
            WearPants:InvokeServer(unpack(pantsArgs))
        end)

        local successShirt, errShirt = pcall(function()
            WearShirt:InvokeServer(unpack(shirtArgs))
        end)

        if successPants and successShirt then
            warn("Maid outfit aplicado em " .. target.Name)
        else
            warn("Erro ao aplicar roupa em " .. target.Name)
        end
    end
end)

addCommand(";unfreeze ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(11))
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart

        -- Desancorar o jogador
        hrp.Anchored = false

        -- Restaurar movimentação
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end

        -- Remover o gelo visual
        local ice = target.Character:FindFirstChild("FreezeBlock")
        if ice then
            ice:Destroy()
        end

        warn(target.Name .. " foi descongelado!")
    end
end)

addCommand(";kick all", function()
    for _, p in pairs(Players:GetPlayers()) do
        if not isAdmin(p) then
            p:Kick("Você foi expulso por um administrador.")
        end
    end
end)

addCommand(";say ", function(msg)
    sendChat(msg:sub(5))
end)

addCommand(";sit all", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character:FindFirstChildOfClass("Humanoid").Sit = true
        end
    end
end)

addCommand(";kick ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(7))
    if target and not isAdmin(target) then
        target:Kick("Você foi expulso por um administrador.")
    end
end)

addCommand(";expusar ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(7))
    if target and not isAdmin(target) then
        target:Kick("Você foi expulso por um administrador.")
    end
end)

-- DANÇA (sem precisar ser admin)
addCommand(";dance ", function(msg)
    local target = findPlayerByNameFragment(msg:sub(8))
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            sendChat("/e dance2") -- só aparece no chat, não força animação real
        end
    end
end)

-- KILL (não mata admin)
addCommand(";kill ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(7))
    if target and not isAdmin(target) and target.Character then
        local humanoid = target.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.Health = 0 end
    end
end)

-- SAY (apenas admins)
addCommand(";cht ", function(msg, admin)
    if isAdmin(admin) then
        sendChat(msg:sub(6))
    end
end)

addCommand(";sit ", function(msg, admin)
    local targetName = msg:sub(6):lower()
    
    for _, p in pairs(Players:GetPlayers()) do
        if (p.Name:lower():find(targetName) or p.DisplayName:lower():find(targetName)) and not isAdmin(p) then
            local humanoid = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Sit = true
            end
        end
    end
end)

-- FLING
addCommand(";fling ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(8))
    if target and not isAdmin(target) and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(100, 100, 100) -- força
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 0.5)
        end
    end
end)

addcmd("Jumpscare", function(args, speaker)
    local target = string.lower(args[1] or "")
    local lp = game:GetService("Players").LocalPlayer
    if target ~= string.lower(lp.Name) then return end

    local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
    gui.Name = "JumpscareGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true

    local image = Instance.new("ImageLabel", gui)
    image.Size = UDim2.new(1.2, 0, 1.2, 0)
    image.Position = UDim2.new(-0.1, 0, -0.1, 0)
    image.BackgroundTransparency = 1
    image.Image = "rbxassetid://10755920342"
    image.ZIndex = 999

    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://85271883712040"
    sound.Volume = 10
    sound.Looped = false
    sound:Play()

    local shaking = true
    task.spawn(function()
        while shaking do
            image.Position = UDim2.new(-0.1, math.random(-20, 20), -0.1, math.random(-20, 20))
            task.wait(0.02)
        end
    end)

    task.delay(3, function()
        shaking = false
        sound:Destroy()
        gui:Destroy()
    end)
end)

addCommand(";f ", function(msg, admin)
    local target = findPlayerByNameFragment(msg:sub(8))
    if target and not isAdmin(target) and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(100, 100, 100) -- força
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 0.5)
        end
    end
end)

addCommand(";show", function()
    sendChat("✅️ here.")
end)

addCommand(";verifique", function()
    sendChat("c_cnd")
end)

addCommand(".", function()
    sendChat(".")
end)

addCommand("-a", function()
    sendChat("#")
end)

addCommand(";dance all", function()
    sendChat("/e dance2")
end)

