local EventConnection
do
  local _base_0 = {
    notify = function(self, ...)
      return self:_observer(...)
    end,
    disonnect = function(self)
      return self._event:removeObserver(self._id)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, id, observer, event)
      self._id = id
      self._observer = observer
      self._event = event
    end,
    __base = _base_0,
    __name = "EventConnection"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EventConnection = _class_0
end
local Event
do
  local _base_0 = {
    connect = function(self, observer)
      local connection = EventConnection(self._nextId, observer, self)
      self._observers[tostring(self._nextId)] = connection
      self._nextId = self._nextId + 1
      return connection
    end,
    notifyObservers = function(self, ...)
      for _, observer in pairs(self._observers) do
        observer:notify(...)
      end
    end,
    removeObserver = function(self, id)
      self._observers[tostring(self._nextId)] = nil
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self._observers = { }
      self._nextId = 1
    end,
    __base = _base_0,
    __name = "Event"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Event = _class_0
end
return Event
