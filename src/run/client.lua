local Framework = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("CEngine"))
local StarterPlayerScript = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local Promise = require(game:GetService("ReplicatedStorage").Shared.Promise)

local RunService = game:GetService("RunService")


for i, v in pairs(StarterPlayerScript:GetDescendants()) do
	if v.ClassName == "ModuleScript" then
		if v:FindFirstAncestor("Controllers") or v:FindFirstAncestor("Modules") then

			local m = Framework:Initalize(v)

		end
	end
end


for i, v in pairs(Framework.Controllers) do 
	Promise.new(function(resolve)
		v:Init()
	end)
end


for i, v in pairs(Framework.Controllers) do
	Promise.new(function()

		v:Start()
	end)
end

return nil 

--[[

Copy Code Below in a local script (Put in game/StarterPlayer/StarterPlayerScripts)
|
V

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Run.client)

]]--