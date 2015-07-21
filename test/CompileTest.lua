package.path = "../lib/?.lua; ./?.lua"

local Compiler
local Tester = require("com.sheepofice.test.Tester")
local File = require("com.sheepofice.io.File")
local t = Tester("CompileTest")

local function createCompileTest(name)
	return function()
		local compiledSource = Compiler.Compile(require("data.parsetrees.parsetree_" .. name))
		local checkSource = File.FileToString("./data/lua/lua_" .. name .. ".lua")
		
		return Tester.AssertEqual(compiledSource, checkSource)
	end
end

t:AddTest("Parse tree with only objects (no children).", createCompileTest("objects"))
t:AddTest("Parse tree with only objects (with children).", createCompileTest("children"))
t:AddTest("Objects with inline properties.", createCompileTest("properties"))
t:AddTest("Objects with classes.", createCompileTest("classes"))
t:AddTest("Objects with an id.", createCompileTest("id"))
t:AddTest("Custom object extensions.", createCompileTest("extensions"))
t:AddTest("Objects with a variable class.", createCompileTest("var_class"))
t:AddTest("Objects with variable properties.", createCompileTest("var_properties"))
t:AddTest("Conditional statements.", createCompileTest("conditionals"))
t:AddTest("For loops.", createCompileTest("loops"))
t:AddTest("Nested conditionals/for loops.", createCompileTest("nesting"))

t:RunTests()
