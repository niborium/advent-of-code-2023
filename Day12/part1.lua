function split(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function matches_groups(sequence, groups)
    local group_index = 1
    local count = 0
    local i = 1

    while i <= #sequence do
    local char = sequence:sub(i, i)
    if char == '#' then
        count = count + 1
    elseif count > 0 then
        if count ~= groups[group_index] then
        return false
        end
        group_index = group_index + 1
        count = 0
    end
    i = i + 1
    end

    if count > 0 then
    if count ~= groups[group_index] then
        return false
    end
    group_index = group_index + 1
    end

    return group_index > #groups
end

function count_arrangements(springs, groups, index)
    if index > #springs then
        return matches_groups(springs, groups) and 1 or 0
    end

    local char = springs:sub(index, index)
    if char ~= '?' then
        return count_arrangements(springs, groups, index + 1)
    end

    local total_count = 0
    -- Replace '?' with '#'
    total_count = total_count + count_arrangements(springs:sub(1, index - 1) .. '#' .. springs:sub(index + 1), groups, index + 1)
    -- Replace '?' with '.'
    total_count = total_count + count_arrangements(springs:sub(1, index - 1) .. '.' .. springs:sub(index + 1), groups, index + 1)

    return total_count
end

local file = io.open("input.txt", "r")
local total_arrangements = 0

for line in file:lines() do
    local parts = split(line, " ")
    local springs = parts[1]
    local groups = split(parts[2], ",")
    for i, v in ipairs(groups) do
        groups[i] = tonumber(v)
    end

    total_arrangements = total_arrangements + count_arrangements(springs, groups, 1)
end

file:close()

print(total_arrangements)