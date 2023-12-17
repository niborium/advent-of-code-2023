local path = "input.txt"

local function is_less(l, r)
  for i = 1, #l do
    if l[i] < r[i] then return true
    elseif l[i] > r[i] then return false end
  end
  return false
end

local function adjust_heap(heap, i)
  local left, right = 2 * i, 2 * i + 1
  local smallest = i
  if left <= #heap and is_less(heap[left], heap[smallest]) then
    smallest = left
  end
  if right <= #heap and is_less(heap[right], heap[smallest]) then
    smallest = right
  end

  if smallest ~= i then
    heap[i], heap[smallest] = heap[smallest], heap[i]
    adjust_heap(heap, smallest)
  end
end

local function create_heap(array)
  for i = math.floor(#array / 2), 1, -1 do adjust_heap(array, i) end
  return array
end

local function push_heap(heap, value)
  table.insert(heap, value)
  local i = #heap
  while i > 1 and is_less(heap[i], heap[math.floor(i / 2)]) do
    heap[i], heap[math.floor(i / 2)] = heap[math.floor(i / 2)], heap[i]
    i = math.floor(i / 2)
  end
end

local function pop_heap(heap)
  if #heap == 0 then return nil end
  local min_val = heap[1]
  heap[1] = heap[#heap]
  table.remove(heap)
  adjust_heap(heap, 1)
  return min_val
end

local grid = {}
for line in io.lines(path) do
  local row = {}
  for x in line:gmatch("(%S)") do table.insert(row, tonumber(x)) end
  table.insert(grid, row)
end

local function get_key(x)
  local res = ""
  for k, v in pairs(x) do res = res .. tostring(v) .. "|" end
  return res
end

local pos = create_heap({ { 1, 2, 1, 1, grid[1][2] }, { 2, 1, 2, 1, grid[2][1] } })
local cost, result = {}, math.huge

local function check_boundary(x, y, dir, d, c, new_dir)
  if dir ~= -new_dir and (x >= 1 and x <= #grid and y >= 1 and y <= #grid[1]) then
    push_heap(pos, { x, y, new_dir, (new_dir == dir) and d + 1 or 1, c + grid[x][y] })
  end
end

local function move(x, y, dir, d, c)
  local directions = { -1, -2, 1, 2 }
  for _, new_dir in ipairs(directions) do
    if new_dir ~= dir or d < 3 then
      local dx, dy = (new_dir == 2) and 1 or (new_dir == -2) and -1 or 0, (new_dir == 1) and 1 or (new_dir == -1) and -1 or 0
      check_boundary(x + dx, y + dy, dir, d, c, new_dir)
    end
  end
end

while next(pos) do
  local point = pop_heap(pos)
  local x, y, dir, d, c = table.unpack(point)
  if not cost[get_key({ x, y, dir, d })] or cost[get_key({ x, y, dir, d })] > c then
    cost[get_key({ x, y, dir, d })] = c
    move(x, y, dir, d, c)
    if x == #grid and y == #grid[1] then result = math.min(result, c) end
  end
end

print(result)