----------------------------------------------------------------
-- A @{Block} of code which is used as a placeholder for other
-- code @{Block}s or @{Line}s.
--
-- @classmod SpaceBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local Block

if game
	Block = require(plugin.com.blacksheepherd.code.Block)
else
	Block = require "com.blacksheepherd.code.Block"

class SpaceBlock extends Block
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
			
			if i < #@_children and (child.__class.__name != "SpaceBlock" or child.__class.__name == "SpaceBlock" and #child._children > 0)
				buffer ..= "\n"

		return buffer

return SpaceBlock
