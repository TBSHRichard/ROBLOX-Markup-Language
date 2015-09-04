local RomlVar = require(game:GetService("ServerScriptService").net.blacksheepherd.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").net.blacksheepherd.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").net.blacksheepherd.roml.RomlObject)
local Nesting
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
      self._rootObject = RomlObject(parent)
      local objTemp
      local objScreenGui1
      local updateScreenGui1
      local varChange_messages
      updateScreenGui1 = function()
        objScreenGui1:RemoveAllChildren()
        for _, message in pairs(messages) do
          objTemp = RomlObject("TextLabel", nil)
          objTemp:SetProperties({Text = message.name})
          objTemp:Refresh()
          objScreenGui1:AddChild(objTemp)
          objTemp = RomlObject("TextLabel", nil)
          objTemp:SetProperties({Text = message.body})
          objTemp:Refresh()
          objScreenGui1:AddChild(objTemp)
          if message.author == "Admin" then
            objTemp = RomlObject("ImageLabel", nil)
            objTemp:SetProperties({Image = "rbxassetid://0"})
            objTemp:Refresh()
            objScreenGui1:AddChild(objTemp)
          end
        end
      end
      varChange_messages = function()
        updateScreenGui1()
      end
      objScreenGui1 = RomlObject("ScreenGui", nil)
      self._rootObject:AddChild(objScreenGui1)
      self._vars.messages = RomlVar(vars.messages)
      self._vars.messages.Changed:connect(varChange_messages)
      varChange_messages()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars)
      return _parent_0.__init(self, parent, vars)
    end,
    __base = _base_0,
    __name = "Nesting",
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
  self.new = function(parent, vars)
    return Nesting(parent, vars)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Nesting = _class_0
end
return Nesting
