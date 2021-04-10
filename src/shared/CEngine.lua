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
	
	OrderTable = {

	};
	
	Storage = game:GetService("ReplicatedStorage"):WaitForChild("Storage")
}


local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local StarterPlayerScript = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local HeartBeat = game:GetService("RunService").Heartbeat
local IsServer = game:GetService("RunService"):IsServer()

CEngine.__index = CEngine


function CEngine:Initalize(module : table)
	local org = require(module)
	org.Ran = false 

	local tab = setmetatable(org, self)
	
	
	local _type = self[module.Parent.Name] 

	_type[module.Name] = org

	org._type = module.Parent.Name
	
	if org._type == "Controller" then
		for _, v in pairs(Shared:GetChildren()) do
			org.Shared[v.Name] = require(v)
		end
	end

	if type(org.Order) == "number" then
		table.insert(self.OrderTable, org.Order, org)

	else
		self.OrderTable[module.name] = org
	end
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
				local RemoteFunction = Instance.new("RemoteFunction")
				RemoteFunction.Name = i 
				RemoteFunction.OnServerInvoke = v
				RemoteFunction.Parent = Remotes
			end
		end
	elseif self.Server ~= nil then
		for i, v in pairs(self.Server) do
			assert(Remotes[i], " RemoteFunction does not exist")
			local RemoteFunction = Remotes[i]
			RemoteFunction.OnClientInvoke = v
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


return CEngine