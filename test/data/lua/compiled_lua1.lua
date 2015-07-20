local RomlVar = require(game:GetService("ServerScriptService").com.sheepofice.roml.RomlVar)
local RomlDoc = require(game:GetService("ServerScriptService").com.sheepofice.roml.RomlDoc)
local RomlObject = require(game:GetService("ServerScriptService").com.sheepofice.roml.RomlObject)
local ObjectBuilder = require(game:GetService("ServerScriptService").com.sheepofice.roml.ObjectBuilder)
local ClassName
do
  local _parent_0 = RomlDoc
  local _base_0 = {
    _create = function(self, parent, vars)
		local varChange_partNames
		local varChange_shouldDisplayPart
		local builder
		local objTemp
		local objModel1
		varChange_partNames = function()
			update1(self._vars.partNames:GetValue(), self._vars.shouldDisplayPart:GetValue())
		end
		varChange_shouldDisplayPart = function()
			update1(self._vars.partNames:GetValue(), self._vars.shouldDisplayPart:GetValue())
		end
		update1 = function(partNames, shouldDisplayPart)
			objModel1:RemoveAllChildren()
			for _,name in pairs(partNames) do
				if shouldDisplayPart then
					objTemp = RomlObject(Instance.new("Part"))
					objTemp:SetProperties({Name = name})
					objModel1:AddChild(objTemp)
					objTemp:Refresh()
				end
			end
		end
		self._vars.partNames = RomlVar(vars.partNames)
		self._vars.partNames.Changed:connect(varChange_partNames)
		self._vars.shouldDisplayPart = RomlVar(vars.shouldDisplayPart)
		self._vars.shouldDisplayPart.Changed:connect(varChange_shouldDisplayPart)
		builder = ObjectBuilder(parent)
		builder:Build(Instance.new("Model"), {"Model"})
		builder:Build(Instance.new("Part"), {"Red"})
		self._objectIds["ClickMe"] = builder:Build(Instance.new("ClickDetector"))
		builder:Pop()
		builder:Pop()
		builder:Build(Instance.new("Part"), {"Red"})
		builder:Pop()
		builder:Pop()
		objModel1 = builder:Build(Instance.new("Model"), {"Model"})
		update1(self._vars.partNames:GetValue(), self._vars.shouldDisplayPart:GetValue())
		builder:Pop()
		self._rootObject = builder:Pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, vars)
      return _parent_0.__init(self, parent, vars)
    end,
    __base = _base_0,
    __name = "ClassName",
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
    return ClassName(parent, vars)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  ClassName = _class_0
end
return ClassName
