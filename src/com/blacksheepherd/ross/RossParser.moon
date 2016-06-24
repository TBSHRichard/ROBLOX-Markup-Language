----------------------------------------------------------------
-- A module with helper functions related to parsing of RoSS.
--
-- @module RossParser
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local lpeg
local HashMap
local Array
local Stack

if game
	lpeg = require(plugin.lulpeg.lulpeg)
	HashMap = require(plugin.com.blacksheepherd.util.HashMap)
	Array = require(plugin.com.blacksheepherd.util.Array)
	Stack = require(plugin.com.blacksheepherd.datastructure.Stack)
else
	lpeg = require "lpeg"
	HashMap = require "com.blacksheepherd.util.HashMap"
	Array = require "com.blacksheepherd.util.Array"
	Stack = require "com.blacksheepherd.datastructure.Stack"

import C, Cc, Cf, Cs, Ct, Cmt, P, R, S, V from lpeg

local indentStack

NewLine =         P"\r"^-1 * P"\n"
UppercaseLetter = R"AZ"
LowercaseLetter = R"az"
Number =          R"09"
Tabs =            S"\t "^0
Spaces =          S"\r\n\t "^0
LineEnd =         Tabs * (NewLine^1 + -1)

VariableStart =   P"_" + UppercaseLetter + LowercaseLetter
VariableBody =    (VariableStart + Number)^0
VariableName =    VariableStart * VariableBody

calculateIndentSize = (tabs) ->
	indentSize = 0

	for char in tabs\gmatch "."
		indentSize += if char == "\t" then 4 else 1

	return indentSize

NewHashMap = ->
	return true, HashMap({})

PropertyPairMatch = (properties, keyValuePair) ->
		key, value = unpack keyValuePair
		properties[key] = value
		return properties

SelectorMatch = (pattern) ->
	pattern / (objectName, classOrId, classOrIdName) ->
		t = {}
		t["object"] = objectName

		if classOrId
			t[classOrId] = classOrIdName

		return t

RoSSBlockMatch = (pattern) ->
	pattern / (selectorStack, properties) ->
		Array.Reverse selectorStack

		if properties.__class == nil
			properties = nil

		return {
			selectorStack: selectorStack
			properties: properties
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
	"RoSS"

	Indent:             #Cmt(Tabs, Indent)
	CheckIndent:        Cmt(Tabs, CheckIndent)
	Dedent:             Cmt("", Dedent)

	SingleString:       P'"' * (P"\\\"" + (1 - P'"'))^0 * P'"'
	DoubleString:       P"'" * (P"\\'" + (1 - P"'"))^0 * P"'"
	String:             C(V"SingleString" + V"DoubleString")

	Id:                 P"#" * C(VariableName)
	Class:              P"." * C(VariableName)

	PropertyKey:        C(UppercaseLetter * (UppercaseLetter + LowercaseLetter + Number)^0)
	PropertyValue:      V"String" + C((S"\t "^0 * (1 - S":\r\n\t "))^0)
	PropertyPair:       Ct(Tabs * V"PropertyKey" * Tabs * P":" * Tabs * V"PropertyValue" * Tabs)
	PropertyLine:       V"CheckIndent" * V"PropertyPair" * LineEnd
	PropertyLines:      Cf(Cmt("", NewHashMap) * V"PropertyLine"^1, PropertyPairMatch)

	ObjectName:         C(UppercaseLetter * (UppercaseLetter + LowercaseLetter)^0)

	ObjectOnlySelector: V"ObjectName" * Cc(nil)
	ClassOrIdSelector:  Cc("id") * V"Id" + Cc("class") * V"Class"
	NoObjectSelector:   Cc(nil) * V"ClassOrIdSelector"
	FullSelector:       V"ObjectName" * V"ClassOrIdSelector"
	Selector:           SelectorMatch((V"FullSelector" + V"ObjectOnlySelector" + V"NoObjectSelector") * Tabs)

	RoSSHeader:         V"CheckIndent" * Ct(V"Selector"^1) * LineEnd
	RoSSBody:           V"Indent" * (V"PropertyLines" + Cc(nil)) * V"Dedent" + Cc({})
	RoSSBlock:          RoSSBlockMatch V"RoSSHeader" * V"RoSSBody"

	Block:              V"RoSSBlock"
	RoSS:               Ct(V"Block"^0)
}

----------------------------------------------------------------
-- Parses a RoSS string into a parse tree to be sent to the
-- @{RossCompiler}.
--
-- @tparam string roml The RoSS string.
-- @treturn table The parse tree.
----------------------------------------------------------------
Parse = (ross) ->
	indentStack = nil -- To avoid weird ROBLOX GC problems
	indentStack = Stack!
	indentStack\Push 0
	grammar\match ross

{ :Parse }