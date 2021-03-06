local Block
if game then
  local pluginModel = script.Parent.Parent.Parent.Parent
  Block = require(pluginModel.com.blacksheepherd.code.Block)
else
  Block = require("com.blacksheepherd.code.Block")
end
local ForBlock
do
  local _parent_0 = Block
  local _base_0 = {
    BeforeRender = function(self)
      return tostring(self._indent) .. "for " .. tostring(self._condition) .. " do"
    end,
    AfterRender = function(self)
      return tostring(self._indent) .. "end"
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, condition)
      _parent_0.__init(self)
      self._condition = condition
    end,
    __base = _base_0,
    __name = "ForBlock",
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
  ForBlock = _class_0
end
return ForBlock
