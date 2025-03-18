_G.FriendColor = Color3.fromRGB(0, 0, 255) -- Azul para aliados (não será usado)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)  -- Vermelho para inimigos
_G.UseTeamColor = false -- Ignorar a cor do time, usar cores personalizadas

--------------------------------------------------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Criando a pasta principal para armazenar ESP
local Holder = Instance.new("Folder", game.CoreGui)
Holder.Name = "ESP"

local function CreateESP(player)
    -- Aguarda o personagem do jogador carregar
    repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    -- Criar pasta do jogador no ESP
    local playerESP = Instance.new("Folder", Holder)
    playerESP.Name = player.Name

    -- Criar caixa (BoxHandleAdornment)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBox"
    box.Size = Vector3.new(2, 5, 2)
    box.Color3 = _G.EnemyColor
    box.Transparency = 0.7
    box.ZIndex = 0
    box.AlwaysOnTop = true
    box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
    box.Parent = playerESP

    -- Criar nome acima do jogador (BillboardGui)
    local nameTag = Instance.new("BillboardGui")
    nameTag.Name = "ESPName"
    nameTag.Size = UDim2.new(0, 200, 0, 50)
    nameTag.StudsOffset = Vector3.new(0, 3, 0)
    nameTag.AlwaysOnTop = true
    nameTag.Adornee = player.Character:FindFirstChild("Head")
    
    local text = Instance.new("TextLabel", nameTag)
    text.Name = "Tag"
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(0, 200, 0, 30)
    text.TextSize = 15
    text.Font = Enum.Font.SourceSansBold
    text.TextColor3 = _G.EnemyColor
    text.TextStrokeTransparency = 0.4
    text.Text = player.Name
    text.Parent = nameTag

    nameTag.Parent = playerESP

    -- Criar Highlight (contorno)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = player.Character
    highlight.FillColor = _G.EnemyColor
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
end

local function RemoveESP(player)
    local playerESP = Holder:FindFirstChild(player.Name)
    if playerESP then
        playerESP:Destroy()
    end
end

local function OnCharacterAdded(player)
    -- Aguarda o personagem e verifica se é inimigo
    repeat task.wait() until player.Character
    if player.Team ~= LocalPlayer.Team then
        CreateESP(player)
    end
end

local function OnPlayerAdded(player)
    if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
        player.CharacterAdded:Connect(function()
            OnCharacterAdded(player)
        end)
        
        player.CharacterRemoving:Connect(function()
            RemoveESP(player)
        end)
        
        if player.Character then
            CreateESP(player)
        end
    end
end

-- Monitorar jogadores
for _, player in ipairs(Players:GetPlayers()) do
    OnPlayerAdded(player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(RemoveESP)

-- Ocultar nome do próprio jogador
LocalPlayer.NameDisplayDistance = 0
