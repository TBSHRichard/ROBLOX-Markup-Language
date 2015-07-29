----------------------------------------------------------------
-- The module for compiling Roml parsetrees into Lua files.
--
-- @module Compiler
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Table = require "com.sheepofice.util.Table"
MainBlock = require "com.sheepofice.roml.code.MainBlock"
SpaceBlock = require "com.sheepofice.roml.code.SpaceBlock"
FunctionBlock = require "com.sheepofice.roml.code.FunctionBlock"
Line = require "com.sheepofice.roml.code.Line"
VariableNamer = require "com.sheepofice.roml.compile.VariableNamer"
CompilerPropertyFilter = require "com.sheepofice.roml.compile.CompilerPropertyFilter"

addCode = nil
addCodeFunctions = nil

writeObjectToBlock = (mainBlock, builderParam, className, id, classes, properties, children) ->
	classesString = "nil"
	varNamer = VariableNamer!
	objectName = nil

	if classes and classes[1] == "static"
		classesString = Table.ArrayToSingleLineString(classes[2])
	elseif classes and classes[1] == "dynamic"
		objectName = varNamer\NameObjectVariable className
		mainBlock\AddChild MainBlock.BLOCK_VARS, Line("local #{objectName}")
		mainBlock\AddChild MainBlock.BLOCK_VARS, Line("local varChange_#{classes[2]}")
		varChange = FunctionBlock "varChange_#{classes[2]}", ""
		varChange\AddChild Line("#{objectName}:SetClasses(self._vars.#{classes[2]}:GetValue())")
		mainBlock\AddChild MainBlock.BLOCK_UPDATE_FUNCTIONS, varChange
		mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("self._vars.#{classes[2]} = RomlVar(vars.#{classes[2]})")
		mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("self._vars.#{classes[2]}.Changed:connect(varChange_#{classes[2]})")
		mainBlock\AddChild MainBlock.BLOCK_FUNCTION_CALLS, Line("varChange_#{classes[2]}()")

	if properties
		for name, value in properties\pairs!
			if type(value) == "string"
				properties[name] = CompilerPropertyFilter.FilterProperty className, name, value
			else
				objectName = varNamer\NameObjectVariable className
				mainBlock\AddChild MainBlock.BLOCK_VARS, Line("local #{objectName}")
				mainBlock\AddChild MainBlock.BLOCK_VARS, Line("local varChange_#{value[2]}")
				varChange = FunctionBlock "varChange_#{value[2]}", ""
				varChange\AddChild Line("#{objectName}:SetProperties({#{name} = self._vars.#{value[2]}:GetValue()})")
				mainBlock\AddChild MainBlock.BLOCK_UPDATE_FUNCTIONS, varChange
				mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("self._vars.#{value[2]} = RomlVar(vars.#{value[2]})")
				mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("self._vars.#{value[2]}.Changed:connect(varChange_#{value[2]})")
				mainBlock\AddChild MainBlock.BLOCK_FUNCTION_CALLS, Line("varChange_#{value[2]}()")
				properties[name] = nil

	objectName = "objTemp" if (id or properties) and not objectName

	buildLine = "builder:Build(#{builderParam}, #{classesString})"
	buildLine = "#{objectName} = #{buildLine}" if objectName

	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line(buildLine)

	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("self._objectIds[\"#{id}\"] = #{objectName}") if id
	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("#{objectName}:SetProperties(#{Table.HashMapToSingleLineString(properties)})") if properties

	addCode mainBlock, children
	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("builder:Pop()")

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