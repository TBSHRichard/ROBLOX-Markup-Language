----------------------------------------------------------------
-- Example showing the creation of an Event object in a
-- MoonScript class and the connection and disconnection of an
-- Event observer. Look at @{Event} for more info.
--
-- @author Richard Voelker
----------------------------------------------------------------

Event = require "Event"

class Foo
	new: =>
		@Changed = Event!
	
	-- Notify our observers!
	Change: =>
		@Changed\notifyObservers "bar"
	
	-- Our Event Property. It is set in the constructor.
	Changed: nil

f = Foo!
observer = f.Changed:connect (b) ->
	print b

f.Change! -- Prints "bar".

observer:disconnect!

f.Change! -- Does nothing; no observers to notify.
