local ArrayToSingleLineString
ArrayToSingleLineString = function(array)
  if not (array == nil) then
    local buffer = "{"
    for i, el in ipairs(array) do
      if type(el) == "table" then
        buffer = buffer .. ArrayToSingleLineString(el)
      elseif type(el) == "string" then
        buffer = buffer .. "\"" .. tostring(el) .. "\""
      else
        buffer = buffer .. tostring(el)
      end
    end
    return buffer .. "}"
  else
    return "nil"
  end
end
return {
  ArrayToSingleLineString = ArrayToSingleLineString
}
