----------------------------------------------------------------
-- A @{Block} that represents a Lua table.
--
-- @classmod TableBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Block = require "net.blacksheepherd.roml.code.Block"

class TableBlock extends Block
	new: (name) =>
		super!
		@_name = name

	Render: =>
		buffer = ""
		
		buffer ..= @\BeforeRender!
		buffer ..= "\n"
		
		for i, child in ipairs @_children
			buffer ..= child\Render!
			buffer ..= "," unless i == #@_children
			buffer ..= "\n"
		
		buffer .. @\AfterRender!
	
	BeforeRender: => "#{@_indent}local #{@_name} = {"
	
	AfterRender: => "#{@_indent}}"

return TableBlock
