----------------------------------------------------------------
-- A RoML variable that holds a generic data type value (string,
-- number, boolean).
--
-- @classmod GenericRomlVar
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

Event = require "Event"

class GenericRomlVar
	----------------------------------------------------------------
	-- Create a new GenericRomlVar with the specified value.
	--
	-- @tparam GenericRomlVar self
	-- @tparam generic value The value to set to.
	----------------------------------------------------------------
	new: (value) =>
		@_value = value
		@Changed = Event!
	
	----------------------------------------------------------------
	-- Set the value for this object. It must be another generic
	-- data type and cannot be a table. All observers of the
	-- @{Changed} @{Event} are notified.
	--
	-- @tparam GenericRomlVar self
	-- @tparam generic value The value to set to.
	----------------------------------------------------------------
	Set: (value) =>
		unless type(value) == "table"
			oldValue = @_value
			@_value = value
			@Change\notifyObservers oldValue, value
	
	----------------------------------------------------------------
	-- The Changed @{Event}. Observers of this @{Event} are notified
	-- whenever the @{Set} method is called. Observing functions are
	-- passed two arguments, the old value and the new value.
	--
	-- @event Changed
	----------------------------------------------------------------
	Changed: nil -- Set during constructor
