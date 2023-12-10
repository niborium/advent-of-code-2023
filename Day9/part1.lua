local inputFile = "input.txt"

local function calculate_diffs(seq)
    local fail = false
    local diffs = {}
    local last = nil
    for _, v in ipairs(seq) do
        if v ~= 0 then
            fail = true
        end
        if last then
            diffs[#diffs + 1] = v - last
        end
        last = v
    end

    if not fail then
        return 0
    end

    local result = calculate_diffs(diffs)
    if #diffs == 0 then
        return result
    end
    return diffs[#diffs] + result
end

local total = 0
for line in io.lines(inputFile) do
    local seq = {}
    for num in line:gmatch("(%S+)") do
        seq[#seq + 1] = tonumber(num)
    end

    total = total + calculate_diffs(seq) + seq[#seq]
end

print('sum:', total)