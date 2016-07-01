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
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0

		spriteSheet = Instance.new("ImageLabel", frame)
		spriteSheet.Name = "SpriteSheet"
		spriteSheet.Size = UDim2.new(0, 256, 0, 256)
		spriteSheet.BackgroundTransparency = 1
		spriteSheet.BorderSizePixel = 0

		return frame

	CreateProperties: =>
		{}
		--{Size: Vector2.new(256, 256)}

	PropertyUpdateOrder: =>
		{"Name", "Position", "SpriteSheet", "Size", "Index"}

	FilterProperty: (name, value, LiteralString, CompilerPropertyFilter) ->
		return switch name
			when "Position"
				CompilerPropertyFilter.UDim2Filter(value)
			when "Size"
				CompilerPropertyFilter.Vector2Filter(value)
			else
				LiteralString(value)

	UpdateProperty: (frame, name, value) =>
		switch name
			when "Name"
				frame.Name = value
			when "Position"
				frame.Position = value
			when "SpriteSheet"
				frame\FindFirstChild("SpriteSheet").Image = value
			when "Size"
				frame.Size = UDim2.new(0, value.x, 0, value.y)
			when "Index"
				rows = math.floor(256 / frame.Size.Y.Offset)
				cols = math.floor(256 / frame.Size.X.Offset)

				x = value % cols
				y = math.floor(value / rows)

				frame\FindFirstChild("SpriteSheet").Position = UDim2.new(0, -x * frame.Size.X.Offset, 0, -y * frame.Size.Y.Offset)

	AllowsChildren: => false
}