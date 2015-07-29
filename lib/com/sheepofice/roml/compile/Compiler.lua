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
writeObjectToBlock = function(mainBlock, builderParam, className, id, classes, properties, children)
  local classesString = "nil"
  local varNamer = VariableNamer()
  local objectName = nil
  if classes and classes[1] == "static" then
    classesString = Table.ArrayToSingleLineString(classes[2])
  elseif classes and classes[1] == "dynamic" then
    objectName = varNamer:NameObjectVariable(className)
    mainBlock:AddChild(MainBlock.BLOCK_VARS, Line("local " .. tostring(objectName)))
    mainBlock:AddChild(MainBlock.BLOCK_VARS, Line("local varChange_" .. tostring(classes[2])))
    local varChange = FunctionBlock("varChange_" .. tostring(classes[2]), "")
    varChange:AddChild(Line(tostring(objectName) .. ":SetClasses(self._vars." .. tostring(classes[2]) .. ":GetValue())"))
    mainBlock:AddChild(MainBlock.BLOCK_UPDATE_FUNCTIONS, varChange)
    mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("self._vars." .. tostring(classes[2]) .. " = RomlVar(vars." .. tostring(classes[2]) .. ")"))
    mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("self._vars." .. tostring(classes[2]) .. ".Changed:connect(varChange_" .. tostring(classes[2]) .. ")"))
    mainBlock:AddChild(MainBlock.BLOCK_FUNCTION_CALLS, Line("varChange_" .. tostring(classes[2]) .. "()"))
  end
  if properties then
    for name, value in properties:pairs() do
      if type(value) == "string" then
        properties[name] = CompilerPropertyFilter.FilterProperty(className, name, value)
      else
        objectName = varNamer:NameObjectVariable(className)
        mainBlock:AddChild(MainBlock.BLOCK_VARS, Line("local " .. tostring(objectName)))
        mainBlock:AddChild(MainBlock.BLOCK_VARS, Line("local varChange_" .. tostring(value[2])))
        local varChange = FunctionBlock("varChange_" .. tostring(value[2]), "")
        varChange:AddChild(Line(tostring(objectName) .. ":SetProperties({" .. tostring(name) .. " = self._vars." .. tostring(value[2]) .. ":GetValue()})"))
        mainBlock:AddChild(MainBlock.BLOCK_UPDATE_FUNCTIONS, varChange)
        mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("self._vars." .. tostring(value[2]) .. " = RomlVar(vars." .. tostring(value[2]) .. ")"))
        mainBlock:AddChild(MainBlock.BLOCK_CREATION, Line("self._vars." .. tostring(value[2]) .. ".Changed:connect(varChange_" .. tostring(value[2]) .. ")"))
        mainBlock:AddChild(MainBlock.BLOCK_FUNCTION_CALLS, Line("varChange_" .. tostring(value[2]) .. "()"))
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
