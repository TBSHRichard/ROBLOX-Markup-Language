----------------------------------------------------------------
-- A @{DoubleBlock} that has two tables within it.
--
-- @classmod MetatableBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local DoubleBlock
local InnerMetatableBlock

if game
	pluginModel = script.Parent.Parent.Parent.Parent
	DoubleBlock = require(pluginModel.com.blacksheepherd.code.DoubleBlock)
	InnerMetatableBlock = require(pluginModel.com.blacksheepherd.code.InnerMetatableBlock)
else
	DoubleBlock = require "com.blacksheepherd.code.DoubleBlock"
	InnerMetatableBlock = require "com.blacksheepherd.code.InnerMetatableBlock"

class MetatableBlock extends DoubleBlock
	new: (name) =>
		super!
		@_name = name
		@_topBlock = InnerMetatableBlock!
		@_bottomBlock = InnerMetatableBlock!
	
	BeforeRender: => "#{@_indent}local #{@_name} = setmetatable({"

	MiddleRender: => "#{@_indent}}, {"
	
	AfterRender: => "#{@_indent}})"

return MetatableBlock
