local function readInput(filename)
    local file = io.open(filename, "r")
    if not file then error("File not found: " .. filename) end

    local lines = {}
    for line in file:lines() do
        local px, py, pz, vx, vy, vz = line:match("([%-?%d]+), ([%-?%d]+), ([%-?%d]+) @ ([%-?%d]+), ([%-?%d]+), ([%-?%d]+)")
        if not (px and py and pz and vx and vy and vz) then
            error("Failed to parse line: " .. line)
        end

        local x, y = tonumber(px), tonumber(py)
        vx, vy = tonumber(vx), tonumber(vy)

        local m = vy / vx
        local b = y - m * x

        table.insert(lines, {m = m, b = b, startX = x, xDir = vx > 0 and 1 or -1, yDir = vy > 0 and 1 or -1})
    end

    file:close()
    return lines
end

local function doLinesIntersectInRanges(line1, line2, rangeStart, rangeEnd)
    local slopeDelta = line1.m - line2.m
    if slopeDelta == 0 then
        return 0
    end
    local x = (line2.b - line1.b) / slopeDelta
    local y = line1.m * x + line1.b

    local doLinesIntersectInRange = x >= rangeStart and x <= rangeEnd and y >= rangeStart and y <= rangeEnd
    local isIntersectionInFutureForLine1 = line1.xDir > 0 and x >= line1.startX or line1.xDir <= 0 and x <= line1.startX
    local isIntersectionInFutureForLine2 = line2.xDir > 0 and x >= line2.startX or line2.xDir <= 0 and x <= line2.startX

    return doLinesIntersectInRange and isIntersectionInFutureForLine1 and isIntersectionInFutureForLine2 and 1 or 0
end

local TEST_START = 200000000000000
local TEST_END = 400000000000000
local lines = readInput("input.txt")

local intersections = 0
for i = 1, #lines - 1 do
    for j = i + 1, #lines do
        intersections = intersections + doLinesIntersectInRanges(lines[i], lines[j], TEST_START, TEST_END)
    end
end

print("Number of intersections within the test area:", intersections)
