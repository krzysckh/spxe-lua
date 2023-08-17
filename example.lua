local s = require("spxe")

local w = 500
local h = 500
local pixels = s.start("Example", 500, 500, w, h)

local f = function(x, y)
  return ~x & y

  -- on luajit:
  --local bit = require("bit")
  --return bit.band(bit.bnot(x), y)
end

for y = 0, h do
  for x = 0, w do
    local cur = (y * w) + x
    local v = f(x, y) ~= 0 and 255 or 0
    pixels[cur].r = v
    pixels[cur].g = v
    pixels[cur].b = v
    pixels[cur].a = 255
  end
end

while s.run(pixels) do
  if s.key.pressed(s.keys.key_escape) then
    break
  end
end

return s.finish(pixels)
