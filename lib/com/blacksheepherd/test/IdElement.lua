local IdElement
do
  local _base_0 = {
    Id = function(self)
      return self._id
    end,
    Element = function(self)
      return self._element
    end,
    __eq = function(self, rhs)
      return self._id == rhs:Id() and self._element == rhs:Element()
    end,
    __tostring = function(self)
      return "IdElement<Id: " .. tostring(self._id) .. ";   Element: " .. tostring(self._element) .. ">"
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, id, element)
      self._id = id
      self._element = element
    end,
    __base = _base_0,
    __name = "IdElement"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  IdElement = _class_0
  return _class_0
end
