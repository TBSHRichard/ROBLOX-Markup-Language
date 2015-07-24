----------------------------------------------------------------
-- A @{Block} for Lua functions.
--
-- @classmod FunctionBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Block = require "com.sheepofice.roml.code.Block"

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
	
	BeforeRender: => "#{@_indent}#{@_name} = function(#{@_parameters})"
	
	AfterRender: => "#{@_indent}end"

return FunctionBlock
