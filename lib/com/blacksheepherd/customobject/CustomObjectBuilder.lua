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
      local objectTable = { }
      objectTable.FilterProperty = t.FilterProperty or function(name, value, LiteralString, CompilerPropertyFilter)
        return LiteralString(value)
      end
      do
        local _parent_0 = CustomObject
        local _base_1 = {
          Create = t.Create,
          UpdateProperty = t.UpdateProperty
        }
        _base_1.__index = _base_1
        setmetatable(_base_1, _parent_0.__base)
        local _class_0 = setmetatable({
          __init = function(self, romlDoc, objectId, classes)
            self.__class.__name = name
            if t.CreateProperties then
              self.CreateProperties = t.CreateProperties
            end
            if t.AllowsChildren then
              self.AllowsChildren = t.AllowsChildren
            end
            if t.PropertyUpdateOrder then
              self.PropertyUpdateOrder = t.PropertyUpdateOrder
            end
            return _parent_0.__init(self, romlDoc, objectId, classes)
          end,
          __base = _base_1,
          __name = "customObject",
          __parent = _parent_0
        }, {
          __index = function(cls, name)
            local val = rawget(_base_1, name)
            if val == nil then
              return _parent_0[name]
            else
              return val
            end
          end,
          __call = function(cls, ...)
            local _self_0 = setmetatable({}, _base_1)
            cls.__init(_self_0, ...)
            return _self_0
          end
        })
        _base_1.__class = _class_0
        if _parent_0.__inherited then
          _parent_0.__inherited(_parent_0, _class_0)
        end
        objectTable.customObject = _class_0
      end
      self._customObjects[name] = objectTable
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
        self:Build("SpriteSheet", require(game:GetService("ServerScriptService").com.blacksheepherd.customobject.SpriteSheet))
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
