local function splitToTable(str, delimiter)
  local result = {}
  for number in str:gmatch("%d+") do
      table.insert(result, tonumber(number))
  end
  return result
end

local function calculateCardPoints(winningNumbers, yourNumbers)
  local winningSet = {}
  for _, num in ipairs(winningNumbers) do
      winningSet[num] = true
  end

  local gameWin = 0
  for _, num in ipairs(yourNumbers) do
      if winningSet[num] then
          if gameWin == 0 then
              gameWin = 1
          else
              gameWin = gameWin * 2
          end
      end
  end
  
  return gameWin
end

local function totalPoints()
  local file = io.open("input.txt", "r")
  local totalPoints = 0

  for line in file:lines() do
      local _, numbersStr = line:match("([^:]+):(.+)")
      local winningNumbersStr, yourNumbersStr = numbersStr:match("([^|]+)|(.+)")
      local winningNumbers = splitToTable(winningNumbersStr, " ")
      local yourNumbers = splitToTable(yourNumbersStr, " ")
      totalPoints = totalPoints + calculateCardPoints(winningNumbers, yourNumbers)
  end

  file:close()
  return totalPoints
end

print("Total points:", totalPoints())