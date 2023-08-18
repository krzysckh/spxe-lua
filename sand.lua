local s = require("spxe")

local w
if (type(jit) == 'table') then
  -- luajit is much faster
  w = 128
else
  w = 64
end

local h = w

local bg = { r = 0, g = 0, b = 255, a = 255 }
local sand = { r = 255, g = 255, b = 0, a = 255 }
local rock = { r = 64, g = 64, b = 64, a = 255 }

-- there are no enums in lua...?
local mode = {
  d_sand = 0,
  d_rock = 1,
}

local pixels = s.start("sand example", 500, 500, w, h)
local current_mode = mode.d_sand

local color_by_mode = function(m)
  if m == mode.d_sand then return sand end
  if m == mode.d_rock then return rock end

  error("no such mode")
end

local is = function(p, c)
  return p.r == c.r and p.g == c.g and p.b == c.b
end

local get = function(x, y)
  return (y * w) + x
end

local set = function(x, y, c)
  local cur = get(x, y)
  pixels[cur].r = c.r
  pixels[cur].g = c.g
  pixels[cur].b = c.b
  pixels[cur].a = c.a
end

local fillbg = function()
  for y = 0, h - 1 do
    for x = 0, w - 1 do
      set(x, y, bg)
    end
  end
end

local update_pixels = function()
  local cur

  local goleft = function(x, y)
    set(x, y, bg)
    set(x - 1, y - 1, sand)
  end

  local goright = function(x, y)
    set(x, y, bg)
    set(x + 1, y - 1, sand)
  end

  for y = 0, h - 1 do
    for x = 0, w - 1 do
      cur = get(x, y)
      if is(pixels[cur], sand) then
        if y - 1 >= 0 then
          if is(pixels[get(x, y - 1)], sand) then
            if x - 1 >= 0 and is(pixels[get(x - 1, y - 1)], bg) then
              goleft(x, y)
            elseif x + 1 < w and is(pixels[get(x + 1, y - 1)], bg) then
              goright(x, y)
            end
          elseif is(pixels[get(x, y - 1)], bg) then
            set(x, y, bg)
            set(x, y - 1, sand)
          end
        end
      end
    end
  end
end

fillbg()
while s.run(pixels) do
  update_pixels()
  if s.key.pressed(s.keys.key_escape) then break end
  if s.key.pressed(s.keys.key_r) then fillbg() end
  if s.mouse.pressed(s.mouse.buttons.button_right) then
    current_mode = current_mode == mode.d_sand and mode.d_rock or mode.d_sand
  end
  if s.mouse.down(s.mouse.buttons.button_left) then
    local pos = s.mouse.pos()
    if (pos.x < h and pos.y < w) then
      set(pos.x, pos.y, color_by_mode(current_mode))
    end
  end
end

return s.finish(pixels)
