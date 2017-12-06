----------------------------------------------------------------
-- Variable naming for ROBLOX objects.
--
-- @classmod VariableNamer
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

-- {{ TBSHTEMPLATE:BEGIN }}
class VariableNamer
	new: =>
		@_nameCount = {}

	----------------------------------------------------------------
	-- Get the next name for a ROBLOX object variable. The name is
	-- in the following form: var(Object ClassName)(Unique ID).
	--
	-- @tparam VariableNamer self
	-- @tparam string className The ClassName of the ROBLOX object.
	-- @treturn string The name for the object variable.
	----------------------------------------------------------------
	NameObjectVariable: (className) =>
		if @_nameCount[className]
			@_nameCount[className] += 1
		else
			@_nameCount[className] = 1

		return "obj#{className}#{@_nameCount[className]}"
-- {{ TBSHTEMPLATE:END }}

return VariableNamer
