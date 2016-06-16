local RossDoc
do
  local _base_0 = {
    StyleObject = function(self, romlObject)
      local objectName = romlObject:GetRobloxObject().ClassName
      self:_styleWithTable(romlObject, self._objects[objectName])
      local _list_0 = romlObject:GetClasses()
      for _index_0 = 1, #_list_0 do
        local c = _list_0[_index_0]
        self:_styleWithTable(romlObject, self._classes["." .. tostring(c)])
        self:_styleWithTable(romlObject, self._classes[tostring(objectName) .. "." .. tostring(c)])
      end
      local objectId = romlObject:GetObjectId()
      if not (objectId == nil) then
        self:_styleWithTable(romlObject, self._ids["#" .. tostring(objectId)])
        return self:_styleWithTable(romlObject, self._ids[tostring(objectName) .. "#" .. tostring(objectId)])
      end
    end,
    _styleWithTable = function(self, romlObject, t)
      if t == nil then
        t = { }
      end
      for _index_0 = 1, #t do
        local el = t[_index_0]
        if romlObject:MatchesSelector(el.selector:Clone()) then
          romlObject:StyleObject(el.properties)
        end
      end
    end,
    _setupObjects = function(self)
      return { }
    end,
    _setupClasses = function(self)
      return { }
    end,
    _setupIds = function(self)
      return { }
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self._objects = self:_setupObjects()
      self._classes = self:_setupClasses()
      self._ids = self:_setupIds()
    end,
    __base = _base_0,
    __name = "RossDoc"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RossDoc = _class_0
  return _class_0
end
