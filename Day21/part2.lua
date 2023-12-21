local input_path = "input.txt"

local maze = {}
local startX, startY = 1, 1
local start = {}

for line in io.lines(input_path) do
  local row = {}
  startY = 1
  for cell in line:gmatch("(%S)") do
    if cell == "S" then
      cell = "."
      start = { startX, startY }
    end
    table.insert(row, cell)
    startY = startY + 1
  end
  startX = startX + 1
  table.insert(maze, row)
end

local max_steps = 26501365

local function calculateReachablePoints(pos, total_steps)
  local result = 0
  local visited = {}
  local function key(x)
    return tostring(x[1]) .. "|" .. tostring(x[2])
  end
  local queue = { { pos, 0 } }

  while next(queue) do
    local item = table.remove(queue, 1)
    local pos, steps = table.unpack(item)

    if (total_steps - steps) % 2 == 0 then
      if visited[key(pos)] then
        goto continue
      end
      visited[key(pos)] = true
      result = result + 1
    end
    if steps == total_steps then
      goto continue
    end

    local x, y = table.unpack(pos)
    for _, d in ipairs({ -1, 1 }) do
      if maze[x + d] and maze[x + d][y] == "." then
        table.insert(queue, { { x + d, y }, steps + 1 })
      end
      if maze[x] and maze[x][y + d] == "." then
        table.insert(queue, { { x, y + d }, steps + 1 })
      end
    end
    ::continue::
  end

  return result
end

local maze_size = max_steps // #maze - 1
local odd = (maze_size // 2 * 2 + 1) ^ 2
local even = ((maze_size + 1) // 2 * 2) ^ 2
local full_odd_points = calculateReachablePoints(start, #maze * 2 + 1)
local full_even_points = calculateReachablePoints(start, #maze * 2)
local from_sides = calculateReachablePoints({ #maze, start[2] }, #maze - 1) + calculateReachablePoints({ start[1], 1 }, #maze - 1) + calculateReachablePoints({ 1, start[2] }, #maze - 1) +
  calculateReachablePoints({ start[1], #maze }, #maze - 1)
local small_sector = calculateReachablePoints({ #maze, 1 }, #maze // 2 - 1) + calculateReachablePoints({ #maze, #maze }, #maze // 2 - 1) + calculateReachablePoints({ 1, 1 }, #maze // 2 - 1) +
  calculateReachablePoints({ 1, #maze }, #maze // 2 - 1)
local large_sectors = calculateReachablePoints({ #maze, 1 }, #maze * 3 // 2 - 1) + calculateReachablePoints({ #maze, #maze }, #maze * 3 // 2 - 1) +
  calculateReachablePoints({ 1, 1 }, #maze * 3 // 2 - 1) + calculateReachablePoints({ 1, #maze }, #maze * 3 // 2 - 1)

local result = odd * full_odd_points + even * full_even_points + from_sides +
  (maze_size + 1) * small_sector +
  maze_size * large_sectors

print(math.ceil(result))