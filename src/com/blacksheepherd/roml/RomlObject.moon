----------------------------------------------------------------
-- A wrapper for ROBLOX objects that contains methods for
-- finding objects within the hierarchy.
--
-- @classmod RomlObject
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local HashMap

if game
	HashMap = require(game\GetService("ServerScriptService").com.blacksheepherd.util.HashMap)
else
	HashMap = require "com.blacksheepherd.util.HashMap"

class RomlObject
	@_currentId: 1
	
	----------------------------------------------------------------
	-- Create a new RomlObject.
	--
	-- @tparam RomlObject self
	-- @tparam Instance object The ROBLOX Instance to wrap with this
	--	RomlObject.
	-- @tparam[opt={}] table classes The list of classes for the
	-- 	RomlObject.
	----------------------------------------------------------------
	new: (romlDoc, object, objectId, classes = {}) =>
		@_romlDoc = romlDoc
		@_id = @@_currentId
		@@_currentId += 1
		
		@_properties = {}
		@_propertyFilters = {}

		@_objectId = objectId

		object = Instance.new(object) if type(object) == "string"
		
		@_robloxObject = object
		@_classes = classes
		@_children = HashMap({})
	
	----------------------------------------------------------------
	-- Sets the parent of this RomlObject and updates any children
	-- lists.
	--
	-- @tparam RomlObject self
	-- @tparam RomlObject parent The new parent.
	----------------------------------------------------------------
	SetParent: (parent) =>
		@_parent = parent
		@_robloxObject.Parent = parent\GetRobloxObject! if parent
	
	----------------------------------------------------------------
	-- @tparam RomlObject self
	-- @treturn Instance The ROBLOX object wrapped by this
	--	RomlObject.
	----------------------------------------------------------------
	GetRobloxObject: => @_robloxObject
	
	----------------------------------------------------------------
	-- Sets the properties of the RomlObject to its associated
	-- ROBLOX object, sending the properties through any filters if
	-- necessary.
	--
	-- @tparam RomlObject self
	----------------------------------------------------------------
	Refresh: =>
		for name, property in pairs @_properties
			filter = @_propertyFilters[name]
			
			if filter
				filter property, @_robloxObject
			else
				@_robloxObject[name] = property

	----------------------------------------------------------------
	-- Changes the properties of the wrapped ROBLOX object without
	-- changing the inline properties of this object.
	--
	-- @tparam RomlObject self
	-- @tparam table properties The list of properties to set on
	--  the ROBLOX object.
	----------------------------------------------------------------
	StyleObject: (properties) =>
		for name, property in pairs properties
			filter = @_propertyFilters[name]
			
			if filter
				filter property, @_robloxObject
			else
				@_robloxObject[name] = property
	
	----------------------------------------------------------------
	-- Add a child RomlObject to this RomlObject. Throws an error if
	-- this RomlObject does not allow children.
	--
	-- @tparam RomlObject self
	-- @tparam RomlObject child The child to add.
	----------------------------------------------------------------
	AddChild: (child) =>
		if @\AllowsChildren!
			child\SetParent self
			@_children[child\GetId!] = child
			return child
		else
			error("RomlObject '#{@@__name}' does not allow children objects.")
	
	----------------------------------------------------------------
	-- Sets the properties to the RomlObject. The associated ROBLOX
	-- object is not updated until @{Refresh} is called.
	--
	-- @tparam RomlObject self
	-- @tparam table properties The properties to set.
	----------------------------------------------------------------
	SetProperties: (properties) =>
		@_properties[name] = value for name, value in pairs properties

	----------------------------------------------------------------
	-- @tparam RomlObject self
	-- @tparam table classes The array of new classes.
	----------------------------------------------------------------
	SetClasses: (classes) => @_classes = classes
	
	----------------------------------------------------------------
	-- Removes all children from this object.
	--
	-- @tparam RomlObject self
	----------------------------------------------------------------
	RemoveAllChildren: =>
		for _, child in @_children\pairs!
			@_romlDoc\RemoveChild child
			child\RemoveAllChildren!
			child._robloxObject\Destroy!
		@_children = {}
	
	----------------------------------------------------------------
	-- @tparam RomlObject self
	-- @treturn integer The unique identifier for this RomlObject.
	----------------------------------------------------------------
	GetId: => @_id

	----------------------------------------------------------------
	-- @tparam RomlObject self
	-- @treturn integer The named identifier for the RomlObject as
	--  defined in the RomlDoc.
	----------------------------------------------------------------
	GetObjectId: => @_objectId

	----------------------------------------------------------------
	-- @tparam RomlObject self
	-- @treturn The style classes of this RomlObject.
	----------------------------------------------------------------
	GetClasses: => @_classes
	
	----------------------------------------------------------------
	-- Remove the provided child from the list of children.
	--
	-- @tparam RomlObject self
	-- @tparam RomlObject child The child to remove.
	----------------------------------------------------------------
	RemoveChild: (child) =>
		child\SetParent nil
		@_children[child\GetId!] = nil

	----------------------------------------------------------------
	-- Returns whether or not this RoML Object has the given
	-- class or not.
	--
	-- @tparam RomlObject self
	-- @tparam string className The class to look for.
	-- @treturn bool True if this RomlObject has the class, false
	--  if it does not.
	----------------------------------------------------------------
	HasClass: (className) =>
		for name in *@_classes
			return true if name == className

		return false

	----------------------------------------------------------------
	-- Returns whether or not this RoML Object matches the given
	-- @{Stack} of selectors. Each element of the @{Stack} should
	-- be a simple table with a object key, a id or class key, or
	-- both.
	--
	-- @tparam RomlObject self
	-- @tparam Stack selectorStack
	-- @treturn bool True if the entire @{Stack} matches this
	--  specific @{RomlObject}, false otherwise.
	----------------------------------------------------------------
	MatchesSelector: (selectorStack) =>
		selector = selectorStack\Pop!
		matches = false

		if selector.object != nil
			matches = selector.object == @_robloxObject.ClassName

			if selector.class != nil
				matches = matches and @\HasClass selector.class
			elseif selector.id != nil
				matches = matches and selector.id == @_objectId
		else
			-- No object ClassName selector, must have class or id
			if selector.class != nil
				matches = @\HasClass selector.class
			else
				matches = selector.id == @_objectId

		if matches
			unless selectorStack\IsEmpty!
				return @_parent\MatchesSelector(selectorStack)
			else
				return true
		else
			return false

	----------------------------------------------------------------
	-- @tparam RomlObject self
	-- @treturn bool Whether or not this RomlObject can have
	--  children RomlObjects.
	----------------------------------------------------------------
	AllowsChildren: => true
	
	----------------------------------------------------------------
	-- Find RomlObjects within this RomlObject's hierarchy using the
	-- given selector.
	--
	-- @tparam RomlObject self
	-- @tparam string selector The selector to use as a search.
	-- @treturn table Table of matching RomlObjects.
	----------------------------------------------------------------
	Find: (selector) =>

return RomlObject
