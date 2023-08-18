local s = require("spxe")

local w = 32
local h = w

local bg = { r = 0, g = 0, b = 255, a = 255 }
local fg = { r = 255, g = 255, b = 0, a = 255 }

local pixels = s.start("sand example", 500, 500, w, h)

local is_sand = function(p)
  return p.r == fg.r and p.g == fg.g and p.b == fg.b
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
    set(x - 1, y - 1, fg)
  end

  local goright = function(x, y)
    set(x, y, bg)
    set(x + 1, y - 1, fg)
  end

  for y = 0, h - 1 do
    for x = 0, w - 1 do
      cur = get(x, y)
      --print("[" .. x .. ", " .. y .. "]")
      if is_sand(pixels[cur]) then
        if y - 1 >= 0 then
          if (is_sand(pixels[get(x, y - 1)])) then
            local o1 = x - 1 >= 0 and not is_sand(pixels[get(x - 1, y - 1)])
            local o2 = x + 1 < w and not is_sand(pixels[get(x + 1, y - 1)])

            if o1 == true and o2 == true then
              if math.random() >= 0.5 then
                goleft(x, y)
              else
                goright(x, y)
              end
            elseif o1 then goleft(x, y)
            elseif o2 then goright(x, y)
            end
          else
            set(x, y, bg)
            set(x, y - 1, fg)
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
  if s.mouse.down(s.mouse.buttons.button_1) then
    local pos = s.mouse.pos()
    if (pos.x < h and pos.y < w) then
      set(pos.x, pos.y, fg)
    end
  end
end

return s.finish(pixels)
