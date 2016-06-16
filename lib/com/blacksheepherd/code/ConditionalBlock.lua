local Block = require("com.blacksheepherd.code.Block")
local SpaceBlock = require("com.blacksheepherd.code.SpaceBlock")
local ConditionalBlock
do
  local _parent_0 = Block
  local _base_0 = {
    AddCondition = function(self, condition)
      if condition == nil then
        condition = ""
      end
      table.insert(self._conditions, condition)
      return _parent_0.AddChild(self, SpaceBlock())
    end,
    AddChild = function(self, child)
      return self._children[#self._children]:AddChild(child)
    end,
    Render = function(self)
      local buffer = ""
      for i, child in ipairs(self._children) do
        local lineString = self._conditions[i]
        if i == 1 then
          lineString = "if " .. tostring(lineString) .. " then"
        elseif lineString == "" then
          lineString = "else"
        else
          lineString = "elseif " .. tostring(lineString) .. " then"
        end
        buffer = buffer .. tostring(self._indent) .. tostring(lineString) .. "\n"
        buffer = buffer .. (child:Render() .. "\n")
      end
      return buffer .. tostring(self._indent) .. "end"
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      _parent_0.__init(self)
      self._conditions = { }
    end,
    __base = _base_0,
    __name = "ConditionalBlock",
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
  ConditionalBlock = _class_0
end
return ConditionalBlock
