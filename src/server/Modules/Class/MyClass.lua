local MyClass = {}
MyClass.__index = MyClass
MyClass._type = "Class"

function MyClass.new()
local self = setmetatable({
  
}, MyClass)

  return self
end

function MyClass:Destroy()


end

return MyClass