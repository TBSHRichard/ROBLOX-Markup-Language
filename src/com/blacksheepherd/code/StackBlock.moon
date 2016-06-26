----------------------------------------------------------------
-- A @{Block} that allows a variable in a @{TableBlock} or
-- @{AnonymousTableBlock} to be a Stack.
--
-- @classmod StackBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local Block

if game
	Block = require(plugin.com.blacksheepherd.code.Block)
else
	Block = require "com.blacksheepherd.code.Block"

class StackBlock extends Block
	----------------------------------------------------------------
	-- Create the StackBlock.
	--
	-- @tparam MainBlock self
	-- @tparam string name The name of the variable that the Stack
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
	
	BeforeRender: => "#{@_indent}#{@_name} = Stack({"
	
	AfterRender: => "#{@_indent}})"

return StackBlock