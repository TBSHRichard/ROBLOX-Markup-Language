package.path = package.path .. ";../lib/?.lua;?.lua"

local Compiler = require("com.blacksheepherd.ross.RossCompiler")
local Tester = require("com.blacksheepherd.test.Tester")
local File = require("com.blacksheepherd.io.File")
local t = Tester("RossCompileTest")

local function createCompileTest(className, filename)
	return function()
		local compiledSource = Compiler.Compile(className, require("data.ross.parsetrees.parsetree_" .. filename))
		local checkSource = File.FileToString("./data/ross/lua/lua_" .. filename .. ".lua")
		
		return Tester.AssertEqual(compiledSource, checkSource)
	end
end

t:AddTest("Selector with an object and no properties.", createCompileTest("ObjectSelector", "object_selector"))
t:AddTest("Selector with properties attached.", createCompileTest("Properties", "properties"))
t:AddTest("Selector with a class.", createCompileTest("ClassSelector", "class_selector"))
t:AddTest("Selector with an id.", createCompileTest("IdSelector", "id_selector"))
t:AddTest("Multiple selectors on the stack.", createCompileTest("MultiSelectors", "multi_selectors"))
t:AddTest("Custom Object property filter.", createCompileTest("CustomObject", "custom_object"))

t:RunTests()
