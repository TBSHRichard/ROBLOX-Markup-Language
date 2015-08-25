----------------------------------------------------------------
-- A @{Block} for Lua if blocks.
--
-- @classmod IfBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Block = require "net.blacksheepherd.roml.code.Block"

class IfBlock extends Block
	----------------------------------------------------------------
	-- Create the if @{Block}.
	--
	-- @tparam IfBlock self
	-- @tparam string condition The condition statement for the
	--	if @{Block}.
	----------------------------------------------------------------
	new: (condition) =>
		super!
		@_condition = condition
	
	BeforeRender: => "#{@_indent}if #{@_condition} then"
	
	AfterRender: => "#{@_indent}end"

return IfBlock
