local LiteralString
local lpeg
if game then
  LiteralString = require(plugin.com.blacksheepherd.compile.LiteralString)
  lpeg = require(plugin.lulpeg.lulpeg)
else
  LiteralString = require("com.blacksheepherd.compile.LiteralString")
  lpeg = require("lpeg")
end
local C, Ct, P, R
C, Ct, P, R = lpeg.C, lpeg.Ct, lpeg.P, lpeg.R
local digit = R("09")
local spaces = P(" ") ^ 0
local number = spaces * (digit ^ 0 * "." * digit ^ 1 + digit ^ 1) / tonumber * spaces
local numberDuo = number * "," * number
local numberTrio = numberDuo * "," * number
local numberQuartet = numberTrio * "," * number
local numberQuartetOrNumberDuo = Ct(numberQuartet + numberDuo) * -1
local numberTrioOrNumber = Ct(numberTrio + number) * -1
local numberDuoCapture = Ct(numberDuo) * -1
local colorName = C(R("AZ") * (R("AZ") + R("az") + " " + ".") ^ 1) * -1
local enumName = C(R("AZ") * (R("AZ") + R("az") + R("09")) ^ 1) * -1
local isAGuiClass
isAGuiClass = function(className)
  return className == "Frame" or className == "ImageButton" or className == "TextButton" or className == "ImageLabel" or className == "TextLabel" or className == "Scale9Frame" or className == "ScrollingFrame" or className == "TextBox"
end
local Udim2Filter
Udim2Filter = function(value)
  do
    local match = numberQuartetOrNumberDuo:match(value)
    if match then
      if #match == 2 then
        return LiteralString("UDim2.new(0, " .. tostring(match[1]) .. ", 0, " .. tostring(match[2]) .. ")")
      elseif #match == 4 then
        return LiteralString("UDim2.new(" .. tostring(match[1]) .. ", " .. tostring(match[2]) .. ", " .. tostring(match[3]) .. ", " .. tostring(match[4]) .. ")")
      end
    else
      return LiteralString(value)
    end
  end
end
local Vector2Filter
Vector2Filter = function(value)
  do
    local match = numberDuoCapture:match(value)
    if match then
      return LiteralString("Vector2.new(" .. tostring(match[1]) .. ", " .. tostring(match[2]) .. ")")
    else
      return LiteralString(value)
    end
  end
end
local Vector3Filter
Vector3Filter = function(value)
  do
    local match = numberTrioOrNumber:match(value)
    if match then
      if #match == 1 then
        return LiteralString("Vector3.new(" .. tostring(match[1]) .. ", " .. tostring(match[1]) .. ", " .. tostring(match[1]) .. ")")
      elseif #match == 3 then
        return LiteralString("Vector3.new(" .. tostring(match[1]) .. ", " .. tostring(match[2]) .. ", " .. tostring(match[3]) .. ")")
      end
    else
      return LiteralString(value)
    end
  end
end
local PositionAndSizeFilter
PositionAndSizeFilter = function(className, value)
  if isAGuiClass(className) then
    return Udim2Filter(value)
  else
    return Vector3Filter(value)
  end
end
local BrickColorFilter
BrickColorFilter = function(className, value)
  do
    local match = numberTrioOrNumber:match(value)
    if match then
      if #match == 1 then
        return LiteralString("BrickColor.new(" .. tostring(match[1]) .. ")")
      elseif #match == 3 then
        return LiteralString("BrickColor.new(" .. tostring(match[1] / 255) .. ", " .. tostring(match[2] / 255) .. ", " .. tostring(match[3] / 255) .. ")")
      end
    else
      do
        match = colorName:match(value)
        if match then
          return LiteralString("BrickColor.new(\"" .. tostring(value) .. "\")")
        else
          return LiteralString(value)
        end
      end
    end
  end
end
local Color3Filter
Color3Filter = function(className, value)
  do
    local match = numberTrioOrNumber:match(value)
    if match then
      if #match == 1 then
        return LiteralString("BrickColor.new(" .. tostring(match[1]) .. ").Color")
      elseif #match == 3 then
        return LiteralString("Color3.new(" .. tostring(match[1] / 255) .. ", " .. tostring(match[2] / 255) .. ", " .. tostring(match[3] / 255) .. ")")
      end
    else
      do
        match = colorName:match(value)
        if match then
          return LiteralString("BrickColor.new(\"" .. tostring(value) .. "\").Color")
        else
          return LiteralString(value)
        end
      end
    end
  end
end
local EnumFilter
EnumFilter = function(enum)
  return function(className, value)
    do
      local match = enumName:match(value)
      if match then
        return LiteralString("Enum." .. tostring(enum) .. "." .. tostring(value))
      else
        return LiteralString(value)
      end
    end
  end
end
local StyleEnumFilter
StyleEnumFilter = function(className, value)
  local _exp_0 = className
  if "ImageButton" == _exp_0 or "TextButton" == _exp_0 then
    return EnumFilter("ButtonStyle")(className, value)
  elseif "Frame" == _exp_0 then
    return EnumFilter("FrameStyle")(className, value)
  elseif "Handles" == _exp_0 then
    return EnumFilter("HandlesStyle")(className, value)
  elseif "TrussPart" == _exp_0 then
    return EnumFilter("Style")(className, value)
  else
    return LiteralString(value)
  end
end
local propertyFilters = {
  AnimationPriority = EnumFilter("AnimationPriority"),
  BackgroundColor3 = Color3Filter,
  BackSurface = EnumFilter("SurfaceType"),
  BackSurfaceInput = EnumFilter("InputType"),
  BinType = EnumFilter("BinType"),
  BodyPart = EnumFilter("BodyPart"),
  BorderColor3 = Color3Filter,
  BottomSurface = EnumFilter("SurfaceType"),
  BottomSurfaceInput = EnumFilter("InputType"),
  BrickColor = BrickColorFilter,
  CameraMode = EnumFilter("CameraMode"),
  CameraType = EnumFilter("CameraType"),
  Color = Color3Filter,
  DisplayDistanceType = EnumFilter("HumanoidDisplayDistanceType"),
  ExplosionType = EnumFilter("ExplosionType"),
  Face = EnumFilter("NormalId"),
  FaceId = EnumFilter("NormalId"),
  Font = EnumFilter("Font"),
  FontSize = EnumFilter("FontSize"),
  FormFactor = EnumFilter("FormFactor"),
  FrontSurface = EnumFilter("SurfaceType"),
  FrontSurfaceInput = EnumFilter("InputType"),
  InOut = EnumFilter("InOut"),
  LeftRight = EnumFilter("LeftRight"),
  LeftSurface = EnumFilter("SurfaceType"),
  LeftSurfaceInput = EnumFilter("InputType"),
  Material = EnumFilter("Material"),
  MeshType = EnumFilter("MeshType"),
  NameOcclusion = EnumFilter("NameOcclusion"),
  Position = PositionAndSizeFilter,
  Purpose = EnumFilter("DialogPurpose"),
  RightSurface = EnumFilter("SurfaceType"),
  RightSurfaceInput = EnumFilter("InputType"),
  SecondaryColor = Color3Filter,
  Shape = EnumFilter("PartType"),
  Size = PositionAndSizeFilter,
  SizeConstraint = EnumFilter("SizeConstraint"),
  SparkleColor = Color3Filter,
  Style = StyleEnumFilter,
  TextXAlignment = EnumFilter("TextXAlignment"),
  TextYAlignment = EnumFilter("TextYAlignment"),
  Tone = EnumFilter("DialogTone"),
  TargetSurface = EnumFilter("NormalId"),
  TextColor3 = Color3Filter,
  TextStrokeColor3 = Color3Filter,
  TopBottom = EnumFilter("TopBottom"),
  TopSurface = EnumFilter("SurfaceType"),
  TopSurfaceInput = EnumFilter("InputType")
}
local FilterProperty
FilterProperty = function(className, propertyName, propertyValue)
  do
    local filter = propertyFilters[propertyName]
    if filter then
      return filter(className, propertyValue)
    else
      return LiteralString(propertyValue)
    end
  end
end
return {
  BrickColorFilter = BrickColorFilter,
  Color3Filter = Color3Filter,
  EnumFilter = EnumFilter,
  FilterProperty = FilterProperty,
  PositionAndSizeFilter = PositionAndSizeFilter,
  StyleEnumFilter = StyleEnumFilter,
  Udim2Filter = Udim2Filter,
  Vector2Filter = Vector2Filter,
  Vector3Filter = Vector3Filter
}
