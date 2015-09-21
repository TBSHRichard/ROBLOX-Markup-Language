local RomlObject
do
  local _base_0 = {
    SetParent = function(self, parent)
      self._parent = parent
      if parent then
        self._robloxObject.Parent = parent:GetRobloxObject()
      end
    end,
    GetRobloxObject = function(self)
      return self._robloxObject
    end,
    Refresh = function(self)
      for name, property in pairs(self._properties) do
        local filter = self._propertyFilters[name]
        if filter then
          filter(property, self._robloxObject)
        else
          self._robloxObject[name] = property
        end
      end
    end,
    AddChild = function(self, child)
      child:SetParent(self)
      self._children[child:GetId()] = child
    end,
    SetProperties = function(self, properties)
      for name, value in pairs(properties) do
        self._properties[name] = value
      end
    end,
    SetClasses = function(self, classes)
      self._classes = classes
    end,
    RemoveAllChildren = function(self)
      local _list_0 = self._children
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        child._robloxObject:Destroy()
      end
      self._children = { }
    end,
    GetId = function(self)
      return self._id
    end,
    RemoveChild = function(self, child)
      child:SetParent(nil)
      self._children[child:GetId()] = nil
    end,
    Find = function(self, selector) end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, object, classes)
      if classes == nil then
        classes = { }
      end
      self._id = self.__class._currentId
      self.__class._currentId = self.__class._currentId + 1
      self._properties = { }
      self._propertyFilters = { }
      self._robloxObject = object
      self._classes = classes
      self._children = { }
    end,
    __base = _base_0,
    __name = "RomlObject"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self._currentId = 1
  RomlObject = _class_0
end
return RomlObject
