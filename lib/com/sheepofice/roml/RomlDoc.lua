local RomlDoc
do
  local _base_0 = {
    GetVar = function(self, varName)
      return self._vars[varName]
    end,
    Find = function(self, selector)
      return {
        [self._rootObject] = Find(selector)
      }
    end,
    _create = function(self, parent, vars) end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, parent, vars)
      self._objectIds = { }
      self._vars = { }
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
