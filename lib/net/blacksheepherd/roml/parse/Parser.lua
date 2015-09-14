local lpeg = require("lpeg")
local C, Ct, P, R, S, V
C, Ct, P, R, S, V = lpeg.C, lpeg.Ct, lpeg.P, lpeg.R, lpeg.S, lpeg.V
local ObjectMatch
ObjectMatch = function(pattern)
  return pattern / function(objectName)
    return {
      "object",
      objectName,
      nil,
      nil,
      nil,
      { }
    }
  end
end
local grammar = P({
  "RoML",
  NewLine = P("\r") ^ -1 * P("\n"),
  UppercaseLetter = R("AZ"),
  LowercaseLetter = R("az"),
  ObjectName = C(V("UppercaseLetter") * (V("UppercaseLetter") + V("LowercaseLetter")) ^ 0),
  Object = ObjectMatch(P("%") * V("ObjectName")),
  Block = V("Object") * V("NewLine") ^ 0 * V("Block") ^ 0,
  RoML = Ct(V("Block"))
})
local Parse
Parse = function(roml)
  return grammar:match(roml)
end
return {
  Parse = Parse
}
