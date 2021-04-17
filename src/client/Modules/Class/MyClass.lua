local MyClass = {}
MyClass.__index = MyClass


function MyClass.new()
local self = setmetatable({
    
}, MyClass)

  return self
end

function MyClass:Destroy()


end

return MyClass