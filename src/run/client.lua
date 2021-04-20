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


Promise.new(function(resolve)
	local servicepromises = {}
	for i, v in pairs(Framework.Controllers) do 
		table.insert(servicepromises, #servicepromises + 1, Promise.new(function(resolve) 
			v:Init()
			resolve(v)			
		end))
	end

	resolve(Promise.all(servicepromises))
end):andThen(function(resolve) 
	for i, v in pairs(Framework.Controllers) do
		v:Start()
	end
end)

return nil 

