package.path = package.path .. ";../../../../lib/?.lua;?.lua"

local Array = require("com.blacksheepherd.util.Array")
local Tester = require("com.blacksheepherd.test.Tester")
local IdElement = require("com.blacksheepherd.test.IdElement")
local t = Tester("ArrayTest")

local function createSortingTest(unsorted, sorted, sortingFn)
	if sortingFn == nil then
		sortingFn = Array.ComparisonOrder.Ascending
	end

	return function()
		unsorted = Array.StableSort(unsorted, sortingFn)

		return Tester.AssertEqual(unsorted, sorted)
	end
end

t:AddTest("Sorting an array with 0 elements.", createSortingTest({}, {}))
t:AddTest("Sorting an array with <= 32 elements.", createSortingTest({5, 2, 9, 4, 32, 16}, {2, 4, 5, 9, 16, 32}))
t:AddTest("Sorting an array with > 32 elements.", createSortingTest(
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
t:AddTest("Sorting an array in descending order.", createSortingTest({5, 2, 9, 4, 32, 16, 4}, {32, 16, 9, 5, 4, 4, 2}, Array.ComparisonOrder.Descending))
t:AddTest("Sort is stable in an array with <= 32 elements.", createSortingTest(
	{IdElement(7, 32), IdElement(6, 4), IdElement(1, 9), IdElement(3, 4), IdElement(4, 32), IdElement(2, 16), IdElement(5, 4)}, 
	{IdElement(6, 4), IdElement(3, 4), IdElement(5, 4), IdElement(1, 9), IdElement(2, 16), IdElement(7, 32), IdElement(4, 32)}, 
	function(left, right) return left:Element() <= right:Element() end
))
t:AddTest("Sort is stable in an array with > 32 elements.", createSortingTest(
	{
		IdElement(32, 6), IdElement(21, 3), IdElement(11, 18), IdElement(31, 5), IdElement(5, 99), IdElement(23, 14),
		IdElement(30, 2), IdElement(3, 7), IdElement(19, 1), IdElement(1, 4), IdElement(13, 18), IdElement(9, 1),
		IdElement(15, 72), IdElement(26, 63), IdElement(25, 9), IdElement(36, 0), IdElement(18, -3), IdElement(2, 13),
		IdElement(27, -15), IdElement(14, 6), IdElement(28, 45), IdElement(7, 33), IdElement(6, -33), IdElement(33, 0),
		IdElement(4, 45), IdElement(8, 78), IdElement(16, -1), IdElement(22, 1), IdElement(29, 12), IdElement(24, 36),
		IdElement(20, 81), IdElement(35, 19), IdElement(12, 22), IdElement(34, 34), IdElement(17, -5), IdElement(10, 9)
	},
	{
		IdElement(6, -33), IdElement(27, -15), IdElement(17, -5), IdElement(18, -3), IdElement(16, -1), IdElement(36, 0),
		IdElement(33, 0), IdElement(19, 1), IdElement(9, 1), IdElement(22, 1), IdElement(30, 2), IdElement(21, 3),
		IdElement(1, 4), IdElement(31, 5), IdElement(32, 6), IdElement(14, 6), IdElement(3, 7), IdElement(25, 9),
		IdElement(10, 9), IdElement(29, 12), IdElement(2, 13), IdElement(23, 14), IdElement(11, 18), IdElement(13, 18),
		IdElement(35, 19), IdElement(12, 22), IdElement(7, 33), IdElement(34, 34), IdElement(24, 36), IdElement(28, 45),
		IdElement(4, 45), IdElement(26, 63), IdElement(15, 72), IdElement(8, 78), IdElement(20, 81), IdElement(5, 99)
	},
	function(left, right) return left:Element() <= right:Element() end
))

t:RunTests()