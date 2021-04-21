local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local StarterPlayerScript = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local HeartBeat = game:GetService("RunService").Heartbeat
local IsServer = game:GetService("RunService"):IsServer()

local CEngine = {
	Class = {
		
	};
	Services = {
		
	};
	Controllers = {
		
	};
	Util = {
		
	};
	
	Shared = {
		
	};

}


CEngine.__index = CEngine

function CEngine:Initalize(module : table)
	local org = require(module)

	local tab = setmetatable(org, self)
	
	
	local _type = self[module.Parent.Name] 

	_type[module.Name] = org

	org._type = module.Parent.Name
	
	if IsServer then 
		org.assets = game:GetService("ServerScriptService").Assets
	end
	
	return org 
end

function CEngine:ConnectEvent(name: string, func: Function)

	if IsServer then
		local RemoteEvent = Remotes:FindFirstChild(name)

		if RemoteEvent then
			RemoteEvent.OnServerEvent:Connect(func)
		end
	else
		local RemoteEvent = Remotes:FindFirstChild(name)

	if RemoteEvent then
		RemoteEvent.OnClientEvent:Connect(func)
	end

	end
end



function CEngine:RegisterEvent(name: string)
	local RemoteEvent = Instance.new("RemoteEvent"); RemoteEvent.Name = name
	RemoteEvent.Parent = Remotes
	self[name] = RemoteEvent
end


function CEngine:RegisterFunction(arg: string)
	if IsServer then
		if arg ~= nil then
			local RemoteFunction = Instance.new("RemoteFunction")
			RemoteFunction.Name = arg
			RemoteFunction.Parent = Remotes
			
		elseif self.Client ~= nil then
			for i, v in pairs(self.Client) do
			
				if type(v) == "function" then 
					local RemoteFunction = Instance.new("RemoteFunction")
					RemoteFunction.Name = i 
					RemoteFunction.OnServerInvoke = v
					RemoteFunction.Parent = Remotes
				end
			end
		end
	elseif self.Server ~= nil then
		for i, v in pairs(self.Server) do
			assert(Remotes[i], " RemoteFunction does not exist")
			if type(v) == "function" then 
				local RemoteFunction = Remotes[i]
				RemoteFunction.OnClientInvoke = v
			end
		end
	end
end


function CEngine:Fire(name: string, ...)
	local Remote = Remotes:FindFirstChild(name)

	if Remote then


		if Remote.ClassName == "RemoteEvent" then
			local r = Remote:FireServer(...)

		elseif Remote.ClassName == "RemoteFunction" then
			local r = Remote:InvokeServer(...)
			
			return r
		end

	end

end

function CEngine:FireClient(name : string, player : client, ...)
	local Remote = Remotes:FindFirstChild(name)

	if Remote then


		if Remote.ClassName == "RemoteEvent" then
			Remote:FireClient(player, ...)
		elseif Remote.ClassName == "RemoteFunction" then
			local r = Remote:InvokeClient(player, ...)
			
			return r
		end

	end

end

function CEngine:FireAllClients(name : string, ...)
	local Remote = Remotes:FindFirstChild(name)

	if Remote then

		Remote:FireAllClients(...)

	end
end

function CEngine:Yield(func: Function)

	return self.Shared.Promise.new(func)
end

for i, v in pairs(Shared:GetChildren()) do

	if v.Name ~= "CEngine" then

		CEngine:Initalize(v)

	end
end


return CEngine