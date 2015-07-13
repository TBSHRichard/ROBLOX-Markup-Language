----------------------------------------------------------------
-- A RoML variable which holds a table.
--
-- @classmod TableRomlVar
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Event = require "Event"

class TableRomlVar
	----------------------------------------------------------------
	-- Create a table variable with the specified starting table.
	--
	-- @tparam TableRomlVar self
	-- @tparam[opt={}] table t The starting table.
	----------------------------------------------------------------
	new: (t = {}) =>
		@_table = t
		@Changed = Event!
	
	----------------------------------------------------------------
	-- Set the value for a key. The key can be anything except for
	-- the strings @{Changed}, and _table (a private member used to
	-- store the actual table values). All observers of the
	-- @{Changed} @{Event} are notified when this method is called.
	-- 
	-- @tparam TableRomlVar self
	-- @param key The key to associate the table value with.
	-- @param value The value to place in the table.
	----------------------------------------------------------------
	__newindex: (key, value) =>
		oldValue = @_table[key]
		@_table[key] = value
		@Changed\notifyObservers key, oldValue, value
	
	----------------------------------------------------------------
	-- The Changed @{Event}. Observers of this @{Event} are notified
	-- whenever the @{__newindex} metamethod is called. Observing
	-- functions are passed three arguments, the table key, the old
	-- value, and the new value.
	--
	-- @event Changed
	----------------------------------------------------------------
	Changed: nil

return TableRomlVar
