----------------------------------------------------------------
-- A specialized @{Block} which contains two @{SpaceBlock}s and
-- allows children to be added to either.
--
-- @classmod DoubleBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local Block
local SpaceBlock

if game
	pluginModel = script.Parent.Parent.Parent.Parent
	Block = require(pluginModel.com.blacksheepherd.code.Block)
	SpaceBlock = require(pluginModel.com.blacksheepherd.code.SpaceBlock)
else
	Block = require "com.blacksheepherd.code.Block"
	SpaceBlock = require "com.blacksheepherd.code.SpaceBlock"

-- {{ TBSHTEMPLATE:BEGIN }}
class DoubleBlock extends Block
	----------------------------------------------------------------
	-- Constant for adding children to the top @{Block}.
	--
	-- @prop TOP
	----------------------------------------------------------------
	@TOP: "top"

	----------------------------------------------------------------
	-- Constant for adding children to the bottom @{Block}.
	--
	-- @prop BOTTOM
	----------------------------------------------------------------
	@BOTTOM: "bottom"

	new: =>
		super!
		@_topBlock = SpaceBlock!
		@_bottomBlock = SpaceBlock!

		table.insert @_children, @_topBlock
		table.insert @_children, @_bottomBlock

	SetIndent: (indent) =>
		@_indent = indent
		@_topBlock\SetIndent "#{indent}  "
		@_bottomBlock\SetIndent "#{indent}  "

	----------------------------------------------------------------
	-- Adds a child to either of the two @{Block}s.
	--
	-- @tparam DoubleBlock self
	-- @tparam string block One of DoubleBlock.TOP or
	--	DoubleBlock.BOTTOM
	-- @tparam Block/Line child The child to add.
	----------------------------------------------------------------
	AddChild: (block, child) =>
		if block == @@TOP
			@_topBlock\AddChild child
		elseif block == @@BOTTOM
			@_bottomBlock\AddChild child

	----------------------------------------------------------------
	-- @tparam DoubleBlock self
	-- @treturn string The code that will be added to the buffer
	--	that will be added in between the content of the two
	--	@{Block}s.
	----------------------------------------------------------------
	MiddleRender: =>

	Render: =>
		buffer = ""

		buffer ..= @\BeforeRender!
		buffer ..= "\n"

		buffer ..= @_topBlock\Render!
		buffer ..= "\n"

		buffer ..= @\MiddleRender!
		buffer ..= "\n"

		buffer ..= @_bottomBlock\Render!
		buffer ..= "\n"

		buffer .. @\AfterRender!
-- {{ TBSHTEMPLATE:END }}

return DoubleBlock
