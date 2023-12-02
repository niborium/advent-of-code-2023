local function parseGame(line)
  local id, details = line:match("Game (%d+): (.+)")
  id = tonumber(id)
  local subsets = {}
  for subset in details:gmatch("[^;]+") do
      local red, green, blue = 0, 0, 0
      for count, color in subset:gmatch("(%d+) (%a+)") do
          count = tonumber(count)
          if color == "red" then red = count
          elseif color == "green" then green = count
          elseif color == "blue" then blue = count
          end
      end
      table.insert(subsets, { red = red, green = green, blue = blue })
  end
  return id, subsets
end

local function findMinimumSet(subsets)
  local minRed, minGreen, minBlue = 0, 0, 0
  for _, subset in ipairs(subsets) do
      minRed = math.max(minRed, subset.red)
      minGreen = math.max(minGreen, subset.green)
      minBlue = math.max(minBlue, subset.blue)
  end
  return minRed, minGreen, minBlue
end

local function calculatePowerSum(lines)
  local powerSum = 0
  for _, line in ipairs(lines) do
      local _, subsets = parseGame(line)
      local minRed, minGreen, minBlue = findMinimumSet(subsets)
      local power = minRed * minGreen * minBlue
      powerSum = powerSum + power
  end
  return powerSum
end

local function main()
  local file = io.open("input.txt", "r")
  local lines = {}
  for line in file:lines() do
      table.insert(lines, line)
  end
  file:close()

  local powerSum = calculatePowerSum(lines)
  return powerSum
end

print("Sum of the power of minimum sets:", main())
