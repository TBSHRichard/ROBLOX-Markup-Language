class IdElement
	new: (id, element) =>
		@_id = id
		@_element = element

	Id: => @_id

	Element: => @_element

	__eq: (rhs) =>
		@_id == rhs\Id! and @_element == rhs\Element!

	__tostring: =>
		"IdElement<Id: #{@_id};   Element: #{@_element}>"