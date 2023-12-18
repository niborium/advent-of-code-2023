local function read_input(input_path)
  local map = { [1] = { [1] = "#" } }
  local x, y = 1, 1

  for line in io.lines(input_path) do
    for direction, steps in line:gmatch("(%S)%s(%d+)%s%(#%S+%)") do
      steps = tonumber(steps)
      if direction == "R" then
        for _ = 1, steps do
          y = y + 1
          map[x][y] = "#"
        end
      elseif direction == "D" then
        for _ = 1, steps do
          x = x + 1
          map[x] = map[x] or {}
          map[x][y] = "#"
        end
      elseif direction == "L" then
        for _ = 1, steps do
          y = y - 1
          map[x][y] = "#"
        end
      elseif direction == "U" then
        for _ = 1, steps do
          x = x - 1
          map[x] = map[x] or {}
          map[x][y] = "#"
        end
      end
    end
  end

  return map
end

local function calculate_bounds(map)
  local xmin, xmax, ymin, ymax = nil, nil, nil, nil

  for x, line in pairs(map) do
    for y, _ in pairs(line) do
      xmin = math.min(xmin or 1, x)
      xmax = math.max(xmax or -1, x)
      ymin = math.min(ymin or 1, y)
      ymax = math.max(ymax or -1, y)
    end
  end

  return xmin, xmax, ymin, ymax
end

local function calculate_outside(map, xmin, xmax, ymin, ymax)
  local outside = 0
  local queue = {}
  local outside_visited = {}
  local function key(x)
    return tostring(x[1]) .. "|" .. tostring(x[2])
  end

  for x = xmin, xmax do
    table.insert(queue, { x, ymin })
    table.insert(queue, { x, ymax })
  end
  for y = ymin, ymax do
    table.insert(queue, { xmin, y })
    table.insert(queue, { xmax, y })
  end

  while next(queue) do
    local point = table.remove(queue)
    local x = point[1]
    local y = point[2]

    if x < xmin or x > xmax or y < ymin or y > ymax then
      goto continue
    end
    if outside_visited[key(point)] then
      goto continue
    end
    if map[x] and map[x][y] then
      goto continue
    end

    outside = outside + 1
    outside_visited[key(point)] = 1

    table.insert(queue, { x + 1, y })
    table.insert(queue, { x - 1, y })
    table.insert(queue, { x, y + 1 })
    table.insert(queue, { x, y - 1 })

    ::continue::
  end

  return outside
end

local function main()
  local input_path = "input.txt"
  local map = read_input(input_path)
  local xmin, xmax, ymin, ymax = calculate_bounds(map)
  local outside = calculate_outside(map, xmin, xmax, ymin, ymax)
  print((xmax - xmin + 1) * (ymax - ymin + 1) - outside)
end

main()