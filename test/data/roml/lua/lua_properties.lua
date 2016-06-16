local RomlVar = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").com.blacksheepherd.roml.RomlObject)
local Properties
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
      self._rootObject = RomlObject(self, parent)
      local objTemp
      local objScreenGui1
      objTemp = RomlObject(self, "Part", nil, nil)
      objTemp:SetProperties({BottomSurface = Enum.SurfaceType.Studs, BrickColor = BrickColor.new(0.2, 0.6, 0.4), Size = Vector3.new(63, 0, 15)})
      objTemp:Refresh()
      self:AddChild(self._rootObject:AddChild(objTemp))
      objTemp = RomlObject(self, "Part", nil, nil)
      objTemp:SetProperties({Size = Vector3.new(43, 43, 43), BrickColor = BrickColor.new(1001), Position = Vector3.new(38.5, 0.3, 55)})
      objTemp:Refresh()
      self:AddChild(self._rootObject:AddChild(objTemp))
      objTemp = RomlObject(self, "Part", nil, nil)
      objTemp:SetProperties({BrickColor = BrickColor.new(0.36, 0.67, 0.8), TopSurface = Enum.SurfaceType.Inlet})
      objTemp:Refresh()
      self:AddChild(self._rootObject:AddChild(objTemp))
      objTemp = RomlObject(self, "Part", nil, nil)
      objTemp:SetProperties({BrickColor = BrickColor.new("Sand red")})
      objTemp:Refresh()
      self:AddChild(self._rootObject:AddChild(objTemp))
      objScreenGui1 = RomlObject(self, "ScreenGui", nil, nil)
      self:AddChild(self._rootObject:AddChild(objScreenGui1))
      objTemp = RomlObject(self, "TextButton", nil, nil)
      objTemp:SetProperties({Style = Enum.ButtonStyle.RobloxButton, TextColor3 = BrickColor.new("Mid gray").Color, TextStrokeColor3 = BrickColor.new(12).Color, BorderColor3 = Color3.new(0.93, 1, 0.55), BackgroundColor3 = Color3.new(0.2, 0.6, 0.4)})
      objTemp:Refresh()
      self:AddChild(objScreenGui1:AddChild(objTemp))
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars, ross)
      return _parent_0.__init(self, parent, vars, ross)
    end,
    __base = _base_0,
    __name = "Properties",
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
  self.new = function(parent, vars, ross)
    return Properties(parent, vars, ross)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Properties = _class_0
end
return Properties
