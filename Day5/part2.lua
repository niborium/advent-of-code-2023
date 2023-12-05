local function processFile(filePath)
  local maps = {["seed-to-soil"] = {}, ["soil-to-fertilizer"] = {}, ["fertilizer-to-water"] = {}, ["water-to-light"] = {}, ["light-to-temperature"] = {}, ["temperature-to-humidity"] = {}, ["humidity-to-location"] = {}}
  local lowestLocation = math.huge

  local function applyMapping(number, mapping)
      for _, range in ipairs(mapping) do
          local destStart, sourceStart, length = table.unpack(range)
          if number >= sourceStart and number < sourceStart + length then
              return destStart + (number - sourceStart)
          end
      end
      return number
  end

  for line in io.lines(filePath) do
      local mapType = line:match("%w+ map:")
      if mapType then
          mapType = mapType:gsub(" map:", "")
      end

      if mapType then
          local destStart, sourceStart, length = line:match("(%d+) (%d+) (%d+)")
          destStart, sourceStart, length = tonumber(destStart), tonumber(sourceStart), tonumber(length)
          if destStart and sourceStart and length then
              table.insert(maps[mapType], {destStart, sourceStart, length})
          end
      elseif line:find("seeds:") then
          for start, len in line:gsub("seeds:", ""):gmatch("(%d+) (%d+)") do
              start, len = tonumber(start), tonumber(len)
              for seed = start, start + len - 1 do
                  -- Apply mappings directly here
                  seed = applyMapping(seed, maps["seed-to-soil"])
                  seed = applyMapping(seed, maps["soil-to-fertilizer"])
                  seed = applyMapping(seed, maps["fertilizer-to-water"])
                  seed = applyMapping(seed, maps["water-to-light"])
                  seed = applyMapping(seed, maps["light-to-temperature"])
                  seed = applyMapping(seed, maps["temperature-to-humidity"])
                  local location = applyMapping(seed, maps["humidity-to-location"])
                  lowestLocation = math.min(lowestLocation, location)
              end
          end
      end
  end

  return lowestLocation
end

local result = processFile("input.txt")
print("Lowest location number:", result)

--- Did not get this to work due to complexity and computation bottlenecks. See my part2.go implementation instead.