local class = require('Helpers.middleclass')
local Vector = require('Helpers.brinevector')
local Helper = require('Helpers.HelperFunction')
local Card = require('CardObjects.Card')
local displayConstant = require('Constants.displayConstant')
local Timer = require('Helpers.timer')

local Dealer = class('Dealer')

Dealer.states = {
    DEALING = "DEALING",
    PLAYING = "PLAYING",
    FINISHED = "FINISHED",
    WAITING = "WAITING"
}

function Dealer:initialize(deck)
    self.deck = deck
    self.canDeal = true
    self.hand = {}
end

Dealer.static.DEALCARD = E.newEvent()

Dealer.static.DEALCARD:addAction(
    function(self, faceUp)
        self.canDeal = false
        faceUp = faceUp or false
        return self.deck:dealCard(faceUp)
    end
)

Timer.every(0.7, function()
    if not self.canDeal then
        self.canDeal = true
    end
end)

function Dealer:arrangeHand(startX, startY)
    for i, card in ipairs(self.hand) do
        local x = startX + (i - 1) * (displayConstant.CARD_WIDTH + displayConstant.SPACING_X)
        card.positionOriginal = Vector(x, startY)
        if card.state == "MOVING" then
            return
        else
            card.targetPosition = Vector(x, startY)
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
        self.state = Dealer.states.FINISHED
    end
end

function Dealer:shouldHit()
    return Helper.calculateHandTotal(self.hand) < 17
end

function Dealer:draw()
    self:displayHand()
    self:displayHandTotal()
end

return Dealer