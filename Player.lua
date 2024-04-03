local displayConstant = require("DisplayConstant")
local Helper = require("Helper")
local Options = require("Options")

local Player = {}
Player.__index = Player

Player.states = {
    PLAYING = "PLAYING",
    WAITING = "WAITING",
    PRINTING = "PRINTING",
}

function Player.new(dealer)
    local self = setmetatable({}, Player)
    self.hand = {}
    self.bet = 0
    self.state = Player.states.WAITING
    self.result = nil
    self.options = Options.new(self, dealer)

    return self
end

function Player:setState(state)
    self.state = Player.states[state]
end

function Player:update(dt, dealer)
    for _, card in ipairs(self.hand) do
        card:update(dt)
    end
    
    if self.state == Player.states.PLAYING then
        self.state = Player.states.PRINTING
    elseif self.state == Player.states.PRINTING then
        self.options:setStates("ACTIVE")
    elseif self.state == Player.states.WAITING then
        self.options:setStates("INACTIVE")
    end
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
    self:handState(dealer)
end

function Player:stay(dealer)
    self.state = Player.states.WAITING
    dealer:setState("PLAYING")
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
    self.options:draw()
end

function Player:handState(dealer)
    if Helper.isBlackjack(self.hand) then
        self.state = Player.states.WAITING
    elseif Helper.isBust(self.hand) then
        self.state = Player.states.WAITING
        dealer:setState("PLAYING")
    elseif Helper.calculateHandTotal(self.hand) == 21 then
        self.state = Player.states.WAITING
    end
end

return Player