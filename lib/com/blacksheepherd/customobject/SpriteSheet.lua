return {
  Create = function(self)
    local frame = Instance.new("Frame")
    frame.ClipsDescendants = true
    frame.Name = "SpriteSheetFrame"
    local spriteSheet = Instance.new("ImageLabel", frame)
    spriteSheet.Name = "SpriteSheet"
    return frame
  end,
  FilterProperty = function(name, value, LiteralString, CompilerPropertyFilter)
    local _exp_0 = name
    if "Position" == _exp_0 then
      return CompilerPropertyFilter.UDim2Filter(value)
    elseif "Size" == _exp_0 then
      return CompilerPropertyFilter.Vector2Filter(value)
    else
      return LiteralString(value)
    end
  end,
  SetProperty = function(self, frame, name, value)
    local _exp_0 = name
    if "Name" == _exp_0 then
      instance.Name = value
    elseif "Position" == _exp_0 then
      instance.Position = value
    elseif "SpriteSheet" == _exp_0 then
      instance:FindFirstChild("SpriteSheet").Image = value
    elseif "Size" == _exp_0 then
      instance.Size = UDim2.new(0, value.x, 0, value.y)
    elseif "Index" == _exp_0 then
      local rows = math.floor(instance.size.Y.Offset / 256)
      local cols = math.floor(instance.size.X.Offset / 256)
      local x = value % cols
      local y = math.floor(value / rows)
      instance:FindFirstChild("SpriteSheet").Position = UDim2.new(0, -x * instance.size.X.Offset, 0, -y * instance.size.Y.Offset)
    end
  end,
  AllowsChildren = function(self)
    return false
  end
}
