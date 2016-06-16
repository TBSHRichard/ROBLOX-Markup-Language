local Event = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.Event)
local RomlVar
do
  local _base_0 = {
    SetValue = function(self, value)
      local oldValue = self._value
      rawset(self, "_value", value)
      return self.Changed:notifyObservers(oldValue, value)
    end,
    GetValue = function(self)
      return self._value
    end,
    __newindex = function(self, key, value)
      if type(self._value) == "table" or type(self._value) == "userdata" and self._value.ClassName then
        local oldValue = self._value[key]
        self._value[key] = value
        return self.Changed:notifyObservers(key, oldValue, value)
      end
    end,
    Changed = nil
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, value)
      rawset(self, "_value", value)
      return rawset(self, "Changed", Event())
    end,
    __base = _base_0,
    __name = "RomlVar"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RomlVar = _class_0
  return _class_0
end
