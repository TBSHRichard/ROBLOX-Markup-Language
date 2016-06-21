Block = require "com.blacksheepherd.code.Block"

class AnonymousTableBlock extends Block
	new: =>
		super!

	Render: =>
		buffer = ""
		
		buffer ..= @\BeforeRender!
		buffer ..= "\n"
		
		for i, child in ipairs @_children
			buffer ..= child\Render!
			buffer ..= "," unless i == #@_children
			buffer ..= "\n"
		
		buffer .. @\AfterRender!
	
	BeforeRender: => "#{@_indent}{"
	
	AfterRender: => "#{@_indent}}"

return AnonymousTableBlock