----------------------------------------------------------------
-- A specialized stack which is used to build a RomlObject
-- hierarchy.
--
-- @classmod ObjectBuilder
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

RomlObject = require game\GetService("ServerScriptService").com.blacksheepherd.roml.RomlObject

class ObjectBuilder
	----------------------------------------------------------------
	-- Create a new ObjectBuilder, starting with the main parent.
	--
	-- @tparam ObjectBuilder self
	-- @tparam Instance root The starting ROBLOX object to build
	--	from.
	----------------------------------------------------------------
	new: (root) =>
		table.insert self, RomlObject(root)
	
	----------------------------------------------------------------
	-- Create a new RomlObject whose parent is the current top of
	-- the stack. The new object is then pushed to the top of the
	-- stack and returned.
	--
	-- @tparam ObjectBuilder self
	-- @tparam Instance object The ROBLOX object to wrap.
	-- @tparam[opt={}] table classes The classes to place on the 
	--	@{RomlObject}.
	-- @tparam[opt={}] table properties The properties to set on the
	--	@{RomlObject}.
	-- @treturn RomlObject The newly created @{RomlObject}.
	----------------------------------------------------------------
	Build: (object, classes, properties) =>
		obj = RomlObject(object, classes)
		self[#self]\AddChild obj
		
		if properties
			obj\SetProperties properties
			obj\Refresh!
		
		table.insert self, obj
		return obj
	
	----------------------------------------------------------------
	-- Remove and return the top @{RomlObject} from the Builder.
	--
	-- @tparam ObjectBuilder self
	-- @treturn RomlObject The removed @{RomlObject}.
	----------------------------------------------------------------
	Pop: => table.remove self

return ObjectBuilder
