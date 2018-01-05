----------------------------------------------------------------
-- A @{Block} that represents a Lua do block.
--
-- @classmod DoBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local Block

if game
	pluginModel = script.Parent.Parent.Parent.Parent
	Block = require(pluginModel.com.blacksheepherd.code.Block)
else
	Block = require "com.blacksheepherd.code.Block"

-- {{ TBSHTEMPLATE:BEGIN }}
class DoBlock extends Block
	BeforeRender: => "#{@_indent}do"

	AfterRender: => "#{@_indent}end"
-- {{ TBSHTEMPLATE:END }}

return DoBlock
