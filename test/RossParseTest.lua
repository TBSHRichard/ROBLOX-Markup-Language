package.path = package.path .. ";../lib/?.lua;?.lua"

local Parser = require("com.blacksheepherd.ross.RossParser")
local Tester = require("com.blacksheepherd.test.Tester")
local File = require("com.blacksheepherd.io.File")
local t = Tester("RossParseTest")

local function createParseTest(filename)
	return function()
		local parsedRoss = Parser.Parse(File.FileToString("./data/ross/ross/ross_" .. filename .. ".ross"))
		local parseTree = require("data.ross.parsetrees.parsetree_" .. filename)
		
		return Tester.AssertEqual(parsedRoss, parseTree)
	end
end

t:AddTest("RoSS file with an object selector and no properties.", createParseTest("object_selector"))
t:AddTest("RoSS file with an object selector and properties.", createParseTest("properties"))
t:AddTest("Selector with a class.", createParseTest("class_selector"))
t:AddTest("Selector with an id.", createParseTest("id_selector"))
t:AddTest("Multiple selectors on the stack.", createParseTest("multi_selectors"))

t:RunTests()
