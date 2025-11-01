local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Dibu Hub - Weak Legacy 2",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Dibu Hub",
   LoadingSubtitle = "by patolinno",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Dibu Hub | Key",
      Subtitle = "Key System",
      Note = "Get key on Discord", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Home🏠", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Main")

local Button = MainTab:CreateButton({
   Name = "patched",
   Callback = function()
   print("hello")
   end,
})

local Toggle = MainTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
-- Weak Legacy 2 Autofarm - Apenas Função
-- Cole este código dentro do seu botão de autofarm

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Variável de controle (use no seu toggle)
_G.AutoFarmEnabled = true

-- Database de Quests
local QuestDatabase = {
    {level = {1, 10}, questNPC = "Quest Dummy 1", mob = "Weak Demon"},
    {level = {10, 30}, questNPC = "Quest Dummy 2", mob = "Regular Demon"},
    {level = {30, 50}, questNPC = "Quest Dummy 3", mob = "Winter Demon"},
    {level = {50, 70}, questNPC = "Quest Dummy 4", mob = "Strong Demon"},
    {level = {70, 150}, questNPC = "Quest Dummy 5", mob = "Lower Moon Demon 6"},
    {level = {150, 175}, questNPC = "Boss Quest 1", mob = "Tanjiro"},
    {level = {175, 200}, questNPC = "Boss Quest 2", mob = "Rengoku"},
    {level = {200, 250}, questNPC = "Boss Quest 3", mob = "Nezuko"},
    {level = {250, 300}, questNPC = "Boss Quest 4", mob = "Zenitsu"},
    {level = {300, 350}, questNPC = "Boss Quest 5", mob = "Tokito"},
    {level = {350, 375}, questNPC = "Boss Quest 6", mob = "Akaza"},
    {level = {375, 400}, questNPC = "Boss Quest 7", mob = "Kaigaku"},
    {level = {400, 425}, questNPC = "Boss Quest 8", mob = "Tengen"},
    {level = {425, 450}, questNPC = "Boss Quest 9", mob = "Gyutaro"},
    {level = {450, 475}, questNPC = "Boss Quest 10", mob = "Hantengu"},
    {level = {475, 500}, questNPC = "Boss Quest 11", mob = "Shinobu"},
    {level = {500, 550}, questNPC = "Boss Quest 12", mob = "Mitsuri"},
    {level = {550, 575}, questNPC = "Boss Quest 13", mob = "Rui"},
    {level = {575, 625}, questNPC = "Boss Quest 14", mob = "Sanemi"},
    {level = {625, 700}, questNPC = "Boss Quest 15", mob = "Obanai"}
}

-- Pega o level do jogador
local function GetLevel()
    local success, level = pcall(function()
        return player.leaderstats.Level.Value
    end)
    return success and level or 1
end

-- Encontra a melhor quest
local function GetBestQuest()
    local level = GetLevel()
    for _, quest in ipairs(QuestDatabase) do
        if level >= quest.level[1] and level <= quest.level[2] then
            return quest
        end
    end
    return QuestDatabase[#QuestDatabase]
end

-- Aceita a quest
local function AcceptQuest(questNPC)
    pcall(function()
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc.Name == questNPC and npc:IsA("Model") then
                local clickDetector = npc:FindFirstChildWhichIsA("ClickDetector", true)
                local proximityPrompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                
                if clickDetector then
                    fireclickdetector(clickDetector)
                elseif proximityPrompt then
                    fireproximityprompt(proximityPrompt)
                end
                
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("quest") or name:find("mission") then
                            remote:FireServer("Accept")
                            remote:FireServer(questNPC)
                        end
                    end
                end
                break
            end
        end
    end)
end

-- Encontra mobs
local function FindMobs(mobName)
    local mobs = {}
    pcall(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:find(mobName) then
                local humanoid = v:FindFirstChildOfClass("Humanoid")
                local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Torso")
                
                if humanoid and root and humanoid.Health > 0 then
                    table.insert(mobs, {
                        model = v,
                        humanoid = humanoid,
                        root = root
                    })
                end
            end
        end
    end)
    return mobs
end

-- Ataca
local function Attack()
    pcall(function()
        local character = player.Character
        if not character then return end
        
        -- Ativa tool
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
        
        -- Procura RemoteEvents de ataque
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("combat") or name:find("attack") or name:find("punch") or name:find("m1") or name:find("click") then
                    remote:FireServer()
                end
            end
        end
    end)
end

-- Loop Principal
spawn(function()
    while wait(0.1) do
        if _G.AutoFarmEnabled then
            pcall(function()
                local character = player.Character
                if not character then return end
                
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart")
                
                if not humanoid or not root or humanoid.Health <= 0 then return end
                
                -- Pega a melhor quest
                local quest = GetBestQuest()
                
                -- Aceita a quest
                AcceptQuest(quest.questNPC)
                
                -- Encontra mobs
                local mobs = FindMobs(quest.mob)
                
                if #mobs > 0 then
                    for _, mob in pairs(mobs) do
                        if mob.humanoid.Health > 0 then
                            -- Teleporta até o mob (fica em cima dele)
                            root.CFrame = mob.root.CFrame * CFrame.new(0, 10, 0)
                            
                            -- Ataca
                            Attack()
                            
                            -- Espera um pouco antes de checar próximo mob
                            wait(0.1)
                        end
                    end
                end
            end)
        end
    end
end)

print("Autofarm iniciado! Use _G.AutoFarmEnabled = false para parar")
   end,
})

local CreditTab = Window:CreateTab("Credits", nil) -- Title, Image
local Section = CreditTab:CreateSection("Main")
local Label = CreditTab:CreateLabel("Discord: Dibu.gg", nil, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme

Rayfield:Notify({
   Title = "Script was executed!",
   Content = "Best script",
   Duration = 6.5,
   Image = nil,
})

local ConfgTab = Window:CreateTab("Confg.", nil) -- Title, Image
local Section = ConfgTab:CreateSection("Configuration")
local Label = ConfgTab:CreateLabel("SOON...", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme
