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

local function isGamePossible(subsets)
  local redLimit, greenLimit, blueLimit = 12, 13, 14
  for _, subset in ipairs(subsets) do
      if subset.red > redLimit or subset.green > greenLimit or subset.blue > blueLimit then
          return false
      end
  end
  return true
end

local function main()
  local file = io.open("input.txt", "r")
  local sumOfIds = 0
  for line in file:lines() do
      local id, subsets = parseGame(line)
      if isGamePossible(subsets) then
          sumOfIds = sumOfIds + id
      end
  end
  file:close()
  return sumOfIds
end

print("Sum of IDs of possible games:", main())