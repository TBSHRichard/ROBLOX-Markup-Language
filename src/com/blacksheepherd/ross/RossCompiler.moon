----------------------------------------------------------------
-- The module for compiling RoSS parsetrees into Lua files.
--
-- @module RossCompiler
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local Array
local Table
local AnonymousTableBlock
local StackBlock
local Line
local MainRossBlock
local LiteralString
local CompilerPropertyFilter
local CustomObjectBuilder

if game
	pluginModel = script.Parent.Parent.Parent.Parent
	Array = require(pluginModel.com.blacksheepherd.util.Array)
	Table = require(pluginModel.com.blacksheepherd.util.Table)
	AnonymousTableBlock = require(pluginModel.com.blacksheepherd.code.AnonymousTableBlock)
	StackBlock = require(pluginModel.com.blacksheepherd.code.StackBlock)
	Line = require(pluginModel.com.blacksheepherd.code.Line)
	MainRossBlock = require(pluginModel.com.blacksheepherd.code.MainRossBlock)
	LiteralString = require(pluginModel.com.blacksheepherd.compile.LiteralString)
	CompilerPropertyFilter = require(pluginModel.com.blacksheepherd.compile.CompilerPropertyFilter)
	CustomObjectBuilder = require(pluginModel.com.blacksheepherd.customobject.CustomObjectBuilder)
else
	Array = require "com.blacksheepherd.util.Array"
	Table = require "com.blacksheepherd.util.Table"
	AnonymousTableBlock = require "com.blacksheepherd.code.AnonymousTableBlock"
	StackBlock = require "com.blacksheepherd.code.StackBlock"
	Line = require "com.blacksheepherd.code.Line"
	MainRossBlock = require "com.blacksheepherd.code.MainRossBlock"
	LiteralString = require "com.blacksheepherd.compile.LiteralString"
	CompilerPropertyFilter = require "com.blacksheepherd.compile.CompilerPropertyFilter"
	CustomObjectBuilder = require "com.blacksheepherd.customobject.CustomObjectBuilder"

local mainBlock

calculateAndAddSpecificity = (block) ->
	numberOfObjects = 0
	numberOfClasses = 0
	numberOfIds = 0

	for selector in *block.selectorStack
		numberOfObjects += 1 unless selector["object"] == nil

		if selector["class"] != nil
			numberOfClasses += 1
		elseif selector["id"] != nil
			numberOfIds += 1

	block.specificity = numberOfIds * 2^16 + numberOfClasses * 2^8 + numberOfObjects

createAndAddSelectorBlock = (block) ->
	selectorBlock = AnonymousTableBlock!

	selectorStackBlock = StackBlock("selector")

	selectorTop = block.selectorStack[1]

	for selector in *block.selectorStack
		selectorStackItemBlock = AnonymousTableBlock!

		if selector.object != nil
			selectorStackItemBlock\AddChild Line("object = \"#{selector.object}\"")

		if selector.class != nil
			selectorStackItemBlock\AddChild Line("class = \"#{selector.class}\"")
		elseif selector.id != nil
			selectorStackItemBlock\AddChild Line("id = \"#{selector.id}\"")

		selectorStackBlock\AddChild selectorStackItemBlock

	keyName = ""
	className = ""

	if selectorTop.object != nil
		keyName = selectorTop.object
		className = selectorTop.object

	selectorBlock\AddChild selectorStackBlock

	if block.properties
		for name, value in block.properties\pairs!
			if CustomObjectBuilder.IsACustomObject(className)
				block.properties[name] = CustomObjectBuilder.FilterProperty className, name, value, LiteralString, CompilerPropertyFilter
			else
				block.properties[name] = CompilerPropertyFilter.FilterProperty className, name, value

		selectorBlock\AddChild Line("properties = #{Table.HashMapToSingleLineString(block.properties)}")
	else
		selectorBlock\AddChild Line("properties = {}")

	if selectorTop.class != nil
		keyName ..= ".#{selectorTop.class}"
		mainBlock\AddClassSelector keyName, selectorBlock
	elseif selectorTop.id != nil
		keyName ..= "##{selectorTop.id}"
		mainBlock\AddIdSelector keyName, selectorBlock
	else
		mainBlock\AddObjectSelector keyName, selectorBlock

addCode = (tree) ->
	if tree
		tree = Array.StableSort tree, (left, right) ->
			calculateAndAddSpecificity(left) if left.specificity == nil
			calculateAndAddSpecificity(right) if right.specificity == nil

			left.specificity >= right.specificity

		for rossBlock in *tree
			createAndAddSelectorBlock rossBlock

----------------------------------------------------------------
-- Compile the parsetree into a Lua string.
--
-- @tparam string name The name of the Lua subclass.
-- @tparam table parseTree The parse tree.
-- @treturn string The compiled Lua code.
----------------------------------------------------------------
Compile = (name, parseTree) ->
	mainBlock = MainRossBlock name

	addCode parseTree
	mainBlock\Render!

{ :Compile }