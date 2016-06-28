local FunctionBlock
local DoBlock
local SpaceBlock
local DoubleBlock
local TableBlock
local TableAssignmentBlock
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
  TableAssignmentBlock = require(pluginModel.com.blacksheepherd.code.TableAssignmentBlock)
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
  TableAssignmentBlock = require("com.blacksheepherd.code.TableAssignmentBlock")
  MetatableBlock = require("com.blacksheepherd.code.MetatableBlock")
  IfElseBlock = require("com.blacksheepherd.code.IfElseBlock")
  IfBlock = require("com.blacksheepherd.code.IfBlock")
  Line = require("com.blacksheepherd.code.Line")
  RequireLine = require("com.blacksheepherd.code.RequireLine")
end
local MainRossBlock
do
  local _base_0 = {
    AddObjectSelector = function(self, key, objectSelectorBlock)
      if self._objects[key] == nil then
        self._objects[key] = TableAssignmentBlock("objects", key)
        self._objectsBlock:AddChild(self._objects[key])
      end
      return self._objects[key]:AddChild(objectSelectorBlock)
    end,
    AddClassSelector = function(self, key, classSelectorBlock)
      if self._classes[key] == nil then
        self._classes[key] = TableAssignmentBlock("classes", key)
        self._classesBlock:AddChild(self._classes[key])
      end
      return self._classes[key]:AddChild(classSelectorBlock)
    end,
    AddIdSelector = function(self, key, idSelectorBlock)
      if self._ids[key] == nil then
        self._ids[key] = TableAssignmentBlock("ids", key)
        self._idsBlock:AddChild(self._ids[key])
      end
      return self._ids[key]:AddChild(idSelectorBlock)
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
      self._objects = { }
      self._classes = { }
      self._ids = { }
      table.insert(self._children, RequireLine("com.blacksheepherd.ross", "RossDoc"))
      table.insert(self._children, RequireLine("com.blacksheepherd.datastructure", "Stack"))
      table.insert(self._children, Line("local " .. tostring(name)))
      local cBlock = DoBlock()
      cBlock:AddChild(Line("local _parent_0 = RossDoc"))
      local baseBlock = TableBlock("_base_0")
      local setupObjectsFunctionBlock = FunctionBlock("_setupObjects", "self")
      setupObjectsFunctionBlock:AddChild(Line("local objects = {}"))
      self._objectsBlock = SpaceBlock()
      setupObjectsFunctionBlock:AddChild(self._objectsBlock)
      setupObjectsFunctionBlock:AddChild(Line("return objects"))
      baseBlock:AddChild(setupObjectsFunctionBlock)
      local setupClassesFunctionBlock = FunctionBlock("_setupClasses", "self")
      setupClassesFunctionBlock:AddChild(Line("local classes = {}"))
      self._classesBlock = SpaceBlock()
      setupClassesFunctionBlock:AddChild(self._classesBlock)
      setupClassesFunctionBlock:AddChild(Line("return classes"))
      baseBlock:AddChild(setupClassesFunctionBlock)
      local setupIdsFunctionBlock = FunctionBlock("_setupIds", "self")
      setupIdsFunctionBlock:AddChild(Line("local ids = {}"))
      self._idsBlock = SpaceBlock()
      setupIdsFunctionBlock:AddChild(self._idsBlock)
      setupIdsFunctionBlock:AddChild(Line("return ids"))
      baseBlock:AddChild(setupIdsFunctionBlock)
      cBlock:AddChild(baseBlock)
      cBlock:AddChild(Line("_base_0.__index = _base_0"))
      cBlock:AddChild(Line("setmetatable(_base_0, _parent_0.__base)"))
      local metatableBlock = MetatableBlock("_class_0")
      local initFunctionBlock = FunctionBlock("__init", "self")
      initFunctionBlock:AddChild(Line("return _parent_0.__init(self)"))
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
      local newFunctionBlock = FunctionBlock("self.new", "")
      newFunctionBlock:AddChild(Line("return " .. tostring(name) .. "()"))
      cBlock:AddChild(newFunctionBlock)
      local inheritanceIfBlock = IfBlock("_parent_0.__inherited")
      inheritanceIfBlock:AddChild(Line("_parent_0.__inherited(_parent_0, _class_0)"))
      cBlock:AddChild(inheritanceIfBlock)
      cBlock:AddChild(Line(tostring(name) .. " = _class_0"))
      table.insert(self._children, cBlock)
      return table.insert(self._children, Line("return " .. tostring(name)))
    end,
    __base = _base_0,
    __name = "MainRossBlock"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MainRossBlock = _class_0
  return _class_0
end
