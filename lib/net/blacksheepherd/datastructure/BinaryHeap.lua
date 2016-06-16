local Table = require("net.blacksheepherd.util.Table")
local BinaryHeap
do
  local _base_0 = {
    Insert = function(self, el)
      table.insert(self, el)
      return self:_upheap(#self)
    end,
    IsEmpty = function(self)
      return #self == 0
    end,
    _upheap = function(self, i)
      local el = self[i]
      local parentI = self:_parentI(i)
      if not (parentI == nil) then
        local parentEl = self[parentI]
        if el > parentEl then
          return Table.Swap(self, i, parentI)
        end
      end
    end,
    _downheap = function(self, i) end,
    _parentI = function(self, i)
      if not (i == 1) then
        return math.floor(i / 2)
      else
        return nil
      end
    end,
    _leftChildI = function(self, i)
      return self[2 * i]
    end,
    _rightChildI = function(self, i)
      return self[2 * i + 1]
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "BinaryHeap"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BinaryHeap = _class_0
  return _class_0
end
