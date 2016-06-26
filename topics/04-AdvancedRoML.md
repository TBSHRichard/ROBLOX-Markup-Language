# Advanced RoML Topics

## Ids

You can assign an id to an object.
You should do this if you want to easily find an object within a RoML doc (to add an Event listener, for example).
All ids are stored in a table, so find objects with an id take the least time.
And object can only have one id, but they are added to an object by using the pound symbol (`#`) followed by the id name:

```
%Part#Id
```

Ids must be unique within a RoML file.
If you have two objects with the same id, the last one will be stored.

## Classes

Classes are similar to ids, but these are more useful when setting properties via a RoSS file (discussed in topic 5: RoSS).
An object can have any number of classes.
Classes are defined like ids, but with a period (`.`) instead of the pound symbol:

```
%Part.Class1.Class2
```

## Finding an Object

Currently in v0.1 of the library, the functionality for finding objects is not available.

## Cloning Existing Objects

To clone an existing ROBLOX object, you can include the location of the object in parentheses after the object name.
This is helpful for objects like `Script`s which cannot have certain properties set during the game.

For example, let's say we have a `Script` called `MyScript` which already exists in our `Workspace`.
If we wanted to Clone it, we could write:

```
%Script(game.Workspace.MyScript)
```

If you want to clone a custom object, you must make sure that the structure of your clone object is the same as the structure created by the custom object.
There may be some errors otherwise.

## Full Object Line

Here is the format of a full object line:

```
%ObjectName(CloneSource)#Id.Classes{Properties}
```

Currently, the order of the CloneSource, Id, Classes, and Properties cannot be changed.
Future versions may allow for different orders.

## Property Variable

Variables are one way of updating your RoML structure.
They can be used in several areas, one of which being the value for a property.
When you have a variable as a property value, the property is updated every time you update the variable.
To define a variable, use the at symbol (`@`) before a variable name (letter or underscore followed by any number of letters, numbers, or underscores):

```
Part{BrickColor: @color}
```

## Setting a Variable

If you remember back to the constructor of the RoMLDoc, the second parameter is an optional table with initial variable values.
By setting values in this table when the RoML is created, these values are used at first.

For this example, will have a similar project structure as before:

	@plain
	game
	 |
	 +-- ServerScriptService
	      |
	      +-- lib (Folder)
	      |    |
	      |    +-- roml (Folder)
	      |         |
	      |         +-- VariableRoML (ModuleScript)
	      |
	      +-- src (Folder)
	           |
	           +-- roml (Folder)
	                |
	                +-- VariableRoML.roml (ModuleScript)

Here is an example using the VariableRoML, the example from the previous section:

	local VariableRoML = require(game.ServerScriptService.lib.roml.VariableRoML)
	
	VariableRoML.new(game.Workspace, {
		color = BrickColor.new(1001)
	})

The second argument is our variable table where we set the inital value of the color variable.
This creates a `Part` in the `Workspace` with a BrickColor of white.

But that seems like a lot of work, we could have just set the BrickColor right in the RoML file, so what's the point?
Well, the helpful feature of variables allows you to change them at any time, and the library will update the appropriate ROBLOX objects.

Here's the same example as above, but changing the variable after waiting a few seconds:

	local VariableRoML = require(game.ServerScriptService.lib.roml.VariableRoML)
	
	variableRoML = VariableRoML.new(game.Workspace, {
		color = BrickColor.new(1001)
	})
	
	wait(5)
	
	variableRoML:GetVar("color"):SetValue(BrickColor.new("Olive"))

So this example creates a `Part` in the `Workspace` with the BrickColor of white just like before.
But, after 5 seconds, the `Part` will have a BrickColor of olive!

Here, we use @{RomlDoc.GetVar} in order to get our variable.
Then, we can call @{RomlVar.SetValue} to set the value of the variable.
Note that we cannot use shorthand values in @{RomlVar.SetValue}.
In future versions of the library, this may be allowed, but not right now.

## Having a Variable for Classes

If you want, you can use a single variable for your classes.
The variable is assumed to be an array-styled table.
The following example has a `Part` with the classes in the `partClasses` variable:

```
%Part.@partClasses
```

Just make sure you pass a table when setting the variable value.

## Conditional Blocks

With variables, you can create conditional blocks to display certain objects when the variable is a specific value.
They work the same as they do in Lua, so not much new to learn here!
Take a look at this example:

```
if @visits > 5
	%TextLabel{Text: "We've gotten a few visits today."}
elseif @visits > 500
	%TextLabel{Text: "We've gotten a lot of visits today!"}
```

Every time the variable `visits` is updated in the example, the statement is checked.
Just like Lua, if the condition is `true`, then the block is executed.
If the `visits` has a value less than 5, no `TextLabel` is created.
Once `visits` gets more than 5, the `TextLabel` is created.
With more than 500, a `TextLabel` with different text is created.

You can have as many `elseif` statements as you want, there is also an `else` statement just like Lua, and you can have conditionals within other conditional blocks.
There is also the option of using `unless` and `elseunless` instead of of `if` and `elseif`.
`unless condition` is the same as `if not(condition)` and `elseunless condition` is the same as `elseif not(condition)`.

## For Blocks

The for blocks in RoML use the pairs iterator.
A for statement has one or two variable names followed by a RoML variable that is assumed to have a table value:

Let's say the variable `names` is the following table:

```
{
	"Part Bob",
	"Part Steve",
	"Part Harry"
}
```

Then, in RoML we can iterate over each:

```
for name in @names
	%Part{Name: name}
```

This RoML creates 3 `Part`s with the names of "Part Bob", "Part Steve", and "Part Harry".
Of course you can have for blocks and conditional blocks within for blocks as well.
If you need the key of each element, you can have two variable names:

```
for index, name in @names
	%Part{Name: "[" .. index .. "]" .. name}
```

The `Part` names this time would be "[1] Part Bob", "[2] Part Steve", and "[3] Part Harry".
