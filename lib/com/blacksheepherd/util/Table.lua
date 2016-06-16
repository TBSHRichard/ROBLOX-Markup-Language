local HashMap = require("com.blacksheepherd.util.HashMap")
local String = require("com.blacksheepherd.util.String")
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
local HashMapToMultiLineString
HashMapToMultiLineString = function(map, depth)
  if depth == nil then
    depth = 0
  end
  if not (map == nil) then
    local buffer = "{\n"
    local i = 0
    for key, el in map:pairs() do
      i = i + 1
      buffer = buffer .. String.StringNTimes("\t", depth + 1)
      buffer = buffer .. tostring(key) .. " = "
      if type(el) == "table" and not getmetatable(el) then
        buffer = buffer .. HashMapToMultiLineString(HashMap(el), depth + 1)
      elseif type(el) == "table" and getmetatable(el) and el.__class.__name == "HashMap" then
        buffer = buffer .. HashMapToMultiLineString(el, depth + 1)
      elseif type(el) == "string" then
        buffer = buffer .. "\"" .. tostring(el) .. "\""
      else
        buffer = buffer .. tostring(el)
      end
      if not (i == map:Length()) then
        buffer = buffer .. ","
      end
      buffer = buffer .. "\n"
    end
    return buffer .. String.StringNTimes("\t", depth) .. "}"
  else
    return "nil"
  end
end
local TablesAreEqual
TablesAreEqual = function(tableOne, tableTwo)
  if type(tableOne) ~= "table" or type(tableTwo) ~= "table" then
    return false
  end
  local equal = true
  for key, value in pairs(tableOne) do
    if type(value) ~= "table" then
      equal = value == tableTwo[key]
    else
      equal = TablesAreEqual(value, tableTwo[key])
    end
    if not equal then
      return false
    end
  end
  for key, value in pairs(tableTwo) do
    if type(value) ~= "table" then
      equal = tableOne[key] == value
    else
      equal = TablesAreEqual(tableOne[key], value)
    end
    if not equal then
      return false
    end
  end
  return true
end
local Swap
Swap = function(t, i1, i2)
  local temp = t[i1]
  t[i1] = t[i2]
  t[i2] = temp
end
return {
  ArrayToSingleLineString = ArrayToSingleLineString,
  HashMapToSingleLineString = HashMapToSingleLineString,
  HashMapToMultiLineString = HashMapToMultiLineString,
  TablesAreEqual = TablesAreEqual,
  Swap = Swap
}
