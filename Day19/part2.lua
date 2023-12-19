local input_path = "input.txt"
local total_sum = 0

local function deepcopy(orig, copies)
  copies = copies or {}
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    if copies[orig] then
      copy = copies[orig]
    else
      copy = {}
      copies[orig] = copy
      for orig_key, orig_value in next, orig, nil do
        copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
      end
      setmetatable(copy, deepcopy(getmetatable(orig), copies))
    end
  else
    copy = orig
  end
  return copy
end

local read_rule_stage = 1
local pipelines = {}
for line in io.lines(input_path) do
  if line == "" then
    read_rule_stage = read_rule_stage + 1
    goto continue
  end

  if read_rule_stage == 1 then
    local pipeline_name = ""
    for name in line:gmatch("([A-Za-z]+){") do
      pipeline_name = name
    end

    pipelines[pipeline_name] = {}
    for property, comparison_operator, value, transition in line:gmatch("([A-Za-z]+)([<>])(%d+):([A-Za-z]+),") do
      table.insert(pipelines[pipeline_name], { property, comparison_operator, transition, tonumber(value) })
    end

    for transition in line:gmatch(",([A-Za-z]+)}") do
      table.insert(pipelines[pipeline_name], { "x", "=", transition })
    end
  end
  ::continue::
end

local queue = { { { ["x"] = { { 1, 4000 } }, ["m"] = { { 1, 4000 } }, ["a"] = { { 1, 4000 } }, ["s"] = { { 1, 4000 } } }, "in", 1 } }

while next(queue) do
  local element = table.remove(queue, 1)
  local variables, pipeline, step = table.unpack(element)

  if pipeline == "A" then
    local product = 1
    for _, variable in pairs(variables) do
      local range = 0
      for _, interval in ipairs(variable) do
        range = range + interval[2] - interval[1] + 1
      end
      product = product * range
    end
    total_sum = total_sum + product
    goto continue
  end
  if pipeline == "R" then
    goto continue
  end

  if #pipelines[pipeline] == step then
    table.insert(queue, { variables, pipelines[pipeline][#pipelines[pipeline]][3], 1 })
    goto continue
  end

  local to_accept = deepcopy(variables)
  local to_reject = deepcopy(variables)

  local rule = pipelines[pipeline][step]
  local feature = rule[1]
  local comparison_operator = rule[2]
  local transition = rule[3]
  local value = rule[4]
  to_accept[feature] = {}
  to_reject[feature] = {}
  if comparison_operator == "<" then
    for _, interval in ipairs(variables[feature]) do
      if interval[2] < value then
        table.insert(to_accept[feature], interval)
      elseif interval[1] >= value then
        table.insert(to_reject[feature], interval)
      else
        table.insert(to_accept[feature], { math.min(value - 1, interval[1]), math.min(value - 1, interval[2]) })
        table.insert(to_reject[feature], { math.max(value, interval[1]), math.max(value, interval[2]) })
      end
    end
  else
    for _, interval in ipairs(variables[feature]) do
      if interval[1] > value then
        table.insert(to_accept[feature], interval)
      elseif interval[2] <= value then
        table.insert(to_reject[feature], interval)
      else
        table.insert(to_accept[feature], { math.max(value + 1, interval[1]), math.max(value + 1, interval[2]) })
        table.insert(to_reject[feature], { math.min(value, interval[1]), math.min(value, interval[2]) })
      end
    end
  end
  table.sort(to_accept[feature], function(a, b) return (a[1] == b[1] and a[2] < b[2]) or (a[1] < b[1]) end)
  table.sort(to_reject[feature], function(a, b) return (a[1] == b[1] and a[2] < b[2]) or (a[1] < b[1]) end)
  table.insert(queue, { to_accept, transition, 1 })
  table.insert(queue, { to_reject, pipeline, step + 1 })
  ::continue::
end

print(total_sum)