----------------------------------------------------------------
-- A @{DoubleBlock} that has two tables within it.
--
-- @classmod MetatableBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

DoubleBlock = require "net.blacksheepherd.roml.code.DoubleBlock"
InnerMetatableBlock = require "net.blacksheepherd.roml.code.InnerMetatableBlock"

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
