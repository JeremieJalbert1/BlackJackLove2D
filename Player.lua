local displayConstant = require("DisplayConstant")
local Helper = require("Helper")

local Player = {}
Player.__index = Player

function Player.new()
    local self = setmetatable({}, Player)
    self.hand = {}
    self.bet = 0
    self.isTurn = false
    self.result = nil

    return self
end

function Player:setCardPositionForHand()
    local screenWidth = love.graphics.getWidth()
    local totalHandWidth = (#self.hand * displayConstant.CARD_WIDTH) +
                           ((#self.hand - 1) * displayConstant.SPACING_X)
    local startX = (screenWidth - totalHandWidth) / 2
    local startY = love.graphics.getHeight() - displayConstant.CARD_HEIGHT - displayConstant.BOTTOM_MARGIN

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

function Player:addCard(card)
    table.insert(self.hand, card)
    self:setCardPositionForHand()
end

function Player:setBet(amount)
    self.bet = amount
end

function Player:hit(dealer)
    local card = dealer:dealCard()
    self:addCard(card)
    self:handState()
end

function Player:stay()
    self.isTurn = false
end

function Player:double(dealer)
    self.bet = self.bet * 2
    self:hit(dealer)
    self:stay()
end

function Player:split()
    -- Implement splitting logic
end

function Player:displayHand()
    for i, card in ipairs(self.hand) do
        card:draw(card.vec2d.x, card.vec2d.y)
    end
end

function Player:displayHandTotal()
    love.graphics.print("Player's Total: " .. Helper.calculateHandTotal(self.hand), 5, love.graphics.getHeight() - displayConstant.CARD_HEIGHT/2 - displayConstant.BOTTOM_MARGIN)
end

function Player:draw()
    self:displayHand()
    self:displayHandTotal()
end

function Player:handState()
    if Helper.isBlackjack(self.hand) then
        self.isTurn = false
        self.result = "Blackjack"
    elseif Helper.isBust(self.hand) then
        self.isTurn = false
        self.result = "Bust"
    elseif Helper.calculateHandTotal(self.hand) == 21 then
        self.isTurn = false
        self.result = "21"
    end
end

return Player