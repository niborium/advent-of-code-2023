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

for times = 1, 1000 do
  local queue = { { "roadcaster", false, "button" } }

  while next(queue) do
    local item = table.remove(queue, 1)
    local node, signal, fromNode = table.unpack(item)

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
      node_inputs[node][fromNode] = signal
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

print('sum:', low * high)