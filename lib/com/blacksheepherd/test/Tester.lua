local HashMap = require("com.blacksheepherd.util.HashMap")
local Table = require("com.blacksheepherd.util.Table")
local assertEqual
assertEqual = function(inputOne, inputTwo)
  local result = nil
  local inputsAreEqual = inputOne == inputTwo
  if type(inputOne) == "table" and not inputsAreEqual then
    inputsAreEqual = Table.TablesAreEqual(inputOne, inputTwo)
  end
  if not (inputsAreEqual) then
    local stringOne = tostring(inputOne)
    local stringTwo = tostring(inputTwo)
    if type(inputOne) == "table" then
      stringOne = Table.HashMapToMultiLineString(HashMap(inputOne))
    end
    if type(inputTwo) == "table" then
      stringTwo = Table.HashMapToMultiLineString(HashMap(inputTwo))
    end
    result = "Failed equality test: " .. tostring(stringOne) .. " == " .. tostring(stringTwo) .. "."
  end
  return result
end
local Tester
do
  local _base_0 = {
    AddTest = function(self, description, testFn)
      return table.insert(self._tests, {
        description = description,
        testFn = testFn
      })
    end,
    RunTests = function(self)
      if #self._tests > 0 then
        print("\nRunning tests: " .. tostring(self._name) .. "\n-----\n")
        local testsPassed = 0
        local _list_0 = self._tests
        for _index_0 = 1, #_list_0 do
          local test = _list_0[_index_0]
          local _, errorMessage = pcall(test.testFn)
          if not (errorMessage) then
            testsPassed = testsPassed + 1
            print("✓ " .. tostring(test.description) .. "\n")
          else
            print("✗ " .. tostring(test.description) .. "\n\t" .. tostring(errorMessage) .. "\n")
          end
        end
        local percentagePassed = string.format("%03.2f", testsPassed / #self._tests * 100)
        return print(tostring(testsPassed) .. "/" .. tostring(#self._tests) .. " (" .. tostring(percentagePassed) .. "%) of the tests have passed.\n")
      else
        return print("\nNo tests to run.\n")
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, name)
      self._tests = { }
      self._name = name
    end,
    __base = _base_0,
    __name = "Tester"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.AssertEqual = assertEqual
  Tester = _class_0
end
return Tester
