----------------------------------------------------------------
-- A Block that puts creates a for loop.
--
-- @classmod ForBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local Block

if game
	Block = require(plugin.com.blacksheepherd.code.Block)
else
	Block = require "com.blacksheepherd.code.Block"

class ForBlock extends Block
	new: (condition) =>
		super!
		@_condition = condition

	BeforeRender: => "#{@_indent}for #{@_condition} do"

	AfterRender: => "#{@_indent}end"

return ForBlock