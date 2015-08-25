----------------------------------------------------------------
-- A line of code.
--
-- @classmod Line
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

class Line
	----------------------------------------------------------------
	-- Create a new Line.
	--
	-- @tparam Block self
	-- @tparam string text The code that is in the line.
	----------------------------------------------------------------
	new: (text) =>
		@_indent = ""
		@_text = text
	
	----------------------------------------------------------------
	-- Sets the indent string for this Line.
	--
	-- @tparam Block self
	-- @tparam string indent The indent string to place before the
	--	line of code.
	----------------------------------------------------------------
	SetIndent: (indent) =>
		@_indent = indent
	
	----------------------------------------------------------------
	-- Render the code for this Line.
	--
	-- @tparam Block self
	----------------------------------------------------------------
	Render: => "#{@_indent}#{@_text}"

return Line
