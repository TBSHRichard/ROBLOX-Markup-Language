----------------------------------------------------------------
-- A @{Block} for the main @{RomlDoc} compiled files.
--
-- @classmod MainBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

FunctionBlock = require "com.sheepofice.roml.code.FunctionBlock"
DoBlock = require "com.sheepofice.roml.code.DoBlock"
SpaceBlock = require "com.sheepofice.roml.code.SpaceBlock"
DoubleBlock = require "com.sheepofice.roml.code.DoubleBlock"
TableBlock = require "com.sheepofice.roml.code.TableBlock"
MetatableBlock = require "com.sheepofice.roml.code.MetatableBlock"
IfElseBlock = require "com.sheepofice.roml.code.IfElseBlock"
IfBlock = require "com.sheepofice.roml.code.IfBlock"
Line = require "com.sheepofice.roml.code.Line"
RequireLine = require "com.sheepofice.roml.code.RequireLine"

class MainBlock
	----------------------------------------------------------------
	-- Create the MainBlock.
	--
	-- @tparam MainBlock self
	-- @tparam string name The name of the subclass for the
	--	@{RomlDoc}
	----------------------------------------------------------------
	new: (name) =>
		@_children = {}
		
		table.insert @_children, RequireLine("com.sheepofice.roml", "RomlVar")
		table.insert @_children, RequireLine("com.sheepofice.roml", "RomlDoc")
		table.insert @_children, RequireLine("com.sheepofice.roml", "RomlObject")
		table.insert @_children, RequireLine("com.sheepofice.roml", "ObjectBuilder")
		table.insert @_children, Line("local #{name}")
		
		cBlock = DoBlock!
		cBlock\AddChild Line("local _parent_0 = RomlDoc")
		
		baseBlock = TableBlock("_base_0")
		
		createFunctionBlock = FunctionBlock("_create", "self, parent, vars")
		createFunctionBlock\AddChild Line("local builder = ObjectBuilder(parent)")
		createFunctionBlock\AddChild Line("local objTemp")
		@_mainBlock = SpaceBlock!
		createFunctionBlock\AddChild @_mainBlock
		createFunctionBlock\AddChild Line("self._rootObject = builder:Pop()")
		
		baseBlock\AddChild createFunctionBlock
		cBlock\AddChild baseBlock
		
		cBlock\AddChild Line("_base_0.__index = _base_0")
		cBlock\AddChild Line("setmetatable(_base_0, _parent_0.__base)")

		metatableBlock = MetatableBlock("_class_0")
		initFunctionBlock = FunctionBlock("__init", "self, parent, vars")
		initFunctionBlock\AddChild Line("return _parent_0.__init(self, parent, vars)")
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
		newFunctionBlock = FunctionBlock("self.new", "parent, vars")
		newFunctionBlock\AddChild Line("return #{name}(parent, vars)")
		cBlock\AddChild newFunctionBlock

		inheritanceIfBlock = IfBlock("_parent_0.__inherited")
		inheritanceIfBlock\AddChild Line("_parent_0.__inherited(_parent_0, _class_0)")
		cBlock\AddChild inheritanceIfBlock
		cBlock\AddChild Line("#{name} = _class_0")

		table.insert @_children, cBlock
		table.insert @_children, Line("return #{name}")
	
	----------------------------------------------------------------
	-- Add a child to the create function of the subclass.
	--
	-- @tparam MainBlock self
	-- @tparam Block/Line child The child to add.
	----------------------------------------------------------------
	AddChild: (child) =>
		@_mainBlock\AddChild child
	
	----------------------------------------------------------------
	-- Render the MainBlock and all children @{Block}s/@{Line}s.
	--
	-- @tparam MainBlock self
	----------------------------------------------------------------
	Render: =>
		buffer = ""
		
		for child in *@_children
			buffer ..= child\Render!
			buffer ..= "\n"
		
		return buffer

return MainBlock
