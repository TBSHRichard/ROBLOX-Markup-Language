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

class CustomObject extends RomlObject
	new: (romlDoc, objectId, classes) =>
		super(romlDoc, @\Create!, objectId, classes)
		@_properties = @\CreateProperties!

	Create: =>

	CreateProperties: =>
		{}

	PropertyUpdateOrder: =>
		{}

	UpdateProperty: (name, value) =>

	Refresh: =>
		propertyUpdateOrder = @\PropertyUpdateOrder!

		if #propertyUpdateOrder > 0
			for name in *propertyUpdateOrder
				@\UpdateProperty name, @_properties[name]
		else
			for name, property in pairs @_properties
				@\UpdateProperty name, property
