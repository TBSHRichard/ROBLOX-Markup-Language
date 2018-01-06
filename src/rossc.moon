local Block, DoubleBlock, RomlObject
local AnonymousTableBlock, Array, CompilerPropertyFilter, CustomObject, CustomObjectBuilder, DoBlock, FunctionBlock
local HashMap, IfBlock, IfElseBlock, InnerMetatableBlock, Line, LiteralString, lpeg, MainRossBlock, MetatableBlock
local RequireLine, RossCompiler, RossParser, SpaceBlock, SpriteSheet, Stack, StackBlock, String, Table
local TableAssignmentBlock, TableBlock

if game
	pluginModel = script.Parent
	lpeg = require(pluginModel.lulpeg.lulpeg)
else
	lpeg = require "lpeg"

-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/Block.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/DoubleBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/roml/RomlObject.moon }}

-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/AnonymousTableBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/util/Array.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/compile/CompilerPropertyFilter.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/roml/CustomObject.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/customobject/CustomObjectBuilder.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/DoBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/FunctionBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/util/HashMap.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/IfBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/IfElseBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/InnerMetatableBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/Line.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/compile/LiteralString.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/MainRossBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/MetatableBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/RequireLine.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/ross/RossCompiler.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/ross/RossParser.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/SpaceBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/customobject/SpriteSheet.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/datastructure/Stack.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/StackBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/util/String.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/util/Table.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/TableAssignmentBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/TableBlock.moon }}

Transpile = (className, source) ->
	tree = RossParser.Parse source

	return '' if tree == nil
	return RossCompiler.Compile className, tree

return { :Transpile }
