----------------------------------------------------------------
-- Module for compile-time filter related methods.
--
-- @module CompilerPropertyFilter
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

local LiteralString
local lpeg

local CompilerPropertyFilter

if game
	pluginModel = script.Parent.Parent.Parent.Parent
	LiteralString = require(pluginModel.com.blacksheepherd.compile.LiteralString)
	lpeg = require(pluginModel.lulpeg.lulpeg)
else
	LiteralString = require "com.blacksheepherd.compile.LiteralString"
	lpeg = require "lpeg"

-- {{ TBSHTEMPLATE:BEGIN }}
import C, Ct, P, R from lpeg

digit = R"09"
spaces = P" " ^ 0
number = spaces * (P"-" ^ -1 * digit^0 * "." * digit^1 + P"-" ^ -1 * digit^1) / tonumber * spaces
numberDuo = number * "," * number
numberTrio = numberDuo * "," * number
numberQuartet = numberTrio * "," * number
numberQuartetOrNumberDuo = Ct(numberQuartet + numberDuo) * -1
numberTrioOrNumber = Ct(numberTrio + number) * -1
numberDuoCapture = Ct(numberDuo) * -1
colorName = C(R"AZ" * (R"AZ" + R"az" + " " + ".")^1) * -1
enumName = C(R"AZ" * (R"AZ" + R"az" + R"09")^1) * -1

isAGuiClass = (className) ->
	className == "Frame" or
	className == "ImageButton" or
	className == "TextButton" or
	className == "ImageLabel" or
	className == "TextLabel" or
	className == "Scale9Frame" or
	className == "ScrollingFrame" or
	className == "TextBox"

----------------------------------------------------------------
-- Return a UDim2 LiteralString from an input string. If the
-- string has 2 numbers separated by a comma, then these are
-- assumed to be the X and Y offsets. If there are 4 numbers
-- separated by a comma, these are assumed to be all 4
-- arguments to the UDim2 constructor. Otherwise, the string is
-- returned as-is (assumed to be Lua code constructing the
-- UDim2).
--
-- @tparam string value The input string to parse.
-- @treturn LiteralString The @{LiteralString} with a UDim2
--  constructor contained within.
----------------------------------------------------------------
UDim2Filter = (value) ->
	if match = numberQuartetOrNumberDuo\match value
		if #match == 2
			return LiteralString "UDim2.new(0, #{match[1]}, 0, #{match[2]})"
		elseif #match == 4
			return LiteralString "UDim2.new(#{match[1]}, #{match[2]}, #{match[3]}, #{match[4]})"
	else
		return LiteralString value

----------------------------------------------------------------
-- Return a Vector2 LiteralString from an input string. If the
-- string has 2 numbers separated by a comma, then these are
-- assumed to be the X and Y parameters. Otherwise, the string
-- is returned as-is (assumed to be Lua code constructing the
-- Vector2).
--
-- @tparam string value The input string to parse.
-- @treturn LiteralString The @{LiteralString} with a Vector2
--  constructor contained within.
----------------------------------------------------------------
Vector2Filter = (value) ->
	if match = numberDuoCapture\match value
		return LiteralString "Vector2.new(#{match[1]}, #{match[2]})"
	else
		return LiteralString value

----------------------------------------------------------------
-- Return a Vector3 LiteralString from an input string. If the
-- string has 1 number separated, then this number is used for
-- the X, Y, and Z parameters. If there are 3 numbers separated
-- by a comma, these are assumed to be the X, Y, and Z
-- parameters. Otherwise, the string is returned as-is (assumed
-- to be Lua code constructing the Vector3).
--
-- @tparam string value The input string to parse.
-- @treturn LiteralString The @{LiteralString} with a Vector3
--  constructor contained within.
----------------------------------------------------------------
Vector3Filter = (value) ->
	if match = numberTrioOrNumber\match value
		if #match == 1
			return LiteralString "Vector3.new(#{match[1]}, #{match[1]}, #{match[1]})"
		elseif #match == 3
			return LiteralString "Vector3.new(#{match[1]}, #{match[2]}, #{match[3]})"
	else
		return LiteralString value

----------------------------------------------------------------
-- Parses a string for a Position or Size parameter. If the
-- class is a Gui class, then the @{UDim2Filter} is used.
-- Otherwise the @{Vector3Filter} is used.
--
-- @tparam string className The name of the object's class.
-- @tparam string value The input string to parse.
-- @treturn LiteralString The @{LiteralString} with a UDim2 or
--  Vector3 constructor contained within.
----------------------------------------------------------------
PositionAndSizeFilter = (className, value) ->
	if isAGuiClass className
		return UDim2Filter value
	else
		return Vector3Filter value

----------------------------------------------------------------
-- Return a BrickColor LiteralString from an input string. If
-- string has 1 number, this is assumed to be a
-- [BrickColor code](wiki.roblox.com/index.php?title=BrickColor_codes).
-- If there are 3 numbers separated by a comma, these are
-- assumed to be the R, G, and B values, in the range of
-- [0, 255]. If there is a name, this is assumed to be a
-- [BrickColor name](wiki.roblox.com/index.php?title=BrickColor_codes).
-- Otherwise the string is returned as-is (assumed to be Lua
-- code with a BrickColor constructor).
--
-- @tparam string className The name of the object's class.
-- @tparam string value The input string to parse.
-- @treturn LiteralString The @{LiteralString} with a BrickColor
--  constructor contained within.
----------------------------------------------------------------
BrickColorFilter = (className, value) ->
	if match = numberTrioOrNumber\match value
		if #match == 1
			return LiteralString "BrickColor.new(#{match[1]})"
		elseif #match == 3
			return LiteralString "BrickColor.new(#{match[1] / 255}, #{match[2] / 255}, #{match[3] / 255})"
	else
		if match = colorName\match value
			return LiteralString "BrickColor.new(\"#{value}\")"
		else
			return LiteralString value

----------------------------------------------------------------
-- Return a Color3 LiteralString from an input string. It has
-- the same rules as @{BrickColorFilter}, except for returning
-- the string as-is; a Color3 constructor is assumed as input
-- in that case (instead of a BrickColor).
--
-- @tparam string className The name of the object's class.
-- @tparam string value The input string to parse.
-- @treturn LiteralString The @{LiteralString} with a Color3
--  constructor contained within.
----------------------------------------------------------------
Color3Filter = (className, value) ->
	if match = numberTrioOrNumber\match value
		if #match == 1
			return LiteralString "BrickColor.new(#{match[1]}).Color"
		elseif #match == 3
			return LiteralString "Color3.new(#{match[1] / 255}, #{match[2] / 255}, #{match[3] / 255})"
	else
		if match = colorName\match value
			return LiteralString "BrickColor.new(\"#{value}\").Color"
		else
			return LiteralString value

----------------------------------------------------------------
-- Return a function for a Enum LiteralString filter from an
-- input string. The filter returned has the same parameters as
-- the @{BrickColorFilter} & @{Color3Filter}. If the input
-- string to the filter is a single enum name, the string is
-- returned as Enum.(enumType).(enumValue). Otherwise, the
-- string is returned as-is (assuming that the input was the
-- full enum value).
--
-- @tparam string enum The name of the enum group.
-- @treturn function A filter functions with className and
--  value parameters which returns a @{LiteralString} with an
--  Enum value contained within.
----------------------------------------------------------------
EnumFilter = (enum) ->
	(className, value) ->
		if match = enumName\match value
			return LiteralString "Enum.#{enum}.#{value}"
		else
			return LiteralString value

----------------------------------------------------------------
-- A specific enum filter for the 'Style' enum type. There are
-- 4 different ROBLOX classes that use this enum.
--
-- @tparam string className The name of the object's class.
-- @tparam string value The input string to parse.
-- @treturn LiteralString The @{LiteralString} with a Enum
--  value contained within.
----------------------------------------------------------------
StyleEnumFilter = (className, value) ->
	return switch className
		when "ImageButton", "TextButton"
			EnumFilter("ButtonStyle")(className, value)
		when "Frame"
			EnumFilter("FrameStyle")(className, value)
		when "Handles"
			EnumFilter("HandlesStyle")(className, value)
		when "TrussPart"
			EnumFilter("Style")(className, value)
		else
			LiteralString value

propertyFilters =
	AnimationPriority: EnumFilter "AnimationPriority"
	BackgroundColor3: Color3Filter
	BackSurface: EnumFilter "SurfaceType"
	BackSurfaceInput: EnumFilter "InputType"
	BinType: EnumFilter "BinType"
	BodyPart: EnumFilter "BodyPart"
	BorderColor3: Color3Filter
	BottomSurface: EnumFilter "SurfaceType"
	BottomSurfaceInput: EnumFilter "InputType"
	BrickColor: BrickColorFilter
	CameraMode: EnumFilter "CameraMode"
	CameraType: EnumFilter "CameraType"
	Color: Color3Filter
	DisplayDistanceType: EnumFilter "HumanoidDisplayDistanceType"
	ExplosionType: EnumFilter "ExplosionType"
	Face: EnumFilter "NormalId"
	FaceId: EnumFilter "NormalId"
	Font: EnumFilter "Font"
	FontSize: EnumFilter "FontSize"
	FormFactor: EnumFilter "FormFactor"
	FrontSurface: EnumFilter "SurfaceType"
	FrontSurfaceInput: EnumFilter "InputType"
	InOut: EnumFilter "InOut"
	LeftRight: EnumFilter "LeftRight"
	LeftSurface: EnumFilter "SurfaceType"
	LeftSurfaceInput: EnumFilter "InputType"
	Material: EnumFilter "Material"
	MeshType: EnumFilter "MeshType"
	NameOcclusion: EnumFilter "NameOcclusion"
	Position: PositionAndSizeFilter
	Purpose: EnumFilter "DialogPurpose"
	RightSurface: EnumFilter "SurfaceType"
	RightSurfaceInput: EnumFilter "InputType"
	SecondaryColor: Color3Filter
	Shape: EnumFilter "PartType"
	Size: PositionAndSizeFilter
	SizeConstraint: EnumFilter "SizeConstraint"
	SparkleColor: Color3Filter
	Style: StyleEnumFilter
	TextXAlignment: EnumFilter "TextXAlignment"
	TextYAlignment: EnumFilter "TextYAlignment"
	Tone: EnumFilter "DialogTone"
	TargetSurface: EnumFilter "NormalId"
	TextColor3: Color3Filter
	TextStrokeColor3: Color3Filter
	TopBottom: EnumFilter "TopBottom"
	TopSurface: EnumFilter "SurfaceType"
	TopSurfaceInput: EnumFilter "InputType"

----------------------------------------------------------------
-- Filter a property if there is a filter available, or output
-- the property as-is.
--
-- @tparam string className The name of the ROBLOX object's
--	class.
-- @tparam string propertyName The name of the Property.
-- @tparam string propertyValue The value of the Property.
----------------------------------------------------------------
FilterProperty = (className, propertyName, propertyValue) ->
	if filter = propertyFilters[propertyName]
		filter className, propertyValue
	else
		LiteralString propertyValue

CompilerPropertyFilter = {
	:BrickColorFilter, :Color3Filter, :EnumFilter, :FilterProperty, :PositionAndSizeFilter, :StyleEnumFilter,
	:UDim2Filter, :Vector2Filter, :Vector3Filter
}
-- {{ TBSHTEMPLATE:END }}

return CompilerPropertyFilter
