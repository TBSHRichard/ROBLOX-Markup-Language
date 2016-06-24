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

	Create: =>

	SetProperty: (instance, name, value) =>

	SetProperties: (properties) =>
		@\SetProperty(@_robloxObject, name, @\FilterProperty(name, value)) for name, value in pairs properties
