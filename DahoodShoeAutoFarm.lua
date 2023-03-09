-- Ignore this Player stuff and connections

local g = getgenv()

if g._connections then
	for i, v in next, g._connections do
		v:Disconnect()
		v = nil
	end
else
	g._connections = {}
end

local function newCon(connection: RBXScriptConnection)
	table.insert(g._connections, connection)
end

local Player
Player = {
	plr = game.Players.LocalPlayer
		or game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and game.Players.LocalPlayer,
	char = function()
		return game.Players.LocalPlayer.Character
			or game.Players.LocalPlayer.CharacterAdded:Wait() and game.Players.LocalPlayer.Character
	end,
	root = function()
		return Player.char().HumanoidRootPart or Player.char().PrimaryPart
	end,
	_rescons = {},
	respawn = function(func)
		print("Res")
		if func and type(func) == "function" then
			if not table.find(Player._rescons, func) then
				table.insert(Player._rescons, func)
			end
		end

		for _, v in next, Player._rescons do
			local s, n = pcall(function()
				coroutine.wrap(v)()
			end)

			if not s then
				warn(n)
			end
		end
	end,
	respawnConnection = function()
		newCon(Player.plr.CharacterAdded:Connect(Player.respawn))
	end,
}
Player.respawnConnection()

-- Anti cheat bypass???? idk what the remote does but yeah this stops it
for i, v in next, getconnections(Player.root():GetPropertyChangedSignal("CFrame")) do
	v:Disable()
end

-- Autofarm

local turnin = game:GetService("Workspace").Ignored
	:FindFirstChild("Clean the shoes on the floor and come to me for cash")

local function AutoFarm()
	if not Player.char() then
		return
	end
	for i, v in next, workspace:GetPartBoundsInBox(game:GetService("Workspace").MAP.Map["hood kicks"]:GetBoundingBox()) do
		if v:IsA("MeshPart") and v:FindFirstChildWhichIsA("ClickDetector") then
			local click = v:FindFirstChildWhichIsA("ClickDetector")
			Player.root().CFrame = v.CFrame
			task.wait(0.1)
			fireclickdetector(click, click.MaxActivationDistance)
			num = 0
			repeat
				task.wait(0.2)
				fireclickdetector(click, click.MaxActivationDistance)
				num += 1
			until not v or not v.Parent or not click or num == 10

			if turnin then
				local turninclick = turnin:FindFirstChildWhichIsA("ClickDetector")
				if not turninclick then
					return
				end
				Player.root().CFrame = turnin.PrimaryPart.CFrame
				task.wait(0.1)
				fireclickdetector(turninclick, turninclick.MaxActivationDistance)
			else
				print("No turnin")
			end
		end
	end
end

getgenv().farm = true

newCon(game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F then
		getgenv().farm = false
	end
end))

while farm and task.wait() do
	AutoFarm()
end
