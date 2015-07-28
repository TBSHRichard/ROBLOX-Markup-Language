local Table = require("com.sheepofice.util.Table")
local MainBlock = require("com.sheepofice.roml.code.MainBlock")
local Line = require("com.sheepofice.roml.code.Line")
local CompilerPropertyFilter = require("com.sheepofice.roml.compile.CompilerPropertyFilter")
local addCode = nil
local addCodeFunctions = nil
addCodeFunctions = {
  object = function(mainBlock, obj)
    local _, className, id, classes, properties, children = unpack(obj)
    local buildLine = "builder:Build(\"" .. tostring(className) .. "\", " .. tostring(Table.ArrayToSingleLineString(classes)) .. ")"
    if id or properties then
      buildLine = "objTemp = " .. tostring(buildLine)
    end
    mainBlock:AddChild(Line(buildLine))
    if id then
      mainBlock:AddChild(Line(""))
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
