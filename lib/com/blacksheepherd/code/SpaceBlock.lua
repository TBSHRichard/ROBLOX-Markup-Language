local Block
if game then
  local pluginModel = script.Parent.Parent.Parent.Parent
  Block = require(pluginModel.com.blacksheepherd.code.Block)
else
  Block = require("com.blacksheepherd.code.Block")
end
local SpaceBlock
do
  local _parent_0 = Block
  local _base_0 = {
    AddChild = function(self, child)
      child:SetIndent(self._indent)
      return table.insert(self._children, child)
    end,
    SetIndent = function(self, indent)
      _parent_0.SetIndent(self, indent)
      local _list_0 = self._children
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        child:SetIndent(indent)
      end
    end,
    Render = function(self)
      local buffer = ""
      for i, child in ipairs(self._children) do
        buffer = buffer .. child:Render()
        if i < #self._children and (child.__class.__name ~= "SpaceBlock" or child.__class.__name == "SpaceBlock" and #child._children > 0) then
          buffer = buffer .. "\n"
        end
      end
      return buffer
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "SpaceBlock",
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
  SpaceBlock = _class_0
end
return SpaceBlock
