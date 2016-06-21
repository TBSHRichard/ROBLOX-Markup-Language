ascendingCompare = (left, right) -> left <= right
descendingCompare = (left, right) -> left >= right

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

ComparisonOrder =
	Ascending:  0
	Descending: 1

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

Reverse = (array) ->
	for i = 1, math.floor(#array / 2)
		temp = array[i]
		array[i] = array[#array - (i - 1)]
		array[#array - (i - 1)] = temp

{ :ComparisonOrder, :Reverse, :StableSort }