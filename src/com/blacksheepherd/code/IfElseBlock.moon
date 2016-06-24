----------------------------------------------------------------
-- A @{DoubleBlock} for Lua if blocks.
--
-- @classmod IfElseBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local DoubleBlock

if game
	DoubleBlock = require(plugin.com.blacksheepherd.code.DoubleBlock)
else
	DoubleBlock = require "com.blacksheepherd.code.DoubleBlock"

class IfElseBlock extends DoubleBlock
	----------------------------------------------------------------
	-- Create the if @{DoubleBlock}.
	--
	-- @tparam IfElseBlock self
	-- @tparam string condition The condition statement for the
	--	if @{Block}.
	----------------------------------------------------------------
	new: (condition) =>
		super!
		@_condition = condition
	
	BeforeRender: => "#{@_indent}if #{@_condition} then"

	MiddleRender: => "#{@_indent}else"
	
	AfterRender: => "#{@_indent}end"

return IfElseBlock
