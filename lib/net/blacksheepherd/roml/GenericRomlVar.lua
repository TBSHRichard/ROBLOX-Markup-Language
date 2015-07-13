local Event = require("Event")
local GenericRomlVar
do
  local _base_0 = {
    Set = function(self, value)
      if not (type(value) == "table") then
        local oldValue = self._value
        self._value = value
        return self.Changed:notifyObservers(oldValue, value)
      end
    end,
    Changed = nil
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, value)
      self._value = value
      self.Changed = Event()
    end,
    __base = _base_0,
    __name = "GenericRomlVar"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  GenericRomlVar = _class_0
  return _class_0
end
