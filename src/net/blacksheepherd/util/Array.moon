InsertionSort = (array) ->
	for i = 2, #array
		x = array[i]
		j = i
		while j > 1 and array[j - 1] > x
			array[j] = array[j - 1]
			j -= 1
		array[j] = x

	return array

Merge = (left, right) ->
	result = {}

	while #left != 0 and #right != 0
		if left[1] <= right[1]
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

StableSort = (array) ->
	if #array <= 32
		return InsertionSort(array)
	else
		left = {}
		right = {}

		for i, el in ipairs(array)
			if i % 2 == 0
				table.insert(right, el)
			else
				table.insert(left, el)

		StableSort left
		StableSort right

		return Merge left, right

{ :StableSort }