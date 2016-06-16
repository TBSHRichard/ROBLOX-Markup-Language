local VariableNamer
do
  local _base_0 = {
    NameObjectVariable = function(self, className)
      if self._nameCount[className] then
        self._nameCount[className] = self._nameCount[className] + 1
      else
        self._nameCount[className] = 1
      end
      return "obj" .. tostring(className) .. tostring(self._nameCount[className])
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self._nameCount = { }
    end,
    __base = _base_0,
    __name = "VariableNamer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  VariableNamer = _class_0
  return _class_0
end
