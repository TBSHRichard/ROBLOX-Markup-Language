----------------------------------------------------------------
-- A module with helper functions related to strings.
--
-- @module String
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

----------------------------------------------------------------
-- Duplicates the given string n times and returns a new string.
--
-- @tparam string s The string to duplicate.
-- @tparam integer n The amount of times to duplicate the
--  string.
-- @treturn string The duplicated string.
----------------------------------------------------------------
StringNTimes = (s, n) ->
	buffer = ""

	for i=1,n
		buffer ..= s

	return buffer

{ :StringNTimes }