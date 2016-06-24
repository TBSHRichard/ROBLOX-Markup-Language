local HashMap = require(game:GetService("ServerScriptService").com.blacksheepherd.util.HashMap)
local RossDoc = require(game:GetService("ServerScriptService").com.blacksheepherd.ross.RossDoc)
local RomlDoc
do
  local _base_0 = {
    GetVar = function(self, varName)
      return self._vars[varName]
    end,
    Find = function(self, selector)
      return self._rootObject:Find(selector)
    end,
    AddChild = function(self, romlObject)
      self._children[romlObject:GetId()] = romlObject
      if not (self._ross == nil) then
        return self._ross:StyleObject(romlObject)
      end
    end,
    RemoveChild = function(self, romlObject)
      self._children[romlObject:GetId()] = nil
    end,
    SetStyleSheet = function(self, ross)
      self._ross = ross
      for _, romlObject in self._children:pairs() do
        self._ross:StyleObject(romlObject)
      end
    end,
    _create = function(self, parent, vars) end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, parent, vars, ross)
      if ross == nil then
        ross = RossDoc()
      end
      self._objectIds = { }
      self._vars = { }
      self._ross = ross
      self._children = HashMap({ })
      return self:_create(parent, vars)
    end,
    __base = _base_0,
    __name = "RomlDoc"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RomlDoc = _class_0
end
return RomlDoc
