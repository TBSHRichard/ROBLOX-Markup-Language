package.path = package.path .. ";../lib/?.lua;?.lua"

local Parser = require("com.blacksheepherd.roml.RomlParser")
local Tester = require("com.blacksheepherd.test.Tester")
local File = require("com.blacksheepherd.io.File")
local t = Tester("ParseTest")

local function createParseTest(filename)
	return function()
		local parsedRoml = Parser.Parse(File.FileToString("./data/roml/roml/roml_" .. filename .. ".roml"))
		local parseTree = require("data.roml.parsetrees.parsetree_" .. filename)
		
		return Tester.AssertEqual(parsedRoml, parseTree)
	end
end

t:AddTest("RoML file with only objects (no children).", createParseTest("objects"))
t:AddTest("RoML file with only objects (with children).", createParseTest("children"))
t:AddTest("Objects with inline properties.", createParseTest("properties"))
t:AddTest("Objects with classes.", createParseTest("classes"))
t:AddTest("Objects with an id.", createParseTest("id"))
t:AddTest("ROBLOX object clone.", createParseTest("clone"))
t:AddTest("Objects with a variable class.", createParseTest("var_class"))
t:AddTest("Objects with variable properties.", createParseTest("var_properties"))
t:AddTest("Conditional statements.", createParseTest("conditionals"))
t:AddTest("For loops.", createParseTest("loops"))
t:AddTest("Nested conditionals/for loops.", createParseTest("nesting"))

t:RunTests()
