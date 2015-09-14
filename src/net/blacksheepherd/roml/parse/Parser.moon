----------------------------------------------------------------
-- A module with helper functions related to parsing of RoML.
--
-- @module Parser
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

lpeg = require "lpeg"

import C, Ct, P, R, S, V from lpeg

ObjectMatch = (pattern) ->
	pattern / (objectName) ->
		{
			"object",
			objectName,
			nil,
			nil,
			nil,
			{}
		}

grammar = P {
	"RoML"

	NewLine: P"\r"^-1 * P"\n"
	UppercaseLetter: R"AZ"
	LowercaseLetter: R"az"

	ObjectName: C(V"UppercaseLetter" * (V"UppercaseLetter" + V"LowercaseLetter")^0)
	Object: ObjectMatch(P"%" * V"ObjectName")

	Block: V"Object" * V"NewLine"^0 * V"Block"^0
	RoML: Ct(V"Block")
}

----------------------------------------------------------------
-- Parses a RoML string into a parse tree to be sent to the
-- @{Compiler}.
--
-- @tparam string roml The RoML string.
-- @treturn table The parse tree.
----------------------------------------------------------------
Parse = (roml) ->
	grammar\match roml

{ :Parse }