----------------------------------------------------------------
-- A @{Block} that represents a Lua do block.
--
-- @classmod DoBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Block = require "net.blacksheepherd.roml.code.Block"

class DoBlock extends Block
	BeforeRender: => "#{@_indent}do"
	
	AfterRender: => "#{@_indent}end"

return DoBlock
