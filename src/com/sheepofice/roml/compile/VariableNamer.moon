----------------------------------------------------------------
-- Module for variable naming for ROBLOX objects.
--
-- @module NameObjectVariable
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

nameCount = {}

----------------------------------------------------------------
-- Get the next name for a ROBLOX object variable. The name is
-- in the following form: var(Object ClassName)(Unique ID).
--
-- @tparam string className The ClassName of the ROBLOX object.
-- @treturn string The name for the object variable.
----------------------------------------------------------------
NameObjectVariable = (className) ->
	if nameCount[className]
		nameCount[className] += 1
	else
		nameCount[className] = 1

	return "obj#{className}#{nameCount[className]}"

{ :NameObjectVariable }