----------------------------------------------------------------
-- The module for compiling Roml parsetrees into Lua files.
--
-- @module Compiler
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Stack = require "net.blacksheepherd.datastructure.Stack"
Table = require "net.blacksheepherd.util.Table"
MainBlock = require "net.blacksheepherd.roml.code.MainBlock"
ConditionalBlock = require "net.blacksheepherd.roml.code.ConditionalBlock"
SpaceBlock = require "net.blacksheepherd.roml.code.SpaceBlock"
FunctionBlock = require "net.blacksheepherd.roml.code.FunctionBlock"
Line = require "net.blacksheepherd.roml.code.Line"
VariableNamer = require "net.blacksheepherd.roml.compile.VariableNamer"
CompilerPropertyFilter = require "net.blacksheepherd.roml.compile.CompilerPropertyFilter"

local addCode
local addCodeFunctions
local mainBlock
local functionTable
local varNamer
local parentNameStack
local creationFunctionStack

mainBlockCreationFunction = (lines) ->
	for line in *lines
		mainBlock\AddChild MainBlock.BLOCK_CREATION, line

writeLineToVarChangeFunction = (varName, lineString) ->
	unless functionTable[varName]
		mainBlock\AddChild MainBlock.BLOCK_VARS, Line("local varChange_#{varName}")
		functionTable[varName] = FunctionBlock "varChange_#{varName}", ""
		mainBlock\AddChild MainBlock.BLOCK_UPDATE_FUNCTIONS, functionTable[varName]
		mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("self._vars.#{varName} = RomlVar(vars.#{varName})")
		mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("self._vars.#{varName}.Changed:connect(varChange_#{varName})")
		mainBlock\AddChild MainBlock.BLOCK_FUNCTION_CALLS, Line("varChange_#{varName}()")

	functionTable[varName]\AddLineIfNotAdded lineString


writeVarCode = (className, varName, changeFunction) ->
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

writeObjectToBlock = (builderParam, className, id, classes, properties, children) ->
	classesString = "nil"
	objectName = nil

	if classes and classes[1] == "static"
		classesString = Table.ArrayToSingleLineString(classes[2])
	elseif classes and classes[1] == "dynamic"
		objectName = writeVarCode className, classes[2], (varChange, objectName, varName) ->
			varChange\AddChild Line("#{objectName}:SetClasses(self._vars.#{varName}:GetValue())")

	if properties
		for name, value in properties\pairs!
			if type(value) == "string"
				properties[name] = CompilerPropertyFilter.FilterProperty className, name, value
			else
				objectName = writeVarCode className, value[2], (varChange, objectName, varName) ->
					varChange\AddChild Line("#{objectName}:SetProperties({#{name} = self._vars.#{varName}:GetValue()})")
				properties[name] = nil

	if #children > 0 and not objectName
		objectName = varNamer\NameObjectVariable(className)
		mainBlock\AddChild MainBlock.BLOCK_VARS, Line("local #{objectName}")

	objectName = "objTemp" if not objectName

	lines = {Line("#{objectName} = RomlObject(#{builderParam}, #{classesString})")}
	table.insert(lines, Line("self._objectIds[\"#{id}\"] = #{objectName}")) if id
	if properties
		table.insert(lines, Line("#{objectName}:SetProperties(#{Table.HashMapToSingleLineString(properties)})"))
		table.insert(lines, Line("#{objectName}:Refresh()"))
	table.insert(lines, Line("#{parentNameStack\Peek!}:AddChild(#{objectName})"))
	creationFunctionStack\Peek!(lines)

	creationFunctionStack\Push creationFunctionStack\Peek!
	parentNameStack\Push objectName
	addCode children
	parentNameStack\Pop!
	creationFunctionStack\Pop!

addCodeFunctions =
	object: (obj) ->
		-- {
		--	"object"
		--	ClassName							:string
		--	Id									:string
		--	Classes								:array
		--	Properties							:table
		--	Children							:array
		-- }
		_, className, id, classes, properties, children = unpack obj
		writeObjectToBlock "\"#{className}\"", className, id, classes, properties, children

	clone: (obj) ->
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
		writeObjectToBlock robloxObject, className, id, classes, properties, children

	if: (obj) ->
		-- {
		--  "if"
		--  Condition							:string
		--  Vars								:array
		--  Children							:array
		--  OtherConditionals					:array
		-- }
		_, condition, vars, children, otherConditionals = unpack obj
		parentName = parentNameStack\Peek!
		parentName = "Parent" if parentName == "self._rootObject"

		if creationFunctionStack\Peek! == mainBlockCreationFunction
			creationFunctionName = "update#{parentName}"
			creationFunction = FunctionBlock creationFunctionName, ""
			creationFunction\AddChild Line("#{parentNameStack\Peek!}:RemoveAllChildren()")
			mainBlock\AddChild MainBlock.BLOCK_VARS, Line("local #{creationFunctionName}")
			mainBlock\AddChild MainBlock.BLOCK_UPDATE_FUNCTIONS, creationFunction
			creationFunctionStack\Push (lines) ->
				for line in *lines
					creationFunction\AddChild line

		ifBlock = ConditionalBlock!
		ifBlock\AddCondition condition
		creationFunctionStack\Peek!({ifBlock})
		creationFunctionStack\Push (input) ->
			for line in *input
				ifBlock\AddChild line

		for var in *vars
			writeLineToVarChangeFunction var, "update#{parentName}()"

		addCode children

		for conditional in *otherConditionals
			-- {
			--  Condition							:string
			--  Vars								:array
			--  Children							:array
			-- }
			condition, vars, children = unpack conditional
			ifBlock\AddCondition condition

			for var in *vars
				writeLineToVarChangeFunction var, "update#{parentName}()"

			addCode children

		creationFunctionStack\Pop!

addCode = (tree) ->
	if tree
		for _, obj in ipairs tree
			addCodeFunctions[obj[1]] obj

----------------------------------------------------------------
-- Compile the parsetree into a Lua string.
--
-- @tparam string name The name of the Lua subclass.
-- @tparam table parsetree The parse tree.
-- @treturn string The compiled Lua code.
----------------------------------------------------------------
Compile = (name, parsetree) ->
	mainBlock = MainBlock name
	functionTable = {}
	varNamer = VariableNamer!
	parentNameStack = Stack!
	creationFunctionStack = Stack!

	parentNameStack\Push "self._rootObject"
	creationFunctionStack\Push mainBlockCreationFunction

	addCode parsetree
	mainBlock\Render!

{ :Compile }