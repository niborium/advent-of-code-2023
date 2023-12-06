local function readInput(filename)
  local file = io.open(filename, "r")
  local timesLine = file:read("*l")
  local distancesLine = file:read("*l")
  file:close()

  local times = {}
  for time in timesLine:gmatch("(%d+)") do
      table.insert(times, tonumber(time))
  end

  local distances = {}
  for distance in distancesLine:gmatch("(%d+)") do
      table.insert(distances, tonumber(distance))
  end

  local races = {}
  for i = 1, #times do
      table.insert(races, {time = times[i], distance = distances[i]})
  end
  return races
end

local function calculateWaysToWin(race)
  local ways = 0
  for holdTime = 1, race.time - 1 do
      local travelTime = race.time - holdTime
      local distance = holdTime * travelTime
      if distance > race.distance then
          ways = ways + 1
      end
  end
  return ways
end

local races = readInput("input.txt")

local totalWays = 1
for _, race in ipairs(races) do
  local ways = calculateWaysToWin(race)
  totalWays = totalWays * ways
end

print("Total number of ways to win: " .. totalWays)
