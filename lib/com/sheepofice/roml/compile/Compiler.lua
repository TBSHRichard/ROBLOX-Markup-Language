local Table = require("com.sheepofice.util.Table")
local MainBlock = require("com.sheepofice.roml.code.MainBlock")
local Line = require("com.sheepofice.roml.code.Line")
local CompilerPropertyFilter = require("com.sheepofice.roml.compile.CompilerPropertyFilter")
local addCode = nil
local addCodeFunctions = nil
local writeObjectToBlock
writeObjectToBlock = function(mainBlock, builderParam, className, id, classes, properties, children)
  local classesString = "nil"
  if classes then
    if classes[1] == "static" then
      classesString = Table.ArrayToSingleLineString(classes[2])
    end
  end
  local buildLine = "builder:Build(" .. tostring(builderParam) .. ", " .. tostring(classesString) .. ")"
  if id or properties then
    buildLine = "objTemp = " .. tostring(buildLine)
  end
  mainBlock:AddChild(Line(buildLine))
  if id then
    mainBlock:AddChild(Line("self._objectIds[\"" .. tostring(id) .. "\"] = objTemp"))
  end
  if properties then
    for name, value in properties:pairs() do
      properties[name] = CompilerPropertyFilter.FilterProperty(className, name, value)
    end
    mainBlock:AddChild(Line("objTemp:SetProperties(" .. tostring(Table.HashMapToSingleLineString(properties)) .. ")"))
  end
  addCode(mainBlock, children)
  return mainBlock:AddChild(Line("builder:Pop()"))
end
addCodeFunctions = {
  object = function(mainBlock, obj)
    local _, className, id, classes, properties, children = unpack(obj)
    return writeObjectToBlock(mainBlock, "\"" .. tostring(className) .. "\"", className, id, classes, properties, children)
  end,
  clone = function(mainBlock, obj)
    local _, className, robloxObject, id, classes, properties, children = unpack(obj)
    return writeObjectToBlock(mainBlock, robloxObject, className, id, classes, properties, children)
  end
}
addCode = function(mainBlock, tree)
  if tree then
    for _, obj in ipairs(tree) do
      addCodeFunctions[obj[1]](mainBlock, obj)
    end
  end
end
local Compile
Compile = function(name, parsetree)
  local mainBlock = MainBlock(name)
  addCode(mainBlock, parsetree)
  return mainBlock:Render()
end
return {
  Compile = Compile
}
