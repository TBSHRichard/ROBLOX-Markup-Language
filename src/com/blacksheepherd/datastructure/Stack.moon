----------------------------------------------------------------
-- A standard Stack data structure.
--
-- @classmod Stack
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

-- {{ TBSHTEMPLATE:BEGIN }}
class Stack
	----------------------------------------------------------------
	-- Create a new Stack.
	--
	-- @tparam Stack self
	-- @tparam[opt={}] table stack The initial stack. The end of
	--  the table is assumed to be the top of the stack.
	----------------------------------------------------------------
	new: (stack = {}) =>
		for el in *stack
			table.insert self, 1, el

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

	----------------------------------------------------------------
	-- Performs a shallow clone (new Stack is created, but
	-- individual elements of the Stack are the same) of this Stack.
	--
	-- @tparam Stack self
	-- @treturn Stack The cloned Stack.
	----------------------------------------------------------------
	Clone: =>
		return Stack(self)
-- {{ TBSHTEMPLATE:END }}

return Stack
