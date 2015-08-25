----------------------------------------------------------------
-- A @{Block} for the main @{RomlDoc} compiled files.
--
-- @classmod MainBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

FunctionBlock = require "net.blacksheepherd.roml.code.FunctionBlock"
DoBlock = require "net.blacksheepherd.roml.code.DoBlock"
SpaceBlock = require "net.blacksheepherd.roml.code.SpaceBlock"
DoubleBlock = require "net.blacksheepherd.roml.code.DoubleBlock"
TableBlock = require "net.blacksheepherd.roml.code.TableBlock"
MetatableBlock = require "net.blacksheepherd.roml.code.MetatableBlock"
IfElseBlock = require "net.blacksheepherd.roml.code.IfElseBlock"
IfBlock = require "net.blacksheepherd.roml.code.IfBlock"
Line = require "net.blacksheepherd.roml.code.Line"
RequireLine = require "net.blacksheepherd.roml.code.RequireLine"

class MainBlock
	----------------------------------------------------------------
	-- Constant for adding children to the variable @{Block}.
	--
	-- @prop BLOCK_VARS
	----------------------------------------------------------------
	@BLOCK_VARS = "block vars"

	----------------------------------------------------------------
	-- Constant for adding children to the update function @{Block}.
	--
	-- @prop BLOCK_UPDATE_FUNCTIONS
	----------------------------------------------------------------
	@BLOCK_UPDATE_FUNCTIONS = "block update functions"

	----------------------------------------------------------------
	-- Constant for adding children to the object creation @{Block}.
	--
	-- @prop BLOCK_CREATION
	----------------------------------------------------------------
	@BLOCK_CREATION = "block creation"

	----------------------------------------------------------------
	-- Constant for adding children to the update function call
	-- @{Block}.
	--
	-- @prop BLOCK_FUNCTION_CALLS
	----------------------------------------------------------------
	@BLOCK_FUNCTION_CALLS = "block function call"

	----------------------------------------------------------------
	-- Create the MainBlock.
	--
	-- @tparam MainBlock self
	-- @tparam string name The name of the subclass for the
	--	@{RomlDoc}
	----------------------------------------------------------------
	new: (name) =>
		@_children = {}
		
		table.insert @_children, RequireLine("net.blacksheepherd.roml", "RomlVar")
		table.insert @_children, RequireLine("net.blacksheepherd.roml", "RomlDoc")
		table.insert @_children, RequireLine("net.blacksheepherd.roml", "RomlObject")
		table.insert @_children, RequireLine("net.blacksheepherd.roml", "ObjectBuilder")
		table.insert @_children, Line("local #{name}")
		
		cBlock = DoBlock!
		cBlock\AddChild Line("local _parent_0 = RomlDoc")
		
		baseBlock = TableBlock("_base_0")
		
		createFunctionBlock = FunctionBlock("_create", "self, parent, vars")
		createFunctionBlock\AddChild Line("local builder = ObjectBuilder(parent)")
		createFunctionBlock\AddChild Line("local objTemp")
		@_varsBlock = SpaceBlock!
		@_updateFunctionsBlock = SpaceBlock!
		@_creationBlock = SpaceBlock!
		@_functionCallsBlock = SpaceBlock!
		createFunctionBlock\AddChild @_varsBlock
		createFunctionBlock\AddChild @_updateFunctionsBlock
		createFunctionBlock\AddChild @_creationBlock
		createFunctionBlock\AddChild @_functionCallsBlock
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
	-- Add a child to the create function of the subclass inside the
	-- specified block.
	--
	-- @tparam MainBlock self
	-- @tparam string block One of @{BLOCK_VARS},
	--	@{BLOCK_UPDATE_FUNCTIONS}, @{BLOCK_CREATION},
	--	or @{BLOCK_FUNCTION_CALLS}.
	-- @tparam Block/Line child The child to add.
	----------------------------------------------------------------
	AddChild: (block, child) =>
		switch block
			when @@BLOCK_VARS
				@_varsBlock\AddChild child
			when @@BLOCK_UPDATE_FUNCTIONS
				@_updateFunctionsBlock\AddChild child
			when @@BLOCK_CREATION
				@_creationBlock\AddChild child
			when @@BLOCK_FUNCTION_CALLS
				@_functionCallsBlock\AddChild child
	
	----------------------------------------------------------------
	-- Render the MainBlock and all children @{Block}s/@{Line}s.
	--
	-- @tparam MainBlock self
	----------------------------------------------------------------
	Render: =>
		buffer = ""
		
		for child in *@_children
			buffer ..= child\Render!

			if child.__class.__name != "SpaceBlock" or child.__class.__name == "SpaceBlock" and #child._children > 0
				buffer ..= "\n"
		
		return buffer

return MainBlock
