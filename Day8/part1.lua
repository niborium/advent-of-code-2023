local function readInput(filename)
  local file = io.open(filename, "r")
  local instructions, nodes = "", {}
  if file then
      instructions = file:read("*line")

      for line in file:lines() do
          if line and line ~= "" then
              local node, left, right = line:match("(%w+) = %((%w+), (%w+)%)")
              if node and left and right then
                  nodes[node] = {left = left, right = right}
              else
                  print("Skipping invalid line: " .. line)
              end
          end
      end
      file:close()
  else
      error("Unable to open file: " .. filename)
  end
  return instructions, nodes
end

local function navigateNodes(instructions, nodes)
  local currentNode = "AAA"
  local stepCount = 0
  local instructionIndex = 1

  while currentNode ~= "ZZZ" do
      local instruction = instructions:sub(instructionIndex, instructionIndex)
      if nodes[currentNode] then
          currentNode = nodes[currentNode][instruction == "R" and "right" or "left"]
          stepCount = stepCount + 1

          instructionIndex = (instructionIndex % #instructions) + 1
      else
          error("Node not found: " .. currentNode)
      end
  end

  return stepCount
end

local instructions, nodes = readInput("input.txt")
local stepsToZZZ = navigateNodes(instructions, nodes)
print("Steps to reach ZZZ:", stepsToZZZ)
