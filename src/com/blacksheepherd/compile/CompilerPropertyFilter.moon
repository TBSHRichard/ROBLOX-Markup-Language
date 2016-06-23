----------------------------------------------------------------
-- Module for compile-time filter related methods.
--
-- @module CompilerPropertyFilter
-- @author Richard Voelker
-- @license MIT
----------------------------------------------------------------

LiteralString = require "com.blacksheepherd.compile.LiteralString"
lpeg = require "lpeg"

import C, Ct, P, R from lpeg

digit = R"09"
spaces = P" " ^ 0
number = spaces * (digit^0 * "." * digit^1 + digit^1) / tonumber * spaces
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

Udim2Filter = (value) ->
	if match = numberQuartetOrNumberDuo\match value
		if #match == 2
			return LiteralString "UDim2.new(0, #{match[1]}, 0, #{match[2]})"
		elseif #match == 4
			return LiteralString "UDim2.new(#{match[1]}, #{match[2]}, #{match[3]}, #{match[4]})"
	else
		return LiteralString value

Vector2Filter = (value) ->
	if match = numberDuoCapture\match value
		return LiteralString "Vector2.new(#{match[1]}, #{match[2]})"
	else
		return LiteralString value

Vector3Filter = (value) ->
	if match = numberTrioOrNumber\match value
		if #match == 1
			return LiteralString "Vector3.new(#{match[1]}, #{match[1]}, #{match[1]})"
		elseif #match == 3
			return LiteralString "Vector3.new(#{match[1]}, #{match[2]}, #{match[3]})"
	else
		return LiteralString value

PositionAndSizeFilter = (className, value) ->
	if isAGuiClass className
		return Udim2Filter value
	else
		return Vector3Filter value

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

EnumFilter = (enum) ->
	(className, value) ->
		if match = enumName\match value
			return LiteralString "Enum.#{enum}.#{value}"
		else
			return LiteralString value

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

{ :BrickColorFilter, :Color3Filter, :EnumFilter, :FilterProperty, :PositionAndSizeFilter, :StyleEnumFilter, :Udim2Filter, :Vector2Filter, :Vector3Filter }