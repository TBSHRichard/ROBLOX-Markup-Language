----------------------------------------------------------------
-- A module with helper functions related to array style tables.
--
-- @module Array
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

ascendingCompare = (left, right) -> left <= right
descendingCompare = (left, right) -> left >= right

----------------------------------------------------------------
-- Perform an insertion sort on the array.
--
-- @tparam array array The array to be sorted.
-- @tparam function comparisonFn The function to compare any
--  two elements in the array. Parameters are the left and right
--  side.
-- @treturn array The sorted array.
----------------------------------------------------------------
InsertionSort = (array, comparisonFn) ->
	for i = 2, #array
		x = array[i]
		j = i
		--while j > 1 and array[j - 1] > x
		while j > 1 and not comparisonFn(array[j - 1], x)
			array[j] = array[j - 1]
			j -= 1
		array[j] = x

	return array

----------------------------------------------------------------
-- The merge operation of the merge sort; merges two halves of
-- an array into one.
--
-- @tparam array left The left half of the array.
-- @tparam array right The right half of the array.
-- @tparam function comparisonFn The function to compare any
--  two elements in the array. Parameters are the left and right
--  side.
-- @treturn array The merged array.
----------------------------------------------------------------
Merge = (left, right, comparisonFn) ->
	result = {}

	while #left != 0 and #right != 0
		--if left[1] <= right[1]
		if comparisonFn(left[1], right[1])
			table.insert result, left[1]
			table.remove left, 1
		else
			table.insert result, right[1]
			table.remove right, 1

	while #left != 0
		table.insert result, left[1]
		table.remove left, 1

	while #right != 0
		table.insert result, right[1]
		table.remove right, 1

	return result

----------------------------------------------------------------
-- An enum type that allows for default sorting functions in
-- the @{StableSort} if the user doesn't one to define their
-- own.
--
-- @field Ascending Sort the array in ascending order.
-- @field Descending Sort the array in descending order.
----------------------------------------------------------------
ComparisonOrder =
	Ascending:  0
	Descending: 1

----------------------------------------------------------------
-- Sort an array, making sure the order of elements with the
-- same sorting value appear in the same order they were in
-- before.
--
-- @tparam array array The array to sort
-- @tparam[opt=ComparisonOrder.Ascending] function/ComparisonOrder comparisonFn
--  The function to compare any two elements in the array.
--  Parameters are the left and right side. May also use
--  @{ComparisonOrder} to use on of the default comparison
--  functions.
-- @treturn array The sorted array.
----------------------------------------------------------------
StableSort = (array, comparisonFn = ComparisonOrder.Ascending) ->
	if comparisonFn == ComparisonOrder.Ascending
		comparisonFn = ascendingCompare
	elseif comparisonFn == ComparisonOrder.Descending
		comparisonFn = descendingCompare

	if #array <= 32
		return InsertionSort(array, comparisonFn)
	else
		left = {}
		right = {}

		for i, el in ipairs(array)
			if i % 2 == 0
				table.insert(right, el)
			else
				table.insert(left, el)

		left = StableSort left, comparisonFn
		right = StableSort right, comparisonFn

		return Merge left, right, comparisonFn

----------------------------------------------------------------
-- Reverses the order of the elements in an array.
--
-- @tparam array array The array to reverse.
----------------------------------------------------------------
Reverse = (array) ->
	for i = 1, math.floor(#array / 2)
		temp = array[i]
		array[i] = array[#array - (i - 1)]
		array[#array - (i - 1)] = temp

{ :ComparisonOrder, :Reverse, :StableSort }