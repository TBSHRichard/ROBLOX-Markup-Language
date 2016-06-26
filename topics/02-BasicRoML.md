# Writing RoML Files

## Introduction to RoML

The RoML language is used to define a structure of ROBLOX objects that can be created and upated.
The syntax of RoML is inspired by HAML, so if you know that you'll learn RoML very quickly.
Not to worry if you don't know it though, as RoML is not complex at all!

## Creating Objects

Creating objects with RoML is very simple.
An object starts with the percent sign (`%`) followed by the class name.

For example, if we wanted to create a `Part` object, we would write:

```
%Part
```

This is equivalent to `Instance.new("Part")` with regular ROBLOX Lua.
The class name can be any ROBLOX class that can be created with `Instance::new` (otherwise ROBLOX will throw an error).
There are also some custom objects that RoML defines, and you can even define your own custom objects as well!

## Creating Your RoML Structure

After you've compiled your RoML file, a ModuleScript will be put in the output folder.
You may then `require` this ModuleScript in another Lua Script.
The ModuleScript has a class which can be instantiated any time you want to create your structure.
The constructor takes upto three arguments: the parent ROBLOX object, an optional table of initial variable values (described in topic 4: AdvancedRoML),
and an optional RoSSDoc instance (described in topic 5: RoSS).

Let's go back to the place structure from the Introduction topic but with the above RoML example as "TestRoML.roml":

	@plain
	game
	 |
	 +-- ServerScriptService
	      |
	      +-- lib (Folder)
	      |    |
	      |    +-- roml (Folder)
	      |         |
	      |         +-- TestRoML (ModuleScript)
	      |
	      +-- src (Folder)
	           |
	           +-- roml (Folder)
	                |
	                +-- TestRoML.roml (ModuleScript)

We can then take a look at the Lua Script we could write in order to create our RoML structure:

	local TestRoML = require(game.ServerScriptService.lib.roml.TestRoML)
	
	TestRoML.new(game.Workspace)

For now we've only included a parent in the RoMLDoc constructor.
By calling `TestRoML.new(game.Workspace)`, we create all of the objects from our RoML file (which in this case is just a `Part`) in the `Workspace`.

## Object Hierarchy

Whitespace in RoML, unlike Lua, is important.
It uses whitespace to determine which objects are children of other objects.
To add a child to an object, you have a tab in front of the object.
Take a look at the following RoML:

```
%Model
	%Part
	%Part
		%ClickDetector
	%Part
```

This RoML file is creating 5 different ROBLOX objects.
The `Model` object is at the very top of our hiearchy here and has 3 `Part` children.
The second `Part` also has a `ClickDetector` child.
To do the same thing with ROBLOX Lua, you would write:

	model = Instance.new("Model")
	Instance.new("Part", model)
	part2 = Instance.new("Part", model)
	Instance.new("ClickDetector", part2)
	Instance.new("Part", model)

From this you may start to see how much typing time you can save using RoML, but we can still do more!

## Setting Object Properties

To set properties of an object, you use curly braces (`{}`) after the object.
Inside the braces, you place any number of name-value pairs (`name: value`) separated by a semi-colon (`;`).
In the next example, we set a few properties on a part:

```
%Part{Name: "My Part"; BrickColor: BrickColor.new(1001); Size: Vector3.new(1.2, 1.2, 1.2)}
```

The property names and values are exactly the same as they are in ROBLOX. To do the above example in ROBLOX Lua:

	part = Instance.new("Part")
	part.Name = "My Part"
	part.BrickColor = BrickColor.new(1001)
	part.Size = Vector3.new(1.2, 1.2, 1.2)

## Property Shorthand

As you saw, setting obect properties like this does not save too much typing.
As such, RoML allows you to abbreviate the values for certain properties.
Before going over these rules, take a look at the previous example, but with shorthand property values:

```
%Part{Name: "My Part"; BrickColor: 1001; Size: 1.2}
```

### Position and Size

Abbreviating Position and Size property values changes based on whether the object is a Gui object or not.

#### Is a Gui Object

For Gui objects, which accept a UDim2 value, the following rules apply:

* If 2 numbers are used, they are used as the XOffset and YOffset: `16, 37` &rarr; `UDim2.new(0, 16, 0, 37)`
* If 4 numbers are used, they are used as the 4 arguments for the constructor: `0.3, 16, 0.6, 37` &rarr; `UDim2.new(0.3, 16, 0.6, 37)`
* Otherwise, the input is used as-is. Currently, RoML assumes this is the UDim2 constructor, otherwise ROBLOX will throw an error: `UDim2.new(0.3, 16, 0.6, 37)` &rarr; `UDim2.new(0.3, 16, 0.6, 37)`

#### Is Not a Gui Object

For any other object with a Position or Size property, which use Vector3, the following rules apply:

* If 1 number is used, it is used as the X, Y, and Z argument: `1.2` &rarr; `Vector3.new(1.2, 1.2, 1.2)`
* If 3 numbers are used, they are assumed as the X, Y, and Z argument: `1.2, 2.5, 1.6` &rarr; `Vector3.new(1.2, 2.5, 1.6)`
* Otherwise, the input is used as-is: `Vector3.new(1.2, 2.5, 1.6)` &rarr; `Vector3.new(1.2, 2.5, 1.6)`

### BrickColor and Color3

The rules for properties that use BrickColor and Color3 values are the same:

* If 1 number is used, the [BrickColor Code](http://wiki.roblox.com/index.php?title=BrickColor_codes) constructor is used: `1001` &rarr; `BrickColor.new(1001)` or `BrickColor.new(1001).Color`
* If 3 numbers are used, these are used as the R, G, & B values (in the range of [0, 255]): `123, 8, 255` &rarr; `BrickColor.new(0.4824, 0.0314, 1)` or `Color3.new(0.4824, 0.0314, 1)`
* If a [BrickColor Name](http://wiki.roblox.com/index.php?title=BrickColor_codes) is used, that constructor is used: `Teal` &rarr; `BrickColor.new("Teal")` or `BrickColor.new("Teal").Color`
* Otherwise, the input is used as-is `BrickColor.new(1001)` &rarr; `BrickColor.new(1001)` or `Color3.new(0.4824, 0.0314, 1)` &rarr; `Color3.new(0.4824, 0.0314, 1)`

### Enum Types

Propreties that accept an Enum as a value, such as `Part.TopSurface`, can be input as just the final part of the full Enum value.
For example, when setting the `TopSurface` property of a `Part`, `Weld` is interpreted  as `Enum.SurfaceType.Weld`.
You may still use the full `Enum.SurfaceType.Weld` if you wish as well, just like other shorthand properties.
