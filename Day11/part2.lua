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

local g = {}
for i, v in ipairs(m) do
  for j, jv in ipairs(v) do
      if jv == '#' then
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
          local nor = filter(o_r, function(i) return (g1i < i and i < g2i) or (g2i < i and i < g1i) end)
          local noc = filter(oc, function(j) return (g1j < j and j < g2j) or (g2j < j and j < g1j) end)
          local dist = math.abs(g1i - g2i) + math.abs(g1j - g2j) + 999999 * #nor + 999999 * #noc
          count = count + dist
      end
  end
end

print(count // 2)