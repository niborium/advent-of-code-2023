local input_path = "input.txt"

local map = {}
for line in io.lines(input_path) do
  local row = {}
  for x in line:gmatch("(%S)") do
    table.insert(row, x)
  end
  table.insert(map, row)
end

local function moveRocks(start, finish, step, axis)
  for i = 1, #map[1] do
    local insert_pos = start
    for j = start, finish, step do
      local x, y = axis == 'x' and j or i, axis == 'x' and i or j
      if map[x][y] == "O" then
        while insert_pos ~= finish and map[axis == 'x' and insert_pos or x][axis == 'x' and y or insert_pos] == "#" do
          insert_pos = insert_pos + step
        end
        map[x][y] = "."
        map[axis == 'x' and insert_pos or x][axis == 'x' and y or insert_pos] = "O"
        insert_pos = insert_pos + step
      elseif map[x][y] == "#" then
        insert_pos = j
      end
    end
  end
end

local function north() moveRocks(1, #map, 1, 'x') end
local function south() moveRocks(#map, 1, -1, 'x') end
local function east() moveRocks(#map[1], 1, -1, 'y') end
local function west() moveRocks(1, #map[1], 1, 'y') end

local res = 0
local function load()
  for y = 1, #map[1] do
    for x = 1, #map do
      if map[x][y] == "O" then
        res = res + #map - x + 1
      end
    end
  end
end

local cache = {}
local function cached()
  for i, c in ipairs(cache) do
    local fail = false
    for x = 1, #map do
      for y = 1, #map[1] do
        if map[x][y] ~= c[x][y] then
          fail = true
          goto continue
        end
      end
    end

    if not fail then
      return true, i
    end

    ::continue::
  end

  local newcache = {}
  for x = 1, #map do
    table.insert(newcache, {})
    for y = 1, #map[1] do
      table.insert(newcache[x], map[x][y])
    end
  end
  table.insert(cache, newcache)

  return false, 0
end

local i = 1
while i <= 1000000000 do
  north()
  west()
  south()
  east()

  local cc, it = cached()
  if cc then
    local size = i - it
    i = i + (((1000000000 - i) // (size))) * size
  end

  i = i + 1
end

load()

print(res)