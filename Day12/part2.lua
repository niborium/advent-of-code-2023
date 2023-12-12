local input_path = "input.txt"
local result = 0

local function convertToKey(val)
  return table.concat(val, ",")
end

local function convertFromKey(key)
  local tokens = {}
  for x in key:gmatch("(%d+)") do
    table.insert(tokens, tonumber(x))
  end

  return tokens
end

local cache = {}
local function recursiveFunction(line, cc)
  local originalInput = cc
  if cache[line .. "|" .. cc] ~= nil then
    return cache[line .. "|" .. cc]
  end
  local res = 0
  local cc = convertFromKey(cc)
  if #line == 0 and next(cc) == nil then
    return 1
  end
  if next(cc) == nil then
    for i = 1, #line do
      if line:sub(i, i) == "#" then
        return 0
      end
    end
    return 1
  end
  if #line == 0 then
    return 0
  end

  if line:sub(1, 1) == "?" then
    res = res + recursiveFunction(line:sub(2), convertToKey(cc))
  end
  if line:sub(1, 1) ~= "." then
    local fail = false
    for i = 1, cc[1] do
      if i > #line then
        fail = true
        break
      end
      if line:sub(i, i) == "." then
        fail = true
        break
      end
    end

    if not fail then
      if cc[1] + 1 > #line or (cc[1] + 1 <= #line and line:sub(cc[1] + 1, cc[1] + 1) ~= "#") then
        local dist = table.remove(cc, 1) + 1
        res = res + recursiveFunction(line:sub(dist + 1), convertToKey(cc))
      end
    end
  else
    local start = 1
    while start <= #line and line:sub(start, start) == "." do
      start = start + 1
    end
    res = res + recursiveFunction(line:sub(start), convertToKey(cc))
  end

  cache[line .. "|" .. originalInput] = res
  return res
end

for line in io.lines(input_path) do
  local tokens = {}
  for x in line:gmatch("(%S+)") do
    table.insert(tokens, x)
  end

  local map = tokens[1]
  local keys = tokens[2]
  for i = 1, 4 do
    map = map .. "?" .. tokens[1]
    keys = keys .. "," .. tokens[2]
  end

  result = result + recursiveFunction(map, keys)
end

print('sum of possible arrangement counts', result)