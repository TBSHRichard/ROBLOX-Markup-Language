local RomlObject = require(game:GetService("ServerScriptService").net.blacksheepherd.roml.RomlObject)
local ObjectBuilder
do
  local _base_0 = {
    Build = function(self, object, classes, properties)
      local obj = RomlObject(object, classes)
      self[#self]:AddChild(obj)
      if properties then
        obj:SetProperties(properties)
        obj:Refresh()
      end
      table.insert(self, obj)
      return obj
    end,
    Pop = function(self)
      return table.remove(self)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, root)
      return table.insert(self, RomlObject(root))
    end,
    __base = _base_0,
    __name = "ObjectBuilder"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ObjectBuilder = _class_0
end
return ObjectBuilder
