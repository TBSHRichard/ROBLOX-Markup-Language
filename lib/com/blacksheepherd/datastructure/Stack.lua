local Stack
do
  local _base_0 = {
    Push = function(self, el)
      return table.insert(self, el)
    end,
    Pop = function(self)
      return table.remove(self)
    end,
    Peek = function(self)
      return self[#self]
    end,
    IsEmpty = function(self)
      return #self == 0
    end,
    Clone = function(self)
      return Stack(self)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, stack)
      if stack == nil then
        stack = { }
      end
      for _index_0 = 1, #stack do
        local el = stack[_index_0]
        table.insert(self, 1, el)
      end
    end,
    __base = _base_0,
    __name = "Stack"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Stack = _class_0
end
return Stack
