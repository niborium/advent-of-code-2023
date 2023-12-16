local DIR_UP = 1
local DIR_RIGHT = 2
local DIR_DOWN = 3
local DIR_LEFT = 4

local function read_input(input_path)
  local map = {}
  for line in io.lines(input_path) do
    local row = {}
    for x in line:gmatch("(%S)") do
      table.insert(row, x)
    end
    table.insert(map, row)
  end
  return map
end

local function generate_key(x)
  return tostring(x[1]) .. "|" .. tostring(x[2]) .. "|" .. tostring(x[3])
end

local function advance(x, y, dir)
  if dir == DIR_UP then
    y = y + 1
  elseif dir == DIR_RIGHT then
    x = x + 1
  elseif dir == DIR_DOWN then
    y = y - 1
  elseif dir == DIR_LEFT then
    x = x - 1
  end
  return x, y
end

local function is_out_of_bounds(x, y, map)
  return x < 1 or x > #map or y < 1 or y > #map[1]
end

local function test_point(initial, map)
  local visited = {}
  local charged = {}
  local res = 0
  local beams = { initial }

  while next(beams) do
    local point = table.remove(beams, 1)
    if visited[generate_key(point)] then
      goto continue
    end

    visited[generate_key(point)] = true
    local x = point[1]
    local y = point[2]
    local dir = point[3]
    charged[generate_key({ x, y, 0 })] = true

    if map[x][y] == "|" then
      if (dir == DIR_UP or dir == DIR_DOWN) then
        local x1, y1 = advance(x, y, DIR_RIGHT)
        local x2, y2 = advance(x, y, DIR_LEFT)

        if not is_out_of_bounds(x1, y1, map) then
          table.insert(beams, { x1, y1, DIR_RIGHT })
        end
        if not is_out_of_bounds(x2, y2, map) then
          table.insert(beams, { x2, y2, DIR_LEFT })
        end
        goto continue
      end
    elseif map[x][y] == "-" then
      if (dir == DIR_RIGHT or dir == DIR_LEFT) then
        local x1, y1 = advance(x, y, DIR_UP)
        local x2, y2 = advance(x, y, DIR_DOWN)
        table.insert(beams, { x1, y1, DIR_UP })
        table.insert(beams, { x2, y2, DIR_DOWN })
        goto continue
      end
    elseif map[x][y] == "/" then
      if dir == DIR_UP then
        dir = DIR_LEFT
      elseif dir == DIR_RIGHT then
        dir = DIR_DOWN
      elseif dir == DIR_DOWN then
        dir = DIR_RIGHT
      elseif dir == DIR_LEFT then
        dir = DIR_UP
      end
    elseif map[x][y] == "\\" then
      if dir == DIR_UP then
        dir = DIR_RIGHT
      elseif dir == DIR_RIGHT then
        dir = DIR_UP
      elseif dir == DIR_DOWN then
        dir = DIR_LEFT
      elseif dir == DIR_LEFT then
        dir = DIR_DOWN
      end
    end

    x, y = advance(x, y, dir)
    if not is_out_of_bounds(x, y, map) then
      table.insert(beams, { x, y, dir })
    end

    ::continue::
  end

  for x = 1, #map do
    for y = 1, #map[1] do
      if charged[generate_key({ x, y, 0 })] then
        res = res + 1
      end
    end
  end

  return res
end

local function main()
  local input_path = "input.txt"
  local map = read_input(input_path)
  local res = 0

  for x = 1, #map do
    res = math.max(res, test_point({ x, 1, DIR_UP }, map))
    res = math.max(res, test_point({ x, #map[1], DIR_DOWN }, map))
  end

  for y = 1, #map[1] do
    res = math.max(res, test_point({ 1, y, DIR_RIGHT }, map))
    res = math.max(res, test_point({ #map, y, DIR_LEFT }, map))
  end

  print(res)
end

main()