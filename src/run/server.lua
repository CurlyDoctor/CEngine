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

for i, v in pairs(Framework.Services) do 
	Promise.new(function(resolve)
		v:Init()
	end)
end


for i, v in pairs(Framework.Services) do
	Promise.new(function()
		
		v:Start()
	end)
end

return nil 

--[[

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Run.server)

]]--


