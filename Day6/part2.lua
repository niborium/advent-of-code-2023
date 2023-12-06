local function readInput(filename)
  local file = io.open(filename, "r")
  local timeLine = file:read("*l")
  local distanceLine = file:read("*l")
  file:close()

  local timeStr = timeLine:match("Time:%s*(.+)")
  local distanceStr = distanceLine:match("Distance:%s*(.+)")

  timeStr = timeStr:gsub("%s+", "")
  distanceStr = distanceStr:gsub("%s+", "")

  return {timeStr = timeStr, distanceStr = distanceStr}
end

local function calculateWaysToWin(race)
  local time = tonumber(race.timeStr)
  local distance = tonumber(race.distanceStr)

  if not time or not distance then
      return "Invalid input"
  end

  local ways = 0
  for holdTime = 1, time - 1 do
      local travelTime = time - holdTime
      local distanceTraveled = holdTime * travelTime
      if distanceTraveled > distance then
          ways = ways + 1
      end
  end
  return ways
end

local race = readInput("input.txt")

local waysToWin = calculateWaysToWin(race)

print("Number of ways to win the race: " .. waysToWin)
