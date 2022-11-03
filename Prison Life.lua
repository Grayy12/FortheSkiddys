local OrionLib = loadstring(game:HttpGet(
                                ('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Prison Life",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

local loopkilltargets = {}
local Settings = {SHOT_AMOUNT = 1}

local killauratargets = {}

local KillAuraToggle = false

local MeleeEvent = game:GetService("ReplicatedStorage").meleeEvent

local DefaultGunsStats = {
    ['M9'] = {
        Damage = 10,
        MaxAmmo = 15,
        CurrentAmmo = 15,
        StoredAmmo = 100,
        FireRate = 0.08,
        AutoFire = false,
        Range = 600,
        Spread = 11,
        ReloadTime = 2,
        Bullets = 1
    },
    ['Remington 870'] = {
        Damage = 15,
        MaxAmmo = 6,
        CurrentAmmo = 6,
        StoredAmmo = 600,
        FireRate = 0.8,
        AutoFire = false,
        Range = 400,
        Spread = 3,
        ReloadTime = 4,
        Bullets = 5
    },
    ['M4A1'] = {
        Damage = 11,
        MaxAmmo = 30,
        CurrentAmmo = 30,
        StoredAmmo = 600,
        FireRate = 0.0875,
        AutoFire = true,
        Range = 800,
        Spread = 18,
        ReloadTime = 2,
        Bullets = 1
    },
    ['AK-47'] = {
        Damage = 11,
        MaxAmmo = 30,
        CurrentAmmo = 30,
        StoredAmmo = 600,
        FireRate = 0.1,
        AutoFire = true,
        Range = 800,
        Spread = 14,
        ReloadTime = 2,
        Bullets = 1
    }

}

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local GunModTab = Window:MakeTab({
    Name = "Gun Mods",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local LocalTab = Window:MakeTab({
    Name = "LocalPlayer",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Teamtab = Window:MakeTab({
    Name = "Teams",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

GunModTab:AddButton({
    Name = "Mod Current Gun",
    Callback = function()
        local gun = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA(
                        'Tool')

        if gun then
            local states = require(gun.GunStates)
            states.Damage = math.huge
            states.MaxAmmo = math.huge
            states.CurrentAmmo = math.huge
            states.StoredAmmo = math.huge
            states.FireRate = 0
            states.Spread = 0
            states.Bullets = 7
            states.AutoFire = true
        end
    end
})

GunModTab:AddButton({
    Name = "Reset Current Gun Mod",
    Callback = function()
        local gun = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA(
                        'Tool')
        if gun then
            if DefaultGunsStats[gun.Name] then
                local states = require(gun.GunStates)
                states.Damage = DefaultGunsStats[gun.Name].Damage
                states.MaxAmmo = DefaultGunsStats[gun.Name].MaxAmmo
                states.CurrentAmmo = DefaultGunsStats[gun.Name].CurrentAmmo
                states.StoredAmmo = DefaultGunsStats[gun.Name].StoredAmmo
                states.FireRate = DefaultGunsStats[gun.Name].FireRate
                states.Spread = DefaultGunsStats[gun.Name].Spread
                states.Bullets = DefaultGunsStats[gun.Name].Bullets
                states.AutoFire = DefaultGunsStats[gun.Name].AutoFire
            end
        end
    end
})

local connection
local connection1

LocalTab:AddToggle({
    Name = "Respawn at location",
    Default = false,
    Callback = function(Value)
        if Value then
            game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Died:Connect(
                OnDeath)
            connection = game.Players.LocalPlayer.CharacterAdded:Connect(
                             function(character)
                    connection1 =
                        character:WaitForChild('Humanoid').Died:Connect(OnDeath)
                end)
        else
            if connection then connection:Disconnect() end
            if connection1 then connection1:Disconnect() end
        end
    end
})

LocalTab:AddSection({Name = "Player"})

local walkspeedslider = LocalTab:AddSlider({
    Name = "WalkSpeed",
    Min = 0,
    Max = 350,
    Default = 16,
    Color = Color3.fromRGB(128, 79, 79),
    Increment = 1,
    ValueName = "Walk Speed",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character or
                         game.Players.LocalPlayer.CharacterAdded:Wait()
        if char and char:FindFirstChild('Humanoid') then
            char.Humanoid.WalkSpeed = Value
        end
    end
})

LocalTab:AddButton({
    Name = "Reset WalkSpeed",
    Callback = function() walkspeedslider:Set(16) end
})

local jumppowerslider = LocalTab:AddSlider({
    Name = "Jump Power",
    Min = 0,
    Max = 350,
    Default = 50,
    Color = Color3.fromRGB(139, 182, 139),
    Increment = 1,
    ValueName = "Jump Power",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character or
                         game.Players.LocalPlayer.CharacterAdded:Wait()
        if char and char:FindFirstChild('Humanoid') then
            char.Humanoid.JumpPower = Value
        end
    end
})

LocalTab:AddButton({
    Name = "Reset JumpPower",
    Callback = function() jumppowerslider:Set(50) end
})

Teamtab:AddDropdown({
    Name = "Join a team",
    Default = "",
    Options = {"Guard", "Inmate", "Criminal", "Neutral"},
    Callback = function(Value)
        if Value == "Guard" then
            local savedcf = GetCF()
            local cam = workspace.CurrentCamera
            workspace.Remote.loadchar:InvokeServer(nil, BrickColor.new(
                                                       "Bright blue").Name)

            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedcf
            cam.CameraType = Enum.CameraType.Custom
        elseif Value == "Inmate" then
            local savedcf = GetCF()
            local cam = workspace.CurrentCamera
            workspace.Remote.loadchar:InvokeServer(nil, BrickColor.new(
                                                       "Bright orange").Name)

            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedcf
            cam.CameraType = Enum.CameraType.Custom
        elseif Value == "Criminal" then
            local savedcf = GetCF()
            local cam = workspace.CurrentCamera
            workspace.Remote.loadchar:InvokeServer(nil, BrickColor.new(
                                                       "Really red").Name)

            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedcf
            cam.CameraType = Enum.CameraType.Custom
        else
            workspace.Remote.TeamEvent:FireServer("Medium stone grey")
        end
    end
})

local players = {}

for i, player in pairs(game:GetService('Players'):GetPlayers()) do
    table.insert(players, player.DisplayName)
end

local GotoPlayer = MainTab:AddDropdown({
    Name = "Goto Player",
    Default = "",
    Options = players,
    Callback = function(Value)
        for i, v in pairs(game.Players:GetPlayers()) do
            if v.DisplayName == Value then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    v.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
})

local playerbring = MainTab:AddDropdown({
    Name = "Bring Player",
    Default = "",
    Options = players,
    Callback = function(Value)
        for i, v in pairs(game.Players:GetPlayers()) do
            if v.DisplayName == Value then
                Teleport(v, game.Players.LocalPlayer.Character.HumanoidRootPart
                             .CFrame)
                break
            end
        end
    end
})

local playerkill = MainTab:AddDropdown({
    Name = "Kill Player",
    Default = "",
    Options = players,
    Callback = function(Value)

        local MyTeam = GetTeam()
        workspace.Remote.TeamEvent:FireServer("Medium stone grey")
        local savedcf = GetOrientation()
        local camcf = workspace.CurrentCamera.CFrame
        for i, v in pairs(game.Players:GetPlayers()) do
            if v.DisplayName == Value then
                Kill(v)
                break
            end
        end
        workspace.Remote.loadchar:InvokeServer(nil, MyTeam.TeamColor.Name)
        workspace.CurrentCamera.CFrame = camcf
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedcf

    end
})

local playerkillaura = MainTab:AddDropdown({
    Name = "Kill aura (CLICK PLAYER AGIAN TO STOP)",
    Default = "",
    Options = players,
    Callback = function(Value)
        for i, v in pairs(game.Players:GetPlayers()) do
            if v.DisplayName == Value then
                if not killauratargets[v.Name] then
                    table.insert(killauratargets, v.Name)
                else
                    for g, f in pairs(killauratargets) do
                        if f == v.Name then
                            table.remove(killauratargets, g)
                        end
                    end
                end
            end
        end
    end
})

local playertaze = MainTab:AddDropdown({
    Name = "Tase Player",
    Default = "",
    Options = players,
    Callback = function(Value)

        local MyTeam = GetTeam()
        local savedcf = GetOrientation()
        local camcf = workspace.CurrentCamera.CFrame
        for i, v in pairs(game.Players:GetPlayers()) do
            if v.DisplayName == Value then
                Tase(v)
                break
            end
        end
        Tase(game.Players[Value])
        workspace.Remote.loadchar:InvokeServer(nil, MyTeam.TeamColor.Name)
        workspace.CurrentCamera.CFrame = camcf
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedcf
    end
})

local odditems = {}

for i, item in pairs(
                   game:GetService("Workspace")["Prison_ITEMS"].giver:GetChildren()) do
    table.insert(odditems, item.Name)
end

local guns = MainTab:AddDropdown({
    Name = "Grab gun",
    Default = "",
    Options = odditems,
    Callback = function(Value)
        workspace.Remote.ItemHandler:InvokeServer(
            workspace.Prison_ITEMS.giver:FindFirstChild(Value).ITEMPICKUP)
    end
})

MainTab:AddButton({
    Name = "Kill All",
    Callback = function()

        local MyTeam = GetTeam()
        workspace.Remote.TeamEvent:FireServer("Medium stone grey")
        KillAll()
        workspace.Remote.loadchar:InvokeServer(nil, MyTeam.TeamColor.Name)
    end
})

MainTab:AddToggle({
	Name = "Kill Aura All",
	Default = false,
	Callback = function(Value)
		KillAuraToggle = Value
	end    
})


MainTab:AddButton({Name = "Tase All", Callback = function() TaserAll() end})

function OnDeath()
    print('Died!')
    local oldCF = GetCF()
    task.wait()
    game:GetService("Workspace").Remote.loadchar:InvokeServer()
    task.wait(.2)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCF
end

game:GetService("Workspace")["Prison_ITEMS"].giver.ChildAdded:Connect(function()
    local items =
        game:GetService("Workspace")["Prison_ITEMS"].giver:GetChildren()
    local Itembackup1 = {}
    for i, v in pairs(items) do
        if v.Name ~= nil and not Itembackup1[v.Name] then
            table.insert(Itembackup1, v.Name)
        end
    end
    guns:Refresh(Itembackup1, true)
end)

game:GetService("Workspace")["Prison_ITEMS"].giver.ChildRemoved:Connect(
    function()
        local items =
            game:GetService("Workspace")["Prison_ITEMS"].giver:GetChildren()
        local Itembackup1 = {}
        for i, v in pairs(items) do
            if v.Name ~= nil and not Itembackup1[v.Name] then
                table.insert(Itembackup1, v.Name)
            end
        end
        guns:Refresh(Itembackup1, true)
    end)

game.Players.PlayerAdded:Connect(function(player)
    local players2 = game:GetService("Players"):GetPlayers()
    local playerbackup1 = {}
    for i, v in pairs(players2) do table.insert(playerbackup1, v.DisplayName) end
    playerbring:Refresh(playerbackup1, true)
    GotoPlayer:Refresh(playerbackup1, true)
    playerkill:Refresh(playerbackup1, true)
    playertaze:Refresh(playerbackup1, true)
    playerkillaura:Refresh(playerbackup1, true)
end)

game.Players.PlayerRemoving:Connect(function(player)
    local players2 = game:GetService("Players"):GetPlayers()
    local playerbackup1 = {}
    for i, v in pairs(players2) do table.insert(playerbackup1, v.DisplayName) end
    playerbring:Refresh(playerbackup1, true)
    GotoPlayer:Refresh(playerbackup1, true)
    playerkill:Refresh(playerbackup1, true)
    playertaze:Refresh(playerbackup1, true)
    playerkillaura:Refresh(playerbackup1, true)
end)

function GetCF()
    return game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end

function GetCamPos() return workspace.CurrentCamera.CFrame end

function GetTeam() return game.Players.LocalPlayer.Team end

function GetOrientation()
    local PosX, PosY, PosZ = game.Players.LocalPlayer.Character:WaitForChild(
                                 "HumanoidRootPart").CFrame:ToOrientation()
    return CFrame.new(game.Players.LocalPlayer.Character:WaitForChild(
                          "HumanoidRootPart").CFrame.X,
                      game.Players.LocalPlayer.Character:WaitForChild(
                          "HumanoidRootPart").CFrame.Y, game.Players.LocalPlayer
                          .Character:WaitForChild("HumanoidRootPart").CFrame.Z) *
               CFrame.fromOrientation(0, PosY, 0)
end

function Teleport(Player, Position)
    if Player == nil or Position == nil then return; end
    local savedcf = GetCF();
    workspace.Remote.loadchar:InvokeServer();
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedcf;
    workspace.Remote.ItemHandler:InvokeServer(
        workspace.Prison_ITEMS.giver.M9.ITEMPICKUP);
    local CHAR = game.Players.LocalPlayer.Character;
    CHAR.Humanoid.Name = "1";
    local c = CHAR["1"]:Clone();
    c.Name = "Humanoid";
    c.Parent = CHAR;
    CHAR["1"]:Destroy();
    game.Workspace.CurrentCamera.CameraSubject = CHAR;
    CHAR.Animate.Disabled = true;
    wait();
    CHAR.Animate.Disabled = false;
    CHAR.Humanoid.DisplayDistanceType = "None";
    ((game.Players.LocalPlayer:FindFirstChild("Backpack")):FindFirstChild("M9")).Parent =
        CHAR;
    local STOP = 0;
    repeat
        wait(0);
        STOP = STOP + 1;
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
            Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.75);

    until (not game.Players.LocalPlayer.Character:FindFirstChild("M9") or
        (not game.Players.LocalPlayer.Character.HumanoidRootPart) or
        (not Player.Character.HumanoidRootPart) or
        (not game.Players.LocalPlayer.Character.HumanoidRootPart.Parent) or
        (not Player.Character.HumanoidRootPart.Parent) or STOP > 500) and STOP >
        3;
    local STOP_2 = 0;
    repeat
        wait();
        STOP_2 = STOP_2 + 1;
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Position;
    until STOP_2 > 10;
    workspace.Remote.loadchar:InvokeServer();
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedcf;
end

function Kill(Player)
    local events = {}
    local gun = nil
    workspace.Remote.ItemHandler:InvokeServer(
        workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name ~= "Taser" and v:FindFirstChild("GunStates") then
            gun = v
        end
    end
    if gun == nil then
        for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v.Name ~= "Taser" and v:FindFirstChild("GunStates") then
                gun = v
            end
        end
    end
    coroutine.wrap(function()
        for i = 1, 5 do
            game.ReplicatedStorage.ReloadEvent:FireServer(gun)
            wait(.5)
        end
    end)()
    for i = 1, 5 do
        events[#events + 1] = {
            Hit = Player.Character:FindFirstChild("Head") or
                Player.Character:FindFirstChildOfClass("Part"),
            Cframe = CFrame.new(),
            RayObject = Ray.new(Vector3.new(), Vector3.new()),
            Distance = 0
        }
    end
    game.Players.LocalPlayer.Character.Humanoid:EquipTool(gun)

    for i = 1, Settings.SHOT_AMOUNT do
        game.ReplicatedStorage.ShootEvent:FireServer(events, gun)
    end
end

function KillAll()
    local events = {}
    local gun = nil
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            if v.TeamColor.Name == game.Players.LocalPlayer.TeamColor.Name then
                local savedcf = GetOrientation()
                local camcf = workspace.CurrentCamera.CFrame
                workspace.Remote.loadchar:InvokeServer(nil,
                                                       BrickColor.random().Name)
                workspace.CurrentCamera.CFrame = camcf
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    savedcf
            end
            for i = 1, 10 do
                events[#events + 1] = {
                    Hit = v.Character:FindFirstChild("Head") or
                        v.Character:FindFirstChildOfClass("Part"),
                    Cframe = CFrame.new(),
                    RayObject = Ray.new(Vector3.new(), Vector3.new()),
                    Distance = 0
                }
            end
        end
    end
    workspace.Remote.ItemHandler:InvokeServer(
        workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name ~= "Taser" and v:FindFirstChild("GunStates") then
            gun = v
        end
    end
    if gun == nil then
        for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v.Name ~= "Taser" and v:FindFirstChild("GunStates") then
                gun = v
            end
        end
    end
    coroutine.wrap(function()
        for i = 1, 5 do
            game.ReplicatedStorage.ReloadEvent:FireServer(gun)
            wait(.5)
        end
    end)()
    game.Players.LocalPlayer.Character.Humanoid:EquipTool(gun)

    for i = 1, Settings.SHOT_AMOUNT do
        game.ReplicatedStorage.ShootEvent:FireServer(events, gun)
    end
end

function Tase(Player)
    local events = {}
    local gun = nil
    if not game.Players.LocalPlayer.Character:FindFirstChild("Taser") and
        not game.Players.LocalPlayer.Backpack:FindFirstChild("Taser") then
        local savedcf = GetOrientation()
        local camcf = workspace.CurrentCamera.CFrame
        workspace.Remote.loadchar:InvokeServer(nil,
                                               BrickColor.new("Bright blue")
                                                   .Name)
        workspace.CurrentCamera.CFrame = camcf
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedcf
    end
    for i = 1, 1 do
        events[#events + 1] = {
            Hit = Player.Character:FindFirstChildOfClass("Part"),
            Cframe = CFrame.new(),
            RayObject = Ray.new(Vector3.new(), Vector3.new()),
            Distance = 0
        }
    end
    gun = game.Players.LocalPlayer.Backpack:FindFirstChild('Taser')
    game.Players.LocalPlayer.Character.Humanoid:EquipTool(gun)
    game.ReplicatedStorage.ShootEvent:FireServer(events, gun)
end

function TaserAll()
    local events = {}
    local gun = nil
    local savedteam = game.Players.LocalPlayer.TeamColor.Name
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            events[#events + 1] = {
                Hit = v.Character:FindFirstChildOfClass("Part"),
                Cframe = CFrame.new(),
                RayObject = Ray.new(Vector3.new(), Vector3.new()),
                Distance = 0
            }
        end
    end
    if not game.Players.LocalPlayer.Character:FindFirstChild("Taser") and
        not game.Players.LocalPlayer:FindFirstChild("Backpack")
            :FindFirstChild("Taser") then
        savedteam = game.Players.LocalPlayer.TeamColor.Name
        local savedcf = GetOrientation()
        local camcf = workspace.CurrentCamera.CFrame
        workspace.Remote.loadchar:InvokeServer(nil,
                                               BrickColor.new("Bright blue")
                                                   .Name)
        workspace.CurrentCamera.CFrame = camcf
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedcf
    end
    gun = game.Players.LocalPlayer.Character:FindFirstChild("Taser") or
              game.Players.LocalPlayer.Backpack:FindFirstChild("Taser")
    game.Players.LocalPlayer.Character.Humanoid:EquipTool(gun)
    game.ReplicatedStorage.ShootEvent:FireServer(events, gun)
    local savedcf = GetOrientation()
    local camcf = workspace.CurrentCamera.CFrame
    workspace.Remote.loadchar:InvokeServer(nil, BrickColor.new(savedteam).Name)
    workspace.CurrentCamera.CFrame = camcf
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedcf
end


function Killauratarget()
    print(killauratargets)
    if #killauratargets > 0 then
        for i, v in pairs(killauratargets) do
            task.spawn(function()
                if game.Players[v] then
                    if (game.Players[v].Character.HumanoidRootPart.Position -
                        game.Players.LocalPlayer.Character.HumanoidRootPart
                            .Position).Magnitude < 25 and
                        game.Players[v].Character.Humanoid.Health > 0 then
                        for i = 1, 12 do
                            task.wait()
                            MeleeEvent:FireServer(v)
                        end
                    end
                end
            end)
        end
    end
end

task.spawn(function()
    Killauratarget()
end)



function Killaura()
    if KillAuraToggle then
        for i, v in pairs(game.Players:GetPlayers()) do
            task.spawn(function()
                if v and v ~= game.Players.LocalPlayer then
                    if (v.Character.HumanoidRootPart.Position -
                        game.Players.LocalPlayer.Character.HumanoidRootPart
                            .Position).Magnitude < 12 and
                        v.Character.Humanoid.Health > 0 then
                        for i = 1, 12 do
                            task.wait()
                            MeleeEvent:FireServer(v)
                        end
                    end
                end
            end)
        end
    end
end

task.spawn(function()
    Killaura()
end)

