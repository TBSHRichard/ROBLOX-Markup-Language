# ROBLOX Markup Language
Custom languages ROBLOX Markup Language (RoML) and ROBLOX Style Sheets (RoSS) writen specifically for ROBLOX to aid in powerful, dynamic object creation.

## RoML
RoML is based off of the Ruby gem HAML which provides a nicer format for HTML pages. Instead of compiling into HTML, RoML compiles into Lua and can be placed within a ROBLOX ModuleScript to be included in your code.

Instead of HTML elements, RoML uses ROBLOX objects as its elements. For example, we can define a RoML file that creates a simple Model.

```
%Model{Name: MyModel}
	%Part.red
	%Part{Name: Blue Part, BrickColor: BrightBlue, Position: 0, 5, 0}
```

## RoSS
RoSS is based off of CSS and, like RoML, compiles into Lua. RoSS can be applied to a RoML object and will style objects based off of matches. For example, we can have a RoSS script to help us style our RoML above.

```
.red
	BrickColor: BrightRed
	Name: Red Part
```

RoSS scripts can be applied to RoML objects to dynamically update the styles that they apply to as well. RoSS works with RoML to keep duplicate styles in one place and easily update mass Properties at once. Inline RoML Properties take precedence over RoSS Properties.

## Disclaimer & License

This project is not created by the ROBLOX team. Just a game developer on ROBLOX who wanted an easier way to create and update objects from scripts.

License: [MIT](https://github.com/TBSHRichard/ROBLOX-Markup-Language/blob/master/LICENSE)
