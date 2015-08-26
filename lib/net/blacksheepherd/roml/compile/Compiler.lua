local Stack = require("net.blacksheepherd.datastructure.Stack")
local Table = require("net.blacksheepherd.util.Table")
local MainBlock = require("net.blacksheepherd.roml.code.MainBlock")
local SpaceBlock = require("net.blacksheepherd.roml.code.SpaceBlock")
local FunctionBlock = require("net.blacksheepherd.roml.code.FunctionBlock")
local Line = require("net.blacksheepherd.roml.code.Line")
local VariableNamer = require("net.blacksheepherd.roml.compile.VariableNamer")
local CompilerPropertyFilter = require("net.blacksheepherd.roml.compile.CompilerPropertyFilter")
local addCode
local addCodeFunctions
local mainBlock
local functionTable
local varNamer
local parentNameStack
local writeVarCode
writeVarCode = function(className, varName, changeFunction)
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
writeObjectToBlock = function(builderParam, className, id, classes, properties, children)
  local classesString = "nil"
  local objectName = nil
  if classes and classes[1] == "static" then
    classesString = Table.ArrayToSingleLineString(classes[2])
  elseif classes and classes[1] == "dynamic" then
    objectName = writeVarCode(className, classes[2], function(varChange, objectName, varName)
      return varChange:AddChild(Line(tostring(objectName) .. ":SetClasses(self._vars." .. tostring(varName) .. ":GetValue())"))
    end)
  end
  if properties then
    for name, value in properties:pairs() do
      if type(value) == "string" then
        properties[name] = CompilerPropertyFilter.FilterProperty(className, name, value)
      else
        objectName = writeVarCode(className, value[2], function(varChange, objectName, varName)
          return varChange:AddChild(Line(tostring(objectName) .. ":SetProperties({" .. tostring(name) .. " = self._vars." .. tostring(varName) .. ":GetValue()})"))
        end)
        properties[name] = nil
      end
    end
  end
  if #children > 0 and not objectName then
    objectName = varNamer:NameObjectVariable(className)
    mainBlock:AddChild(MainBlock.BLOCK_VARS, Line("local " .. tostring(objectName)))
  end
  if not objectName then
    objectName = "objTemp"
  end
  mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line(tostring(objectName) .. " = RomlObject(" .. tostring(builderParam) .. ", " .. tostring(classesString) .. ")"))
  if id then
    mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("self._objectIds[\"" .. tostring(id) .. "\"] = " .. tostring(objectName)))
  end
  if properties then
    mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line(tostring(objectName) .. ":SetProperties(" .. tostring(Table.HashMapToSingleLineString(properties)) .. ")"))
  end
  if properties then
    mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line(tostring(objectName) .. ":Refresh()"))
  end
  mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line(tostring(parentNameStack:Peek()) .. ":AddChild(" .. tostring(objectName) .. ")"))
  parentNameStack:Push(objectName)
  addCode(children)
  return parentNameStack:Pop()
end
addCodeFunctions = {
  object = function(obj)
    local _, className, id, classes, properties, children = unpack(obj)
    return writeObjectToBlock("\"" .. tostring(className) .. "\"", className, id, classes, properties, children)
  end,
  clone = function(obj)
    local _, className, robloxObject, id, classes, properties, children = unpack(obj)
    return writeObjectToBlock(robloxObject, className, id, classes, properties, children)
  end
}
addCode = function(tree)
  if tree then
    for _, obj in ipairs(tree) do
      addCodeFunctions[obj[1]](obj)
    end
  end
end
local Compile
Compile = function(name, parsetree)
  mainBlock = MainBlock(name)
  functionTable = { }
  varNamer = VariableNamer()
  parentNameStack = Stack()
  parentNameStack:Push("self._rootObject")
  addCode(parsetree)
  return mainBlock:Render()
end
return {
  Compile = Compile
}
