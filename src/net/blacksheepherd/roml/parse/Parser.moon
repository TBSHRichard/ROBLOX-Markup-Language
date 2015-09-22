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

import C, Cc, Cf, Ct, Cmt, P, R, S, V from lpeg

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
	pattern / (objectName, classes, properties, children) ->
		{
			"object",
			objectName,
			nil,
			classes,
			properties,
			children
		}

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

grammar = P {
	"RoML"

	NewLine:         P"\r"^-1 * P"\n"
	LineEnd:         V"Tabs" * (V"NewLine"^1 + -1)
	UppercaseLetter: R"AZ"
	LowercaseLetter: R"az"
	Number:          R"09"
	Tabs:            S"\t "^0
	Spaces:          S"\r\n\t "^0

	VariableStart:   P"_" + V"UppercaseLetter" + V"LowercaseLetter"
	VariableBody:    (V"VariableStart" + V"Number")^0
	VariableName:    C(V"VariableStart" * V"VariableBody")

	Indent:          #Cmt(V"Tabs", Indent)
	CheckIndent:     Cmt(V"Tabs", CheckIndent)
	Dedent:          Cmt("", Dedent)

	SingleString:    P'"' * C(P"\\\"" + (1 - P'"')^0) * P'"'
	DoubleString:    P"'" * C(P"\\'" + (1 - P"'")^0) * P"'"
	String:          V"SingleString" + V"DoubleString"

	Classes:         Ct Cc("static") * Ct((P"." * V"VariableName")^1)

	PropertyKey:     C(V"UppercaseLetter" * (V"UppercaseLetter" + V"LowercaseLetter" + V"Number")^0)
	PropertyValue:   V"String" + C((S"\t "^-1 * (1 - S"}:;\r\n\t "))^0)
	PropertyPair:    Ct(V"Tabs" * V"PropertyKey" * V"Tabs" * P":" * V"Tabs" * V"PropertyValue" * V"Tabs")
	PropertyList:    P"{" * Cf(Cmt("", NewHashMap) * (V"PropertyPair" * P";")^0 * V"PropertyPair" * P"}", PropertyPairMatch)

	ObjectName:      C(V"UppercaseLetter" * (V"UppercaseLetter" + V"LowercaseLetter")^0)
	Object:          V"CheckIndent" * P"%" * V"ObjectName" * (V"Classes" + Cc(nil)) * (V"PropertyList" + Cc(nil))
	ObjectBlock:     ObjectMatch V"Object" * V"LineEnd" * (V"Indent" * Ct(V"Block"^0) * V"Dedent" + Cc({}))

	Block:           V"ObjectBlock"
	RoML:            Ct(V"Block"^0)
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