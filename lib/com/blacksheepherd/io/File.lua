local FileToString
FileToString = function(path)
  local file = io.open(path)
  local s = file:read("*all")
  file:close()
  return s
end
return {
  FileToString = FileToString
}
