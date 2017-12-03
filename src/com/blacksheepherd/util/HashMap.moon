----------------------------------------------------------------
-- A structure for storing a simple key-value table but it also
-- keeps track of how many pairs are in the table.
--
-- @classmod HashMap
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

-- {{ TBSHTEMPLATE:BEGIN }}
class HashMap
	----------------------------------------------------------------
	-- Create the HashMap. Values are stored and retrieved as if
	-- this were a normal table.
	--
	-- @tparam HashMap self
	-- @tparam table t The starting values for the HashMap.
	----------------------------------------------------------------
	new: (t) =>
		rawset @, "_t", {}
		rawset @, "_length", 0

		for key, value in pairs t
			@[key] = value

		mt = getmetatable @
		old_index = mt.__index

		mt.__index = (key) =>
			if value = rawget rawget(@, "_t"), key
				return value
			else
				if type(old_index) == "function"
					return old_index @, key
				else
					return old_index[key]

	----------------------------------------------------------------
	-- @treturn iterator The pairs iterator over the table.
	----------------------------------------------------------------
	pairs: => pairs @_t

	----------------------------------------------------------------
	-- Alias for the __len metamethod. Since the __len metamethod is
	-- not supported in Lua 5.1 (the current version on ROBLOX),
	-- this can be used instead.
	--
	-- @treturn integer The number of key-value pairs in the table.
	----------------------------------------------------------------
	Length: => @\__len!

	__newindex: (key, value) =>
		if @_t[key] == nil
			@_length += 1
		elseif value == nil
			@_length -= 1

		@_t[key] = value

	__len: => @_length
-- {{ TBSHTEMPLATE:END }}

return HashMap
