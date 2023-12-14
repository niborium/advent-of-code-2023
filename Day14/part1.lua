local function readMap(file)
  local map = {}
  for line in io.lines(file) do
      local row = {}
      for char in line:gmatch("(%S)") do
          table.insert(row, char)
      end
      table.insert(map, row)
  end
  return map
end

local function calculateTotalLoad(map)
  local totalLoad = 0
  local cols = #map[1]

  for col = 1, cols do
      local insertPos = 1
      for row = 1, #map do
          local cell = map[row][col]
          if cell == 'O' then
              while insertPos <= #map and map[insertPos][col] == '#' do
                  insertPos = insertPos + 1
              end
              totalLoad = totalLoad + #map - insertPos + 1
              insertPos = insertPos + 1
          elseif cell == '#' then
              insertPos = row
          end
      end
  end

  return totalLoad
end

local function main()
  local inputPath = "input.txt"
  local map = readMap(inputPath)
  local load = calculateTotalLoad(map)
  print(load)
end

main()
