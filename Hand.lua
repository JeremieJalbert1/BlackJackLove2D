local Helper = require("Helper")

local Hand = {}
Hand.__index = Hand

Hand.states = {
    PLAYING = "PLAYING",
    WAITING = "WAITING",
    FINISHED = "FINISHED",
    BETTING = "BETTING"
}

Hand.results = {
    WIN = "WIN",
    BLACKJACK = "BLACKJACK",
    LOSE = "LOSE",
    DRAW = "PUSH"
}

function Hand.new()
    local self = setmetatable({}, Hand)
    self.cards = {}
    self.state = Hand.states.WAITING
    self.result = nil
    return self
end

function Hand:addCard(card)
    table.insert(self.cards, card)
end

function Hand:setState(state)
    self.state = Hand.states[state]
end

function Hand:setResult(result)
    self.result = Hand.results[result]
end

function Hand:update(dt, player, dealer)
    if self.state == Hand.states.FINISHED then
        self:checkResult(player, dealer)
    end
    
end

function Hand:playerBet(chip, player, betZone)
    player:placeBet(chip)
    betZone:addChip(chip)
end

function Hand:checkResult(player, dealer)
    if self.result == nil then
        print("Checking result")
        self:setResult(Helper.whichHandWon(player.hand, dealer.hand))
    end

    if self.result == Hand.results.WIN then
        dealer:playerWon(player)
    elseif self.result == Hand.results.LOSE then
        print("LOSE")
    elseif self.result == Hand.results.BLACKJACK then
        print("BLACKJACK")
        player.money = player.money + player.bet * 2.5
    elseif self.result == Hand.results.DRAW then
        print("PUSH")
        player.money = player.money + player.bet
    end
    self:setState("BETTING")
end

return Hand