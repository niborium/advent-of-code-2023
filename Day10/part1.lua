local file = io.open("input.txt", "r")
local adj = {}
local start
local y = 0

for line in file:lines() do
    y = y + 1
    local x = 0
    for c in line:gmatch(".") do
        x = x + 1
        if c == 'S' then
            start = {x, y}
        elseif c == '|' then
            adj[x .. "," .. y] = {{x, y+1}, {x, y-1}}
        elseif c == '-' then
            adj[x .. "," .. y] = {{x-1, y}, {x+1, y}}
        elseif c == 'L' then
            adj[x .. "," .. y] = {{x, y-1}, {x+1, y}}
        elseif c == 'J' then
            adj[x .. "," .. y] = {{x, y-1}, {x-1, y}}
        elseif c == '7' then
            adj[x .. "," .. y] = {{x, y+1}, {x-1, y}}
        elseif c == 'F' then
            adj[x .. "," .. y] = {{x, y+1}, {x+1, y}}
        end
    end
end
file:close()

adj[start[1] .. "," .. start[2]] = {}
for k, v in pairs(adj) do
  local x, y = k:match("([^,]+),([^,]+)")
  x, y = tonumber(x), tonumber(y)
  for _, pos in ipairs(v) do
    if pos[1] == start[1] and pos[2] == start[2] then
      table.insert(adj[start[1] .. "," .. start[2]], {x, y})
    end
  end
end

local seen = {}
local to_process = {{0, start}}
local curr_dist = 0
while #to_process > 0 do
  curr_dist, curr = table.unpack(table.remove(to_process, 1))
  seen[curr[1] .. "," .. curr[2]] = true
  local adj_list = adj[curr[1] .. "," .. curr[2]]
  if type(adj_list) == "table" then
    for _, new in ipairs(adj_list) do
      if not seen[new[1] .. "," .. new[2]] then
        table.insert(to_process, {curr_dist + 1, new})
      end
    end
  end
end

print('steps', curr_dist)