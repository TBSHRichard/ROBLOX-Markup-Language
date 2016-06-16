local RomlVar = require(game:GetService("ServerScriptService").net.blacksheepherd.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").net.blacksheepherd.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").net.blacksheepherd.roml.RomlObject)
local VarProperties
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
      self._rootObject = RomlObject(self, parent)
      local objTemp
      local objPart1
      local varChange_partColor
      varChange_partColor = function()
        objPart1:SetProperties({BrickColor = self._vars.partColor:GetValue()})
        objPart1:Refresh()
      end
      self._vars.partColor = RomlVar(vars.partColor)
      self._vars.partColor.Changed:connect(varChange_partColor)
      objPart1 = RomlObject(self, "Part", nil, nil)
      objPart1:SetProperties({TopSurface = Enum.SurfaceType.Weld})
      objPart1:Refresh()
      self:AddChild(self._rootObject:AddChild(objPart1))
      varChange_partColor()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars, ross)
      return _parent_0.__init(self, parent, vars, ross)
    end,
    __base = _base_0,
    __name = "VarProperties",
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
    return VarProperties(parent, vars, ross)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  VarProperties = _class_0
end
return VarProperties
