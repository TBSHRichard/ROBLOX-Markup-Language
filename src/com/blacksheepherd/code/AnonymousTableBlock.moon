----------------------------------------------------------------
-- A table @{Block} that is not assigned to any variable.
-- Useful to have a table within a @{TableBlock}.
--
-- @classmod AnonymousTableBlock
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
class AnonymousTableBlock extends Block
	new: =>
		super!

	Render: =>
		buffer = ""

		buffer ..= @\BeforeRender!
		buffer ..= "\n"

		for i, child in ipairs @_children
			buffer ..= child\Render!
			buffer ..= "," unless i == #@_children
			buffer ..= "\n"

		buffer .. @\AfterRender!

	BeforeRender: => "#{@_indent}{"

	AfterRender: => "#{@_indent}}"
-- {{ TBSHTEMPLATE:END }}

return AnonymousTableBlock
