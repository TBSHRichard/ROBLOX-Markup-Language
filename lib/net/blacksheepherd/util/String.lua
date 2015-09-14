local StringNTimes
StringNTimes = function(string, n)
  local buffer = ""
  for i = 1, n do
    buffer = buffer .. string
  end
  return buffer
end
return {
  StringNTimes = StringNTimes
}
