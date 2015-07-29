local Block
do
  local _base_0 = {
    AddChild = function(self, child)
      child:SetIndent(tostring(self._indent) .. "  ")
      return table.insert(self._children, child)
    end,
    SetIndent = function(self, indent)
      self._indent = indent
      local _list_0 = self._children
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        child:SetIndent(tostring(self._indent) .. "  ")
      end
    end,
    BeforeRender = function(self) end,
    AfterRender = function(self) end,
    Render = function(self)
      local buffer = ""
      buffer = buffer .. self:BeforeRender()
      buffer = buffer .. "\n"
      local _list_0 = self._children
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        buffer = buffer .. child:Render()
        if child.__class.__name ~= "SpaceBlock" or child.__class.__name == "SpaceBlock" and #child._children > 0 then
          buffer = buffer .. "\n"
        end
      end
      return buffer .. self:AfterRender()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self._indent = ""
      self._children = { }
    end,
    __base = _base_0,
    __name = "Block"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Block = _class_0
end
return Block
