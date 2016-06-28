local FunctionBlock
local DoBlock
local SpaceBlock
local DoubleBlock
local TableBlock
local MetatableBlock
local IfElseBlock
local IfBlock
local Line
local RequireLine
if game then
  local pluginModel = script.Parent.Parent.Parent.Parent
  FunctionBlock = require(pluginModel.com.blacksheepherd.code.FunctionBlock)
  DoBlock = require(pluginModel.com.blacksheepherd.code.DoBlock)
  SpaceBlock = require(pluginModel.com.blacksheepherd.code.SpaceBlock)
  DoubleBlock = require(pluginModel.com.blacksheepherd.code.DoubleBlock)
  TableBlock = require(pluginModel.com.blacksheepherd.code.TableBlock)
  MetatableBlock = require(pluginModel.com.blacksheepherd.code.MetatableBlock)
  IfElseBlock = require(pluginModel.com.blacksheepherd.code.IfElseBlock)
  IfBlock = require(pluginModel.com.blacksheepherd.code.IfBlock)
  Line = require(pluginModel.com.blacksheepherd.code.Line)
  RequireLine = require(pluginModel.com.blacksheepherd.code.RequireLine)
else
  FunctionBlock = require("com.blacksheepherd.code.FunctionBlock")
  DoBlock = require("com.blacksheepherd.code.DoBlock")
  SpaceBlock = require("com.blacksheepherd.code.SpaceBlock")
  DoubleBlock = require("com.blacksheepherd.code.DoubleBlock")
  TableBlock = require("com.blacksheepherd.code.TableBlock")
  MetatableBlock = require("com.blacksheepherd.code.MetatableBlock")
  IfElseBlock = require("com.blacksheepherd.code.IfElseBlock")
  IfBlock = require("com.blacksheepherd.code.IfBlock")
  Line = require("com.blacksheepherd.code.Line")
  RequireLine = require("com.blacksheepherd.code.RequireLine")
end
local MainBlock
do
  local _base_0 = {
    AddChild = function(self, block, child)
      local _exp_0 = block
      if self.__class.BLOCK_VARS == _exp_0 then
        return self._varsBlock:AddChild(child)
      elseif self.__class.BLOCK_UPDATE_FUNCTIONS == _exp_0 then
        return self._updateFunctionsBlock:AddChild(child)
      elseif self.__class.BLOCK_CREATION == _exp_0 then
        return self._creationBlock:AddChild(child)
      elseif self.__class.BLOCK_FUNCTION_CALLS == _exp_0 then
        return self._functionCallsBlock:AddChild(child)
      end
    end,
    AddCustomObjectBuilderRequire = function(self)
      if not (self._hasCustomObjectBuilderRequire) then
        return self._extraRequiresBlock:AddChild(RequireLine("com.blacksheepherd.customobject", "CustomObjectBuilder"))
      end
    end,
    Render = function(self)
      local buffer = ""
      local _list_0 = self._children
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        buffer = buffer .. child:Render()
        if child.__class.__name ~= "SpaceBlock" or child.__class.__name == "SpaceBlock" and #child._children > 0 then
          buffer = buffer .. "\n"
        end
      end
      return buffer
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, name)
      self._children = { }
      table.insert(self._children, RequireLine("com.blacksheepherd.roml", "RomlVar"))
      table.insert(self._children, RequireLine("com.blacksheepherd.roml", "RomlDoc"))
      table.insert(self._children, RequireLine("com.blacksheepherd.roml", "RomlObject"))
      self._extraRequiresBlock = SpaceBlock()
      self._hasCustomObjectBuilderRequire = false
      table.insert(self._children, self._extraRequiresBlock)
      table.insert(self._children, Line("local " .. tostring(name)))
      local cBlock = DoBlock()
      cBlock:AddChild(Line("local _parent_0 = RomlDoc"))
      local baseBlock = TableBlock("_base_0")
      local createFunctionBlock = FunctionBlock("_create", "self, parent, vars")
      createFunctionBlock:AddChild(Line("self._rootObject = RomlObject(self, parent)"))
      createFunctionBlock:AddChild(Line("local objTemp"))
      self._varsBlock = SpaceBlock()
      self._updateFunctionsBlock = SpaceBlock()
      self._creationBlock = SpaceBlock()
      self._functionCallsBlock = SpaceBlock()
      createFunctionBlock:AddChild(self._varsBlock)
      createFunctionBlock:AddChild(self._updateFunctionsBlock)
      createFunctionBlock:AddChild(self._creationBlock)
      createFunctionBlock:AddChild(self._functionCallsBlock)
      baseBlock:AddChild(createFunctionBlock)
      cBlock:AddChild(baseBlock)
      cBlock:AddChild(Line("_base_0.__index = _base_0"))
      cBlock:AddChild(Line("setmetatable(_base_0, _parent_0.__base)"))
      local metatableBlock = MetatableBlock("_class_0")
      local initFunctionBlock = FunctionBlock("__init", "self, parent, vars, ross")
      initFunctionBlock:AddChild(Line("return _parent_0.__init(self, parent, vars, ross)"))
      metatableBlock:AddChild(DoubleBlock.TOP, initFunctionBlock)
      metatableBlock:AddChild(DoubleBlock.TOP, Line("__base = _base_0"))
      metatableBlock:AddChild(DoubleBlock.TOP, Line("__name = \"" .. tostring(name) .. "\""))
      metatableBlock:AddChild(DoubleBlock.TOP, Line("__parent = _parent_0"))
      local indexFunctionBlock = FunctionBlock("__index", "cls, name")
      indexFunctionBlock:AddChild(Line("local val = rawget(_base_0, name)"))
      local valueNilCheckBlock = IfElseBlock("val == nil")
      valueNilCheckBlock:AddChild(DoubleBlock.TOP, Line("return _parent_0[name]"))
      valueNilCheckBlock:AddChild(DoubleBlock.BOTTOM, Line("return val"))
      indexFunctionBlock:AddChild(valueNilCheckBlock)
      metatableBlock:AddChild(DoubleBlock.BOTTOM, indexFunctionBlock)
      local callFunctionBlock = FunctionBlock("__call", "cls, ...")
      callFunctionBlock:AddChild(Line("local _self_0 = setmetatable({}, _base_0)"))
      callFunctionBlock:AddChild(Line("cls.__init(_self_0, ...)"))
      callFunctionBlock:AddChild(Line("return _self_0"))
      metatableBlock:AddChild(DoubleBlock.BOTTOM, callFunctionBlock)
      cBlock:AddChild(metatableBlock)
      cBlock:AddChild(Line("_base_0.__class = _class_0"))
      cBlock:AddChild(Line("local self = _class_0"))
      local newFunctionBlock = FunctionBlock("self.new", "parent, vars, ross")
      newFunctionBlock:AddChild(Line("return " .. tostring(name) .. "(parent, vars, ross)"))
      cBlock:AddChild(newFunctionBlock)
      local inheritanceIfBlock = IfBlock("_parent_0.__inherited")
      inheritanceIfBlock:AddChild(Line("_parent_0.__inherited(_parent_0, _class_0)"))
      cBlock:AddChild(inheritanceIfBlock)
      cBlock:AddChild(Line(tostring(name) .. " = _class_0"))
      table.insert(self._children, cBlock)
      return table.insert(self._children, Line("return " .. tostring(name)))
    end,
    __base = _base_0,
    __name = "MainBlock"
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
  self.BLOCK_VARS = 1
  self.BLOCK_UPDATE_FUNCTIONS = 2
  self.BLOCK_CREATION = 4
  self.BLOCK_FUNCTION_CALLS = 8
  MainBlock = _class_0
end
return MainBlock
