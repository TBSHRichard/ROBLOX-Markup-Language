local RomlVar = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlObject)
local CustomObjectBuilder = require(game:GetService("ServerScriptService").com.blacksheepherd.customobject.CustomObjectBuilder)
local SameVarMultiPlaces
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
      self._rootObject = RomlObject(self, parent)
      local objTemp
      local objFrame1
      local objSpriteSheet1
      local varChange_sheet
      local objFrame2
      local objSpriteSheet2
      varChange_sheet = function()
        objSpriteSheet1:SetProperties({SpriteSheet = self._vars.sheet:GetValue()})
        objSpriteSheet1:Refresh()
        objSpriteSheet2:SetProperties({SpriteSheet = self._vars.sheet:GetValue()})
        objSpriteSheet2:Refresh()
      end
      objFrame1 = RomlObject(self, "Frame", nil, nil)
      self:AddChild(self._rootObject:AddChild(objFrame1))
      self._vars.sheet = RomlVar(vars.sheet)
      self._vars.sheet.Changed:connect(varChange_sheet)
      objSpriteSheet1 = CustomObjectBuilder.CreateObject("SpriteSheet", self, nil, nil)
      self:AddChild(objFrame1:AddChild(objSpriteSheet1))
      objFrame2 = RomlObject(self, "Frame", nil, nil)
      self:AddChild(objFrame1:AddChild(objFrame2))
      objSpriteSheet2 = CustomObjectBuilder.CreateObject("SpriteSheet", self, nil, nil)
      self:AddChild(objFrame2:AddChild(objSpriteSheet2))
      varChange_sheet()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars, ross)
      return _parent_0.__init(self, parent, vars, ross)
    end,
    __base = _base_0,
    __name = "SameVarMultiPlaces",
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
    return SameVarMultiPlaces(parent, vars, ross)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  SameVarMultiPlaces = _class_0
end
return SameVarMultiPlaces
