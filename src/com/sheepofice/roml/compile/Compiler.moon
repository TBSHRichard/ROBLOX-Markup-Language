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

writeVarCode = (mainBlock, functionTable, varNamer, className, varName, changeFunction) ->
	functionTable[varName] = FunctionBlock "varChange_#{varName}", "" unless functionTable[varName]

	objectName = varNamer\NameObjectVariable className
	mainBlock\AddChild MainBlock.BLOCK_VARS, Line("local #{objectName}")
	mainBlock\AddChild MainBlock.BLOCK_VARS, Line("local varChange_#{varName}")
	varChange = functionTable[varName]
	changeFunction varChange, objectName, varName
	mainBlock\AddChild MainBlock.BLOCK_UPDATE_FUNCTIONS, varChange
	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("self._vars.#{varName} = RomlVar(vars.#{varName})")
	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("self._vars.#{varName}.Changed:connect(varChange_#{varName})")
	mainBlock\AddChild MainBlock.BLOCK_FUNCTION_CALLS, Line("varChange_#{varName}()")
	return objectName


writeObjectToBlock = (mainBlock, functionTable, varNamer, builderParam, className, id, classes, properties, children) ->
	classesString = "nil"
	objectName = nil

	if classes and classes[1] == "static"
		classesString = Table.ArrayToSingleLineString(classes[2])
	elseif classes and classes[1] == "dynamic"
		objectName = writeVarCode mainBlock, functionTable, varNamer, className, classes[2], (varChange, objectName, varName) ->
			varChange\AddChild Line("#{objectName}:SetClasses(self._vars.#{varName}:GetValue())")

	if properties
		for name, value in properties\pairs!
			if type(value) == "string"
				properties[name] = CompilerPropertyFilter.FilterProperty className, name, value
			else
				objectName = writeVarCode mainBlock, functionTable, varNamer, className, value[2], (varChange, objectName, varName) ->
					varChange\AddChild Line("#{objectName}:SetProperties({#{name} = self._vars.#{varName}:GetValue()})")
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
	object: (mainBlock, functionTable, varNamer, obj) ->
		-- {
		--	"object"
		--	ClassName							:string
		--	Id									:string
		--	Classes								:array
		--	Properties							:table
		--	Children							:array
		-- }
		_, className, id, classes, properties, children = unpack obj
		writeObjectToBlock mainBlock, functionTable, varNamer, "\"#{className}\"", className, id, classes, properties, children

	clone: (mainBlock, functionTable, varNamer, obj) ->
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
		writeObjectToBlock mainBlock, functionTable, varNamer, robloxObject, className, id, classes, properties, children

addCode = (mainBlock, tree) ->
	functionTable = {}
	varNamer = VariableNamer!

	if tree
		for _, obj in ipairs tree
			addCodeFunctions[obj[1]] mainBlock, functionTable, varNamer, obj

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