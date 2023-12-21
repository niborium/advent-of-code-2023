function readMap(filename)
  local map = {}
  local startX, startY
  for line in io.lines(filename) do
      local row = {}
      for i = 1, #line do
          local char = line:sub(i, i)
          if char == 'S' then
              startX, startY = #map + 1, i
              char = '.'
          end
          table.insert(row, char)
      end
      table.insert(map, row)
  end
  return map, startX, startY
end

function bfs(map, startX, startY, maxSteps)
  local dirs = {{-1, 0}, {0, 1}, {1, 0}, {0, -1}}
  local heap = {{startX, startY}}
  local k = 0

  while k < maxSteps do
      local heap2 = {}
      local visited = {}
      local curr

      while #heap > 0 do
          curr = table.remove(heap)
          local x, y = curr[1], curr[2]

          for _, dir in ipairs(dirs) do
              local nx, ny = x + dir[1], y + dir[2]
              if nx < 1 or nx > #map or ny < 1 or ny > #map[1] then
                  -- Skip out-of-bounds
              else
                  local key = nx..','..ny
                  if not visited[key] and map[nx][ny] == '.' then
                      visited[key] = true
                      table.insert(heap2, {nx, ny})
                  end
              end
          end
      end

      heap = heap2
      k = k + 1
  end

  return #heap
end

function main()
  local map, startX, startY = readMap("input.txt")
  local result = bfs(map, startX, startY, 64)
  print("Unique garden plots reachable in exactly 64 steps:", result)
end

main()
