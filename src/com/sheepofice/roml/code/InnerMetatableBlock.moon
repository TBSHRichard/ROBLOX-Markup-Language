----------------------------------------------------------------
-- A @{Block} that is used inside of the @{MetatableBlock}.
--
-- @classmod InnerMetatableBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Block = require "com.sheepofice.roml.code.Block"

class InnerMetatableBlock extends Block
	AddChild: (child) =>
		child\SetIndent @_indent
		table.insert @_children, child

	SetIndent: (indent) =>
		super indent
		for child in *@_children
			child\SetIndent indent
	
	Render: =>
		buffer = ""

		for i, child in ipairs @_children
			buffer ..= child\Render!
			buffer ..= ",\n" unless i == #@_children

		return buffer

return InnerMetatableBlock
