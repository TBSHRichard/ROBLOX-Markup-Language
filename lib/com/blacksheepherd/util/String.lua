local StringNTimes
StringNTimes = function(s, n)
  local buffer = ""
  for i = 1, n do
    buffer = buffer .. s
  end
  return buffer
end
return {
  StringNTimes = StringNTimes
}
