function contains(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

function filter(tbl, func)
  local newTable = {}
  for _, v in ipairs(tbl) do
    if func(v) then
      table.insert(newTable, v)
    end
  end
  return newTable
end

local D = io.open("input.txt"):read("*a"):gsub("\n$", "")

local L = {}
for line in D:gmatch("[^\n]+") do
  table.insert(L, line)
end

local m = {}
for _, node in ipairs(L) do
  local row = {}
  for n in node:gmatch(".") do
    table.insert(row, n)
  end
  table.insert(m, row)
end

local oc = {}
for i, n in ipairs(m[1]) do
  if n == '.' then
    table.insert(oc, i)
  end
end

local o_r = {}
for i, v in ipairs(m) do
  local nc = {}
  for j, n in ipairs(v) do
    if n == '.' and contains(oc, j) then
      table.insert(nc, j)
    end
  end
  oc = nc
  if #filter(v, function(a) return a ~= '.' end) == 0 then
    table.insert(o_r, i)
  end
end

local nm = {}
local nr = string.rep('.', #m[1] + #oc)
for i = 1, #m do
  if contains(o_r, i) then
    table.insert(nm, nr)
    table.insert(nm, nr)
  else
    local row = {}
    for j = 1, #m[i] do
      if contains(oc, j) then
        table.insert(row, '..')
      else
        table.insert(row, m[i][j])
      end
    end
    table.insert(nm, table.concat(row))
  end
end

local g = {}
for i, v in ipairs(nm) do
  for j = 1, #v do
    if v:sub(j, j) == '#' then
      table.insert(g, {i, j})
    end
  end
end

local count = 0
for _, g1 in ipairs(g) do
    for _, g2 in ipairs(g) do
        if g1[1] ~= g2[1] or g1[2] ~= g2[2] then
            local g1i, g1j = table.unpack(g1)
            local g2i, g2j = table.unpack(g2)
            local dist = math.abs(g1i - g2i) + math.abs(g1j - g2j)
            count = count + dist
        end
    end
end

print(count // 2)