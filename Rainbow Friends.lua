local OrionLib = loadstring(game:HttpGet(
                                ('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Rainbow Friends",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})
local l = game:GetService("Players").LocalPlayer
local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddToggle({
    Name = "Toggle Monster Esp",
    Default = false,
    Callback = function()
        -- SetEspMonster(Value) 
    end
})

Tab:AddToggle({
    Name = "Toggle Item Esp",
    Default = false,
    Callback = function(Value) SetEspItems(Value) end
})

Tab:AddButton({
    Name = "Attemt to PickUp all items",
    Callback = function() grabItems() end
})

Tab:AddButton({
    Name = "Fake Box",
    Callback = function()
        game.ReplicatedStorage.communication.boxes.cl.BoxUpdated:FireServer(
            "Equip")
    end
})

function grabItems()
    pcall(function()
        task.spawn(function()
            for i, v in pairs(game.Workspace:GetChildren()) do
                if string.find(v.Name, "Food") and v:IsA("Model") then
                    local t = v:FindFirstChild("TouchTrigger")
                    if t then
                        firetouchinterest(l.Character.Head, t, 0)
                    end
                end
            end

            for i, v in pairs(game.Workspace:GetChildren()) do
                if string.find(v.Name, "Block") and v:IsA("Model") then
                    local t = v:FindFirstChild("TouchTrigger")
                    if t then
                        firetouchinterest(l.Character.Head, t, 0)
                    end
                end
            end
        end)
    end)
end

function SetEspMonster(bool)
    pcall(function()
        if bool then
            for i, v in pairs(
                            game:GetService("Workspace").Monsters:GetChildren()) do
                if v then
                    if v:IsA("Model") then
                        local hl = Instance.new("Highlight", v)
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Name = "Hl"
                    end
                end
            end
        else
            for i, v in pairs(
                            game:GetService("Workspace").Monsters:GetChildren()) do
                if v:IsA("Model") then
                    local hl = v:FindFirstChild("Hl")
                    if hl then hl:Destroy() end
                end
            end
        end
    end)

end

function SetEspItems(bool)
    if bool then
        for i, v in pairs(game.Workspace:GetChildren()) do
            if string.find(v.Name, "Block") and v:IsA("Model") and
                not v:FindFirstChild("Hl") then
                local hl = Instance.new("Highlight", v)
                hl.FillColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Name = "Hl"
            end
        end
        for i, v in pairs(game.Workspace:GetChildren()) do
            if string.find(v.Name, "Food") and v:IsA("Model") and
                not v:FindFirstChild("Hl") then
                local hl = Instance.new("Highlight", v)
                hl.FillColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Name = "Hl"
            end
        end
    else
        for i, v in pairs(game.Workspace:GetChildren()) do
            if string.find(v.Name, "Block") and v:IsA("Model") and
                v:FindFirstChild("Hl") then
                local hl = v:FindFirstChild("Hl")
                if hl then hl:Destroy() end
            end
        end
        for i, v in pairs(game.Workspace:GetChildren()) do
            if string.find(v.Name, "Food") and v:IsA("Model") and
                v:FindFirstChild("Hl") then
                local hl = v:FindFirstChild("Hl")
                if hl then hl:Destroy() end
            end
        end
    end
end

