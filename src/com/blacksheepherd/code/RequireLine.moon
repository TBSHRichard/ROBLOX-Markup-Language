----------------------------------------------------------------
-- A @{Line} that is used to require a ModuleScript in ROBLOX.
--
-- @classmod RequireLine
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local Line

if game
	pluginModel = script.Parent.Parent.Parent.Parent
	Line = require(pluginModel.com.blacksheepherd.code.Line)
else
	Line = require "com.blacksheepherd.code.Line"

-- {{ TBSHTEMPLATE:BEGIN }}
class RequireLine extends Line
	new: (package, name) =>
		super "local #{name} = require(game:GetService(\"ServerScriptService\").#{package}.#{name})"
-- {{ TBSHTEMPLATE:END }}

return RequireLine
