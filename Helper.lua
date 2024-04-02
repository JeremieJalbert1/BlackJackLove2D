local Helper = {}

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

function Helper.canSplit(hand)
    if #hand == 2 then
        return hand[1].value == hand[2].value
    end
    return false
end

function Helper.canDouble(hand)
    return #hand == 2
end

function Helper.isBlackjack(hand)
    return #hand == 2 and Helper.calculateHandTotal(hand) == 21
end

function Helper.isBust(hand)
    return Helper.calculateHandTotal(hand) > 21
end

function Helper.whichHandWon(playerHand, dealerHand)
    local playerTotal = Helper.calculateHandTotal(playerHand)
    local dealerTotal = Helper.calculateHandTotal(dealerHand)
    
    if playerTotal > 21 then
        return "Dealer"
    elseif dealerTotal > 21 then
        return "Player"
    elseif playerTotal > dealerTotal then
        return "Player"
    elseif playerTotal < dealerTotal then
        return "Dealer"
    else
        return "Push"
    end
end

return Helper