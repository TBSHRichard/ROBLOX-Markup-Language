# Introduction to ROBLOX Markup Language (RoML)

## What is RoML?

RoML is a domain-specific language and library to aid you in creating and updating ROBLOX objects dynamically during the game.
RoML tries to to cut down on the amount of code you have to right in order to increase your production.
RoML also mimics existing languages so those who already know those languages will feel comfortable.

## Getting Started with RoML

To start, you should download the ROLBOX Studio plugin.
This can be done by either [installing the plugin from the ROBLOX website](https://www.roblox.com/ROBLOX-Markup-Language-Plugin-item?id=465414319), or by
[downloading the file from the Git repository](https://github.com/TBSHRichard/ROBLOX-Markup-Language/blob/master/bin/RoMLCompiler.rbxm?raw=true)
and adding it to your plugins folder. It can be found by clicking on Plugins > Plugins Folder within ROBLOX Studio.

## Installing the Library

Once the plugin is installed, you may then install the library on any of your places.
There is a button in the plugin (Plugins > ROBLOX Markup Language > Install).
Click on this and it will copy the required ModuleScripts into the ServerScriptService of your place.
You will have to do this for every place you want to use RoML in.

## Compiling RoML and RoSS Scripts

After you've added a few RoML and RoSS scripts to your place you must then compile them into Lua scripts.
To do this, click the compile button (Plugins > ROBLOX Markup Language > Compile).
In the Gui window that pops up, you can then add a source folder by clicking the "Add a Source Folder" button.
In the window that pops up you have two text fields, one for the source and one for the output folder (the output is optional).
Enter these values, then click the "Add" button.

Both should be in the format with a Service name first, followed by children objects separated by a period.
Consider our project has the following structure:

	@plain
	game
	 |
	 +-- ServerScriptService
	      |
	      +-- src (Folder)
	           |
	           +-- roml (Folder)
	                |
	                +-- TestRoML1.roml (ModuleScript)
	                |
	                +-- TestRoML2.roml (ModuleScript)

We have a couple of RoML scripts inside of the roml folder inside the src folder inside the ServerScriptService.
So our source folder would be: _`ServerScriptService.src.roml`_.
We could then set our output folder as _`ServerScriptService.lib.roml`_, for example.
If you don't include an output folder, the compile ModuleScripts will be placed in the same location as the source ModuleScripts.

After you have a source folder added, you can then click the "Compile" button back on the main compiler window.
The library will then attempt to parse and compile your RoML scripts into Lua scripts.
If there are any problems, the message will appear in ROBLOX Studio's output.
Once we've successfully compiled, our example project will look like this:

	@plain
	game
	 |
	 +-- ServerScriptService
	      |
	      +-- lib (Folder)
	      |    |
	      |    +-- roml (Folder)
	      |         |
	      |         +-- TestRoML1 (ModuleScript)
	      |         |
	      |         +-- TestRoML2 (ModuleScript)
	      |
	      +-- src (Folder)
	           |
	           +-- roml (Folder)
	                |
	                +-- TestRoML1.roml (ModuleScript)
	                |
	                +-- TestRoML2.roml (ModuleScript)
