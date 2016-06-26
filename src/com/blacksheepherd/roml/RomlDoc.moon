----------------------------------------------------------------
-- The base class for RoML object creation. All compiled RoML
-- files will be compiled into a Lua class with this class as
-- its base.
--
-- @classmod RomlDoc
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

HashMap = require(game\GetService("ServerScriptService").com.blacksheepherd.util.HashMap)
RossDoc = require(game\GetService("ServerScriptService").com.blacksheepherd.ross.RossDoc)

class RomlDoc
	----------------------------------------------------------------
	-- Create a new RomlDoc.
	--
	-- @tparam RomlDoc self
	-- @tparam Instance parent The ROBLOX object to add the RomlDoc
	--	to.
	-- @tparam[opt] table vars The starting values for the variables.
	-- @tparam[opt] RossDoc ross The starting RoSS.
	----------------------------------------------------------------
	new: (parent, vars, ross) =>
		@_objectIds = {}
		@_vars = {}
		@_ross = ross
		@_children = HashMap({})
		
		@\_create parent, (vars or {})
	
	----------------------------------------------------------------
	-- Get a variable from this document so it may be changed.
	--
	-- @tparam RomlDoc self
	-- @tparam string varName The name of the variable.
	-- @treturn GenericRomlVar/TableRomlVar/Instance The variable.
	----------------------------------------------------------------
	GetVar: (varName) => @_vars[varName]
	
	----------------------------------------------------------------
	-- Find a specific @{RomlObject} in this document based on the
	-- selector.
	--
	-- @tparam RomlDoc self
	-- @tparam string selector The RoSS selector to search by.
	-- @treturn array An array of matching @{RomlObject}s.
	----------------------------------------------------------------
	Find: (selector) =>
		@_rootObject\Find selector

	----------------------------------------------------------------
	-- Add a child @{RomlObject} to this @{RomlDoc}.
	--
	-- @tparam RomlDoc self
	-- @tparam RomlObject romlObject The object to add.
	----------------------------------------------------------------
	AddChild: (romlObject) =>
		@_children[romlObject\GetId!] = romlObject

		unless @_ross == nil
			@_ross\StyleObject romlObject

	----------------------------------------------------------------
	-- Remove a child @{RomlObject} from this @{RomlDoc}.
	--
	-- @tparam RomlDoc self
	-- @tparam RomlObject romlObject The object to remove.
	----------------------------------------------------------------
	RemoveChild: (romlObject) =>
		@_children[romlObject\GetId!] = nil

	----------------------------------------------------------------
	-- @tparam RomlDoc self
	-- @tparam RossDoc ross The new RoSS to apply to this
	--  @{RomlDoc}.
	----------------------------------------------------------------
	SetStyleSheet: (ross) =>
		@_ross = ross

		for _, romlObject in @_children\pairs!
			@_ross\StyleObject romlObject
	
	_create: (parent, vars) =>

return RomlDoc
