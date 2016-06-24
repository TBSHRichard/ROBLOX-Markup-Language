----------------------------------------------------------------
-- A @{Block} for the main @{RomlDoc} compiled files.
--
-- @classmod MainBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

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

if game
	FunctionBlock = require(plugin.com.blacksheepherd.code.FunctionBlock)
	DoBlock = require(plugin.com.blacksheepherd.code.DoBlock)
	SpaceBlock = require(plugin.com.blacksheepherd.code.SpaceBlock)
	DoubleBlock = require(plugin.com.blacksheepherd.code.DoubleBlock)
	TableBlock = require(plugin.com.blacksheepherd.code.TableBlock)
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
	MetatableBlock = require "com.blacksheepherd.code.MetatableBlock"
	IfElseBlock = require "com.blacksheepherd.code.IfElseBlock"
	IfBlock = require "com.blacksheepherd.code.IfBlock"
	Line = require "com.blacksheepherd.code.Line"
	RequireLine = require "com.blacksheepherd.code.RequireLine"

class MainBlock
	----------------------------------------------------------------
	-- Constant for adding children to the variable @{Block}.
	--
	-- @prop BLOCK_VARS
	----------------------------------------------------------------
	@BLOCK_VARS = 1

	----------------------------------------------------------------
	-- Constant for adding children to the update function @{Block}.
	--
	-- @prop BLOCK_UPDATE_FUNCTIONS
	----------------------------------------------------------------
	@BLOCK_UPDATE_FUNCTIONS = 2

	----------------------------------------------------------------
	-- Constant for adding children to the object creation @{Block}.
	--
	-- @prop BLOCK_CREATION
	----------------------------------------------------------------
	@BLOCK_CREATION = 4

	----------------------------------------------------------------
	-- Constant for adding children to the update function call
	-- @{Block}.
	--
	-- @prop BLOCK_FUNCTION_CALLS
	----------------------------------------------------------------
	@BLOCK_FUNCTION_CALLS = 8

	----------------------------------------------------------------
	-- Create the MainBlock.
	--
	-- @tparam MainBlock self
	-- @tparam string name The name of the subclass for the
	--	@{RomlDoc}
	----------------------------------------------------------------
	new: (name) =>
		@_children = {}
		
		table.insert @_children, RequireLine("com.blacksheepherd.roml", "RomlVar")
		table.insert @_children, RequireLine("com.blacksheepherd.roml", "RomlDoc")
		table.insert @_children, RequireLine("com.blacksheepherd.roml", "RomlObject")

		@_extraRequiresBlock = SpaceBlock!
		@_hasCustomObjectBuilderRequire = false
		table.insert @_children, @_extraRequiresBlock

		table.insert @_children, Line("local #{name}")
		
		cBlock = DoBlock!
		cBlock\AddChild Line("local _parent_0 = RomlDoc")
		
		baseBlock = TableBlock("_base_0")
		
		createFunctionBlock = FunctionBlock("_create", "self, parent, vars")
		createFunctionBlock\AddChild Line("self._rootObject = RomlObject(self, parent)")
		createFunctionBlock\AddChild Line("local objTemp")
		@_varsBlock = SpaceBlock!
		@_updateFunctionsBlock = SpaceBlock!
		@_creationBlock = SpaceBlock!
		@_functionCallsBlock = SpaceBlock!
		createFunctionBlock\AddChild @_varsBlock
		createFunctionBlock\AddChild @_updateFunctionsBlock
		createFunctionBlock\AddChild @_creationBlock
		createFunctionBlock\AddChild @_functionCallsBlock
		
		baseBlock\AddChild createFunctionBlock
		cBlock\AddChild baseBlock
		
		cBlock\AddChild Line("_base_0.__index = _base_0")
		cBlock\AddChild Line("setmetatable(_base_0, _parent_0.__base)")

		metatableBlock = MetatableBlock("_class_0")
		initFunctionBlock = FunctionBlock("__init", "self, parent, vars, ross")
		initFunctionBlock\AddChild Line("return _parent_0.__init(self, parent, vars, ross)")
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
		newFunctionBlock = FunctionBlock("self.new", "parent, vars, ross")
		newFunctionBlock\AddChild Line("return #{name}(parent, vars, ross)")
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

	AddCustomObjectBuilderRequire: =>
		unless @_hasCustomObjectBuilderRequire
			@_extraRequiresBlock\AddChild RequireLine("com.blacksheepherd.customobject", "CustomObjectBuilder")
	
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
