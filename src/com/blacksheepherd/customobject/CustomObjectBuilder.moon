----------------------------------------------------------------
-- Module that contains functions for creating custom objects
-- and filtering their associated properties.
--
-- @module CustomObject
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local CustomObject
local SpriteSheet

if game
	CustomObject = require(game\GetService("ServerScriptService").com.blacksheepherd.roml.CustomObject)
	SpriteSheet = require(game\GetService("ServerScriptService").com.blacksheepherd.customobject.SpriteSheet)
else
	CustomObject = require "com.blacksheepherd.roml.CustomObject"
	SpriteSheet = require "com.blacksheepherd.customobject.SpriteSheet"

-- {{ TBSHTEMPLATE:BEGIN }}
class CustomObjectBuilder
	@Instance: ->
		unless @@_instance
			@@_instance = CustomObjectBuilder!

		return @@_instance

	new: =>
		@_customObjects = {}

		@\Build "SpriteSheet", SpriteSheet

		if game
			for moduleScript in *game\GetService("ServerScriptService").com.blacksheepherd.customobject.user\GetChildren!
				@\Build moduleScript.name, require(moduleScript)

	Build: (name, t) =>
		objectTable = {}
		objectTable.FilterProperty = t.FilterProperty or (name, value, LiteralString, CompilerPropertyFilter) ->
			return LiteralString(value)

		objectTable.customObject = class extends CustomObject
			new: (romlDoc, objectId, classes) =>
				@@__name = name
				@CreateProperties = t.CreateProperties if t.CreateProperties
				@AllowsChildren = t.AllowsChildren if t.AllowsChildren
				@PropertyUpdateOrder = t.PropertyUpdateOrder if t.PropertyUpdateOrder
				super(romlDoc, objectId, classes)

			Create: t.Create

			UpdateProperty: t.UpdateProperty

		@_customObjects[name] = objectTable

	HasObject: (name) =>
		@_customObjects[name] != nil

	GetObject: (name) =>
		@_customObjects[name].customObject

	FilterProperty: (objectName, propertyName, value, LiteralString, CompilerPropertyFilter) =>
		@_customObjects[objectName].FilterProperty(propertyName, value, LiteralString, CompilerPropertyFilter)

----------------------------------------------------------------
-- @tparam string name The name of the @{CustomObject}.
-- @treturn bool Whether or not the object name is a
--  @{CustomObject}.
----------------------------------------------------------------
IsACustomObject = (name) ->
	CustomObjectBuilder.Instance!\HasObject(name)

----------------------------------------------------------------
-- Creates a @{CustomObject}.
--
-- @tparam string name The name of the @{CustomObject}.
-- @tparam RomlDoc romlDoc The @{RomlDoc} object that this
--  @{CustomObject} will be a part of.
-- @tparam string objectId The ID of the object, or nil if there
--  is none.
-- @tparam array classes An array of strings for the classes, or
--  nil if there are none.
-- @treturn CustomObject The created @{CustomObject}.
----------------------------------------------------------------
CreateObject = (name, romlDoc, objectId, classes) ->
	CustomObjectBuilder.Instance!\GetObject(name)(romlDoc, objectId, classes)

----------------------------------------------------------------
-- Filter a property based on the @{CustomObject}'s rules.
--
-- @tparam string objectName The name of the @{CustomObject}.
-- @tparam string propertyName The name of the property to
--  filter.
-- @tparam string value The input string.
-- @tparam table LiteralString The @{LiteralString} class.
-- @tparam table CompilerPropertyFilter The
--  @{CompilerPropertyFilter} class.
-- @treturn LiteralString The filtered property value.
----------------------------------------------------------------
FilterProperty = (objectName, propertyName, value, LiteralString, CompilerPropertyFilter) ->
	CustomObjectBuilder.Instance!\FilterProperty(objectName, propertyName, value, LiteralString, CompilerPropertyFilter)
-- {{ TBSHTEMPLATE:END }}

{ :CreateObject, :FilterProperty, :IsACustomObject }
