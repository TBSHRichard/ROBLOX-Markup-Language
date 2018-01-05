local Block, DoubleBlock, RomlObject
local CompilerPropertyFilter, ConditionalBlock, CustomObject, CustomObjectBuilder, DoBlock, ForBlock, FunctionBlock
local HashMap, IfBlock, IfElseBlock, InnerMetatableBlock, Line, LiteralString, lpeg, MainRomlBlock, MetatableBlock
local RequireLine, RomlCompiler, RomlParser, SpaceBlock, SpriteSheet, Stack, String, Table, TableBlock, VariableNamer

if game
	pluginModel = script.Parent
	lpeg = require(pluginModel.lulpeg.lulpeg)
else
	lpeg = require "lpeg"

-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/Block.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/DoubleBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/roml/RomlObject.moon }}

-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/compile/CompilerPropertyFilter.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/ConditionalBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/roml/CustomObject.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/customobject/CustomObjectBuilder.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/DoBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/ForBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/FunctionBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/util/HashMap.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/IfBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/IfElseBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/InnerMetatableBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/Line.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/compile/LiteralString.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/MainRomlBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/MetatableBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/RequireLine.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/roml/RomlCompiler.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/roml/RomlParser.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/SpaceBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/customobject/SpriteSheet.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/datastructure/Stack.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/util/String.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/util/Table.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/code/TableBlock.moon }}
-- {{ TBSHTEMPLATE:IMPORT com/blacksheepherd/compile/VariableNamer.moon }}

Transpile = (className, source) ->
	tree = RomlParser.Parse source

	return '' if tree == nil
	return RomlCompiler.Compile className, tree

return { :Transpile }
