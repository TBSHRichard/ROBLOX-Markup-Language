----------------------------------------------------------------
-- The base class used for creating custom @{RomlObject}s.
-- Creating custom objects has been simplified for the purposes
-- of coding them in Lua; they only are simple tables with the
-- specific functions within them. The library creates the
-- sub-class from that (inside @{CustomObjectBuilder}).
--
-- @classmod MainRossBlock
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local RomlObject

if game
	RomlObject = require(game\GetService("ServerScriptService").com.blacksheepherd.roml.RomlObject)
else
	RomlObject = require "com.blacksheepherd.roml.RomlObject"

-- {{ TBSHTEMPLATE:BEGIN }}
class CustomObject extends RomlObject
	new: (romlDoc, objectId, classes) =>
		super(romlDoc, @\Create!, objectId, classes)
		@\SetProperties(@\CreateProperties!)

	ObjectName: => @@__name

	Create: =>

	CreateProperties: =>
		{}

	PropertyUpdateOrder: =>
		{}

	UpdateProperty: (robloxObject, name, value) =>

	Refresh: =>
		propertyUpdateOrder = @\PropertyUpdateOrder!

		if #propertyUpdateOrder > 0
			for name in *propertyUpdateOrder
				if @_properties[name] != nil
					@\UpdateProperty @_robloxObject, name, @_properties[name]
		else
			for name, property in pairs @_properties
				@\UpdateProperty @_robloxObject, name, property

	StyleObject: (properties) =>
		propertyUpdateOrder = @\PropertyUpdateOrder!

		if #propertyUpdateOrder > 0
			for name in *propertyUpdateOrder
				if properties[name] != nil
					@\UpdateProperty @_robloxObject, name, properties[name]
		else
			for name, property in pairs properties
				@\UpdateProperty @_robloxObject, name, property
-- {{ TBSHTEMPLATE:END }}

return CustomObject
