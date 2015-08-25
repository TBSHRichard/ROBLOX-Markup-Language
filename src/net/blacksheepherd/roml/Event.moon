----------------------------------------------------------------
-- The Event class, with the EventConnection class, is used
-- to mimic the structure of ROBLOX's Events. It follows the
-- observer pattern and can be used to send a variable number
-- of arguments to observing functions. For an example of
-- using an Event Property in a class, see @{event.moon}.
--
-- @classmod Event
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

class EventConnection
	new: (id, observer, event) =>
		@_id = id
		@_observer = observer
		@_event = event
	
	notify: (...) =>
		@\_observer ...
	
	disonnect: =>
		@_event\removeObserver @_id

class Event
	----------------------------------------------------------------
	-- Create a new Event.
	--
	-- @tparam Event self
	----------------------------------------------------------------
	new: =>
		@_observers = { }
		@_nextId = 1
	
	----------------------------------------------------------------
	-- Add an observer to wait for a notification. An
	-- EventConnection is returned so that the observer can be
	-- removed later if desired.
	--
	-- @tparam Event self
	-- @tparam function observer A function which will be called
	--	when all observers are notified of an event.
	-- @treturn EventConnection An EventConnection class with
	--	the callback function.
	----------------------------------------------------------------
	connect: (observer) =>
		connection = EventConnection @_nextId, observer, @
		@_observers[tostring(@_nextId)] = connection
		@_nextId += 1
		return connection
	
	----------------------------------------------------------------
	-- Notifies all connected observers and calls their callback
	-- functions.
	--
	-- @tparam Event self
	-- @param ... The arguments to pass to the observer.
	----------------------------------------------------------------
	notifyObservers: (...) =>
		for _, observer in pairs @_observers
			observer\notify ...
	
	----------------------------------------------------------------
	-- Remove an observer from this Event so it's callback won't be
	-- called anymore.
	--
	-- @tparam Event self
	-- @tparam int id The Id for the observer.
	----------------------------------------------------------------
	removeObserver: (id) =>
		@_observers[tostring(@_nextId)] = nil

return Event
