local Line
if game then
  local pluginModel = script.Parent.Parent.Parent.Parent
  Line = require(pluginModel.com.blacksheepherd.code.Line)
else
  Line = require("com.blacksheepherd.code.Line")
end
local RequireLine
do
  local _parent_0 = Line
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, package, name)
      return _parent_0.__init(self, "local " .. tostring(name) .. " = require(game:GetService(\"ServerScriptService\")." .. tostring(package) .. "." .. tostring(name) .. ")")
    end,
    __base = _base_0,
    __name = "RequireLine",
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
  RequireLine = _class_0
end
return RequireLine
