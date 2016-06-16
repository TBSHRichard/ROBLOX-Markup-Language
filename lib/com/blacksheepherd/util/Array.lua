local InsertionSort
InsertionSort = function(array)
  for i = 2, #array do
    local x = array[i]
    local j = i
    while j > 1 and array[j - 1] > x do
      array[j] = array[j - 1]
      j = j - 1
    end
    array[j] = x
  end
  return array
end
local Merge
Merge = function(left, right)
  local result = { }
  while #left ~= 0 and #right ~= 0 do
    if left[1] <= right[1] then
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
local StableSort
StableSort = function(array)
  if #array <= 32 then
    return InsertionSort(array)
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
    StableSort(left)
    StableSort(right)
    return Merge(left, right)
  end
end
return {
  StableSort = StableSort
}
