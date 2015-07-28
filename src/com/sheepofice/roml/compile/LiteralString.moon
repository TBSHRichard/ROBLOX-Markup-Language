----------------------------------------------------------------
-- Holds a string value and is used by the Compiler to print
-- out literal string text without having quotes in the output.
--
-- @classmod LiteralString
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

class LiteralString
	----------------------------------------------------------------
	-- Create a new LiteralString.
	--
	-- @tparam LiteralString self
	-- @tparam string s The string to output.
	----------------------------------------------------------------
	new: (s) =>
		@_string = s

	__tostring: => @_string