CustomObject = require "com.blacksheepherd.roml.CustomObject"
LiteralString = require "com.blacksheepherd.compile.LiteralString"
CompilerPropertyFilter = require "com.blacksheepherd.compile.CompilerPropertyFilter"

class CustomObjectBuilder
	@Instance: ->
		unless @@_instance
			@@_instance = CustomObjectBuilder!

		return @@_instance

	new: =>
		@_customObjects = {}

		@\Build "SpriteSheet", require("com.blacksheepherd.customobject.SpriteSheet")

	Build: (name, t) =>
		unless @\HasObject(name)
			objectTable = {}
			objectTable.FilterProperty = t.FilterProperty or (name, value) ->
				return LiteralString(value)

			objectTable.customObject = CustomObject!
			objectTable.customObject.Create = t.Create
			objectTable.customObject.SetProperty = t.SetProperty
			objectTable.customObject.AllowsChildren = t.AllowsChildren if t.AllowsChildren
			objectTable.customObject.__class.__name = name

			@_customObjects[name] = objectTable

	HasObject: (name) =>
		@_customObjects[name] != nil

	GetObject: (name) =>
		@_customObjects[name].customObject

	FilterProperty: (objectName, propertyName, value) =>
		@_customObjects[objectName].FilterProperty(propertyName, value, LiteralString, CompilerPropertyFilter)

IsACustomObject = (name) ->
	CustomObjectBuilder.Instance!\HasObject(name)

CreateObject = (name, romlDoc, objectId, classes) ->
	CustomObjectBuilder.Instance!\GetObject(name)(romlDoc, objectId, classes)

FilterProperty = (objectName, propertyName, value) ->
	CustomObjectBuilder.Instance!\FilterProperty(objectName, propertyName, value)

{ :CreateObject, :CustomObjectBuilder, :FilterProperty, :IsACustomObject }