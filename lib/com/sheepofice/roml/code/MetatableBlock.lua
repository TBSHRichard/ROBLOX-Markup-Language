local DoubleBlock = require("com.sheepofice.roml.code.DoubleBlock")
local InnerMetatableBlock = require("com.sheepofice.roml.code.InnerMetatableBlock")
local MetatableBlock
do
  local _parent_0 = DoubleBlock
  local _base_0 = {
    BeforeRender = function(self)
      return tostring(self._indent) .. "local " .. tostring(self._name) .. " = setmetatable({"
    end,
    MiddleRender = function(self)
      return tostring(self._indent) .. "}, {"
    end,
    AfterRender = function(self)
      return tostring(self._indent) .. "})"
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, name)
      _parent_0.__init(self)
      self._name = name
      self._topBlock = InnerMetatableBlock()
      self._bottomBlock = InnerMetatableBlock()
    end,
    __base = _base_0,
    __name = "MetatableBlock",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  MetatableBlock = _class_0
end
return MetatableBlock
