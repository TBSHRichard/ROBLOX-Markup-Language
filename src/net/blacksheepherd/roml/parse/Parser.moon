----------------------------------------------------------------
-- A module with helper functions related to parsing of RoML.
--
-- @module Parser
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

lpeg = require "lpeg"
HashMap = require "net.blacksheepherd.util.HashMap"
Stack = require "net.blacksheepherd.datastructure.Stack"

import C, Cc, Cf, Cs, Ct, Cmt, P, R, S, V from lpeg

local indentStack

calculateIndentSize = (tabs) ->
	indentSize = 0

	for char in tabs\gmatch "."
		indentSize += if char == "\t" then 4 else 1

	return indentSize

NewHashMap = ->
	return true, HashMap({})

BlockMatch = (pattern) ->
	pattern / (parentTable, children) ->
		parentTable[#parentTable] = children
		return parentTable

ObjectMatch = (pattern) ->
	pattern / (objectName, cloneSource, id, classes, properties, children) ->
		t = {
			"object",
			objectName,
			id,
			classes,
			properties,
			children
		}

		if cloneSource
			t[1] = "clone"
			table.insert t, 3, cloneSource

		return t

PropertyPairMatch = (properties, keyValuePair) ->
		key, value = unpack keyValuePair
		properties[key] = value
		return properties

-- Implementation from MoonScript: https://github.com/leafo/moonscript/blob/master/moonscript/parse.moon#L48
Indent = (roml, position, tabs) ->
	indentSize = calculateIndentSize tabs
	lastIndent = indentStack\Peek!

	if indentSize > lastIndent
		indentStack\Push indentSize
		true

-- Implementation from MoonScript: https://github.com/leafo/moonscript/blob/master/moonscript/parse.moon#L44
CheckIndent = (roml, position, tabs) ->
	indentSize = calculateIndentSize tabs
	lastIndent = indentStack\Peek!

	indentSize == lastIndent

-- Implementation from MoonScript: https://github.com/leafo/moonscript/blob/master/moonscript/parse.moon#L58
Dedent = (roml, position, tabs) ->
	indentStack\Pop!
	true

Condition = (pattern) ->
	pattern / (condition, ...) ->
		vars = {...}
		for var in *vars
			sub = Cs((P"@" * C(P(var)) / "self._vars.%1:GetValue()" + 1)^0)
			condition = lpeg.match(sub, condition)
		return condition, vars

ConditionalIfMatch = (pattern) ->
	pattern / (keyword, condition, vars, children, extra) ->
		{
			"if",
			if keyword == "if" then condition else "not(#{condition})",
			vars,
			children,
			extra
		}

ConditionalElseIfMatch = (pattern) ->
	pattern / (keyword, condition, vars, children) ->
		{
			if keyword == "elseif" then condition else "not(#{condition})",
			vars,
			children
		}

ConditionalElseMatch = (pattern) ->
	pattern / (children) ->
		{
			"",
			{},
			children
		}


grammar = P {
	"RoML"

	NewLine:           P"\r"^-1 * P"\n"
	LineEnd:           V"Tabs" * (V"NewLine"^1 + -1)
	UppercaseLetter:   R"AZ"
	LowercaseLetter:   R"az"
	Number:            R"09"
	Tabs:              S"\t "^0
	Spaces:            S"\r\n\t "^0

	VariableStart:     P"_" + V"UppercaseLetter" + V"LowercaseLetter"
	VariableBody:      (V"VariableStart" + V"Number")^0
	VariableName:      C(V"VariableStart" * V"VariableBody")
	Variable:          P"@" * V"VariableName"

	Indent:            #Cmt(V"Tabs", Indent)
	CheckIndent:       Cmt(V"Tabs", CheckIndent)
	Dedent:            Cmt("", Dedent)

	SingleString:      P'"' * C(P"\\\"" + (1 - P'"')^0) * P'"'
	DoubleString:      P"'" * C(P"\\'" + (1 - P"'")^0) * P"'"
	String:            V"SingleString" + V"DoubleString"

	CloneValue:        C((S"\t "^0 * (1 - S")\r\n\t "))^0)
	CloneSource:       P"(" * V"Tabs" * V"CloneValue" * V"Tabs" * P")"

	Id:                P"#" * V"VariableName"
	Classes:           Ct(Cc("dynamic") * P"." * V"Variable" + Cc("static") * Ct((P"." * V"VariableName")^1))

	PropertyKey:       C(V"UppercaseLetter" * (V"UppercaseLetter" + V"LowercaseLetter" + V"Number")^0)
	PropertyValue:     Ct(Cc("var") * V"Variable") + C((S"\t "^0 * (1 - S"}:;\r\n\t "))^0)
	PropertyPair:      Ct(V"Tabs" * V"PropertyKey" * V"Tabs" * P":" * V"Tabs" * V"PropertyValue" * V"Tabs")
	PropertyList:      P"{" * Cf(Cmt("", NewHashMap) * (V"PropertyPair" * P";")^0 * V"PropertyPair" * P"}", PropertyPairMatch)

	ObjectName:        C(V"UppercaseLetter" * (V"UppercaseLetter" + V"LowercaseLetter")^0)
	Object:            V"CheckIndent" * P"%" * V"ObjectName" * (V"CloneSource" + Cc(nil)) * (V"Id" + Cc(nil)) * (V"Classes" + Cc(nil)) * (V"PropertyList" + Cc(nil))
	ObjectBlock:       ObjectMatch V"Object" * V"BlockBody"--V"LineEnd" * (V"Indent" * Ct(V"Block"^0) * V"Dedent" + Cc({}))

	Condition:         V"Tabs" * C((V"Tabs" * V"Variable" + (S"\t "^0 * (1 - S"@\r\n\t ")))^1)
	ConditionalTop:    V"CheckIndent" * C(P"if" + P"unless") * Condition(V"Condition")
	ConditionalMiddle: V"CheckIndent" * C(P"elseif" + P"elseunless") * Condition(V"Condition")
	ConditionalBottom: V"CheckIndent" * P"else"
	ConditionalBlock:  ConditionalIfMatch V"ConditionalTop" * V"BlockBody" * Ct(ConditionalElseIfMatch((V"ConditionalMiddle" * V"BlockBody")^0) * ConditionalElseMatch((V"ConditionalBottom" * V"BlockBody")^-1))

	BlockBody:         V"LineEnd" * (V"Indent" * Ct(V"Block"^0) * V"Dedent" + Cc({}))
	Block:             V"ObjectBlock" + V"ConditionalBlock"
	RoML:              Ct(V"Block"^0)
}

----------------------------------------------------------------
-- Parses a RoML string into a parse tree to be sent to the
-- @{Compiler}.
--
-- @tparam string roml The RoML string.
-- @treturn table The parse tree.
----------------------------------------------------------------
Parse = (roml) ->
	indentStack = nil -- To avoid weird ROBLOX GC problems
	indentStack = Stack!
	indentStack\Push 0
	grammar\match roml

{ :Parse }