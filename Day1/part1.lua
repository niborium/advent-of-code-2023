function extractDigits(line)
  local firstDigit = string.match(line, "%d")
  local reversedLine = string.reverse(line)
  local lastDigit = string.match(reversedLine, "%d")
  if lastDigit then
      lastDigit = string.reverse(lastDigit)
  end
  return firstDigit, lastDigit
end

function sumCalibrationValues(lines)
  local total = 0
  for _, line in ipairs(lines) do
      local firstDigit, lastDigit = extractDigits(line)
      if firstDigit and lastDigit then
          total = total + tonumber(firstDigit .. lastDigit)
      end
  end
  return total
end

function main()
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