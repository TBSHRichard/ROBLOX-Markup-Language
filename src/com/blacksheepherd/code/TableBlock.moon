----------------------------------------------------------------
-- A @{Block} that represents a Lua table.
--
-- @classmod TableBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local Block

if game
	pluginModel = script.Parent.Parent.Parent.Parent
	Block = require(pluginModel.com.blacksheepherd.code.Block)
else
	Block = require "com.blacksheepherd.code.Block"

class TableBlock extends Block
	----------------------------------------------------------------
	-- Create the TableBlock.
	--
	-- @tparam TableBlock self
	-- @tparam string name The name of the variable that this table
	--  is assigned to.
	----------------------------------------------------------------
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
