local input_path = "input.txt"
local blocks = {}
local forwardDependencies = {}
local backwardDependencies = {}
local map = {}
local maxX = 0
local maxY = 0

for line in io.lines(input_path) do
  for x1, y1, z1, x2, y2, z2 in line:gmatch("(%d+),(%d+),(%d+)~(%d+),(%d+),(%d+)") do
    x1, x2, y1, y2, z1, z2 = tonumber(x1), tonumber(x2), tonumber(y1), tonumber(y2), tonumber(z1), tonumber(z2)
    table.insert(blocks, { { x1, y1, z1 }, { x2, y2, z2 } })
    maxX, maxY = math.max(maxX, x1, x2), math.max(maxY, y1, y2)
  end
end

local function key(x)
  return tostring(x[1]) .. "|" .. tostring(x[2])
end

local function insertIntoMap(x, y, z, name)
  if map[key({ x, y })] and map[key({ x, y })][2] ~= name then
    local prev = map[key({ x, y })]
    if prev[1] + 1 == z then
      forwardDependencies[prev[2]] = forwardDependencies[prev[2]] or {}
      forwardDependencies[prev[2]][name] = true
      backwardDependencies[name] = backwardDependencies[name] or {}
      backwardDependencies[name][prev[2]] = true
    end
  end
  map[key({ x, y })] = { z, name }
end

local function applyBlock(block, name)
  local pos1, pos2 = table.unpack(block)
  local x1, y1, z1 = table.unpack(pos1)
  local x2, y2, z2 = table.unpack(pos2)

  -- vertical bar
  if x1 == x2 and y1 == y2 then
    local top = (map[key({ x1, y1 })] or { 0, "" })[1]
    for i = z1, z2 do
      insertIntoMap(x1, y1, top + 1 + (i - z1), name)
    end
    -- horizontal bar
  elseif x1 == x2 then
    local top = 0
    for i = y1, y2 do
      top = math.max(top, (map[key({ x1, i })] or { 0, "" })[1])
    end
    for i = y1, y2 do
      insertIntoMap(x1, i, top + 1, name)
    end
  elseif y1 == y2 then
    local top = 0
    for i = x1, x2 do
      top = math.max(top, (map[key({ i, y1 })] or { 0, "" })[1])
    end
    for i = x1, x2 do
      insertIntoMap(i, y1, top + 1, name)
    end
  end
end

table.sort(blocks, function(a, b)
  return a[1][3] < b[1][3]
end)

for i, block in ipairs(blocks) do
  applyBlock(block, i)
end

local function len(x)
  local c = 0
  for n in pairs(x) do
    c = c + 1
  end
  return c
end

local result = 0
for block, _ in ipairs(blocks) do
  if not forwardDependencies[block] then
    result = result + 1
  else
    local willRemove = true
    for dependant, _ in pairs(forwardDependencies[block]) do
      if len(backwardDependencies[dependant]) <= 1 then
        willRemove = false
        break
      end
    end
    if willRemove then
      result = result + 1
    end
  end
end

print(result)