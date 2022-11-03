local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = 'Roblox Talent Show 🎤 | Made by Grayy#9991',
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

game.StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[Grayy#9991]: Thanks for using my script!",
    Color = Color3.fromRGB(255, 0, 0),
    Font = Enum.Font.Cartoon,
    FontSize = 14
})


getgenv().SpamHost = false
getgenv().SpamJudge = false

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

function judge()
    task.spawn(function()
        while getgenv().SpamJudge do
            if not getgenv().SpamJudge then
                break
            end
            local Team1Players = game:GetService("Teams")["Judges"]:GetPlayers()
            if #Team1Players < 4 then
                game:GetService("ReplicatedStorage").Remotes.PlayerRemotes.ChangeTeam:FireServer("Judge")
            end
            task.wait()
        end
    end)
end

function host()
    task.spawn(function()
        while getgenv().SpamHost do
            if not getgenv().SpamHost then
                break
            end
            local Team2Players = game:GetService("Teams")["Host"]:GetPlayers()
            if #Team2Players ~= 1 then
                game:GetService("ReplicatedStorage").Remotes.PlayerRemotes.ChangeTeam:FireServer("Host")
            end
            task.wait()
        end
    end)
end

Tab:AddToggle({
    Name = "Spam Host Team",
    Default = false,
    Callback = function(Value)
        getgenv().SpamHost = Value
        host()
    end
})

Tab:AddToggle({
    Name = "Spam Judge Team",
    Default = false,
    Callback = function(Value)
        getgenv().SpamJudge = Value
        judge()
    end
})

game:GetService("Teams")["Host"].PlayerRemoved:Connect(function(Player)
    OrionLib:MakeNotification({
        Name = "Player Left Team",
        Content = Player.Name .. " has left the Host Team!",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end)

game:GetService("Teams")["Judges"].PlayerRemoved:Connect(function(Player)
    OrionLib:MakeNotification({
        Name = "Player Left Team",
        Content = Player.Name .. " has left the Judges Team!",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end)

game:GetService("Teams")["Host"].PlayerAdded:Connect(function(Player)
    OrionLib:MakeNotification({
        Name = "Player Joined Team",
        Content = Player.Name .. " has joined the Host Team!",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end)

game:GetService("Teams")["Judges"].PlayerAdded:Connect(function(Player)
    OrionLib:MakeNotification({
        Name = "Player Joined Team",
        Content = Player.Name .. " has joined the Judges Team!",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end)
