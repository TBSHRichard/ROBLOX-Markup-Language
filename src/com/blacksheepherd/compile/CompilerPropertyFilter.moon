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

udim2Filter = (value) ->
	if match = numberQuartetOrNumberDuo\match value
		if #match == 2
			return LiteralString "UDim2.new(0, #{match[1]}, 0, #{match[2]})"
		elseif #match == 4
			return LiteralString "UDim2.new(#{match[1]}, #{match[2]}, #{match[3]}, #{match[4]})"
	else
		return LiteralString value

vector3Filter = (value) ->
	if match = numberTrioOrNumber\match value
		if #match == 1
			return LiteralString "Vector3.new(#{match[1]}, #{match[1]}, #{match[1]})"
		elseif #match == 3
			return LiteralString "Vector3.new(#{match[1]}, #{match[2]}, #{match[3]})"
	else
		return LiteralString value

positionAndSizeFilter = (className, value) ->
	if isAGuiClass className
		return udim2Filter value
	else
		return vector3Filter value

brickColorFilter = (className, value) ->
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

color3Filter = (className, value) ->
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

enumFilter = (enum) ->
	(className, value) ->
		if match = enumName\match value
			return LiteralString "Enum.#{enum}.#{value}"
		else
			return LiteralString value

styleEnumFilter = (className, value) ->
	return switch className
		when "ImageButton", "TextButton"
			enumFilter("ButtonStyle")(className, value)
		when "Frame"
			enumFilter("FrameStyle")(className, value)
		when "Handles"
			enumFilter("HandlesStyle")(className, value)
		when "TrussPart"
			enumFilter("Style")(className, value)
		else
			LiteralString value

propertyFilters =
	AnimationPriority: enumFilter "AnimationPriority"
	BackgroundColor3: color3Filter
	BackSurface: enumFilter "SurfaceType"
	BackSurfaceInput: enumFilter "InputType"
	BinType: enumFilter "BinType"
	BodyPart: enumFilter "BodyPart"
	BorderColor3: color3Filter
	BottomSurface: enumFilter "SurfaceType"
	BottomSurfaceInput: enumFilter "InputType"
	BrickColor: brickColorFilter
	CameraMode: enumFilter "CameraMode"
	CameraType: enumFilter "CameraType"
	Color: color3Filter
	DisplayDistanceType: enumFilter "HumanoidDisplayDistanceType"
	ExplosionType: enumFilter "ExplosionType"
	Face: enumFilter "NormalId"
	FaceId: enumFilter "NormalId"
	Font: enumFilter "Font"
	FontSize: enumFilter "FontSize"
	FormFactor: enumFilter "FormFactor"
	FrontSurface: enumFilter "SurfaceType"
	FrontSurfaceInput: enumFilter "InputType"
	InOut: enumFilter "InOut"
	LeftRight: enumFilter "LeftRight"
	LeftSurface: enumFilter "SurfaceType"
	LeftSurfaceInput: enumFilter "InputType"
	Material: enumFilter "Material"
	MeshType: enumFilter "MeshType"
	NameOcclusion: enumFilter "NameOcclusion"
	Position: positionAndSizeFilter
	Purpose: enumFilter "DialogPurpose"
	RightSurface: enumFilter "SurfaceType"
	RightSurfaceInput: enumFilter "InputType"
	SecondaryColor: color3Filter
	Shape: enumFilter "PartType"
	Size: positionAndSizeFilter
	SizeConstraint: enumFilter "SizeConstraint"
	SparkleColor: color3Filter
	Style: styleEnumFilter
	TextXAlignment: enumFilter "TextXAlignment"
	TextYAlignment: enumFilter "TextYAlignment"
	Tone: enumFilter "DialogTone"
	TargetSurface: enumFilter "NormalId"
	TextColor3: color3Filter
	TextStrokeColor3: color3Filter
	TopBottom: enumFilter "TopBottom"
	TopSurface: enumFilter "SurfaceType"
	TopSurfaceInput: enumFilter "InputType"

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

{ :FilterProperty }