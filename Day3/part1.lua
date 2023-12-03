local function isDigit(char)
  return char:match("%d") ~= nil
end

local function isSymbol(char)
  return not isDigit(char) and char ~= "."
end

local function findNumberStart(schematic, x, y)
  while x > 0 and isDigit(schematic[y]:sub(x, x)) do
      x = x - 1
  end
  return x + 1
end

local function parseNumber(schematic, x, y)
  local numberStr = ""
  while x <= #schematic[y] and isDigit(schematic[y]:sub(x, x)) do
      numberStr = numberStr .. schematic[y]:sub(x, x)
      x = x + 1
  end
  return tonumber(numberStr)
end

local function findPartsAroundSymbols(schematic)
  local sum = 0
  local parts = {}
  for y = 1, #schematic do
      for x = 1, #schematic[y] do
          if isSymbol(schematic[y]:sub(x, x)) then
              for dx = -1, 1 do
                  for dy = -1, 1 do
                      local nx, ny = x + dx, y + dy
                      if nx >= 1 and nx <= #schematic[y] and ny >= 1 and ny <= #schematic and isDigit(schematic[ny]:sub(nx, nx)) then
                          local startX = findNumberStart(schematic, nx, ny)
                          if not parts[startX..","..ny] then
                              local number = parseNumber(schematic, startX, ny)
                              parts[startX..","..ny] = true
                              sum = sum + number
                          end
                      end
                  end
              end
          end
      end
  end
  return sum
end

local function main()
  local file = io.open("input.txt", "r")
  local schematic = {}
  for line in file:lines() do
      table.insert(schematic, line)
  end
  file:close()

  local sum = findPartsAroundSymbols(schematic)
  return sum
end

print("Sum of all part numbers:", main())