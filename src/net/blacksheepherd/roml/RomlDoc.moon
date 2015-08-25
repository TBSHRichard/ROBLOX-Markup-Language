----------------------------------------------------------------
-- The base class for RoML object creation. All compiled RoML
-- files will be compiled into a Lua class with this class as
-- its base.
--
-- @classmod RomlDoc
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

class RomlDoc
	----------------------------------------------------------------
	-- Create a new RomlDoc.
	--
	-- @tparam RomlDoc self
	-- @tparam Instance parent The ROBLOX object to add the RomlDoc
	--	to.
	-- @tparam table vars The starting values for the variables.
	----------------------------------------------------------------
	new: (parent, vars) =>
		@_objectIds = {}
		@_vars = {}
		
		@\_create parent, vars
	
	----------------------------------------------------------------
	-- Get a variable from this document so it may be changed.
	--
	-- @tparam RomlDoc self
	-- @tparam string varName The name of the variable.
	-- @treturn GenericRomlVar/TableRomlVar/Instance The variable.
	----------------------------------------------------------------
	GetVar: (varName) => @_vars[varName]
	
	----------------------------------------------------------------
	-- 
	----------------------------------------------------------------
	Find: (selector) =>
		@_rootObject\Find selector
	
	_create: (parent, vars) =>

return RomlDoc
