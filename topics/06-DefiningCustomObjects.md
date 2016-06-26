# Defining Your Own Custom Objects

## Getting Started

To define your own custom objects to use in your RoML files, you have to know how to create ROBLOX objects with Lua.
You will need to write a couple of functions that the library can use in order to create and update your custom object.

## Where to Put Your Custom Object Scripts

After installing the RoML library, there will be a folder that you can use: `game.ServerScriptService.com.blacksheepherd.customobject.user`.
Any ModuleScripts you put in this folder will be used as a custom object.
The name of the ModuleScript becomes the name of your custom object.

## What to Put In The Custom Object ModuleScript

The ModuleScript needs to return a table with a couple of functions in it.
Write these functions based on the guidelines described below.
Your custom object is a sub-class of the @{CustomObject} class, so most of the functions get passed a reference to self.

### Required Functions

These functions are REQUIRED in order for the custom object to work properly.

#### Create

The first required function is the Create function.
The function will be passed a single argument and that is the @{CustomObject} instance.
You should return a ROBLOX Instance object in this function.

The purpose of this function is to create the ROBLOX objects that you want to create from your custom object.
It is called every time your custom object is created.

As an example, here is the Create function for the library's custom SpriteSheet object:

	Create = function(self)
		frame = Instance.new("Frame")
		frame.ClipsDescendants = true
		frame.Name = "SpriteSheetFrame"

		spriteSheet = Instance.new("ImageLabel", frame)
		spriteSheet.Name = "SpriteSheet"

		return frame
	end

Note that you don't need to set the parent of the ROBLOX object you return.
The RoML library does that automatically for you.

#### UpdateProperty

The final required function is the UpdateProperty function.
Whenever a property is passed to your object, it is passed to this function.
Three arguments will be passed to this function: the @{CustomObject} (same as before), the name of the property, and the value of the property.
Nothing needs to be returned.

Any properties you don't want to accept can just be ignored.
Nothing will happen if the library tries to set these properties.

Here is the UpdateProperty function from the SpriteSheet object:

	UpdateProperty = function(self, name, value)
		frame = self:GetRobloxObject()
		
		if name == "Name" then
			frame.Name = value
		elseif name == "Position" then
			frame.Position = value
		elseif name == "SpriteSheet" then
			frame:FindFirstChild("SpriteSheet").Image = value
		elseif name == "Size" then
			frame.Size = UDim2.new(0, value.x, 0, value.y)
		elseif name == "Index"
			rows = math.floor(frame.Size.Y.Offset / 256)
			cols = math.floor(frame.Size.X.Offset / 256)
			
			x = value % self.Custom.cols
			y = math.floor(value / self.Custom.rows)

			frame:FindFirstChild("SpriteSheet").Position = UDim2.new(0, -x * frame.Size.X.Offset, 0, -y * frame.Size.Y.Offset)
		end
	end

You can call the @{RomlObject.GetRobloxObject} method on self, like in the example, to get the object you created in your Create function.

### Optional Functions

Any other functions within the table are optional. You may choose to define these functions only if your custom object needs them.

#### CreateProperties

This funciton is used to set values of properties when the object is created.
This function is passed in a reference to the @{CustomObject}.
It should return a table with the values of the properties that you want them at when the object is created.

This is the CreateProperties function from the SpriteSheet object:

	CreateProperties = function(self)
		return {
			Size = Vector2.new(256, 256)
		}
	end

The Size is set in this function since the calculation for the Index property relies on the Size.

#### PropertyUpdateOrder

This function is used to tell the library the order in which to update properties.
Again, this function is passed in a reference to the @{CustomObject}.
The function returns an array with the name of each property, in the order they should be updated.
If you do define this function, make sure to include all property names in the array, otherwise not all properties will get updated.

Here is the example from the SpriteSheet:

	PropertyUpdateOrder = function(self)
		return {"Name", "Position", "SpriteSheet", "Size", "Index"}
	end

Most of the order doesn't matter.
For the Index property, however, it is important that it gets updated after the Size gets updated since the calculations rely on the Size property.

#### AllowsChildren

This function tells the library whether or not the object should allow children objects.
Again, this function is passed in a reference to the @{CustomObject}.
It should return a boolean.
If you don't define this function, it will allow children by default.

SpriteSheet example:

	AllowsChildren = function(self)
		return false
	end

If the object doesn't allow children, an error will be thrown if one is attempted to be added.

#### FilterProperty

The final optional function allows you to define shorthand property values, just like the RoML library allows.
This function is called while the RoML or RoSS file is being compiled, but not a run time. In the future, property filters may be added during run time.
The arguments passed to the function are the name of the property, the value of the property (as a string), the @{LiteralString} class, and the @{CompilerPropertyFilter} module.
The function must return a @{LiteralString}, which is why the class is passed to the function.
You may also use the Filter functions in the @{CompilerPropertyFilter} module (which return a @{LiteralString}) to help.

If you don't want to filter a property, just return a @{LiteralString} of the value. The library handles the rest.
Once again, here is the FilterProperty function from the SpriteSheet object:

	FilterProperty = function(name, value, LiteralString, CompilerPropertyFilter)
		if name == "Position" then
			CompilerPropertyFilter.UDim2Filter(value)
		elseif name == "Size" then
			CompilerPropertyFilter.Vector2Filter(value)
		else
			LiteralString(value)
		end
	end

## Full Custom Object Template

For your convenience, the contents of the custom object ModuleScript (without function bodies) is including below:

	return {
		Create = function(self)
			
		end,
		CreateProperties = function(self)
			
		end,
		PropertyUpdateOrder = function(self)
			
		end,
		UpdateProperty = function(self, name, value)
			
		end,
		FilterProperty = function(name, value, LiteralString, CompilerPropertyFilter)
			
		end,
		AllowsChildren = function(self)
			
		end
	}
