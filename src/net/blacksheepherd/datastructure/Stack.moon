----------------------------------------------------------------
-- A standard Stack data structure.
--
-- @classmod Stack
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

class Stack
	----------------------------------------------------------------
	-- Push an element onto the top of the Stack.
	--
	-- @tparam Stack self
	-- @param el The element to add.
	----------------------------------------------------------------
	Push: (el) =>
		table.insert self, el

	----------------------------------------------------------------
	-- Remove an element from the top of the Stack.
	--
	-- @tparam Stack self
	-- @return The top element of the Stack, or nil if the Stack is
	--	empty.
	----------------------------------------------------------------
	Pop: =>
		table.remove self

	----------------------------------------------------------------
	-- Returns the top element from the Stack without removing it.
	--
	-- @tparam Stack self
	-- @return The top element of the Stack, or nil if the Stack is
	--	empty.
	----------------------------------------------------------------
	Peek: =>
		self[#self]

	----------------------------------------------------------------
	-- Returns whether or not the Stack is empty (length of the
	-- Stack is 0).
	--
	-- @tparam Stack self
	-- @treturn bool True if the Stack is empty, false otherwise.
	----------------------------------------------------------------
	IsEmpty: =>
		#self == 0

return Stack