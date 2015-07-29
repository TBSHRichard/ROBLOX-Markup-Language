nameCount = {}

NameObjectVariable = (className) ->
	if nameCount[className]
		nameCount[className] += 1
	else
		nameCount[className] = 1

	return "obj#{className}#{nameCount[className]}"

{ :NameObjectVariable }