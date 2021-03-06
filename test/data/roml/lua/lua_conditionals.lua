local RomlVar = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlObject)
local Conditionals
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
      self._rootObject = RomlObject(self, parent)
      local objTemp
      local updateParent
      local varChange_foo
      local varChange_bar
      updateParent = function()
        self._rootObject:RemoveAllChildren()
        if 5 == 5 then
          objTemp = RomlObject(self, "Part", nil, nil)
          self:AddChild(self._rootObject:AddChild(objTemp))
        elseif self._vars.foo:GetValue() < self._vars.bar:GetValue() then
          objTemp = RomlObject(self, "Model", nil, nil)
          self:AddChild(self._rootObject:AddChild(objTemp))
        else
          objTemp = RomlObject(self, "ScreenGui", nil, nil)
          self:AddChild(self._rootObject:AddChild(objTemp))
        end
      end
      varChange_foo = function()
        updateParent()
      end
      varChange_bar = function()
        updateParent()
      end
      self._vars.foo = RomlVar(vars.foo)
      self._vars.foo.Changed:connect(varChange_foo)
      self._vars.bar = RomlVar(vars.bar)
      self._vars.bar.Changed:connect(varChange_bar)
      varChange_foo()
      varChange_bar()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars, ross)
      return _parent_0.__init(self, parent, vars, ross)
    end,
    __base = _base_0,
    __name = "Conditionals",
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
    return Conditionals(parent, vars, ross)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Conditionals = _class_0
end
return Conditionals
