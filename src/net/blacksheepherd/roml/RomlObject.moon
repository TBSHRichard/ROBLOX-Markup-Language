----------------------------------------------------------------
-- A wrapper for ROBLOX objects that contains methods for
-- finding objects within the hierarchy.
--
-- @classmod RomlObject
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

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
	new: (object, classes = {}) =>
		@_id = @@_currentId
		@@_currentId += 1
		
		@_properties = {}
		@_propertyFilters = {}
		
		@_robloxObject = object
		@_classes = classes
		@_children = {}
	
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
	-- Add a child RomlObject to this RomlObject.
	--
	-- @tparam RomlObject self
	-- @tparam RomlObject child The child to add.
	----------------------------------------------------------------
	AddChild: (child) =>
		child\SetParent self
		@_children[child\GetId!] = child
	
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
		for child in *@_children
			child._robloxObject\Destroy!
		@_children = {}
	
	----------------------------------------------------------------
	-- @tparam RomlObject self
	-- @treturn integer The unique identifier for this RomlObject.
	----------------------------------------------------------------
	GetId: => @_id
	
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
	-- Find RomlObjects within this RomlObject's hierarchy using the
	-- given selector.
	--
	-- @tparam RomlObject self
	-- @tparam string selector The selector to use as a search.
	-- @treturn table Table of matching RomlObjects.
	----------------------------------------------------------------
	Find: (selector) =>

return RomlObject
