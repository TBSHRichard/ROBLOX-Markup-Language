local nameCount = { }
local NameObjectVariable
NameObjectVariable = function(className)
  if nameCount[className] then
    nameCount[className] = nameCount[className] + 1
  else
    nameCount[className] = 1
  end
  return "obj" .. tostring(className) .. tostring(nameCount[className])
end
return {
  NameObjectVariable = NameObjectVariable
}
