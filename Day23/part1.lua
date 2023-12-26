local input_path = "input.txt"

local map = {}
local maxPathLength = 0

for line in io.lines(input_path) do
    local row = {}
    for cell in line:gmatch("(%S)") do
        table.insert(row, cell)
    end
    table.insert(map, row)
end

local queue = { { 1, 2, {}, 0 } }

local function createKey(x, y)
    return tostring(x) .. "," .. tostring(y)
end

local function deepCopy(original, copies)
    copies = copies or {}
    local originalType = type(original)
    local copy
    if originalType == 'table' then
        if copies[original] then
            copy = copies[original]
        else
            copy = {}
            copies[original] = copy
            for originalKey, originalValue in next, original, nil do
                copy[deepCopy(originalKey, copies)] = deepCopy(originalValue, copies)
            end
            setmetatable(copy, deepCopy(getmetatable(original), copies))
        end
    else
        copy = original
    end
    return copy
end

while next(queue) do
    local item = table.remove(queue, 1)
    local x, y, path, pathLength = table.unpack(item)

    if x == #map and y == #map[1] - 1 then
        maxPathLength = math.max(maxPathLength, pathLength)
        goto continue
    end

    path = deepCopy(path)
    local key = createKey(x, y)
    if not path[key] then
        path[key] = true
        local directions = { { x, y + 1, ">" }, { x, y - 1, "<" }, { x - 1, y, "^" }, { x + 1, y, "v" } }
        for _, direction in ipairs(directions) do
            local newX, newY, requiredDirection = table.unpack(direction)
            if map[newX] and map[newX][newY] and map[newX][newY] ~= "#" and (map[x][y] == requiredDirection or map[x][y] == ".") then
                table.insert(queue, { newX, newY, path, pathLength + 1 })
            end
        end
    end

    ::continue::
end

print(maxPathLength)