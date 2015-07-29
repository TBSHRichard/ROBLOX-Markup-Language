local Table = require("com.sheepofice.util.Table")
local MainBlock = require("com.sheepofice.roml.code.MainBlock")
local SpaceBlock = require("com.sheepofice.roml.code.SpaceBlock")
local FunctionBlock = require("com.sheepofice.roml.code.FunctionBlock")
local Line = require("com.sheepofice.roml.code.Line")
local VariableNamer = require("com.sheepofice.roml.compile.VariableNamer")
local CompilerPropertyFilter = require("com.sheepofice.roml.compile.CompilerPropertyFilter")
local addCode = nil
local addCodeFunctions = nil
local writeObjectToBlock
writeObjectToBlock = function(mainBlock, varBlock, updateFnBlock, updateCallBlock, builderParam, className, id, classes, properties, children)
  local classesString = "nil"
  local objectName = nil
  if classes and classes[1] == "static" then
    classesString = Table.ArrayToSingleLineString(classes[2])
  elseif classes and classes[1] == "dynamic" then
    objectName = VariableNamer.NameObjectVariable(className)
    varBlock:AddChild(Line("local " .. tostring(objectName)))
    varBlock:AddChild(Line("local varChange_" .. tostring(classes[2])))
    local varChange = FunctionBlock("varChange_" .. tostring(classes[2]), "")
    varChange:AddChild(Line(tostring(objectName) .. ":SetClasses(self._vars." .. tostring(classes[2]) .. ":GetValue())"))
    updateFnBlock:AddChild(varChange)
    mainBlock:AddChild(Line("self._vars." .. tostring(classes[2]) .. " = RomlVar(vars." .. tostring(classes[2]) .. ")"))
    mainBlock:AddChild(Line("self._vars." .. tostring(classes[2]) .. ".Changed:connect(varChange_" .. tostring(classes[2]) .. ")"))
    updateCallBlock:AddChild(Line("varChange_" .. tostring(classes[2]) .. "()"))
  end
  if id or properties and not objectName then
    objectName = "objTemp"
  end
  local buildLine = "builder:Build(" .. tostring(builderParam) .. ", " .. tostring(classesString) .. ")"
  if objectName then
    buildLine = tostring(objectName) .. " = " .. tostring(buildLine)
  end
  mainBlock:AddChild(Line(buildLine))
  if id then
    mainBlock:AddChild(Line("self._objectIds[\"" .. tostring(id) .. "\"] = " .. tostring(objectName)))
  end
  if properties then
    for name, value in properties:pairs() do
      properties[name] = CompilerPropertyFilter.FilterProperty(className, name, value)
    end
    mainBlock:AddChild(Line(tostring(objectName) .. ":SetProperties(" .. tostring(Table.HashMapToSingleLineString(properties)) .. ")"))
  end
  addCode(mainBlock, varBlock, updateFnBlock, updateCallBlock, children)
  return mainBlock:AddChild(Line("builder:Pop()"))
end
addCodeFunctions = {
  object = function(mainBlock, varBlock, updateFnBlock, updateCallBlock, obj)
    local _, className, id, classes, properties, children = unpack(obj)
    return writeObjectToBlock(mainBlock, varBlock, updateFnBlock, updateCallBlock, "\"" .. tostring(className) .. "\"", className, id, classes, properties, children)
  end,
  clone = function(mainBlock, varBlock, updateFnBlock, updateCallBlock, obj)
    local _, className, robloxObject, id, classes, properties, children = unpack(obj)
    return writeObjectToBlock(mainBlock, varBlock, updateFnBlock, updateCallBlock, robloxObject, className, id, classes, properties, children)
  end
}
addCode = function(mainBlock, varBlock, updateFnBlock, updateCallBlock, tree)
  if tree then
    for _, obj in ipairs(tree) do
      addCodeFunctions[obj[1]](mainBlock, varBlock, updateFnBlock, updateCallBlock, obj)
    end
  end
end
local Compile
Compile = function(name, parsetree)
  local mainBlock = MainBlock(name)
  local varBlock = SpaceBlock()
  local updateFnBlock = SpaceBlock()
  local updateCallBlock = SpaceBlock()
  mainBlock:AddChild(varBlock)
  mainBlock:AddChild(updateFnBlock)
  addCode(mainBlock, varBlock, updateFnBlock, updateCallBlock, parsetree)
  mainBlock:AddChild(updateCallBlock)
  return mainBlock:Render()
end
return {
  Compile = Compile
}
