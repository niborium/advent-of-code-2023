local input_path = "input.txt"

local res = 0
local boxes = {}

local function hash(str)
  local x = 0
  for i = 1, #str do
    x = ((x + string.byte(str:sub(i, i))) * 17) % 256
  end
  return x
end

local iteration = 0
for line in io.lines(input_path) do
  line = line .. ","
  for pattern in line:gmatch("([^,]+),") do
    for code, lens in pattern:gmatch("([^=-]+)=(%d+)") do
      local box = hash(code)
      boxes[box] = boxes[box] or {}
      boxes[box][code] = boxes[box][code] and { lens, boxes[box][code][2] } or { lens, iteration }
    end
    for code in pattern:gmatch("([^=-]+)-") do
      local box = hash(code)
      boxes[box] = boxes[box] or {}
      boxes[box][code] = nil
    end
    iteration = iteration + 1
  end
end

for box = 0, 255 do
  if boxes[box] then
    local lenses = {}
    for _, v in pairs(boxes[box]) do
      table.insert(lenses, v)
    end
    table.sort(lenses, function(a, b) return b[2] > a[2] end)
    for i, v in ipairs(lenses) do
      res = res + (box + 1) * i * v[1]
    end
  end
end

print(math.ceil(res))