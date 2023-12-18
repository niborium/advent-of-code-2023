local function read_input(input_path)
  local total_steps = 0
  local x, y = 1, 1
  local points = { { x, y } }

  for line in io.lines(input_path) do
    for _, steps_str, str in line:gmatch("(%S)%s(%d+)%s%(#(%S+)%)") do
      local direction = str:sub(#str, #str)
      local steps = tonumber(str:sub(1, #str - 1), 16)

      if direction == "0" then
        y = y + steps
      elseif direction == "1" then
        x = x + steps
      elseif direction == "2" then
        y = y - steps
      elseif direction == "3" then
        x = x - steps
      end

      table.insert(points, { x, y })
      total_steps = total_steps + steps
    end
  end

  return points, total_steps
end

local function calculate_inside(points)
  local inside = 0
  for i = 1, #points - 1 do
    inside = inside + ((points[i][2] + points[i + 1][2]) * (points[i][1] - points[i + 1][1]))
  end
  return inside
end

local function main()
  local input_path = "input.txt"
  local points, total_steps = read_input(input_path)
  local inside = calculate_inside(points)
  print((math.abs(inside) + total_steps) // 2 + 1)
end

main()