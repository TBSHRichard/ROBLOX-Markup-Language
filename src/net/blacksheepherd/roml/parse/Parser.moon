----------------------------------------------------------------
-- A module with helper functions related to parsing of RoML.
--
-- @module Parser
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

lpeg = require "lpeg"
Stack = require "net.blacksheepherd.datastructure.Stack"

import C, Cc, Ct, Cmt, P, R, S, V from lpeg

local indentStack

calculateIndentSize = (tabs) ->
	indentSize = 0

	for char in tabs\gmatch "."
		indentSize += if char == "\t" then 4 else 1

	return indentSize

BlockMatch = (pattern) ->
	pattern / (parentTable, children) ->
		parentTable[#parentTable] = children
		return parentTable

ObjectMatch = (pattern) ->
	pattern / (objectName, children) ->
		{
			"object",
			objectName,
			nil,
			nil,
			nil,
			children
		}

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
	Tabs:            S"\t "^0
	Indent:          #Cmt(V"Tabs", Indent)
	CheckIndent:     Cmt(V"Tabs", CheckIndent)
	Dedent:          Cmt("", Dedent)

	ObjectName:      C(V"UppercaseLetter" * (V"UppercaseLetter" + V"LowercaseLetter")^0)
	Object:          V"CheckIndent" * P"%" * V"ObjectName"
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