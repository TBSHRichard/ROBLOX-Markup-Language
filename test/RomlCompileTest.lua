package.path = package.path .. ";../lib/?.lua;?.lua"

local Compiler = require("com.blacksheepherd.roml.RomlCompiler")
local Tester = require("com.blacksheepherd.test.Tester")
local File = require("com.blacksheepherd.io.File")
local t = Tester("CompileTest")

local function createCompileTest(className, filename)
	return function()
		local compiledSource = Compiler.Compile(className, require("data.roml.parsetrees.parsetree_" .. filename))
		local checkSource = File.FileToString("./data/roml/lua/lua_" .. filename .. ".lua")
		
		return Tester.AssertEqual(compiledSource, checkSource)
	end
end

t:AddTest("Parse tree with only objects (no children).", createCompileTest("Objects", "objects"))
t:AddTest("Parse tree with only objects (with children).", createCompileTest("Children", "children"))
t:AddTest("Objects with inline properties.", createCompileTest("Properties", "properties"))
t:AddTest("Objects with classes.", createCompileTest("Classes", "classes"))
t:AddTest("Objects with an id.", createCompileTest("Id", "id"))
t:AddTest("ROBLOX object clone.", createCompileTest("Clone", "clone"))
t:AddTest("Objects with a variable class.", createCompileTest("VarClass", "var_class"))
t:AddTest("Objects with variable properties.", createCompileTest("VarProperties", "var_properties"))
t:AddTest("Multiple objects which share the same variable.", createCompileTest("SameVarMultiPlaces", "same_var_multi_places"))
t:AddTest("Single object which has multiple variables associated with it.", createCompileTest("MultiVarsSamePlace", "multi_vars_same_place"))
t:AddTest("Conditional statements.", createCompileTest("Conditionals", "conditionals"))
t:AddTest("For loops.", createCompileTest("Loops", "loops"))
t:AddTest("Nested conditionals/for loops.", createCompileTest("Nesting", "nesting"))
t:AddTest("Custom object with property.", createCompileTest("CustomObject", "custom_object"))

t:RunTests()
