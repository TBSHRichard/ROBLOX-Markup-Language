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

if game
	FunctionBlock = require(plugin.com.blacksheepherd.code.FunctionBlock)
	DoBlock = require(plugin.com.blacksheepherd.code.DoBlock)
	SpaceBlock = require(plugin.com.blacksheepherd.code.SpaceBlock)
	DoubleBlock = require(plugin.com.blacksheepherd.code.DoubleBlock)
	TableBlock = require(plugin.com.blacksheepherd.code.TableBlock)
	TableAssignmentBlock = require(plugin.com.blacksheepherd.code.TableAssignmentBlock)
	MetatableBlock = require(plugin.com.blacksheepherd.code.MetatableBlock)
	IfElseBlock = require(plugin.com.blacksheepherd.code.IfElseBlock)
	IfBlock = require(plugin.com.blacksheepherd.code.IfBlock)
	Line = require(plugin.com.blacksheepherd.code.Line)
	RequireLine = require(plugin.com.blacksheepherd.code.RequireLine)
else
	FunctionBlock = require "com.blacksheepherd.code.FunctionBlock"
	DoBlock = require "com.blacksheepherd.code.DoBlock"
	SpaceBlock = require "com.blacksheepherd.code.SpaceBlock"
	DoubleBlock = require "com.blacksheepherd.code.DoubleBlock"
	TableBlock = require "com.blacksheepherd.code.TableBlock"
	TableAssignmentBlock = require "com.blacksheepherd.code.TableAssignmentBlock"
	MetatableBlock = require "com.blacksheepherd.code.MetatableBlock"
	IfElseBlock = require "com.blacksheepherd.code.IfElseBlock"
	IfBlock = require "com.blacksheepherd.code.IfBlock"
	Line = require "com.blacksheepherd.code.Line"
	RequireLine = require "com.blacksheepherd.code.RequireLine"

class MainRossBlock
	new: (name) =>
		@_children = {}

		@_objects = {}
		@_classes = {}
		@_ids = {}

		table.insert @_children, RequireLine("com.blacksheepherd.ross", "RossDoc")
		table.insert @_children, RequireLine("com.blacksheepherd.datastructure", "Stack")
		table.insert @_children, Line("local #{name}")
		
		cBlock = DoBlock!
		cBlock\AddChild Line("local _parent_0 = RossDoc")
		
		baseBlock = TableBlock("_base_0")

		setupObjectsFunctionBlock = FunctionBlock("_setupObjects", "self")
		setupObjectsFunctionBlock\AddChild Line("local objects = {}")
		@_objectsBlock = SpaceBlock!
		setupObjectsFunctionBlock\AddChild @_objectsBlock
		setupObjectsFunctionBlock\AddChild Line("return objects")
		baseBlock\AddChild setupObjectsFunctionBlock

		setupClassesFunctionBlock = FunctionBlock("_setupClasses", "self")
		setupClassesFunctionBlock\AddChild Line("local classes = {}")
		@_classesBlock = SpaceBlock!
		setupClassesFunctionBlock\AddChild @_classesBlock
		setupClassesFunctionBlock\AddChild Line("return classes")
		baseBlock\AddChild setupClassesFunctionBlock

		setupIdsFunctionBlock = FunctionBlock("_setupIds", "self")
		setupIdsFunctionBlock\AddChild Line("local ids = {}")
		@_idsBlock = SpaceBlock!
		setupIdsFunctionBlock\AddChild @_idsBlock
		setupIdsFunctionBlock\AddChild Line("return ids")
		baseBlock\AddChild setupIdsFunctionBlock

		cBlock\AddChild baseBlock
		
		cBlock\AddChild Line("_base_0.__index = _base_0")
		cBlock\AddChild Line("setmetatable(_base_0, _parent_0.__base)")

		metatableBlock = MetatableBlock("_class_0")
		initFunctionBlock = FunctionBlock("__init", "self")
		initFunctionBlock\AddChild Line("return _parent_0.__init(self)")
		metatableBlock\AddChild DoubleBlock.TOP, initFunctionBlock
		metatableBlock\AddChild DoubleBlock.TOP, Line("__base = _base_0")
		metatableBlock\AddChild DoubleBlock.TOP, Line("__name = \"#{name}\"")
		metatableBlock\AddChild DoubleBlock.TOP, Line("__parent = _parent_0")

		indexFunctionBlock = FunctionBlock("__index", "cls, name")
		indexFunctionBlock\AddChild Line("local val = rawget(_base_0, name)")
		valueNilCheckBlock = IfElseBlock("val == nil")
		valueNilCheckBlock\AddChild DoubleBlock.TOP, Line("return _parent_0[name]")
		valueNilCheckBlock\AddChild DoubleBlock.BOTTOM, Line("return val")
		indexFunctionBlock\AddChild valueNilCheckBlock
		metatableBlock\AddChild DoubleBlock.BOTTOM, indexFunctionBlock

		callFunctionBlock = FunctionBlock("__call", "cls, ...")
		callFunctionBlock\AddChild Line("local _self_0 = setmetatable({}, _base_0)")
		callFunctionBlock\AddChild Line("cls.__init(_self_0, ...)")
		callFunctionBlock\AddChild Line("return _self_0")
		metatableBlock\AddChild DoubleBlock.BOTTOM, callFunctionBlock
		
		cBlock\AddChild metatableBlock
		cBlock\AddChild Line("_base_0.__class = _class_0")
		cBlock\AddChild Line("local self = _class_0")
		newFunctionBlock = FunctionBlock("self.new", "")
		newFunctionBlock\AddChild Line("return #{name}()")
		cBlock\AddChild newFunctionBlock

		inheritanceIfBlock = IfBlock("_parent_0.__inherited")
		inheritanceIfBlock\AddChild Line("_parent_0.__inherited(_parent_0, _class_0)")
		cBlock\AddChild inheritanceIfBlock
		cBlock\AddChild Line("#{name} = _class_0")

		table.insert @_children, cBlock
		table.insert @_children, Line("return #{name}")

	AddObjectSelector: (key, objectSelectorBlock) =>
		if @_objects[key] == nil
			@_objects[key] = TableAssignmentBlock("objects", key)
			@_objectsBlock\AddChild @_objects[key]

		@_objects[key]\AddChild objectSelectorBlock

	AddClassSelector: (key, classSelectorBlock) =>
		if @_classes[key] == nil
			@_classes[key] = TableAssignmentBlock("classes", key)
			@_classesBlock\AddChild @_classes[key]

		@_classes[key]\AddChild classSelectorBlock

	AddIdSelector: (key, idSelectorBlock) =>
		if @_ids[key] == nil
			@_ids[key] = TableAssignmentBlock("ids", key)
			@_idsBlock\AddChild @_ids[key]

		@_ids[key]\AddChild idSelectorBlock

	Render: =>
		buffer = ""
		
		for child in *@_children
			buffer ..= child\Render!

			if child.__class.__name != "SpaceBlock" or child.__class.__name == "SpaceBlock" and #child._children > 0
				buffer ..= "\n"
		
		return buffer