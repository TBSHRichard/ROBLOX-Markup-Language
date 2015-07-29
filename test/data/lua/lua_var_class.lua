local RomlVar = require(game:GetService("ServerScriptService").com.sheepofice.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").com.sheepofice.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").com.sheepofice.roml.RomlObject)
local ObjectBuilder = require(game:GetService("ServerScriptService").com.sheepofice.roml.ObjectBuilder)
local VarClass
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
      local builder = ObjectBuilder(parent)
      local objTemp
      local objPart1
      local varChange_partClasses
      varChange_partClasses = function()
        objPart1:SetClasses(self._vars.partClasses:GetValue())
      end
      self._vars.partClasses = RomlVar(vars.partClasses)
      self._vars.partClasses.Changed:connect(varChange_partClasses)
      objPart1 = builder:Build("Part", nil)
      builder:Pop()
      varChange_partClasses()
      self._rootObject = builder:Pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars)
      return _parent_0.__init(self, parent, vars)
    end,
    __base = _base_0,
    __name = "VarClass",
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
    return VarClass(parent, vars)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  VarClass = _class_0
end
return VarClass
