local input_path = "input.txt"
local res = 0
local map = {}

for line in io.lines(input_path) do
  local row = {}
  for x in line:gmatch("(%S)") do
    table.insert(row, x)
  end
  table.insert(map, row)
end

local function key(x)
  return tostring(x[1]) .. "|" .. tostring(x[2]) .. "|" .. tostring(x[3])
end

local directions = { {0, 1}, {1, 0}, {0, -1}, {-1, 0} }

local function advance(x, y, dir)
  x = x + directions[dir][1]
  y = y + directions[dir][2]
  return x, y
end

local function fall(x, y)
  if x < 1 or x > #map or y < 1 or y > #map[1] then
    return true
  end
  return false
end

local beams = {
  { 1, 1, 1 }
}

local visited = {}
local charged = {}
local dir_changes = {
  ["/"] = {4, 3, 2, 1},
  ["\\"] = {2, 1, 4, 3}
}

while next(beams) do
  local point = table.remove(beams, 1)
  if visited[key(point)] then
    goto continue
  end

  visited[key(point)] = true
  local x = point[1]
  local y = point[2]
  local dir = point[3]
  charged[key({ x, y, 0 })] = true

  if map[x][y] == "|" then
    if (dir == 1 or dir == 3) then
      local x1, y1 = advance(x, y, 2)
      local x2, y2 = advance(x, y, 4)

      if not fall(x1, y1) then
        table.insert(beams, { x1, y1, 2 })
      end
      if not fall(x2, y2) then
        table.insert(beams, { x2, y2, 4 })
      end
      goto continue
    end
  elseif map[x][y] == "-" then
    if (dir == 2 or dir == 4) then
      local x1, y1 = advance(x, y, 1)
      local x2, y2 = advance(x, y, 3)
      table.insert(beams, { x1, y1, 1 })
      table.insert(beams, { x2, y2, 3 })
      goto continue
    end
  elseif map[x][y] == "/" then
    dir = dir_changes["/"][dir]
  elseif map[x][y] == "\\" then
    dir = dir_changes["\\"][dir]
  end

  x, y = advance(x, y, dir)
  if not fall(x, y) then
    table.insert(beams, { x, y, dir })
  end

  ::continue::
end

for x = 1, #map do
  for y = 1, #map[1] do
    if charged[key({ x, y, 0 })] then
      res = res + 1
    end
  end
end

print(res)