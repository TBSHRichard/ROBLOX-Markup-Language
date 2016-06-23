local RossDoc = require(game:GetService("ServerScriptService").com.blacksheepherd.ross.RossDoc)
local Stack = require(game:GetService("ServerScriptService").com.blacksheepherd.datastructure.Stack)
local CustomObject
do
  local _parent_0 = RossDoc
  local _base_0 = {
    _setupObjects = function(self)
      local objects = {}
      objects["SpriteSheet"] = {
        {
          selector = Stack({
            {
              object = "SpriteSheet"
            }
          }),
          properties = {Size = Vector2.new(64, 64)}
        }
      }
      return objects
    end,
    _setupClasses = function(self)
      local classes = {}
      return classes
    end,
    _setupIds = function(self)
      local ids = {}
      return ids
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      return _parent_0.__init(self)
    end,
    __base = _base_0,
    __name = "CustomObject",
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
  self.new = function()
    return CustomObject()
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  CustomObject = _class_0
end
return CustomObject
