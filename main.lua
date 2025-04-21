-- Blade Simulator Script with Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source'))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Blade Simulator Hub (UPD 22.5)",
    LoadingTitle = "Blade Simulator Script",
    LoadingSubtitle = "by Sginats",
    ConfigurationSaving = {Enabled = true, FolderName = "BladeSimulatorHub", FileName = "Config"},
    Discord = {Enabled = true, Invite = "your_discord_code", RememberJoins = true},
    KeySystem = false
})

-- Variables
local player = game.Players.LocalPlayer
local autofarmEnabled = false
local autoBuyEnabled = false
local enemyFarmEnabled = false
local rebirthEnabled = false

-- Autofarm Function
local function startAutofarm()
    spawn(function()
        while autofarmEnabled do
            game.ReplicatedStorage.Swing:FireServer() -- Adjust remote name
            wait(0.1 + math.random(0.05, 0.15))
        end
    end)
end

-- Auto-Buy Pets
local function startAutoBuy()
    spawn(function()
        while autoBuyEnabled do
            local gems = player.leaderstats.Gems.Value or 0
            local petEvent = game.ReplicatedStorage.PurchasePet
            if petEvent and gems >= 1000 then
                petEvent:FireServer("EpicPet") -- Adjust pet name
            end
            wait(1)
        end
    end)
end

-- Enemy Farming
local function farmEnemies()
    spawn(function()
        while enemyFarmEnabled do
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                    game.ReplicatedStorage.AttackEvent:FireServer(enemy) -- Adjust remote
                    wait(0.5)
                end
            end
            wait(1)
        end
    end)
end

-- Auto-Rebirth
local function autoRebirth()
    spawn(function()
        while rebirthEnabled do
            if player.leaderstats.Strength.Value >= 1000000 then
                game.ReplicatedStorage.RebirthEvent:FireServer() -- Adjust remote
            end
            wait(5)
        end
    end)
end

-- Main Tab
local MainTab = Window:CreateTab("Main", "rewind")

-- Autofarm Toggle
MainTab:CreateToggle({
    Name = "Autofarm",
    CurrentValue = false,
    Callback = function(Value)
        autofarmEnabled = Value
        if Value then
            startAutofarm()
            Rayfield:Notify({Title = "Autofarm", Content = "Autofarm enabled!", Duration = 3})
        else
            Rayfield:Notify({Title = "Autofarm", Content = "Autofarm disabled!", Duration = 3})
        end
    end
})

-- Auto-Buy Toggle
MainTab:CreateToggle({
    Name = "Auto-Buy Pets",
    CurrentValue = false,
    Callback = function(Value)
        autoBuyEnabled = Value
        if Value then
            startAutoBuy()
            Rayfield:Notify({Title = "Auto-Buy", Content = "Auto-buy enabled!", Duration = 3})
        else
            Rayfield:Notify({Title = "Auto-Buy", Content = "Auto-buy disabled!", Duration = 3})
        end
    end
})

-- Enemy Farm Toggle
MainTab:CreateToggle({
    Name = "Enemy Farm",
    CurrentValue = false,
    Callback = function(Value)
        enemyFarmEnabled = Value
        if Value then
            farmEnemies()
            Rayfield:Notify({Title = "Enemy Farm", Content = "Enemy farming enabled!", Duration = 3})
        else
            Rayfield:Notify({Title = "Enemy Farm", Content = "Enemy farming disabled!", Duration = 3})
        end
    end
})

-- Auto-Rebirth Toggle
MainTab:CreateToggle({
    Name = "Auto-Rebirth",
    CurrentValue = false,
    Callback = function(Value)
        rebirthEnabled = Value
        if Value then
            autoRebirth()
            Rayfield:Notify({Title = "Auto-Rebirth", Content = "Auto-rebirth enabled!", Duration = 3})
        else
            Rayfield:Notify({Title = "Auto-Rebirth", Content = "Auto-rebirth disabled!", Duration = 3})
        end
    end
})

-- Speed Slider
MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- Teleport Dropdown
MainTab:CreateDropdown({
    Name = "Teleport to Location",
    Options = {"Spawn", "BossArena", "HighRewardZone"},
    CurrentOption = "Spawn",
    Callback = function(Option)
        local locations = {
            ["Spawn"] = CFrame.new(0, 10, 0), -- Replace with actual coordinates
            ["BossArena"] = CFrame.new(100, 10, 100),
            ["HighRewardZone"] = CFrame.new(200, 10, 200)
        }
        if player.Character and player.Character.HumanoidRootPart then
            player.Character.HumanoidRootPart.CFrame = locations[Option]
        end
        Rayfield:Notify({Title = "Teleport", Content = "Teleported to " .. Option, Duration = 3})
    end
})

-- Currency Tracker
local currencyLabel = MainTab:CreateLabel("Gems: 0")
spawn(function()
    while wait(1) do
        if player.leaderstats and player.leaderstats:FindFirstChild("Gems") then
            currencyLabel:Set("Gems: " .. player.leaderstats.Gems.Value)
        end
    end
end)

-- Welcome Notification
Rayfield:Notify({
    Title = "Blade Simulator Hub",
    Content = "Script loaded successfully! Enjoy!",
    Duration = 5
})
