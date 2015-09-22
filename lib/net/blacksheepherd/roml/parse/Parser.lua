local lpeg = require("lpeg")
local HashMap = require("net.blacksheepherd.util.HashMap")
local Stack = require("net.blacksheepherd.datastructure.Stack")
local C, Cc, Cf, Ct, Cmt, P, R, S, V
C, Cc, Cf, Ct, Cmt, P, R, S, V = lpeg.C, lpeg.Cc, lpeg.Cf, lpeg.Ct, lpeg.Cmt, lpeg.P, lpeg.R, lpeg.S, lpeg.V
local indentStack
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
local BlockMatch
BlockMatch = function(pattern)
  return pattern / function(parentTable, children)
    parentTable[#parentTable] = children
    return parentTable
  end
end
local ObjectMatch
ObjectMatch = function(pattern)
  return pattern / function(objectName, cloneSource, id, classes, properties, children)
    local t = {
      "object",
      objectName,
      id,
      classes,
      properties,
      children
    }
    if cloneSource then
      t[1] = "clone"
      table.insert(t, 3, cloneSource)
    end
    return t
  end
end
local PropertyPairMatch
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
  "RoML",
  NewLine = P("\r") ^ -1 * P("\n"),
  LineEnd = V("Tabs") * (V("NewLine") ^ 1 + -1),
  UppercaseLetter = R("AZ"),
  LowercaseLetter = R("az"),
  Number = R("09"),
  Tabs = S("\t ") ^ 0,
  Spaces = S("\r\n\t ") ^ 0,
  VariableStart = P("_") + V("UppercaseLetter") + V("LowercaseLetter"),
  VariableBody = (V("VariableStart") + V("Number")) ^ 0,
  VariableName = C(V("VariableStart") * V("VariableBody")),
  Variable = P("@") * V("VariableName"),
  Indent = #Cmt(V("Tabs"), Indent),
  CheckIndent = Cmt(V("Tabs"), CheckIndent),
  Dedent = Cmt("", Dedent),
  SingleString = P('"') * C(P("\\\"") + (1 - P('"')) ^ 0) * P('"'),
  DoubleString = P("'") * C(P("\\'") + (1 - P("'")) ^ 0) * P("'"),
  String = V("SingleString") + V("DoubleString"),
  CloneValue = C((S("\t ") ^ 0 * (1 - S(")\r\n\t "))) ^ 0),
  CloneSource = P("(") * V("Tabs") * V("CloneValue") * V("Tabs") * P(")"),
  Id = P("#") * V("VariableName"),
  Classes = Ct(Cc("dynamic") * P(".") * V("Variable") + Cc("static") * Ct((P(".") * V("VariableName")) ^ 1)),
  PropertyKey = C(V("UppercaseLetter") * (V("UppercaseLetter") + V("LowercaseLetter") + V("Number")) ^ 0),
  PropertyValue = Ct(Cc("var") * V("Variable")) + V("String") + C((S("\t ") ^ 0 * (1 - S("}:;\r\n\t "))) ^ 0),
  PropertyPair = Ct(V("Tabs") * V("PropertyKey") * V("Tabs") * P(":") * V("Tabs") * V("PropertyValue") * V("Tabs")),
  PropertyList = P("{") * Cf(Cmt("", NewHashMap) * (V("PropertyPair") * P(";")) ^ 0 * V("PropertyPair") * P("}"), PropertyPairMatch),
  ObjectName = C(V("UppercaseLetter") * (V("UppercaseLetter") + V("LowercaseLetter")) ^ 0),
  Object = V("CheckIndent") * P("%") * V("ObjectName") * (V("CloneSource") + Cc(nil)) * (V("Id") + Cc(nil)) * (V("Classes") + Cc(nil)) * (V("PropertyList") + Cc(nil)),
  ObjectBlock = ObjectMatch(V("Object") * V("LineEnd") * (V("Indent") * Ct(V("Block") ^ 0) * V("Dedent") + Cc({ }))),
  Block = V("ObjectBlock"),
  RoML = Ct(V("Block") ^ 0)
})
local Parse
Parse = function(roml)
  indentStack = nil
  indentStack = Stack()
  indentStack:Push(0)
  return grammar:match(roml)
end
return {
  Parse = Parse
}
