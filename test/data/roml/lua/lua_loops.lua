local RomlVar = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlObject)
local Loops
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
      self._rootObject = RomlObject(self, parent)
      local objTemp
      local updateParent
      local varChange_myTable
      updateParent = function()
        self._rootObject:RemoveAllChildren()
        for _, child in pairs(self._vars.myTable:GetValue()) do
          objTemp = RomlObject(self, "Part", nil, nil)
          self:AddChild(self._rootObject:AddChild(objTemp))
        end
      end
      varChange_myTable = function()
        updateParent()
      end
      self._vars.myTable = RomlVar(vars.myTable)
      self._vars.myTable.Changed:connect(varChange_myTable)
      varChange_myTable()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars, ross)
      return _parent_0.__init(self, parent, vars, ross)
    end,
    __base = _base_0,
    __name = "Loops",
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
    return Loops(parent, vars, ross)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Loops = _class_0
end
return Loops
