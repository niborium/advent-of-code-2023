local input_path = "input.txt"
local res = 0

for line in io.lines(input_path) do
    for pattern in line:gmatch("([^,]+)") do
        local x = 0
        for i = 1, #pattern do
            x = ((x + string.byte(pattern:sub(i, i))) * 17) % 256
        end
        res = res + x
    end
end

print(res)