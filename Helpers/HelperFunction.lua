local Helper = {}

function Helper.objectInTable(object, table)
    for _, value in ipairs(table) do
        if object == value then
            return true
        end
    end
    return false
end

function Helper.findIndex(object, table)
    for index, value in ipairs(table) do
        if value == object then
            return index
        end
    end
end

function Helper.calculateHandTotal(hand)
    local total = 0
    local aceCount = 0
    
    for _, card in ipairs(hand) do
        local value = card.value
        if value == "Jack" or value == "Queen" or value == "King" then
            total = total + 10
        elseif value == "Ace" then
            aceCount = aceCount + 1
            total = total + 11  -- Initially consider ace as 11
        else
            total = total + tonumber(value)
        end
    end

    -- Adjust for aces if total is over 21
    while total > 21 and aceCount > 0 do
        total = total - 10  -- Change an ace from 11 to 1
        aceCount = aceCount - 1
    end

    return total
end

return Helper