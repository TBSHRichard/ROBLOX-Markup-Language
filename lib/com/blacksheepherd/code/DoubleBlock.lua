local Block
local SpaceBlock
if game then
  Block = require(plugin.com.blacksheepherd.code.Block)
  SpaceBlock = require(plugin.com.blacksheepherd.code.SpaceBlock)
else
  Block = require("com.blacksheepherd.code.Block")
  SpaceBlock = require("com.blacksheepherd.code.SpaceBlock")
end
local DoubleBlock
do
  local _parent_0 = Block
  local _base_0 = {
    SetIndent = function(self, indent)
      self._indent = indent
      self._topBlock:SetIndent(tostring(indent) .. "  ")
      return self._bottomBlock:SetIndent(tostring(indent) .. "  ")
    end,
    AddChild = function(self, block, child)
      if block == self.__class.TOP then
        return self._topBlock:AddChild(child)
      elseif block == self.__class.BOTTOM then
        return self._bottomBlock:AddChild(child)
      end
    end,
    MiddleRender = function(self) end,
    Render = function(self)
      local buffer = ""
      buffer = buffer .. self:BeforeRender()
      buffer = buffer .. "\n"
      buffer = buffer .. self._topBlock:Render()
      buffer = buffer .. "\n"
      buffer = buffer .. self:MiddleRender()
      buffer = buffer .. "\n"
      buffer = buffer .. self._bottomBlock:Render()
      buffer = buffer .. "\n"
      return buffer .. self:AfterRender()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      _parent_0.__init(self)
      self._topBlock = SpaceBlock()
      self._bottomBlock = SpaceBlock()
      table.insert(self._children, self._topBlock)
      return table.insert(self._children, self._bottomBlock)
    end,
    __base = _base_0,
    __name = "DoubleBlock",
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
  local self = _class_0
  self.TOP = "top"
  self.BOTTOM = "bottom"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DoubleBlock = _class_0
  return _class_0
end
