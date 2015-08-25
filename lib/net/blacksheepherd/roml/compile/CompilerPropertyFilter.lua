local LiteralString = require("net.blacksheepherd.roml.compile.LiteralString")
local lpeg = require("lpeg")
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
local colorName = C(R("AZ") * (R("AZ") + R("az") + " " + ".") ^ 1) * -1
local enumName = C(R("AZ") * (R("AZ") + R("az") + R("09")) ^ 1) * -1
local isAGuiClass
isAGuiClass = function(className)
  return className == "Frame" or className == "ImageButton" or className == "TextButton" or className == "ImageLabel" or className == "TextLabel" or className == "Scale9Frame" or className == "ScrollingFrame" or className == "TextBox"
end
local udim2Filter
udim2Filter = function(value)
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
local vector3Filter
vector3Filter = function(value)
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
local positionAndSizeFilter
positionAndSizeFilter = function(className, value)
  if isAGuiClass(className) then
    return udim2Filter(value)
  else
    return vector3Filter(value)
  end
end
local brickColorFilter
brickColorFilter = function(className, value)
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
local color3Filter
color3Filter = function(className, value)
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
local enumFilter
enumFilter = function(enum)
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
local styleEnumFilter
styleEnumFilter = function(className, value)
  local _exp_0 = className
  if "ImageButton" == _exp_0 or "TextButton" == _exp_0 then
    return enumFilter("ButtonStyle")(className, value)
  elseif "Frame" == _exp_0 then
    return enumFilter("FrameStyle")(className, value)
  elseif "Handles" == _exp_0 then
    return enumFilter("HandlesStyle")(className, value)
  elseif "TrussPart" == _exp_0 then
    return enumFilter("Style")(className, value)
  else
    return LiteralString(value)
  end
end
local propertyFilters = {
  AnimationPriority = enumFilter("AnimationPriority"),
  BackgroundColor3 = color3Filter,
  BackSurface = enumFilter("SurfaceType"),
  BackSurfaceInput = enumFilter("InputType"),
  BinType = enumFilter("BinType"),
  BodyPart = enumFilter("BodyPart"),
  BorderColor3 = color3Filter,
  BottomSurface = enumFilter("SurfaceType"),
  BottomSurfaceInput = enumFilter("InputType"),
  BrickColor = brickColorFilter,
  CameraMode = enumFilter("CameraMode"),
  CameraType = enumFilter("CameraType"),
  Color = color3Filter,
  DisplayDistanceType = enumFilter("HumanoidDisplayDistanceType"),
  ExplosionType = enumFilter("ExplosionType"),
  Face = enumFilter("NormalId"),
  FaceId = enumFilter("NormalId"),
  Font = enumFilter("Font"),
  FontSize = enumFilter("FontSize"),
  FormFactor = enumFilter("FormFactor"),
  FrontSurface = enumFilter("SurfaceType"),
  FrontSurfaceInput = enumFilter("InputType"),
  InOut = enumFilter("InOut"),
  LeftRight = enumFilter("LeftRight"),
  LeftSurface = enumFilter("SurfaceType"),
  LeftSurfaceInput = enumFilter("InputType"),
  Material = enumFilter("Material"),
  MeshType = enumFilter("MeshType"),
  NameOcclusion = enumFilter("NameOcclusion"),
  Position = positionAndSizeFilter,
  Purpose = enumFilter("DialogPurpose"),
  RightSurface = enumFilter("SurfaceType"),
  RightSurfaceInput = enumFilter("InputType"),
  SecondaryColor = color3Filter,
  Shape = enumFilter("PartType"),
  Size = positionAndSizeFilter,
  SizeConstraint = enumFilter("SizeConstraint"),
  SparkleColor = color3Filter,
  Style = styleEnumFilter,
  TextXAlignment = enumFilter("TextXAlignment"),
  TextYAlignment = enumFilter("TextYAlignment"),
  Tone = enumFilter("DialogTone"),
  TargetSurface = enumFilter("NormalId"),
  TextColor3 = color3Filter,
  TextStrokeColor3 = color3Filter,
  TopBottom = enumFilter("TopBottom"),
  TopSurface = enumFilter("SurfaceType"),
  TopSurfaceInput = enumFilter("InputType")
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
  FilterProperty = FilterProperty
}
