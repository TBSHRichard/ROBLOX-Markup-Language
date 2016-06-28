local CustomObject
if game then
  CustomObject = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.CustomObject)
else
  CustomObject = require("com.blacksheepherd.roml.CustomObject")
end
local CustomObjectBuilder
do
  local _base_0 = {
    Build = function(self, name, t)
      if not (self:HasObject(name)) then
        local objectTable = { }
        objectTable.FilterProperty = t.FilterProperty or function(name, value)
          return LiteralString(value)
        end
        objectTable.customObject = CustomObject()
        objectTable.customObject.Create = t.Create
        if t.CreateProperties then
          objectTable.customobject.CreateProperties = t.CreateProperties
        end
        objectTable.customObject.UpdateProperty = t.UpdateProperty
        if t.AllowsChildren then
          objectTable.customObject.AllowsChildren = t.AllowsChildren
        end
        if t.PropertyUpdateOrder then
          objectTable.customobject.PropertyUpdateOrder = t.PropertyUpdateOrder
        end
        objectTable.customObject.__class.__name = name
        self._customObjects[name] = objectTable
      end
    end,
    HasObject = function(self, name)
      return self._customObjects[name] ~= nil
    end,
    GetObject = function(self, name)
      return self._customObjects[name].customObject
    end,
    FilterProperty = function(self, objectName, propertyName, value, LiteralString, CompilerPropertyFilter)
      return self._customObjects[objectName].FilterProperty(propertyName, value, LiteralString, CompilerPropertyFilter)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self._customObjects = { }
      if game then
        self:Build("SpriteSheet", require(plugin.com.blacksheepherd.customobject.SpriteSheet))
        local _list_0 = game:GetService("ServerScriptService").com.blacksheepherd.customobject.user:GetChildren()
        for _index_0 = 1, #_list_0 do
          local moduleScript = _list_0[_index_0]
          self:Build(moduleScript.name, require(moduleScript))
        end
      else
        return self:Build("SpriteSheet", require("com.blacksheepherd.customobject.SpriteSheet"))
      end
    end,
    __base = _base_0,
    __name = "CustomObjectBuilder"
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
  self.Instance = function()
    if not (self.__class._instance) then
      self.__class._instance = CustomObjectBuilder()
    end
    return self.__class._instance
  end
  CustomObjectBuilder = _class_0
end
local IsACustomObject
IsACustomObject = function(name)
  return CustomObjectBuilder.Instance():HasObject(name)
end
local CreateObject
CreateObject = function(name, romlDoc, objectId, classes)
  return CustomObjectBuilder.Instance():GetObject(name)(romlDoc, objectId, classes)
end
local FilterProperty
FilterProperty = function(objectName, propertyName, value, LiteralString, CompilerPropertyFilter)
  return CustomObjectBuilder.Instance():FilterProperty(objectName, propertyName, value, LiteralString, CompilerPropertyFilter)
end
return {
  CreateObject = CreateObject,
  FilterProperty = FilterProperty,
  IsACustomObject = IsACustomObject
}
