local Block
local Line
if game then
  Block = require(plugin.com.blacksheepherd.code.Block)
  Line = require(plugin.com.blacksheepherd.code.Line)
else
  Block = require("com.blacksheepherd.code.Block")
  Line = require("com.blacksheepherd.code.Line")
end
local FunctionBlock
do
  local _parent_0 = Block
  local _base_0 = {
    BeforeRender = function(self)
      return tostring(self._indent) .. tostring(self._name) .. " = function(" .. tostring(self._parameters) .. ")"
    end,
    AfterRender = function(self)
      return tostring(self._indent) .. "end"
    end,
    AddLineIfNotAdded = function(self, lineString)
      if not (self._addedLines[lineString]) then
        self._addedLines[lineString] = true
        return self:AddChild(Line(lineString))
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, name, parameters)
      _parent_0.__init(self)
      self._name = name
      self._parameters = parameters
      self._addedLines = { }
    end,
    __base = _base_0,
    __name = "FunctionBlock",
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
  FunctionBlock = _class_0
end
return FunctionBlock
