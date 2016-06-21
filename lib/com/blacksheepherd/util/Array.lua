local ascendingCompare
ascendingCompare = function(left, right)
  return left <= right
end
local descendingCompare
descendingCompare = function(left, right)
  return left >= right
end
local InsertionSort
InsertionSort = function(array, comparisonFn)
  for i = 2, #array do
    local x = array[i]
    local j = i
    while j > 1 and not comparisonFn(array[j - 1], x) do
      array[j] = array[j - 1]
      j = j - 1
    end
    array[j] = x
  end
  return array
end
local Merge
Merge = function(left, right, comparisonFn)
  local result = { }
  while #left ~= 0 and #right ~= 0 do
    if comparisonFn(left[1], right[1]) then
      table.insert(result, left[1])
      table.remove(left, 1)
    else
      table.insert(result, right[1])
      table.remove(right, 1)
    end
  end
  while #left ~= 0 do
    table.insert(result, left[1])
    table.remove(left, 1)
  end
  while #right ~= 0 do
    table.insert(result, right[1])
    table.remove(right, 1)
  end
  return result
end
local ComparisonOrder = {
  Ascending = 0,
  Descending = 1
}
local StableSort
StableSort = function(array, comparisonFn)
  if comparisonFn == nil then
    comparisonFn = ComparisonOrder.Ascending
  end
  if comparisonFn == ComparisonOrder.Ascending then
    comparisonFn = ascendingCompare
  elseif comparisonFn == ComparisonOrder.Descending then
    comparisonFn = descendingCompare
  end
  if #array <= 32 then
    return InsertionSort(array, comparisonFn)
  else
    local left = { }
    local right = { }
    for i, el in ipairs(array) do
      if i % 2 == 0 then
        table.insert(right, el)
      else
        table.insert(left, el)
      end
    end
    left = StableSort(left, comparisonFn)
    right = StableSort(right, comparisonFn)
    return Merge(left, right, comparisonFn)
  end
end
local Reverse
Reverse = function(array)
  for i = 1, math.floor(#array / 2) do
    local temp = array[i]
    array[i] = array[#array - (i - 1)]
    array[#array - (i - 1)] = temp
  end
end
return {
  ComparisonOrder = ComparisonOrder,
  Reverse = Reverse,
  StableSort = StableSort
}
