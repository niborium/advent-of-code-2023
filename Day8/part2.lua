local function lcmCalc(numbers)
  local function gcd(a, b)
    while b ~= 0 do
      a, b = b, a % b
    end
    return a
  end

  local function lcm(a, b)
     return (a * b) / gcd(a, b)
  end

  local result = numbers[1]

  for i = 2, #numbers do
    result = lcm(result, numbers[i])
  end

  return result
end

local function core(input)
  local steps = {}
  for line in input:gmatch('[^\n]+') do
    if line ~= '' then
      table.insert(steps, line)
    end
  end

  local directions = steps[1]:gsub('%s', '')
  table.remove(steps, 1)

  local locationsObject = {}
  for _, step in ipairs(steps) do
    local location, leftLocation, rightLocation = step:match('(%w+)[^%w]*(%w*)[^%w]*(%w*)')
    locationsObject[location] = {L = leftLocation, R = rightLocation}
  end

  local startingLocations = {}
  for location, _ in pairs(locationsObject) do
    if location:match('A$') then
      table.insert(startingLocations, location)
    end
  end

  local stepsToZ = {}
  for _, location in ipairs(startingLocations) do
    local currLocation = location
    local stepCount = 0
    while not currLocation:match('Z$') do
      for _ = 1, #directions do
        local dir = directions:sub(_, _)
        local nextLocation = locationsObject[currLocation][dir]
        currLocation = nextLocation
        stepCount = stepCount + 1
      end
    end
    table.insert(stepsToZ, stepCount)
  end

  print('steps:', math.floor(lcmCalc(stepsToZ)))
end

local inputFile = io.open('./input.txt', 'r'):read('*all')
core(inputFile)