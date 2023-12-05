local function convertNumber(number, map)
  for _, range in ipairs(map) do
      local destStart, sourceStart, length = table.unpack(range)
      if number >= sourceStart and number < sourceStart + length then
          return destStart + (number - sourceStart)
      end
  end
  return number
end

local function processFile(filePath)
  local currentMap = nil
  local maps = {}
  local seeds = {}
  local lowestLocation = math.huge

  for line in io.lines(filePath) do
      if line:find("seeds:") then
          for seed in line:gmatch("%d+") do
              table.insert(seeds, tonumber(seed))
          end
      elseif line:find(" map:") then
          currentMap = line:gsub(" map:", "")
          maps[currentMap] = {}
      elseif currentMap and line:find("%d+") then
          local destStart, sourceStart, length = line:match("(%d+) (%d+) (%d+)")
          destStart, sourceStart, length = tonumber(destStart), tonumber(sourceStart), tonumber(length)
          table.insert(maps[currentMap], {destStart, sourceStart, length})
      end
  end

  for _, seed in ipairs(seeds) do
      local soil = convertNumber(seed, maps["seed-to-soil"])
      local fertilizer = convertNumber(soil, maps["soil-to-fertilizer"])
      local water = convertNumber(fertilizer, maps["fertilizer-to-water"])
      local light = convertNumber(water, maps["water-to-light"])
      local temperature = convertNumber(light, maps["light-to-temperature"])
      local humidity = convertNumber(temperature, maps["temperature-to-humidity"])
      local location = convertNumber(humidity, maps["humidity-to-location"])
      lowestLocation = math.min(lowestLocation, location)
  end

  return lowestLocation
end

local result = processFile("input.txt")
print("Lowest location number:", result)
