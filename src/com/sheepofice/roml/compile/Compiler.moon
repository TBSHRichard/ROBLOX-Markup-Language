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
CompilerPropertyFilter = require "com.sheepofice.roml.compile.CompilerPropertyFilter"

addCode = nil
addCodeFunctions = nil

writeObjectToBlock = (mainBlock, builderParam, className, id, classes, properties, children) ->
	classesString = "nil"

	if classes
		if classes[1] == "static"
			classesString = Table.ArrayToSingleLineString(classes[2])

	buildLine = "builder:Build(#{builderParam}, #{classesString})"
	buildLine = "objTemp = #{buildLine}" if id or properties

	mainBlock\AddChild Line(buildLine)

	if id
		mainBlock\AddChild Line("self._objectIds[\"#{id}\"] = objTemp")

	if properties
		for name, value in properties\pairs!
			properties[name] = CompilerPropertyFilter.FilterProperty className, name, value

		mainBlock\AddChild Line("objTemp:SetProperties(#{Table.HashMapToSingleLineString(properties)})")

	addCode mainBlock, children
	mainBlock\AddChild Line("builder:Pop()")

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
		writeObjectToBlock mainBlock, "\"#{className}\"", className, id, classes, properties, children

	clone: (mainBlock, obj) ->
		-- {
		--	"clone"
		--	ClassName							:string
		--	RobloxObject						:string
		--	Id									:string
		--	Classes								:array
		--	Properties							:table
		--	Children							:array
		-- }
		_, className, robloxObject, id, classes, properties, children = unpack obj
		writeObjectToBlock mainBlock, robloxObject, className, id, classes, properties, children

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