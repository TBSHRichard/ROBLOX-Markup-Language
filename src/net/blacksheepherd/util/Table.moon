----------------------------------------------------------------
-- A module with helper functions related to tables.
--
-- @module Table
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

HashMap = require "net.blacksheepherd.util.HashMap"

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
			if type(el) == "table" and not getmetatable el
				buffer ..= ArrayToSingleLineString el
			elseif type(el) == "string"
				buffer ..= "\"#{el}\""
			else
				buffer ..= tostring el

			buffer ..= ", " unless i == #array

		return buffer .. "}"
	else
		return "nil"

----------------------------------------------------------------
-- Reads a @{HashMap} and converts it into a single-line string.
--
-- @tparam HashMap map The @{HashMap} to turn into a string.
-- @treturn string The @{HashMap} as a single-line string.
----------------------------------------------------------------
HashMapToSingleLineString = (map) ->
	unless map == nil
		buffer = "{"
		i = 0

		for key, el in map\pairs!
			i += 1
			buffer ..= "#{key} = "

			if type(el) == "table" and not getmetatable el
				buffer ..= HashMapToSingleLineString HashMap el
			elseif type(el) == "string"
				buffer ..= "\"#{el}\""
			else
				buffer ..= tostring el

			buffer ..= ", " unless i == map\Length!

		return buffer .. "}"
	else
		return "nil"

{ :ArrayToSingleLineString, :HashMapToSingleLineString }