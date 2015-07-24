----------------------------------------------------------------
-- A module with helper functions related to tables.
--
-- @module Table
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

----------------------------------------------------------------
-- Reads an array-like table and converts it into a single-line
-- string.
--
-- @tparam table array The array-like table to turn into a
--	string.
-- @treturn string The array as a single-line string.
----------------------------------------------------------------
ArrayToSingleLineString = (array) ->
	unless array == nil
		buffer = "{"

		for i, el in ipairs array
			if type(el) == "table"
				buffer ..= ArrayToSingleLineString el
			elseif type(el) == "string"
				buffer ..= "\"#{el}\""
			else
				buffer ..= tostring el

		return buffer .. "}"
	else
		return "nil"

{ :ArrayToSingleLineString }