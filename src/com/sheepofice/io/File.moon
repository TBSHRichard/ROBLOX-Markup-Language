----------------------------------------------------------------
-- Contains helper methods for file reading and writing.
--
-- @module File
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

----------------------------------------------------------------
-- Reads the contents of a file and places them inside of
-- string, which is returned.
--
-- @tparam string path The path to the file.
-- @treturn string The contents of the file.
----------------------------------------------------------------
FileToString = (path) ->
	file = io.open(path)
	s = file:read("*all")
	file:close()
	return s

{ :FileToString }
