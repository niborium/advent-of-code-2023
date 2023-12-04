local function readFile(filePath)
  local file = io.open(filePath, "r")
  if not file then
      error("File not found: " .. filePath)
  end
  local lines = {}
  for line in file:lines() do
      table.insert(lines, line)
  end
  file:close()
  return lines
end

local function splitNumbers(str)
  local numbers = {}
  for num in str:gmatch("%d+") do
      table.insert(numbers, tonumber(num))
  end
  return numbers
end

local function processCards(inputList)
  local total = 0
  local reps = {}
  for _ = 1, #inputList do
      table.insert(reps, 1)
  end

  for card, inputStr in ipairs(inputList) do
      local winningPart, numbersPart = inputStr:match(".*: (.*) | (.*)")
      local winningNumbers = splitNumbers(winningPart)
      local numbers = splitNumbers(numbersPart)

      for _ = 1, reps[card] do
          local winTot = 0
          local winDict = {}

          for _, win in ipairs(winningNumbers) do
              winDict[win] = 0
          end

          for _, number in ipairs(numbers) do
              if winDict[number] ~= nil then
                  winTot = winTot + 1
              end
          end

          for i = 1, winTot do
              local nextCard = card + i
              if nextCard <= #inputList then
                  reps[nextCard] = reps[nextCard] + 1
              end
          end

          total = total + 1
      end
  end

  return total
end

local inputList = readFile("input.txt")
local total = processCards(inputList)
print("Total scratchcards:", total)
