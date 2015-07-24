----------------------------------------------------------------
-- The module for compiling Roml parsetrees into Lua files.
--
-- @module Compiler
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Table = require "com.sheepofice.util.Table"
MainBlock = require "com.sheepofice.roml.code.MainBlock"
Line = require "com.sheepofice.roml.code.Line"

addCode = nil
addCodeFunctions = nil

addCodeFunctions =
	object: (mainBlock, obj) ->
		-- {
		--	"object"
		--	ClassName							:string
		--	Id									:string
		--	Classes								:array
		--	Properties							:table
		--	Children							:array
		-- }
		_, className, id, classes, properties, children = unpack obj
		mainBlock\AddChild Line("builder:Build(\"#{className}\", #{Table.ArrayToSingleLineString(classes)})")
		mainBlock\AddChild Line("") if id
		mainBlock\AddChild Line("") if properties
		addCode mainBlock, children
		mainBlock\AddChild Line("builder:Pop()")

addCode = (mainBlock, tree) ->
	if tree
		for _, obj in ipairs tree
			addCodeFunctions[obj[1]] mainBlock, obj

----------------------------------------------------------------
-- Compile the parsetree into a Lua string.
--
-- @tparam string name The name of the Lua subclass.
-- @tparam table parsetree The parse tree.
-- @treturn string The compiled Lua code.
----------------------------------------------------------------
Compile = (name, parsetree) ->
	mainBlock = MainBlock name
	addCode mainBlock, parsetree
	mainBlock\Render!

{ :Compile }