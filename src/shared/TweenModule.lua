local TweenModule = {}

TweenModule.__index = TweenModule

local TweenService = game:GetService("TweenService")

function TweenModule.GetTween(ti, instance, p)
	local self = setmetatable({}, TweenModule)
	self.TweenInfo = ti
	self.Instance = instance
	self.Properties = p
	
	self.Tween = TweenService:Create(self.Instance, self.TweenInfo, self.Properties)
	return self
end

function TweenModule:Start()
	self.Tween:Play()
end

function TweenModule:Connect(func)
	
	return func(self.Tween)
end

return TweenModule
