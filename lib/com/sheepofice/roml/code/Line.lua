local Line
do
  local _base_0 = {
    SetIndent = function(self, indent)
      self._indent = indent
    end,
    Render = function(self)
      return tostring(self._indent) .. tostring(self._text)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, text)
      self._indent = ""
      self._text = text
    end,
    __base = _base_0,
    __name = "Line"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Line = _class_0
end
return Line
