local Table = require("net.blacksheepherd.util.Table")
local MainBlock = require("net.blacksheepherd.roml.code.MainBlock")
local SpaceBlock = require("net.blacksheepherd.roml.code.SpaceBlock")
local FunctionBlock = require("net.blacksheepherd.roml.code.FunctionBlock")
local Line = require("net.blacksheepherd.roml.code.Line")
local VariableNamer = require("net.blacksheepherd.roml.compile.VariableNamer")
local CompilerPropertyFilter = require("net.blacksheepherd.roml.compile.CompilerPropertyFilter")
local addCode = nil
local addCodeFunctions = nil
local writeVarCode
writeVarCode = function(mainBlock, functionTable, varNamer, className, varName, changeFunction)
  if not (functionTable[varName]) then
    functionTable[varName] = FunctionBlock("varChange_" .. tostring(varName), "")
  end
  local objectName = varNamer:NameObjectVariable(className)
  mainBlock:AddChild(MainBlock.BLOCK_VARS, Line("local " .. tostring(objectName)))
  mainBlock:AddChild(MainBlock.BLOCK_VARS, Line("local varChange_" .. tostring(varName)))
  local varChange = functionTable[varName]
  changeFunction(varChange, objectName, varName)
  mainBlock:AddChild(MainBlock.BLOCK_UPDATE_FUNCTIONS, varChange)
  mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("self._vars." .. tostring(varName) .. " = RomlVar(vars." .. tostring(varName) .. ")"))
  mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("self._vars." .. tostring(varName) .. ".Changed:connect(varChange_" .. tostring(varName) .. ")"))
  mainBlock:AddChild(MainBlock.BLOCK_FUNCTION_CALLS, Line("varChange_" .. tostring(varName) .. "()"))
  return objectName
end
local writeObjectToBlock
writeObjectToBlock = function(mainBlock, functionTable, varNamer, builderParam, className, id, classes, properties, children)
  local classesString = "nil"
  local objectName = nil
  if classes and classes[1] == "static" then
    classesString = Table.ArrayToSingleLineString(classes[2])
  elseif classes and classes[1] == "dynamic" then
    objectName = writeVarCode(mainBlock, functionTable, varNamer, className, classes[2], function(varChange, objectName, varName)
      return varChange:AddChild(Line(tostring(objectName) .. ":SetClasses(self._vars." .. tostring(varName) .. ":GetValue())"))
    end)
  end
  if properties then
    for name, value in properties:pairs() do
      if type(value) == "string" then
        properties[name] = CompilerPropertyFilter.FilterProperty(className, name, value)
      else
        objectName = writeVarCode(mainBlock, functionTable, varNamer, className, value[2], function(varChange, objectName, varName)
          return varChange:AddChild(Line(tostring(objectName) .. ":SetProperties({" .. tostring(name) .. " = self._vars." .. tostring(varName) .. ":GetValue()})"))
        end)
        properties[name] = nil
      end
    end
  end
  if (id or properties) and not objectName then
    objectName = "objTemp"
  end
  local buildLine = "builder:Build(" .. tostring(builderParam) .. ", " .. tostring(classesString) .. ")"
  if objectName then
    buildLine = tostring(objectName) .. " = " .. tostring(buildLine)
  end
  mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line(buildLine))
  if id then
    mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("self._objectIds[\"" .. tostring(id) .. "\"] = " .. tostring(objectName)))
  end
  if properties then
    mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line(tostring(objectName) .. ":SetProperties(" .. tostring(Table.HashMapToSingleLineString(properties)) .. ")"))
  end
  addCode(mainBlock, children)
  return mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("builder:Pop()"))
end
addCodeFunctions = {
  object = function(mainBlock, functionTable, varNamer, obj)
    local _, className, id, classes, properties, children = unpack(obj)
    return writeObjectToBlock(mainBlock, functionTable, varNamer, "\"" .. tostring(className) .. "\"", className, id, classes, properties, children)
  end,
  clone = function(mainBlock, functionTable, varNamer, obj)
    local _, className, robloxObject, id, classes, properties, children = unpack(obj)
    return writeObjectToBlock(mainBlock, functionTable, varNamer, robloxObject, className, id, classes, properties, children)
  end
}
addCode = function(mainBlock, tree)
  local functionTable = { }
  local varNamer = VariableNamer()
  if tree then
    for _, obj in ipairs(tree) do
      addCodeFunctions[obj[1]](mainBlock, functionTable, varNamer, obj)
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
