local lpeg = require("lpeg")
local HashMap = require("com.blacksheepherd.util.HashMap")
local Array = require("com.blacksheepherd.util.Array")
local Stack = require("com.blacksheepherd.datastructure.Stack")
local C, Cc, Cf, Cs, Ct, Cmt, P, R, S, V
C, Cc, Cf, Cs, Ct, Cmt, P, R, S, V = lpeg.C, lpeg.Cc, lpeg.Cf, lpeg.Cs, lpeg.Ct, lpeg.Cmt, lpeg.P, lpeg.R, lpeg.S, lpeg.V
local indentStack
local NewLine = P("\r") ^ -1 * P("\n")
local UppercaseLetter = R("AZ")
local LowercaseLetter = R("az")
local Number = R("09")
local Tabs = S("\t ") ^ 0
local Spaces = S("\r\n\t ") ^ 0
local LineEnd = Tabs * (NewLine ^ 1 + -1)
local VariableStart = P("_") + UppercaseLetter + LowercaseLetter
local VariableBody = (VariableStart + Number) ^ 0
local VariableName = VariableStart * VariableBody
local calculateIndentSize
calculateIndentSize = function(tabs)
  local indentSize = 0
  for char in tabs:gmatch(".") do
    indentSize = indentSize + (function()
      if char == "\t" then
        return 4
      else
        return 1
      end
    end)()
  end
  return indentSize
end
local NewHashMap
NewHashMap = function()
  return true, HashMap({ })
end
local PropertyPairMatch
PropertyPairMatch = function(properties, keyValuePair)
  local key, value = unpack(keyValuePair)
  properties[key] = value
  return properties
end
local SelectorMatch
SelectorMatch = function(pattern)
  return pattern / function(objectName, classOrId, classOrIdName)
    local t = { }
    t["object"] = objectName
    if classOrId then
      t[classOrId] = classOrIdName
    end
    return t
  end
end
local RoSSBlockMatch
RoSSBlockMatch = function(pattern)
  return pattern / function(selectorStack, properties)
    Array.Reverse(selectorStack)
    if properties.__class == nil then
      properties = nil
    end
    return {
      selectorStack = selectorStack,
      properties = properties
    }
  end
end
PropertyPairMatch = function(properties, keyValuePair)
  local key, value = unpack(keyValuePair)
  properties[key] = value
  return properties
end
local Indent
Indent = function(roml, position, tabs)
  local indentSize = calculateIndentSize(tabs)
  local lastIndent = indentStack:Peek()
  if indentSize > lastIndent then
    indentStack:Push(indentSize)
    return true
  end
end
local CheckIndent
CheckIndent = function(roml, position, tabs)
  local indentSize = calculateIndentSize(tabs)
  local lastIndent = indentStack:Peek()
  return indentSize == lastIndent
end
local Dedent
Dedent = function(roml, position, tabs)
  indentStack:Pop()
  return true
end
local grammar = P({
  "RoSS",
  Indent = #Cmt(Tabs, Indent),
  CheckIndent = Cmt(Tabs, CheckIndent),
  Dedent = Cmt("", Dedent),
  SingleString = P('"') * (P("\\\"") + (1 - P('"'))) ^ 0 * P('"'),
  DoubleString = P("'") * (P("\\'") + (1 - P("'"))) ^ 0 * P("'"),
  String = C(V("SingleString") + V("DoubleString")),
  Id = P("#") * C(VariableName),
  Class = P(".") * C(VariableName),
  PropertyKey = C(UppercaseLetter * (UppercaseLetter + LowercaseLetter + Number) ^ 0),
  PropertyValue = V("String") + C((S("\t ") ^ 0 * (1 - S(":\r\n\t "))) ^ 0),
  PropertyPair = Ct(Tabs * V("PropertyKey") * Tabs * P(":") * Tabs * V("PropertyValue") * Tabs),
  PropertyLine = V("CheckIndent") * V("PropertyPair") * LineEnd,
  PropertyLines = Cf(Cmt("", NewHashMap) * V("PropertyLine") ^ 1, PropertyPairMatch),
  ObjectName = C(UppercaseLetter * (UppercaseLetter + LowercaseLetter) ^ 0),
  ObjectOnlySelector = V("ObjectName") * Cc(nil),
  ClassOrIdSelector = Cc("id") * V("Id") + Cc("class") * V("Class"),
  NoObjectSelector = Cc(nil) * V("ClassOrIdSelector"),
  FullSelector = V("ObjectName") * V("ClassOrIdSelector"),
  Selector = SelectorMatch((V("FullSelector") + V("ObjectOnlySelector") + V("NoObjectSelector")) * Tabs),
  RoSSHeader = V("CheckIndent") * Ct(V("Selector") ^ 1) * LineEnd,
  RoSSBody = V("Indent") * (V("PropertyLines") + Cc(nil)) * V("Dedent") + Cc({ }),
  RoSSBlock = RoSSBlockMatch(V("RoSSHeader") * V("RoSSBody")),
  Block = V("RoSSBlock"),
  RoSS = Ct(V("Block") ^ 0)
})
local Parse
Parse = function(ross)
  indentStack = nil
  indentStack = Stack()
  indentStack:Push(0)
  return grammar:match(ross)
end
return {
  Parse = Parse
}
