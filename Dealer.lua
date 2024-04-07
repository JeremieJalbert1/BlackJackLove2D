local Deck = require("Deck")
local displayConstant = require("DisplayConstant")
local Helper = require("Helper")

local Dealer = {}
Dealer.__index = Dealer

Dealer.states = {
    IDLE = "IDLE",
    DEALING = "DEALING",
    PLAYING = "PLAYING",
    WAITING = "WAITING",
}

-- TODO: IF DECK IS EMPTY PERFECTLY AFTER THE HAND, THE LAST CARDS STAYS IN THE DECK.
-- TODO: REPOPULATE THE DECK IS NOT WORKING PROPERLY

function Dealer.new(deck)
    local self = setmetatable({}, Dealer)
    self.deck = deck or Deck.new()
    self.hand = {}
    self.endDeck = {}
    self.state = Dealer.states.IDLE

    self.dealIndex = 0
    self.actionTimer = 0
    self.actionDelay = 0.5

    self.chips = {}
    self.money = 1000
    
    self:shuffleDeck()
    self:startDealing()
    return self
end

function Dealer:setState(state)
    self.state = Dealer.states[state]
end

function Dealer:update(dt, player, hand)
    for _, card in ipairs(self.hand) do
        card:update(dt)
    end

    if self.actionTimer > 0 then
        self.actionTimer = self.actionTimer - dt
    end
    if self.state == Dealer.states.IDLE then
        self:startDealing()
    end
    if self.state == Dealer.states.DEALING and self.actionTimer <= 0 then
        self:dealHand(player)
        self.actionTimer = self.actionDelay
    elseif self.state == Dealer.states.PLAYING and self.actionTimer <= 0 then
        self:turnActions(hand)
        self.actionTimer = self.actionDelay
    end
end

function Dealer:resetHand(player)
    for key, card in ipairs(self.hand) do
        self.endDeck[key] = card
        self.hand[key] = nil
    end
    for key, card in ipairs(player.hand) do
        self.endDeck[key] = card
        player.hand[key] = nil
    end
end

function Dealer:playerWon(player)
    player.money = player.money + player.bet * 2
    self.money = self.money - player.bet
    print(player.bet, player.money)
end

function Dealer:startDealing()
    self.dealIndex = 0
    self.dealTimer = self.dealDelay
end

function Dealer:addCard(card)
    table.insert(self.hand, card)
    self:setHandPosition()
end

function Dealer:flipCard()
    self.hand[1].isFaceUp = false
    self.hand.faceUp = true
end

function Dealer:shouldHit()
    if Helper.calculateHandTotal(self.hand) < 17 then
        return true
    end
    return false
end

function Dealer:dealHand(player)
    self.dealIndex = self.dealIndex + 1
        if self.dealIndex == 1 then
            player:addCard(self:dealCard())
        elseif self.dealIndex == 2 then
            self:addCard(self:dealCard(true))
        elseif self.dealIndex == 3 then
            player:addCard(self:dealCard())
        elseif self.dealIndex == 4 then
            self:addCard(self:dealCard())
            self.state = Dealer.states.WAITING
            player:setState("PLAYING")
        end
end

function Dealer:dealCard(isFaceUp)
    if #self.deck.cards == 0 then
        self.deck.cards = self.endDeck
        self.endDeck = {}
        self:shuffleDeck()
    end
    print(#self.deck.cards)
    return self.deck:dealCard(isFaceUp)
end

function Dealer:shuffleDeck()
    self.deck:shuffle()
end

function Dealer:setHandPosition()
    local screenWidth = love.graphics.getWidth()
    local totalHandWidth = (#self.hand * displayConstant.CARD_WIDTH) +
                           ((#self.hand - 1) * displayConstant.SPACING_X)
    local startX = (screenWidth - totalHandWidth) / 2
    local startY = displayConstant.TOP_MARGIN

    for i, card in ipairs(self.hand) do
        local x = startX + (i - 1) * (displayConstant.CARD_WIDTH + displayConstant.SPACING_X)
        card.positionOriginal:set(x, startY)
        if card.state == "MOVING" then
            return
        else
            card.targetPosition:set(x, startY)
        end
    end
end

function Dealer:displayHand()
    for i, card in ipairs(self.hand) do
        card:draw(card.position.x, card.position.y)
    end
end

function Dealer:displayHandTotal()
    local total = Helper.calculateHandTotal(self.hand)
    local dealerTotalDisplay = "Dealer's Total: "
    
    if #self.hand > 0 and not self.hand.faceUp then
        dealerTotalDisplay = dealerTotalDisplay .. "?"
    else
        dealerTotalDisplay = dealerTotalDisplay .. total
    end
    love.graphics.print(dealerTotalDisplay, 5, displayConstant.TOP_MARGIN + displayConstant.CARD_HEIGHT / 2)
end

function Dealer:turnActions(hand)
    self:flipCard()
    if self:shouldHit() then
        self:addCard(self:dealCard())
    else 
        hand:setState("RESETTING")
    end
end

return Dealer