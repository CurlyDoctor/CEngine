local Framework = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("CEngine"))
local StarterPlayerScript = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")

local RunService = game:GetService("RunService")

local TabOne = {}
local TabTwo = {}

for i, v in pairs(StarterPlayerScript:GetDescendants()) do
	if v.ClassName == "ModuleScript" then
		if v:FindFirstAncestor("Controllers") or v:FindFirstAncestor("Modules") then

			local m = Framework:Initalize(v)

		end
	end
end


for i, v in pairs(Framework.OrderTable) do
if v._type == "Controller" then
		if type(i) == "string" then
			TabOne[i] = v
			
		else
			TabTwo[i] = v
		end
		
	end
end

for i, v in pairs(TabOne) do
	if type(v) == "table" then
		v:Init()
		v:Start()
	end
end

RunService.Heartbeat:Wait()

for i = 1, #TabTwo do
	if type(TabTwo[i]) == "table" then
		TabTwo[i]:Init()
		TabTwo[i]:Start()
	end
end