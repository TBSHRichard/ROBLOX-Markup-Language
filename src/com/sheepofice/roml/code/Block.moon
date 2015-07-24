----------------------------------------------------------------
-- A block of code.
--
-- @classmod Block
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

class Block
	----------------------------------------------------------------
	-- Create a new Block.
	--
	-- @tparam Block self
	----------------------------------------------------------------
	new: =>
		@_indent = ""
		@_children = {}
	
	----------------------------------------------------------------
	-- Add a child @{Block} or @{Line} to be rendered with this
	-- Block.
	--
	-- @tparam Block self
	-- @tparam Block/Line child The child to add.
	----------------------------------------------------------------
	AddChild: (child) =>
		child\SetIndent "#{@_indent}  "
		table.insert @_children, child
	
	----------------------------------------------------------------
	-- Sets the indent string for this Block.
	--
	-- @tparam Block self
	-- @tparam string indent The indent string to place before each
	--	line of code.
	----------------------------------------------------------------
	SetIndent: (indent) =>
		@_indent = indent
		for child in *@_children
			child\SetIndent "#{@_indent}  "
	
	----------------------------------------------------------------
	-- The code to render before rendering all of this Block's
	-- children.
	--
	-- @tparam Block self
	----------------------------------------------------------------
	BeforeRender: =>
	
	----------------------------------------------------------------
	-- The code to render after rendering all of this Block's
	-- children.
	--
	-- @tparam Block self
	----------------------------------------------------------------
	AfterRender: =>
	
	----------------------------------------------------------------
	-- Render the code for this Block and any children Block/Lines.
	--
	-- @tparam Block self
	----------------------------------------------------------------
	Render: =>
		buffer = ""
		
		buffer ..= @\BeforeRender!
		buffer ..= "\n"
		
		for child in *@_children
			buffer ..= child\Render!
			buffer ..= "\n"
		
		buffer .. @\AfterRender!

return Block
