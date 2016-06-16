class RossDoc
	new: =>
		@_objects = @\_setupObjects!
		@_classes = @\_setupClasses!
		@_ids = @\_setupIds!

	StyleObject: (romlObject) =>
		objectName = romlObject\GetRobloxObject!.ClassName
		@\_styleWithTable(romlObject, @_objects[objectName])

		for c in *romlObject\GetClasses!
			@\_styleWithTable(romlObject, @_classes[".#{c}"])
			@\_styleWithTable(romlObject, @_classes["#{objectName}.#{c}"])

		objectId = romlObject\GetObjectId!
		unless objectId == nil
			@\_styleWithTable(romlObject, @_ids["##{objectId}"])
			@\_styleWithTable(romlObject, @_ids["#{objectName}##{objectId}"])

	_styleWithTable: (romlObject, t = {}) =>
		for el in *t
			if romlObject\MatchesSelector(el.selector\Clone!)
				romlObject\StyleObject(el.properties)

	_setupObjects: =>
		{}

	_setupClasses: =>
		{}

	_setupIds: =>
		{}
