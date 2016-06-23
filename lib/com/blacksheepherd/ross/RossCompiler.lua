local Array = require("com.blacksheepherd.util.Array")
local Table = require("com.blacksheepherd.util.Table")
local AnonymousTableBlock = require("com.blacksheepherd.code.AnonymousTableBlock")
local StackBlock = require("com.blacksheepherd.code.StackBlock")
local Line = require("com.blacksheepherd.code.Line")
local MainRossBlock = require("com.blacksheepherd.code.MainRossBlock")
local CompilerPropertyFilter = require("com.blacksheepherd.compile.CompilerPropertyFilter")
local CustomObjectBuilder = require("com.blacksheepherd.customobject.CustomObjectBuilder")
local mainBlock
local calculateAndAddSpecificity
calculateAndAddSpecificity = function(block)
  local numberOfObjects = 0
  local numberOfClasses = 0
  local numberOfIds = 0
  local _list_0 = block.selectorStack
  for _index_0 = 1, #_list_0 do
    local selector = _list_0[_index_0]
    if not (selector["object"] == nil) then
      numberOfObjects = numberOfObjects + 1
    end
    if selector["class"] ~= nil then
      numberOfClasses = numberOfClasses + 1
    elseif selector["id"] ~= nil then
      numberOfIds = numberOfIds + 1
    end
  end
  block.specificity = numberOfIds * 2 ^ 16 + numberOfClasses * 2 ^ 8 + numberOfObjects
end
local createAndAddSelectorBlock
createAndAddSelectorBlock = function(block)
  local selectorBlock = AnonymousTableBlock()
  local selectorStackBlock = StackBlock("selector")
  local selectorTop = block.selectorStack[1]
  local _list_0 = block.selectorStack
  for _index_0 = 1, #_list_0 do
    local selector = _list_0[_index_0]
    local selectorStackItemBlock = AnonymousTableBlock()
    if selector.object ~= nil then
      selectorStackItemBlock:AddChild(Line("object = \"" .. tostring(selector.object) .. "\""))
    end
    if selector.class ~= nil then
      selectorStackItemBlock:AddChild(Line("class = \"" .. tostring(selector.class) .. "\""))
    elseif selector.id ~= nil then
      selectorStackItemBlock:AddChild(Line("id = \"" .. tostring(selector.id) .. "\""))
    end
    selectorStackBlock:AddChild(selectorStackItemBlock)
  end
  local keyName = ""
  local className = ""
  if selectorTop.object ~= nil then
    keyName = selectorTop.object
    className = selectorTop.object
  end
  selectorBlock:AddChild(selectorStackBlock)
  if block.properties then
    for name, value in block.properties:pairs() do
      if CustomObjectBuilder.IsACustomObject(className) then
        block.properties[name] = CustomObjectBuilder.FilterProperty(className, name, value)
      else
        block.properties[name] = CompilerPropertyFilter.FilterProperty(className, name, value)
      end
    end
    selectorBlock:AddChild(Line("properties = " .. tostring(Table.HashMapToSingleLineString(block.properties))))
  else
    selectorBlock:AddChild(Line("properties = {}"))
  end
  if selectorTop.class ~= nil then
    keyName = keyName .. "." .. tostring(selectorTop.class)
    return mainBlock:AddClassSelector(keyName, selectorBlock)
  elseif selectorTop.id ~= nil then
    keyName = keyName .. "#" .. tostring(selectorTop.id)
    return mainBlock:AddIdSelector(keyName, selectorBlock)
  else
    return mainBlock:AddObjectSelector(keyName, selectorBlock)
  end
end
local addCode
addCode = function(tree)
  if tree then
    tree = Array.StableSort(tree, function(left, right)
      if left.specificity == nil then
        calculateAndAddSpecificity(left)
      end
      if right.specificity == nil then
        calculateAndAddSpecificity(right)
      end
      return left.specificity >= right.specificity
    end)
    for _index_0 = 1, #tree do
      local rossBlock = tree[_index_0]
      createAndAddSelectorBlock(rossBlock)
    end
  end
end
local Compile
Compile = function(name, parseTree)
  mainBlock = MainRossBlock(name)
  addCode(parseTree)
  return mainBlock:Render()
end
return {
  Compile = Compile
}
