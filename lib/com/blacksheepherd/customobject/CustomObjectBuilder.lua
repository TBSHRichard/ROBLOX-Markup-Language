local CustomObject = require("com.blacksheepherd.roml.CustomObject")
local LiteralString = require("com.blacksheepherd.compile.LiteralString")
local CompilerPropertyFilter = require("com.blacksheepherd.compile.CompilerPropertyFilter")
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
        objectTable.customObject.SetProperty = t.SetProperty
        if t.AllowsChildren then
          objectTable.customObject.AllowsChildren = t.AllowsChildren
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
    FilterProperty = function(self, objectName, propertyName, value)
      return self._customObjects[objectName].FilterProperty(propertyName, value, LiteralString, CompilerPropertyFilter)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self._customObjects = { }
      return self:Build("SpriteSheet", require("com.blacksheepherd.customobject.SpriteSheet"))
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
FilterProperty = function(objectName, propertyName, value)
  return CustomObjectBuilder.Instance():FilterProperty(objectName, propertyName, value)
end
return {
  CreateObject = CreateObject,
  CustomObjectBuilder = CustomObjectBuilder,
  FilterProperty = FilterProperty,
  IsACustomObject = IsACustomObject
}
