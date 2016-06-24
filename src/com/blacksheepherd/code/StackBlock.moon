local Block

if game
	Block = require(plugin.com.blacksheepherd.code.Block)
else
	Block = require "com.blacksheepherd.code.Block"

class StackBlock extends Block
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