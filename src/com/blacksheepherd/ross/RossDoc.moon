----------------------------------------------------------------
-- The base class for RoSS object creation. All compiled RoSS
-- files will be compiled into a Lua class with this class as
-- its base.
--
-- @classmod RossDoc
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

-- {{ TBSHTEMPLATE:BEGIN }}
class RossDoc
	----------------------------------------------------------------
	-- Create a new RossDoc.
	--
	-- @tparam RossDoc self
	----------------------------------------------------------------
	new: =>
		@_objects = @\_setupObjects!
		@_classes = @\_setupClasses!
		@_ids = @\_setupIds!

	----------------------------------------------------------------
	-- Styles a @{RomlObject} based on the rules within this
	-- @{RossDoc}.
	--
	-- @tparam RossDoc self
	-- @tparam RomlObject romlObject The @{RomlObject} to style.
	----------------------------------------------------------------
	StyleObject: (romlObject) =>
		objectName = romlObject\ObjectName!
		@\_styleWithTable(romlObject, @_objects[objectName])

		for c in *romlObject\GetClasses!
			@\_styleWithTable(romlObject, @_classes[".#{c}"])
			@\_styleWithTable(romlObject, @_classes["#{objectName}.#{c}"])

		objectId = romlObject\GetObjectId!
		unless objectId == nil
			@\_styleWithTable(romlObject, @_ids["##{objectId}"])
			@\_styleWithTable(romlObject, @_ids["#{objectName}##{objectId}"])

		romlObject\Refresh!

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
-- {{ TBSHTEMPLATE:END }}

return RossDoc
