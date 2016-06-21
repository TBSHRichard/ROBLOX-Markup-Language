Block = require "com.blacksheepherd.code.Block"

class TableAssignmentBlock extends Block
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