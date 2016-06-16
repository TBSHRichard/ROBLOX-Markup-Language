package.path = package.path .. ";../../../../lib/?.lua;?.lua"

local Array = require("com.blacksheepherd.util.Array")
local Tester = require("com.blacksheepherd.test.Tester")
local t = Tester("ArrayTest")

local function createSortingTest(unsorted, sorted)
	return function()
		Array.StableSort(unsorted)

		return Tester.AssertEqual(unsorted, sorted)
	end
end

t:AddTest("Sorting an array with 0 elements.", createSortingTest({}, {}))
t:AddTest("Sorting an array with <32 elements.", createSortingTest({5, 2, 9, 4, 32, 16}, {2, 4, 5, 9, 16, 32}))
t:AddTest("Sorting an array with >32 elements.", createSortingTest(
	{
		6, 3, 18, 5, 99, 14,
		2, 7, 1, 4, 18, 1,
		72, 63, 9, 0, -3, 13,
		-15, 6, 45, 33, -33, 0,
		45, 78, -1, 1, 12, 36,
		81, 19, 22, 34, -5, 9
	},
	{
		-33, -15, -5, -3, -1, 0,
		0, 1, 1, 1, 2, 3,
		4, 5, 6, 6, 7, 9,
		9, 12, 13, 14, 18, 18,
		19, 22, 33, 34, 36, 45,
		45, 63, 72, 78, 81, 99
	}
))

t:RunTests()