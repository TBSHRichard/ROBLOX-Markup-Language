----------------------------------------------------------------
-- A RoML variable that holds a generic data type value (string,
-- number, boolean).
--
-- @classmod RomlVar
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Event = require game\GetService("ServerScriptService").com.sheepofice.roml.Event

class RomlVar
	----------------------------------------------------------------
	-- Create a new RomlVar with the specified value.
	--
	-- @tparam RomlVar self
	-- @tparam[opt] generic value The value to set to.
	----------------------------------------------------------------
	new: (value) =>
		rawset @, "_value", value
		rawset @, "Changed", Event!
	
	----------------------------------------------------------------
	-- Set the value for this object. All observers of the
	-- @{Changed} @{Event} are notified.
	--
	-- @tparam RomlVar self
	-- @tparam generic value The value to set to.
	----------------------------------------------------------------
	SetValue: (value) =>
		oldValue = @_value
		rawset @, "_value", value
		@Changed\notifyObservers oldValue, value
	
	----------------------------------------------------------------
	-- @tparam RomlVar self
	-- @return The current value of the variable.
	----------------------------------------------------------------
	GetValue: => @_value
	
	----------------------------------------------------------------
	-- Set the value for a table key, if our variable is a ROBLOX
	-- object or Lua table. All observers of the @{Changed} @{Event}
	-- are notified if there is 
	-- 
	-- @tparam RomlVar self
	-- @param key The key to associate the table value with.
	-- @param value The value to place in the table.
	----------------------------------------------------------------
	__newindex: (key, value) =>
		if type(@_value) == "table" or type(@_value) == "userdata" and @_value.ClassName
			oldValue = @_value[key]
			@_value[key] = value
			@Changed\notifyObservers key, oldValue, value
	
	----------------------------------------------------------------
	-- The Changed @{Event}. Observers of this @{Event} are notified
	-- whenever the @{SetValue} method is called. Observing functions
	-- are passed two arguments, the old value and the new value.
	--
	-- @event Changed
	----------------------------------------------------------------
	Changed: nil -- Set during constructor
