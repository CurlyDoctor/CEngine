local Framework = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("CEngine"))

local RunService = game:GetService("RunService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LightingAPI = game:GetService("Lighting")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")

local TabOne = {}
local TabTwo = {}



for i, v in pairs(ServerStorage:GetDescendants()) do
	if v.ClassName == "ModuleScript" then
		Framework:Initalize(v)
	end
end



for i, v in pairs(ReplicatedStorage.Shared:GetDescendants()) do
	if v.ClassName == "ModuleScript" and v.Name ~= "CEngine" then
		local Module = Framework:Initalize(v)
	end
end

for i, v in pairs(LightingAPI:GetDescendants()) do
	if v.ClassName == "ModuleScript" then
		local Module = Framework:Initalize(v)
	end
end





for i, v in pairs(Framework.OrderTable) do
	if v._type == "Service" then
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



for i = 1, #TabTwo do
	if type(TabTwo[i]) == "table" then
		TabTwo[i]:Init()
		TabTwo[i]:Start()
	end
end


