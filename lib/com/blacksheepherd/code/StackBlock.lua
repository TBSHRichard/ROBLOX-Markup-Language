local Block = require("com.blacksheepherd.code.Block")
local StackBlock
do
  local _parent_0 = Block
  local _base_0 = {
    Render = function(self)
      local buffer = ""
      buffer = buffer .. self:BeforeRender()
      buffer = buffer .. "\n"
      for i, child in ipairs(self._children) do
        buffer = buffer .. child:Render()
        if not (i == #self._children) then
          buffer = buffer .. ","
        end
        buffer = buffer .. "\n"
      end
      return buffer .. self:AfterRender()
    end,
    BeforeRender = function(self)
      return tostring(self._indent) .. tostring(self._name) .. " = Stack({"
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
    end,
    __base = _base_0,
    __name = "StackBlock",
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
  StackBlock = _class_0
end
return StackBlock
