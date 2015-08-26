local RomlVar = require(game:GetService("ServerScriptService").net.blacksheepherd.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").net.blacksheepherd.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").net.blacksheepherd.roml.RomlObject)
local Children
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
      self._rootObject = RomlObject(parent)
      local objTemp
      local objModel1
      local objModel2
      local objPart1
      objModel1 = RomlObject("Model", nil)
      self._rootObject:AddChild(objModel1)
      objModel2 = RomlObject("Model", nil)
      objModel1:AddChild(objModel2)
      objTemp = RomlObject("WedgePart", nil)
      objModel2:AddChild(objTemp)
      objTemp = RomlObject("Part", nil)
      objModel1:AddChild(objTemp)
      objPart1 = RomlObject("Part", nil)
      self._rootObject:AddChild(objPart1)
      objTemp = RomlObject("ClickDetector", nil)
      objPart1:AddChild(objTemp)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars)
      return _parent_0.__init(self, parent, vars)
    end,
    __base = _base_0,
    __name = "Children",
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
  self.new = function(parent, vars)
    return Children(parent, vars)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Children = _class_0
end
return Children
