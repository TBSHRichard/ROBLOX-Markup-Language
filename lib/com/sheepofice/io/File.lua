local FileToString
FileToString = function(path)
  local file = io.open(path)
  local s = {
    file = read("*all")
  }
  local _ = {
    file = close()
  }
  return s
end
return {
  FileToString = FileToString
}
