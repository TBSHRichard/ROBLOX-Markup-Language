local RomlObject
if game then
  RomlObject = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlObject)
else
  RomlObject = require("com.blacksheepherd.roml.RomlObject")
end
local CustomObject
do
  local _parent_0 = RomlObject
  local _base_0 = {
    Create = function(self) end,
    CreateProperties = function(self)
      return { }
    end,
    PropertyUpdateOrder = function(self)
      return { }
    end,
    UpdateProperty = function(self, name, value) end,
    Refresh = function(self)
      local propertyUpdateOrder = self:PropertyUpdateOrder()
      if #propertyUpdateOrder > 0 then
        for _index_0 = 1, #propertyUpdateOrder do
          local name = propertyUpdateOrder[_index_0]
          self:UpdateProperty(name, self._properties[name])
        end
      else
        for name, property in pairs(self._properties) do
          self:UpdateProperty(name, property)
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, romlDoc, objectId, classes)
      _parent_0.__init(self, romlDoc, self:Create(), objectId, classes)
      self._properties = self:CreateProperties()
    end,
    __base = _base_0,
    __name = "CustomObject",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  CustomObject = _class_0
  return _class_0
end
