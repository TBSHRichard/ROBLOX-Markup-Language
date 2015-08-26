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

	--buildLine = "builder:Build(#{builderParam}, #{classesString})"
	--buildLine = "#{objectName} = #{buildLine}" if objectName

	--mainBlock\AddChild MainBlock.BLOCK_CREATION, Line(buildLine)

	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("#{objectName} = RomlObject(#{builderParam}, #{classesString})")

	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("self._objectIds[\"#{id}\"] = #{objectName}") if id
	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("#{objectName}:SetProperties(#{Table.HashMapToSingleLineString(properties)})") if properties
	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("#{objectName}:Refresh()") if properties

	mainBlock\AddChild MainBlock.BLOCK_CREATION, Line("#{parentNameStack\Peek!}:AddChild(#{objectName})")

	parentNameStack\Push objectName
	addCode children
	parentNameStack\Pop!

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
	parentNameStack\Push "self._rootObject"

	addCode parsetree
	mainBlock\Render!

{ :Compile }