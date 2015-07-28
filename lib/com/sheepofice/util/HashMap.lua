local HashMap
do
  local _base_0 = {
    pairs = function(self)
      return pairs(self._t)
    end,
    Length = function(self)
      return self:__len()
    end,
    __newindex = function(self, key, value)
      if self._t[key] == nil then
        self._length = self._length + 1
      elseif value == nil then
        self._length = self._length - 1
      end
      self._t[key] = value
    end,
    __len = function(self)
      return self._length
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, t)
      rawset(self, "_t", { })
      rawset(self, "_length", 0)
      for key, value in pairs(t) do
        self[key] = value
      end
      local mt = getmetatable(self)
      local old_index = mt.__index
      mt.__index = function(self, key)
        do
          local value = rawget(rawget(self, "_t"), key)
          if value then
            return value
          else
            if type(old_index) == "function" then
              return old_index(self, key)
            else
              return old_index[key]
            end
          end
        end
      end
    end,
    __base = _base_0,
    __name = "HashMap"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  HashMap = _class_0
end
return HashMap
