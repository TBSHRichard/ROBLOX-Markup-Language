# ROBLOX Style Sheets

## Introduction to ROBLOX Style Sheets

ROBLOX Style Sheets (RoSS) is another small language defined by the RoML library.
It is used to set properties of objects created by RoML.
If you've used CSS, RoSS is designed to work very similar.

## Selectors

To be able to set properties of an object, we must first write a selector to know which objects the properties belong to.
A selector has an optional object name, followed by a class name or an id name.
Below are a few examples.

* Object selector: `Part`
* Class selector: `.Red`
* Id selector: `#Part1`
* Object with class selector: `Part.Red`
* Object with id selector: `Part#Part1`

Each property you set is on it's own line.
Like RoML, whitespace matters in RoSS.
Properties that are tabbed and below a selector line are associated with that selector:

```
Part.White
	Name: "White Part"
	BrickColor: 1001
```

As you can see, short hand properties work here as well.
There are some extra rules you should note, however:

* If the property is Position or Size, you must include the object name otherwise it will assume a Vector3 even for Gui classes.
* If the property is the Style Enum, you must also include the object name because there are 4 different Style Enums depending on the ROBLOX object.
* If the object is a custom object, you must include the object name so that the custom object's filters can be used.

Other than that, the object name is optional.

## Selecting Children

Selecting children within a large structure is not all that much more difficult.
Just simply include multiple selectors, separated by a space.
Take the following RoML file for example:

```
%Model
	%Part#Part1
%Part#Part2
```

And the following RoSS file:

```
Model Part
	BrickColor: Bright red
```

Only the `Part` with the id of "Part1" would be colored red.
This is because the `Part` with id of "Part2" is not a child of a `Model` object.

## Setting the RossDoc

We can set an initial RossDoc in the constructor for our RomlDoc, just like variables.
Let's take a look at the project structure for this example assuming our RoML and RoSS are the examples from the last section:

	@plain
	game
	 |
	 +-- ServerScriptService
	      |
	      +-- lib (Folder)
	      |    |
	      |    +-- roml (Folder)
	      |    |    |
	      |    |    +-- StyledRoML (ModuleScript)
	      |    |
	      |    +-- ross (Folder)
	      |         |
	      |         +-- TestRoSS (ModuleScript)
	      |
	      +-- src (Folder)
	           |
	           +-- roml (Folder)
	           |    |
	           |    +-- StyledRoML.roml (ModuleScript)
	           |
	           +-- ross (Folder)
	                |
	                +-- TestRoSS.ross (ModuleScript)

So now we may set our RoSS file when constructing our RoML:

	local StyledRoML = require(game.ServerScriptService.lib.roml.StyledRoML)
	local TestRoSS = require(game.ServerScriptServer.lib.ross.TestRoSS)
	
	StyledRoML.new(game.Workspace, {}, TestRoSS.new())

But we may also update the style sheet at runtime, just like we can with variables.
Let's create another RoSS script, TestRoSS2:

```
Model Part
	BrickColor: 1001
```

Then we can use the @{RomlDoc.SetStyleSheet} to change the style sheet:

	local StyledRoML = require(game.ServerScriptService.lib.roml.StyledRoML)
	local TestRoSS = require(game.ServerScriptServer.lib.ross.TestRoSS)
	local TestRoSS2 = require(game.ServerScriptServer.lib.ross.TestRoSS2)
	
	styledRoML = StyledRoML.new(game.Workspace, {}, TestRoSS.new())
	
	wait(5)
	
	styledRoML:SetStyleSheet(TestRoSS2.new())

After 5 seconds, the `Part` inside the `Model` changes from red to white!

## When to Use RoSS

So there are two methods of setting properties inside of the RoML library.
There is not correct way to set them, but I suggest using the following rules of thumb to know when to set properties inside the RoML or RoSS files:

* If the property is a variable property, use RoML.
* Otherwise, use RoSS.

With these rules, you can help keep your code neat and organized.
