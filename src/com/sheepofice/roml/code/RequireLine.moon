----------------------------------------------------------------
-- A @{Line} that is used to require a ModuleScript in ROBLOX.
--
-- @classmod RequireLine
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Line = require "com.sheepofice.roml.code.Line"

class RequireLine extends Line
	new: (package, name) =>
		super "local #{name} = require(game:GetService(\"ServerScriptService\").#{package}.#{name})"

return RequireLine