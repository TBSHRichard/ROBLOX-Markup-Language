----------------------------------------------------------------
-- A @{Block} that represents a Lua do block.
--
-- @classmod DoBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local Block

if game
	Block = require(plugin.com.blacksheepherd.code.Block)
else
	Block = require "com.blacksheepherd.code.Block"

class DoBlock extends Block
	BeforeRender: => "#{@_indent}do"
	
	AfterRender: => "#{@_indent}end"

return DoBlock
