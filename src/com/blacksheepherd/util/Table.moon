----------------------------------------------------------------
-- A module with helper functions related to tables.
--
-- @module Table
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

HashMap = require "com.blacksheepherd.util.HashMap"
String = require "com.blacksheepherd.util.String"

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

----------------------------------------------------------------
-- Returns a @{HashMap} as a string representation across
-- multiple lines.
--
-- @tparam HashMap map The @{HashMap} to turn into a string.
-- @tparam integer depth[opt=0] How many tabs to print at the
--  start of the string.
-- @treturn string The @{HashMap} as a multi-line string.
----------------------------------------------------------------
HashMapToMultiLineString = (map, depth = 0) ->
	unless map == nil
		buffer = "{\n"
		i = 0

		for key, el in map\pairs!
			i += 1
			buffer ..= String.StringNTimes "\t", depth + 1
			buffer ..= "#{key} = "

			if type(el) == "table" and not getmetatable el
				buffer ..= HashMapToMultiLineString HashMap(el), depth + 1
			elseif type(el) == "table" and getmetatable(el) and el.__class.__name == "HashMap"
				buffer ..= HashMapToMultiLineString el, depth + 1
			elseif type(el) == "string"
				buffer ..= "\"#{el}\""
			else
				buffer ..= tostring el

			buffer ..= "," unless i == map\Length!
			buffer ..= "\n"

		return buffer .. String.StringNTimes("\t", depth) .. "}"
	else
		return "nil"

----------------------------------------------------------------
-- Performs a deep comparison of two tables to check if they
-- are equal.
--
-- @tparam table tableOne The first table to compare.
-- @tparam table tableTwo The second table to compare.
-- @treturn boolean True if the two tables are equal.
----------------------------------------------------------------
TablesAreEqual = (tableOne, tableTwo) ->
	return false if type(tableOne) != "table" or type(tableTwo) != "table"
	equal = true

	for key, value in pairs tableOne
		if type(value) != "table"
			equal = value == tableTwo[key]
		else
			equal = TablesAreEqual value, tableTwo[key]
		return false if not equal

	for key, value in pairs tableTwo
		if type(value) != "table"
			equal = tableOne[key] == value
		else
			equal = TablesAreEqual tableOne[key], value
		return false if not equal

	return true

----------------------------------------------------------------
-- Swap the values of two elements in a table.
--
-- @tparam table t The table to swap elements in.
-- @param i1 The key of the first element.
-- @param i2 The key of the second element.
----------------------------------------------------------------
Swap = (t, i1, i2) ->
	temp = t[i1]
	t[i1] = t[i2]
	t[i2] = temp

{ :ArrayToSingleLineString, :HashMapToSingleLineString, :HashMapToMultiLineString, :TablesAreEqual, :Swap }