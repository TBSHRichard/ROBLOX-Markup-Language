local Stack = require("net.blacksheepherd.datastructure.Stack")
local Table = require("net.blacksheepherd.util.Table")
local MainBlock = require("net.blacksheepherd.roml.code.MainBlock")
local ConditionalBlock = require("net.blacksheepherd.roml.code.ConditionalBlock")
local ForBlock = require("net.blacksheepherd.roml.code.ForBlock")
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
local creationFunctionStack
local mainBlockCreationFunction
mainBlockCreationFunction = function(lines)
  for _index_0 = 1, #lines do
    local line = lines[_index_0]
    mainBlock:AddChild(MainBlock.BLOCK_CREATION, line)
  end
end
local writeLineToVarChangeFunction
writeLineToVarChangeFunction = function(varName, lineString)
  if not (functionTable[varName]) then
    mainBlock:AddChild(MainBlock.BLOCK_VARS, Line("local varChange_" .. tostring(varName)))
    functionTable[varName] = FunctionBlock("varChange_" .. tostring(varName), "")
    mainBlock:AddChild(MainBlock.BLOCK_UPDATE_FUNCTIONS, functionTable[varName])
    mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("self._vars." .. tostring(varName) .. " = RomlVar(vars." .. tostring(varName) .. ")"))
    mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("self._vars." .. tostring(varName) .. ".Changed:connect(varChange_" .. tostring(varName) .. ")"))
    mainBlock:AddChild(MainBlock.BLOCK_FUNCTION_CALLS, Line("varChange_" .. tostring(varName) .. "()"))
  end
  return functionTable[varName]:AddLineIfNotAdded(lineString)
end
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
          varChange:AddChild(Line(tostring(objectName) .. ":SetProperties({" .. tostring(name) .. " = self._vars." .. tostring(varName) .. ":GetValue()})"))
          return varChange:AddChild(Line(tostring(objectName) .. ":Refresh()"))
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
  local idString
  if id == nil then
    idString = "nil"
  else
    idString = "\"" .. tostring(id) .. "\""
  end
  local lines = {
    Line(tostring(objectName) .. " = RomlObject(self, " .. tostring(builderParam) .. ", " .. tostring(idString) .. ", " .. tostring(classesString) .. ")")
  }
  if id then
    table.insert(lines, Line("self._objectIds[" .. tostring(idString) .. "] = " .. tostring(objectName)))
  end
  if properties then
    table.insert(lines, Line(tostring(objectName) .. ":SetProperties(" .. tostring(Table.HashMapToSingleLineString(properties)) .. ")"))
    table.insert(lines, Line(tostring(objectName) .. ":Refresh()"))
  end
  table.insert(lines, Line("self:AddChild(" .. tostring(parentNameStack:Peek()) .. ":AddChild(" .. tostring(objectName) .. "))"))
  creationFunctionStack:Peek()(lines)
  creationFunctionStack:Push(creationFunctionStack:Peek())
  parentNameStack:Push(objectName)
  addCode(children)
  parentNameStack:Pop()
  return creationFunctionStack:Pop()
end
addCodeFunctions = {
  object = function(obj)
    local _, className, id, classes, properties, children = unpack(obj)
    return writeObjectToBlock("\"" .. tostring(className) .. "\"", className, id, classes, properties, children)
  end,
  clone = function(obj)
    local _, className, robloxObject, id, classes, properties, children = unpack(obj)
    return writeObjectToBlock(robloxObject, className, id, classes, properties, children)
  end,
  ["if"] = function(obj)
    local _, condition, vars, children, otherConditionals = unpack(obj)
    local parentName = parentNameStack:Peek()
    if parentName == "self._rootObject" then
      parentName = "Parent"
    else
      parentName = string.sub(parentName, 4)
    end
    if creationFunctionStack:Peek() == mainBlockCreationFunction then
      local creationFunctionName = "update" .. tostring(parentName)
      local creationFunction = FunctionBlock(creationFunctionName, "")
      creationFunction:AddChild(Line(tostring(parentNameStack:Peek()) .. ":RemoveAllChildren()"))
      mainBlock:AddChild(MainBlock.BLOCK_VARS, Line("local " .. tostring(creationFunctionName)))
      mainBlock:AddChild(MainBlock.BLOCK_UPDATE_FUNCTIONS, creationFunction)
      creationFunctionStack:Push(function(lines)
        for _index_0 = 1, #lines do
          local line = lines[_index_0]
          creationFunction:AddChild(line)
        end
      end)
    end
    local ifBlock = ConditionalBlock()
    ifBlock:AddCondition(condition)
    creationFunctionStack:Peek()({
      ifBlock
    })
    creationFunctionStack:Push(function(lines)
      for _index_0 = 1, #lines do
        local line = lines[_index_0]
        ifBlock:AddChild(line)
      end
    end)
    for _index_0 = 1, #vars do
      local var = vars[_index_0]
      writeLineToVarChangeFunction(var, "update" .. tostring(parentName) .. "()")
    end
    addCode(children)
    for _index_0 = 1, #otherConditionals do
      local conditional = otherConditionals[_index_0]
      condition, vars, children = unpack(conditional)
      ifBlock:AddCondition(condition)
      for _index_1 = 1, #vars do
        local var = vars[_index_1]
        writeLineToVarChangeFunction(var, "update" .. tostring(parentName) .. "()")
      end
      addCode(children)
    end
    return creationFunctionStack:Pop()
  end,
  ["for"] = function(obj)
    local _, condition, vars, children = unpack(obj)
    local parentName = parentNameStack:Peek()
    if parentName == "self._rootObject" then
      parentName = "Parent"
    else
      parentName = string.sub(parentName, 4)
    end
    if creationFunctionStack:Peek() == mainBlockCreationFunction then
      local creationFunctionName = "update" .. tostring(parentName)
      local creationFunction = FunctionBlock(creationFunctionName, "")
      creationFunction:AddChild(Line(tostring(parentNameStack:Peek()) .. ":RemoveAllChildren()"))
      mainBlock:AddChild(MainBlock.BLOCK_VARS, Line("local " .. tostring(creationFunctionName)))
      mainBlock:AddChild(MainBlock.BLOCK_UPDATE_FUNCTIONS, creationFunction)
      creationFunctionStack:Push(function(lines)
        for _index_0 = 1, #lines do
          local line = lines[_index_0]
          creationFunction:AddChild(line)
        end
      end)
    end
    local forBlock = ForBlock(condition)
    creationFunctionStack:Peek()({
      forBlock
    })
    creationFunctionStack:Push(function(lines)
      for _index_0 = 1, #lines do
        local line = lines[_index_0]
        forBlock:AddChild(line)
      end
    end)
    for _index_0 = 1, #vars do
      local var = vars[_index_0]
      writeLineToVarChangeFunction(var, "update" .. tostring(parentName) .. "()")
    end
    addCode(children)
    return creationFunctionStack:Pop()
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
  creationFunctionStack = Stack()
  parentNameStack:Push("self._rootObject")
  creationFunctionStack:Push(mainBlockCreationFunction)
  addCode(parsetree)
  return mainBlock:Render()
end
return {
  Compile = Compile
}
