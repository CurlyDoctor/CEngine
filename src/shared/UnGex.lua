local UnGex = {}
UnGex._type = "Shared"
UnGex.__index = UnGex


local InterfaceTypes = {
    ["ScreenGui"] = function()
        local newGui = Instance.new("ScreenGui")

        return newGui
    end,
    ["TextLabel"] = function()
        local newLabel = Instance.new("TextLabel")

        return newLabel
    end,
    ["TextButton"] = function()
        local newTextButton = Instance.new("TextButton")

        return newTextButton
    end,
    ["Frame"] = function()
        local newFrame = Instance.new("Frame")

        return newFrame
    end,
    ["ImageButton"] = function()
        local ImageButton = Instance.new("ImageButton")

        return ImageButton
    end,
    ["TextBox"] = function()
        local TextBox = Instance.new("TextBox")

        return TextBox
    end,
    ["ImageLabel"] = function()
        local ImageLabel = Instance.new("ImageLabel")

        return ImageLabel
    end,
    ["ScrollingFrame"] = function()
        local ScrollingFrame = Instance.new("ScrollingFrame")

        return ScrollingFrame
    end
}




function UnGex.CreateElement(Interface)
    assert(Interface.Class, " Class of Interface has to be defined.")
    assert(Interface.V, "Value has to be defined")
    
    local newElement

    if Interface.UI == nil then
		
		newElement = InterfaceTypes[Interface.Class]()
		Interface.UI = newElement
		
	else
		newElement = Interface.UI
	end
    
	for index, value in pairs(Interface.V) do
		newElement[index] = value
	end

  
    
    if (Interface.Children ~= nil) then
        for i, Child in pairs(Interface.Children) do
            if (Child.V.Parent == nil) then

                Child.UI.Parent = Interface.UI; Child.V.Parent = Interface.UI

            end
        end
    end

    setmetatable(Interface, UnGex)

    if (Interface.maid) then
        Interface.maid:GiveTask(Interface)
    end
    return Interface

end

function UnGex:Update()
    for i, v in pairs(self.V) do
        assert(self.UI[i], " Index does not exist in UI.")
        self.UI[i] = v
    end
end

function UnGex:Destroy()
    self.UI:Destroy()
    
    for i, v in pairs(self.V) do
        self.V[i] = nil
    end
    
    for i, v in pairs(self.Children) do
        self.Children[i] = nil
    end

    self.Class = nil; self.V = nil; self.Children = nil
    
end

function UnGex:Get(gui)
    local ClonedGui = gui:Clone()


    return ClonedGui
end

function UnGex:Clone()
    local newInterface = Interface(self)

    return newInterface
end

return UnGex