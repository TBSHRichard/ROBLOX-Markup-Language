RomlObject = require "com.blacksheepherd.roml.RomlObject"

class CustomObject extends RomlObject
	new: (romlDoc, objectId, classes) =>
		super(romlDoc, @\Create!, objectId, classes)

	Create: =>

	SetProperty: (instance, name, value) =>

	SetProperties: (properties) =>
		@\SetProperty(@_robloxObject, name, @\FilterProperty(name, value)) for name, value in pairs properties
