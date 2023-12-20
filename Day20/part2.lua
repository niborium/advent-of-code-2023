local input_path = "input.txt"
local nodes = {}
local node_status = {}
local node_inputs = {}

for line in io.lines(input_path) do
  local nodeName = ""
  for nodeType, name in line:gmatch("(%S)(%S+)%s%->") do
    nodeName = name
    node_status[nodeName] = { ["type"] = nodeType, ["status"] = false }
  end

  line = line .. ","
  for connectedNode in line:gmatch("(%S+),") do
    nodes[nodeName] = nodes[nodeName] or {}
    table.insert(nodes[nodeName], connectedNode)
    node_inputs[connectedNode] = node_inputs[connectedNode] or {}
    node_inputs[connectedNode][nodeName] = false
  end
end

local low = 1000
local high = 0

local function pushToQueue(queue, fromNode, signal)
  if signal then
    high = high + #nodes[fromNode]
  else
    low = low + #nodes[fromNode]
  end
  for _, receiver in ipairs(nodes[fromNode]) do
    table.insert(queue, { receiver, signal, fromNode })
  end
end

local target_node = ""
for from, pipeline in pairs(nodes) do
  for _, node in ipairs(pipeline) do
    if node == "rx" then
      target_node = from
    end
  end
end

local inputs = 0
for _, pipeline in pairs(nodes) do
  for _, node in ipairs(pipeline) do
    if node == target_node then
      inputs = inputs + 1
    end
  end
end

local function len(x)
  local count = 0
  for _ in pairs(x) do
    count = count + 1
  end
  return count
end

local function gcd(m, n)
  while n ~= 0 do
    local q = m
    m = n
    n = q % n
  end
  return m
end

local function lcm(m, n)
  return (m ~= 0 and n ~= 0) and m * n / gcd(m, n) or 0
end

local cycle = {}

for times = 1, 1000000000 do
  local queue = { { "roadcaster", false, "button" } }

  while next(queue) do
    local item = table.remove(queue, 1)
    local node, signal, from = table.unpack(item)

    if node == target_node and signal then
      if cycle[from] then
        cycle[from] = times - cycle[from]
      else
        cycle[from] = times
      end
    end
    if len(cycle) == inputs then
      local result = 1
      for _, v in pairs(cycle) do
        result = lcm(result, v)
      end

      print('sum:', math.ceil(result))
      os.exit(0)
    end

    if not node_status[node] then
      goto continue
    end
    if node_status[node]["type"] == "%" then
      if not signal then
        node_status[node]["status"] = not node_status[node]["status"]
        if node_status[node]["status"] then
          pushToQueue(queue, node, true)
          goto continue
        else
          pushToQueue(queue, node, false)
          goto continue
        end
      end
    elseif node_status[node]["type"] == "&" then
      node_inputs[node][from] = signal
      for _, inputStatus in pairs(node_inputs[node]) do
        if not inputStatus then
          pushToQueue(queue, node, true)
          goto continue
        end
      end
      pushToQueue(queue, node, false)
      goto continue
    else
      pushToQueue(queue, node, false)
      goto continue
    end
    ::continue::
  end
end