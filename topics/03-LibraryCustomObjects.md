# Library Defined Custom Objects

## About Custom Objects

In addition to the existing ROBLOX objects, RoML has a few custom objects defined that you may use.
This page describes each custom object as well as their properties that can be set.

## SpriteSheet Object

The SpriteSheet is a Gui object allows you to display a small portion of a ROBLOX decal.
It is made up of 2 ROBLOX objects: a `Frame` and an `ImageLabel`.

### SpriteSheet Properties

Name string: The name of the Frame.

Position UDim2: The position of the SpriteSheet. Uses the same shorthand rules as regular Gui object Position.

Size Vector2: The size of each sprite in the SpriteSheet.
The sprite size is expected to be the same for each sprite in the sheet, but this property can be changed to change the size for multi-sized sprites.
Instead of include the full Vector2 constructor, you can also use two comma separated numbers as a shorthand: `64, 64` &rarr; `Vector2.new(64, 64)`.

Image string: The [content url](http://wiki.roblox.com/index.php?title=Content) of the ROBLOX decal.

Index int: The index of the sprite. The index runs from left-to-right, top-to-bottom and is 0-based.
As an example, here is the indices of a SpriteSheet with a size of 64x64:

	@plain
	+----+----+----+----+
	|  0 |  1 |  2 |  3 |
	+----+----+----+----+
	|  4 |  5 |  6 |  7 |
	+----+----+----+----+
	|  8 |  9 | 10 | 11 |
	+----+----+----+----+
	| 12 | 13 | 14 | 15 |
	+----+----+----+----+
