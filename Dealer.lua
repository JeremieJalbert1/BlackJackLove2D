local Deck = require("Deck")
local displayConstant = require("DisplayConstant")
local Helper = require("Helper")

local Dealer = {}
Dealer.__index = Dealer

function Dealer.new(deck)
    local self = setmetatable({}, Dealer)
    self.deck = deck or Deck.new()
    self.hand = {}
    self.isDealing = false
    self.isPlaying = false

    self.dealIndex = 0
    self.dealTimer = 0
    self.dealDelay = 1
    
    self:shuffleDeck()
    return self
end

function Dealer:startDealing()
    self.isDealing = true
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

function Dealer:dealCard(isFaceUp)
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
        card.vec2dOriginal:set(x, startY)
        if card.isDragging then
            return
        else
            card.targetVec2d:set(x, startY)
        end
    end
end

function Dealer:displayHand()
    for i, card in ipairs(self.hand) do
        print(card.vec2d.x, " ",card.vec2d.y)
        card:draw(card.vec2d.x, card.vec2d.y)
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

function Dealer:turnActions()
    self:flipCard()
    if self:shouldHit() then
        self:addCard(self:dealCard())
    else
        self.isPlaying = false
    end
end

return Dealer