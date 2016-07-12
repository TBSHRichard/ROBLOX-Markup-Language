local RomlVar = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlObject)
local MultiVarsSamePlace
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
      self._rootObject = RomlObject(self, parent)
      local objTemp
      local objPart1
      local varChange_classes
      local varChange_color
      local varChange_size
      varChange_classes = function()
        objPart1:SetClasses(self._vars.classes:GetValue())
      end
      varChange_color = function()
        objPart1:SetProperties({BrickColor = self._vars.color:GetValue()})
        objPart1:Refresh()
      end
      varChange_size = function()
        objPart1:SetProperties({Size = self._vars.size:GetValue()})
        objPart1:Refresh()
      end
      self._vars.classes = RomlVar(vars.classes)
      self._vars.classes.Changed:connect(varChange_classes)
      self._vars.color = RomlVar(vars.color)
      self._vars.color.Changed:connect(varChange_color)
      self._vars.size = RomlVar(vars.size)
      self._vars.size.Changed:connect(varChange_size)
      objPart1 = RomlObject(self, "Part", nil, nil)
      self:AddChild(self._rootObject:AddChild(objPart1))
      varChange_classes()
      varChange_color()
      varChange_size()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars, ross)
      return _parent_0.__init(self, parent, vars, ross)
    end,
    __base = _base_0,
    __name = "MultiVarsSamePlace",
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
    return MultiVarsSamePlace(parent, vars, ross)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  MultiVarsSamePlace = _class_0
end
return MultiVarsSamePlace
