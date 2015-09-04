----------------------------------------------------------------
-- A Block that puts creates a for loop.
--
-- @classmod ForBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Block = require "net.blacksheepherd.roml.code.Block"

class ForBlock extends Block
	new: (condition) =>
		super!
		@_condition = condition

	BeforeRender: => "#{@_indent}for #{@_condition} do"

	AfterRender: => "#{@_indent}end"

return ForBlock