local lpeg
local HashMap
local Stack
if game then
  lpeg = require(plugin.lulpeg.lulpeg)
  HashMap = require(plugin.com.blacksheepherd.util.HashMap)
  Stack = require(plugin.com.blacksheepherd.datastructure.Stack)
else
  lpeg = require("lpeg")
  HashMap = require("com.blacksheepherd.util.HashMap")
  Stack = require("com.blacksheepherd.datastructure.Stack")
end
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
local Variable = P("@") * C(VariableName)
local varReplacement
varReplacement = function(statement, vars, replacement)
  for _index_0 = 1, #vars do
    local var = vars[_index_0]
    local sub = Cs((P("@") * C(P(var)) / replacement + 1) ^ 0)
    statement = lpeg.match(sub, statement)
  end
  return statement, vars
end
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
local Condition
Condition = function(pattern)
  return pattern / function(condition, ...)
    return varReplacement(condition, {
      ...
    }, "self._vars.%1:GetValue()")
  end
end
local ConditionalIfMatch
ConditionalIfMatch = function(pattern)
  return pattern / function(keyword, condition, vars, children, extra)
    return {
      "if",
      (function()
        if keyword == "if" then
          return condition
        else
          return "not(" .. tostring(condition) .. ")"
        end
      end)(),
      vars,
      children,
      extra
    }
  end
end
local ConditionalElseIfMatch
ConditionalElseIfMatch = function(pattern)
  return pattern / function(keyword, condition, vars, children)
    return {
      (function()
        if keyword == "elseif" then
          return condition
        else
          return "not(" .. tostring(condition) .. ")"
        end
      end)(),
      vars,
      children
    }
  end
end
local ConditionalElseMatch
ConditionalElseMatch = function(pattern)
  return pattern / function(children)
    return {
      "",
      { },
      children
    }
  end
end
local ForVars
ForVars = function(pattern)
  return pattern / function(varOne, varTwo)
    return tostring(varOne) .. ", " .. tostring(varTwo)
  end
end
local ForHeader
ForHeader = function(pattern)
  return pattern / function(condition, ...)
    local checkForTwoVars = VariableName * Tabs * P(",") * Tabs * VariableName
    if not (lpeg.match(checkForTwoVars, condition)) then
      condition = "_, " .. tostring(condition)
    end
    return varReplacement(condition, {
      ...
    }, "pairs(self._vars.%1:GetValue())")
  end
end
local ForLoopMatch
ForLoopMatch = function(pattern)
  return pattern / function(condition, vars, children)
    return {
      "for",
      condition,
      vars,
      children
    }
  end
end
local grammar = P({
  "RoML",
  Indent = #Cmt(Tabs, Indent),
  CheckIndent = Cmt(Tabs, CheckIndent),
  Dedent = Cmt("", Dedent),
  SingleString = P('"') * (P("\\\"") + (1 - P('"'))) ^ 0 * P('"'),
  DoubleString = P("'") * (P("\\'") + (1 - P("'"))) ^ 0 * P("'"),
  String = C(V("SingleString") + V("DoubleString")),
  CloneValue = C((S("\t ") ^ 0 * (1 - S(")\r\n\t "))) ^ 0),
  CloneSource = P("(") * Tabs * V("CloneValue") * Tabs * P(")"),
  Id = P("#") * C(VariableName),
  Classes = Ct(Cc("dynamic") * P(".") * Variable + Cc("static") * Ct((P(".") * C(VariableName)) ^ 1)),
  PropertyKey = C(UppercaseLetter * (UppercaseLetter + LowercaseLetter + Number) ^ 0),
  PropertyValue = Ct(Cc("var") * Variable) + V("String") + C((S("\t ") ^ 0 * (1 - S("}:;\r\n\t "))) ^ 0),
  PropertyPair = Ct(Tabs * V("PropertyKey") * Tabs * P(":") * Tabs * V("PropertyValue") * Tabs),
  PropertyList = P("{") * Cf(Cmt("", NewHashMap) * (V("PropertyPair") * P(";")) ^ 0 * V("PropertyPair") * P("}"), PropertyPairMatch),
  ObjectName = C(UppercaseLetter * (UppercaseLetter + LowercaseLetter) ^ 0),
  Object = V("CheckIndent") * P("%") * V("ObjectName") * (V("CloneSource") + Cc(nil)) * (V("Id") + Cc(nil)) * (V("Classes") + Cc(nil)) * (V("PropertyList") + Cc(nil)),
  ObjectBlock = ObjectMatch(V("Object") * V("BlockBody")),
  Condition = Tabs * C((Tabs * Variable + (S("\t ") ^ 0 * (1 - S("@\r\n\t ")))) ^ 1),
  ConditionalTop = V("CheckIndent") * C(P("if") + P("unless")) * Condition(V("Condition")),
  ConditionalMiddle = V("CheckIndent") * C(P("elseif") + P("elseunless")) * Condition(V("Condition")),
  ConditionalBottom = V("CheckIndent") * P("else"),
  ConditionalBlock = ConditionalIfMatch(V("ConditionalTop") * V("BlockBody") * Ct(ConditionalElseIfMatch(V("ConditionalMiddle") * V("BlockBody")) ^ 0 * ConditionalElseMatch(V("ConditionalBottom") * V("BlockBody")) ^ -1)),
  ForVars = (VariableName * Tabs * P(",")) ^ -1 * Tabs * VariableName,
  ForHeader = ForHeader(V("CheckIndent") * P("for") * Tabs * C(V("ForVars") * Tabs * P("in") * Tabs * Variable)),
  ForBlock = ForLoopMatch(V("ForHeader") * V("BlockBody")),
  BlockBody = LineEnd * (V("Indent") * Ct(V("Block") ^ 0) * V("Dedent") + Cc({ })),
  Block = V("ObjectBlock") + V("ConditionalBlock") + V("ForBlock"),
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
