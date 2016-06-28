return {
  Create = function(self)
    local frame = Instance.new("Frame")
    frame.ClipsDescendants = true
    frame.Name = "SpriteSheetFrame"
    local spriteSheet = Instance.new("ImageLabel", frame)
    spriteSheet.Name = "SpriteSheet"
    return frame
  end,
  CreateProperties = function(self)
    return {
      Size = Vector2.new(256, 256)
    }
  end,
  PropertyUpdateOrder = function(self)
    return {
      "Name",
      "Position",
      "SpriteSheet",
      "Size",
      "Index"
    }
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
      frame.Name = value
    elseif "Position" == _exp_0 then
      frame.Position = value
    elseif "SpriteSheet" == _exp_0 then
      frame:FindFirstChild("SpriteSheet").Image = value
    elseif "Size" == _exp_0 then
      frame.Size = UDim2.new(0, value.x, 0, value.y)
    elseif "Index" == _exp_0 then
      local rows = math.floor(frame.Size.Y.Offset / 256)
      local cols = math.floor(frame.Size.X.Offset / 256)
      local x = value % cols
      local y = math.floor(value / rows)
      frame:FindFirstChild("SpriteSheet").Position = UDim2.new(0, -x * frame.Size.X.Offset, 0, -y * frame.Size.Y.Offset)
    end
  end,
  AllowsChildren = function(self)
    return false
  end
}
