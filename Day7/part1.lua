local camelCardsStore = {}
local availableCards = "23456789TJQKA"
local handTypes = "12T3F45"

local function processHand(hand)
    local cardCounts = {}
    local maxCount, pairCount = 0, 0

    hand = string.gsub(hand, '.', function(card)
        cardCounts[card] = (cardCounts[card] or 0) + 1
        if cardCounts[card] == 2 then pairCount = pairCount + 1 end
        maxCount = math.max(maxCount, cardCounts[card])
        return string.char(availableCards:find(card) + ("A"):byte() - 1)
    end)

    local handType = handTypes:find(tostring(maxCount))
    if (maxCount == 3 and pairCount == 2) or (maxCount == 2 and pairCount == 2) then handType = handType + 1 end
    return string.char(handType + ("A"):byte() - 1) .. hand
end

local function insertHand(hand, score)
    local index = #camelCardsStore + 1
    for i = 1, #camelCardsStore do
        if camelCardsStore[i][1] > hand then
            index = i
            break
        end
    end
    table.insert(camelCardsStore, index, { hand, score, hand })
end

local function processLine(line)
    local hand, scoreString = line:match("(%S+) (%d+)")
    local score = tonumber(scoreString)
    hand = processHand(hand)
    insertHand(hand, score)
end

local function calculateTotalWinnings()
    local totalWinnings = 0
    for i, game in ipairs(camelCardsStore) do totalWinnings = totalWinnings + i * game[2] end
    return totalWinnings
end

for line in io.lines("inputs.txt") do
    processLine(line)
end

print('total winnings:', calculateTotalWinnings())