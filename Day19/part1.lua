local input_path = "input.txt"
local total_sum = 0

local function create_comparator(x, comparison_operator)
  if comparison_operator == "<" then
    return function(value)
      return value < x
    end
  else
    return function(value)
      return value > x
    end
  end
end

local function always_accept(_)
  return true
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
      table.insert(pipelines[pipeline_name], { property, create_comparator(tonumber(value), comparison_operator), transition })
    end

    for transition in line:gmatch(",([A-Za-z]+)}") do
      table.insert(pipelines[pipeline_name], { "x", always_accept, transition })
    end
  else
    local variables = {}
    for feature, value in line:gmatch("([xmas]+)=(%d+)") do
      variables[feature] = tonumber(value)
    end

    local pipeline = "in"
    while true do
      local current_pipeline = pipelines[pipeline]
      for _, rule in ipairs(current_pipeline) do
        local feature, comparator, transition = table.unpack(rule)
        if comparator(variables[feature]) then
          pipeline = transition
          break
        end
      end

      if pipeline == "A" then
        local sum = 0
        for _, value in pairs(variables) do
          sum = sum + value
        end
        total_sum = total_sum + sum
        break
      elseif pipeline == "R" then
        break
      end
    end
  end
  ::continue::
end

print(total_sum)