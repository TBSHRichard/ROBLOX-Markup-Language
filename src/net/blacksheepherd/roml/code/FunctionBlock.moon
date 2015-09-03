----------------------------------------------------------------
-- A @{Block} for Lua functions.
--
-- @classmod FunctionBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Block = require "net.blacksheepherd.roml.code.Block"
Line = require "net.blacksheepherd.roml.code.Line"

class FunctionBlock extends Block
	----------------------------------------------------------------
	-- Create the function @{Block}.
	--
	-- @tparam FunctionBlock self
	-- @tparam string name The name of the function.
	-- @tparam string parameters The comma-separated parameter
	--	names.
	----------------------------------------------------------------
	new: (name, parameters) =>
		super!
		@_name = name
		@_parameters = parameters
		@_addedLines = {}
	
	BeforeRender: => "#{@_indent}#{@_name} = function(#{@_parameters})"
	
	AfterRender: => "#{@_indent}end"

	----------------------------------------------------------------
	-- Add a line to this Block as a child if it has not already
	-- been added by this function.
	--
	-- @tparam FunctionBlock self
	-- @tparam string lineString The text that should be contained
	--  in the Line.
	----------------------------------------------------------------
	AddLineIfNotAdded: (lineString) =>
		unless @_addedLines[lineString]
			@_addedLines[lineString] = true
			@\AddChild Line(lineString)

return FunctionBlock
