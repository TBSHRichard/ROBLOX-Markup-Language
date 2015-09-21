local lpeg = require("lpeg")
local Stack = require("net.blacksheepherd.datastructure.Stack")
local C, Cc, Ct, Cmt, P, R, S, V
C, Cc, Ct, Cmt, P, R, S, V = lpeg.C, lpeg.Cc, lpeg.Ct, lpeg.Cmt, lpeg.P, lpeg.R, lpeg.S, lpeg.V
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
local BlockMatch
BlockMatch = function(pattern)
  return pattern / function(parentTable, children)
    parentTable[#parentTable] = children
    return parentTable
  end
end
local ObjectMatch
ObjectMatch = function(pattern)
  return pattern / function(objectName, children)
    return {
      "object",
      objectName,
      nil,
      nil,
      nil,
      children
    }
  end
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
  Tabs = S("\t ") ^ 0,
  Indent = #Cmt(V("Tabs"), Indent),
  CheckIndent = Cmt(V("Tabs"), CheckIndent),
  Dedent = Cmt("", Dedent),
  ObjectName = C(V("UppercaseLetter") * (V("UppercaseLetter") + V("LowercaseLetter")) ^ 0),
  Object = V("CheckIndent") * P("%") * V("ObjectName"),
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
