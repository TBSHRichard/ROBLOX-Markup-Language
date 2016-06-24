----------------------------------------------------------------
-- The SpriteSheet @{CustomObject} is used to easily display
-- only part of an ImageLabel. It's properties are: Name(string)
-- (changes the Name of the ROBLOX Frame), Position(UDim2) (the
-- position of the ROBLOX Frame), SpriteSheet(string) (the asset
-- url for the ROBLOX decal), Size(Vector2) (the size of each
-- sprite in the sprite sheet), Index(int) (the index of the
-- sprite; order is left to right, top to bottom). It does not
-- allow child elements.
--
-- @module SpriteSheet
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

return {
	Create: =>
		frame = Instance.new("Frame")
		frame.ClipsDescendants = true
		frame.Name = "SpriteSheetFrame"

		spriteSheet = Instance.new("ImageLabel", frame)
		spriteSheet.Name = "SpriteSheet"

		return frame

	FilterProperty: (name, value, LiteralString, CompilerPropertyFilter) ->
		return switch name
			when "Position"
				CompilerPropertyFilter.UDim2Filter(value)
			when "Size"
				CompilerPropertyFilter.Vector2Filter(value)
			else
				LiteralString(value)

	SetProperty: (frame, name, value) =>
		switch name
			when "Name"
				instance.Name = value
			when "Position"
				instance.Position = value
			when "SpriteSheet"
				instance\FindFirstChild("SpriteSheet").Image = value
			when "Size"
				instance.Size = UDim2.new(0, value.x, 0, value.y)
			when "Index"
				rows = math.floor(instance.size.Y.Offset / 256)
				cols = math.floor(instance.size.X.Offset / 256)

				x = value % cols
				y = math.floor(value / rows)

				instance\FindFirstChild("SpriteSheet").Position = UDim2.new(0, -x * instance.size.X.Offset, 0, -y * instance.size.Y.Offset)

	AllowsChildren: => false
}