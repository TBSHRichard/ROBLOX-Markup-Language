local Table = require("com.sheepofice.util.Table")
local MainBlock = require("com.sheepofice.roml.code.MainBlock")
local Line = require("com.sheepofice.roml.code.Line")
local addCode = nil
local addCodeFunctions = nil
addCodeFunctions = {
  object = function(mainBlock, obj)
    local _, className, id, classes, properties, children = unpack(obj)
    mainBlock:AddChild(Line("builder:Build(\"" .. tostring(className) .. "\", " .. tostring(Table.ArrayToSingleLineString(classes)) .. ")"))
    if id then
      mainBlock:AddChild(Line(""))
    end
    if properties then
      mainBlock:AddChild(Line(""))
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
