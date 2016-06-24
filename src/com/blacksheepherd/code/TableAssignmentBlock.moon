----------------------------------------------------------------
-- A @{Block} that is similar to to @{TableBlock} but assigns
-- the table to a table key instead of a local variable.
--
-- @classmod TableAssignmentBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local Block

if game
	Block = require(plugin.com.blacksheepherd.code.Block)
else
	Block = require "com.blacksheepherd.code.Block"

class TableAssignmentBlock extends Block
	----------------------------------------------------------------
	-- Create the TableAssignmentBlock.
	--
	-- @tparam TableAssignmentBlock self
	-- @tparam string name The name of the table variable that this
	--  table is assigned to.
	-- @tparam string key The key of the table to assign to.
	----------------------------------------------------------------
	new: (name, key) =>
		super!
		@_name = name
		@_key = key

	Render: =>
		buffer = ""
		
		buffer ..= @\BeforeRender!
		buffer ..= "\n"
		
		for i, child in ipairs @_children
			buffer ..= child\Render!
			buffer ..= "," unless i == #@_children
			buffer ..= "\n"
		
		buffer .. @\AfterRender!
	
	BeforeRender: => "#{@_indent}#{@_name}[\"#{@_key}\"] = {"
	
	AfterRender: => "#{@_indent}}"

return TableAssignmentBlock