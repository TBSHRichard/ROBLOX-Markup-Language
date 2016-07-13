local HashMap
local _currentId = 1
if game then
  HashMap = require(game:GetService("ServerScriptService").com.blacksheepherd.util.HashMap)
else
  HashMap = require("com.blacksheepherd.util.HashMap")
end
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
    ObjectName = function(self)
      return self._robloxObject.ClassName
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
    StyleObject = function(self, properties)
      for name, property in pairs(properties) do
        local filter = self._propertyFilters[name]
        if filter then
          filter(property, self._robloxObject)
        else
          self._robloxObject[name] = property
        end
      end
    end,
    AddChild = function(self, child)
      if self:AllowsChildren() then
        child:SetParent(self)
        self._children[child:GetId()] = child
        return child
      else
        return error("RomlObject '" .. tostring(self.__class.__name) .. "' does not allow children objects.")
      end
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
      for _, child in self._children:pairs() do
        self._romlDoc:RemoveChild(child)
        child:RemoveAllChildren()
        child._robloxObject:Destroy()
      end
      self._children = { }
    end,
    GetId = function(self)
      return self._id
    end,
    GetObjectId = function(self)
      return self._objectId
    end,
    GetClasses = function(self)
      return self._classes
    end,
    RemoveChild = function(self, child)
      child:SetParent(nil)
      self._children[child:GetId()] = nil
    end,
    HasClass = function(self, className)
      local _list_0 = self._classes
      for _index_0 = 1, #_list_0 do
        local name = _list_0[_index_0]
        if name == className then
          return true
        end
      end
      return false
    end,
    MatchesSelector = function(self, selectorStack)
      local selector = selectorStack:Pop()
      local matches = false
      if selector.object ~= nil then
        matches = selector.object == self:ObjectName()
        if selector.class ~= nil then
          matches = matches and self:HasClass(selector.class)
        elseif selector.id ~= nil then
          matches = matches and selector.id == self._objectId
        end
      else
        if selector.class ~= nil then
          matches = self:HasClass(selector.class)
        else
          matches = selector.id == self._objectId
        end
      end
      if matches then
        if not (selectorStack:IsEmpty()) then
          return self._parent:MatchesSelector(selectorStack)
        else
          return true
        end
      else
        return false
      end
    end,
    AllowsChildren = function(self)
      return true
    end,
    Find = function(self, selector) end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, romlDoc, object, objectId, classes)
      if classes == nil then
        classes = { }
      end
      self._romlDoc = romlDoc
      self._id = _currentId
      _currentId = _currentId + 1
      self._properties = { }
      self._propertyFilters = { }
      self._objectId = objectId
      if type(object) == "string" then
        object = Instance.new(object)
      end
      self._robloxObject = object
      self._classes = classes
      self._children = HashMap({ })
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
  RomlObject = _class_0
end
return RomlObject
