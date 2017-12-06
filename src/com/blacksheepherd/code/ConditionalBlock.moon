----------------------------------------------------------------
-- A Block that puts creates a conditional structure.
--
-- @classmod ConditionalBlock
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
class ConditionalBlock extends Block
	new: =>
		super!
		@_conditions = {}

	----------------------------------------------------------------
	-- Adds a condition to the list of conditions. A new SpaceBlock
	-- is added to this Block as well, and any AddChild calls made
	-- after will be added to the new SpaceBlock.
	--
	-- @tparam ConditionalBlock self
	-- @tparam string condition[opt=""] The condition of if
	-- 	statement. Leave this blank to add an else statement.
	----------------------------------------------------------------
	AddCondition: (condition = "") =>
		table.insert @_conditions, condition
		super\AddChild SpaceBlock!

	----------------------------------------------------------------
	-- Adds a child Block or Line to the latest conditional Block,
	-- as created by @{AddCondition}.
	--
	-- @tparam ConditionalBlock self
	-- @tparam Block/Line child The child to add.
	----------------------------------------------------------------
	AddChild: (child) =>
		@_children[#@_children]\AddChild child

	Render: =>
		buffer = ""

		for i, child in ipairs @_children
			lineString = @_conditions[i]

			if i == 1
				lineString = "if #{lineString} then"
			elseif lineString == ""
				lineString = "else"
			else
				lineString = "elseif #{lineString} then"

			buffer ..= "#{@_indent}#{lineString}\n"
			buffer ..= child\Render! .. "\n"

		buffer .. "#{@_indent}end"
-- {{ TBSHTEMPLATE:END }}

return ConditionalBlock
