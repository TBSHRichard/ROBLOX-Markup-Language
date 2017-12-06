----------------------------------------------------------------
-- A Block that puts creates a for loop.
--
-- @classmod ForBlock
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
class ForBlock extends Block
	new: (condition) =>
		super!
		@_condition = condition

	BeforeRender: => "#{@_indent}for #{@_condition} do"

	AfterRender: => "#{@_indent}end"
-- {{ TBSHTEMPLATE:END }}

return ForBlock
