local function convertSpelledDigit()
  return {
      ["one"] = 1,
      ["two"] = 2,
      ["three"] = 3,
      ["four"] = 4,
      ["five"] = 5,
      ["six"] = 6,
      ["seven"] = 7,
      ["eight"] = 8,
      ["nine"] = 9
  }
end

local function findFirstDigit(line, digitLookup)
  for i = 1, #line do
      local char = line:sub(i, i)
      if char:match("%d") then
          return tonumber(char)
      else
          for word, number in pairs(digitLookup) do
              if line:sub(i, i + #word - 1) == word then
                  return number
              end
          end
      end
  end
  return nil
end

local function findLastDigit(line, digitLookup)
  for i = #line, 1, -1 do
      local char = line:sub(i, i)
      if char:match("%d") then
          return tonumber(char)
      else
          for word, number in pairs(digitLookup) do
              if i >= #word and line:sub(i - #word + 1, i) == word then
                  return number
              end
          end
      end
  end
  return nil
end

local function sumCalibrationValues(lines)
  local total = 0
  local digitLookup = convertSpelledDigit()

  for _, line in ipairs(lines) do
      local firstDigit = findFirstDigit(line, digitLookup)
      local lastDigit = findLastDigit(line, digitLookup)
      if firstDigit and lastDigit then
          total = total + (firstDigit * 10 + lastDigit)
      end
  end
  return total
end

local function main()
  local file = io.open("input.txt", "r")
  local lines = {}
  for line in file:lines() do
      table.insert(lines, line)
  end
  file:close()

  local sum = sumCalibrationValues(lines)
  print("Sum of calibration values:", sum)
end

main()