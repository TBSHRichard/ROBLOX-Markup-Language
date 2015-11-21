----------------------------------------------------------------
-- The base class for RoML object creation. All compiled RoML
-- files will be compiled into a Lua class with this class as
-- its base.
--
-- @classmod RomlDoc
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

HashMap = require(game\GetService("ServerScriptService").net.blacksheepherd.util.HashMap)

class RomlDoc
	----------------------------------------------------------------
	-- Create a new RomlDoc.
	--
	-- @tparam RomlDoc self
	-- @tparam Instance parent The ROBLOX object to add the RomlDoc
	--	to.
	-- @tparam table vars The starting values for the variables.
	----------------------------------------------------------------
	new: (parent, vars, ross) =>
		@_objectIds = {}
		@_vars = {}
		@_ross = ross
		@_children = HashMap({})
		
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

	----------------------------------------------------------------
	-- 
	----------------------------------------------------------------
	AddChild: (romlObject) =>
		@_children[romlObject\GetId!] = romlObject

		unless @_ross == nil
			@_ross\StyleObject romlObject

	----------------------------------------------------------------
	-- 
	----------------------------------------------------------------
	RemoveChild: (romlObject) =>
		@_children[romlObject\GetId!] = nil

	----------------------------------------------------------------
	-- 
	----------------------------------------------------------------
	SetStyleSheet: (ross) =>
		@_ross = ross

		for _, romlObject in @_children\pairs!
			@_ross\StyleObject romlObject
	
	_create: (parent, vars) =>

return RomlDoc
