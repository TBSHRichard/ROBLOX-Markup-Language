local RomlVar = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlObject)
local Objects
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
      self._rootObject = RomlObject(self, parent)
      local objTemp
      objTemp = RomlObject(self, "Model", nil, nil)
      self:AddChild(self._rootObject:AddChild(objTemp))
      objTemp = RomlObject(self, "Part", nil, nil)
      self:AddChild(self._rootObject:AddChild(objTemp))
      objTemp = RomlObject(self, "WedgePart", nil, nil)
      self:AddChild(self._rootObject:AddChild(objTemp))
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars, ross)
      return _parent_0.__init(self, parent, vars, ross)
    end,
    __base = _base_0,
    __name = "Objects",
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
  local self = _class_0
  self.new = function(parent, vars, ross)
    return Objects(parent, vars, ross)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Objects = _class_0
end
return Objects
