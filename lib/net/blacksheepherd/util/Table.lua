local HashMap = require("net.blacksheepherd.util.HashMap")
local ArrayToSingleLineString
ArrayToSingleLineString = function(array)
  if not (array == nil) then
    local buffer = "{"
    for i, el in ipairs(array) do
      if type(el) == "table" and not getmetatable(el) then
        buffer = buffer .. ArrayToSingleLineString(el)
      elseif type(el) == "string" then
        buffer = buffer .. "\"" .. tostring(el) .. "\""
      else
        buffer = buffer .. tostring(el)
      end
      if not (i == #array) then
        buffer = buffer .. ", "
      end
    end
    return buffer .. "}"
  else
    return "nil"
  end
end
local HashMapToSingleLineString
HashMapToSingleLineString = function(map)
  if not (map == nil) then
    local buffer = "{"
    local i = 0
    for key, el in map:pairs() do
      i = i + 1
      buffer = buffer .. tostring(key) .. " = "
      if type(el) == "table" and not getmetatable(el) then
        buffer = buffer .. HashMapToSingleLineString(HashMap(el))
      elseif type(el) == "string" then
        buffer = buffer .. "\"" .. tostring(el) .. "\""
      else
        buffer = buffer .. tostring(el)
      end
      if not (i == map:Length()) then
        buffer = buffer .. ", "
      end
    end
    return buffer .. "}"
  else
    return "nil"
  end
end
return {
  ArrayToSingleLineString = ArrayToSingleLineString,
  HashMapToSingleLineString = HashMapToSingleLineString
}
