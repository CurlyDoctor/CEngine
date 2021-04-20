local Framework = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("CEngine"))

local RunService = game:GetService("RunService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LightingAPI = game:GetService("Lighting")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")

local Promise = require(ReplicatedStorage.Shared.Promise)

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

Promise.new(function(resolve)
	local servicepromises = {}
	for i, v in pairs(Framework.Services) do 
		table.insert( servicepromises, #servicepromises + 1, Promise.new(function(resolve) 
			v:Init()
			resolve(v)			
		end))
	end

	resolve(Promise.all(servicepromises))
end):andThen(function(resolve) 
	for i, v in pairs(Framework.Services) do
		v:Start()
	end
end)

return nil 

