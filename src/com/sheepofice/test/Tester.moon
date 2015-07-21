----------------------------------------------------------------
-- A class to run tests.
--
-- @classmod Tester
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

assertEqual = (inputOne, inputTwo) ->
	result = nil
	
	unless inputOne == inputTwo
		result = "Failed equality test: #{inputOne} == #{inputTwo}."
	
	return result

class Tester
	----------------------------------------------------------------
	-- Checks to see if two items are equal to one another.
	--
	-- @param inputOne The left hand side of the equality operator.
	-- @param inputTwo The right hand side of the equality operator.
	-- @return nil If the equality check was successful, or an error
	--	message if it was not.
	----------------------------------------------------------------
	@AssertEqual = assertEqual
	
	----------------------------------------------------------------
	-- Create a new Tester to begin running tests.
	--
	-- @tparam Tester self
	-- @tparam string name The name of the test suite.
	----------------------------------------------------------------
	new: (name) =>
		@_tests = {}
		@_name = name
	
	----------------------------------------------------------------
	-- Add a new test to be run.
	--
	-- @tparam Tester self
	-- @tparam string description The description of what the test
	--	is testing.
	-- @tparam function testFn The function that runs the test. It
	--	should return an error message if the test failed, or nil if
	--	it passed.
	----------------------------------------------------------------
	AddTest: (description, testFn) =>
		table.insert @_tests, {
			description: description
			testFn: testFn
		}
	
	----------------------------------------------------------------
	-- Run all of the tests that have been added and print the
	-- results.
	--
	-- @tparam Tester self
	----------------------------------------------------------------
	RunTests: =>
		if #@_tests > 0
			print("\nRunning tests: #{@_name}\n-----\n")
			testsPassed = 0
			
			for test in *@_tests
				_, errorMessage = pcall test.testFn
				
				unless errorMessage
					testsPassed += 1
					print "✓ #{test.description}\n"
				else
					print "✗ #{test.description}\n\t#{errorMessage}\n"
			
			print("#{testsPassed}/#{#@_tests} (#{testsPassed/#@_tests}%) of the tests have passed.\n")
		else
			print("\nNo tests to run.\n")

return Tester
