local LiteralString
do
  local _base_0 = {
    __tostring = function(self)
      return self._string
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, s)
      self._string = s
    end,
    __base = _base_0,
    __name = "LiteralString"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  LiteralString = _class_0
  return _class_0
end
