local Event = require("Event")
local TableRomlVar
do
  local _base_0 = {
    __newindex = function(self, key, value)
      local oldValue = self._table[key]
      self._table[key] = value
      return self.Changed:notifyObservers(key, oldValue, value)
    end,
    Changed = nil
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, t)
      if t == nil then
        t = { }
      end
      self._table = t
      self.Changed = Event()
    end,
    __base = _base_0,
    __name = "TableRomlVar"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  TableRomlVar = _class_0
end
return TableRomlVar
