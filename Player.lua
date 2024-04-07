local displayConstant = require("DisplayConstant")
local Helper = require("Helper")
local Options = require("Options")
local Chip = require("Chip")
local Vec2d = require("Vec2d")

local Player = {}
Player.__index = Player

Player.states = {
    PLAYING = "PLAYING",
    WAITING = "WAITING",
    PRINTING = "PRINTING",
    BETTING = "BETTING"
}

function Player.new(dealer)
    local self = setmetatable({}, Player)
    self.hand = {}
    self.money = 1000
    self.bet = 0
    self.state = Player.states.BETTING
    self.result = nil
    self.options = Options.new(self, dealer)
    self.chips = {}
    self:createChips()

    return self
end

function Player:setState(state)
    self.state = Player.states[state]
end

function Player:update(dt, dealer)
    for _, card in ipairs(self.hand) do
        card:update(dt)
    end
    for _, chip in ipairs(self.chips) do
        chip:update(dt)
    end
    if self.state == Player.states.PLAYING then
        self.state = Player.states.PRINTING
    elseif self.state == Player.states.PRINTING then
        self.options:setStates("ACTIVE")
    elseif self.state == Player.states.WAITING then
        self.options:setStates("INACTIVE")
    end
end

function Player:createChips()
    local amount = self.money/10

    for i = 1, 1 do
        table.insert(self.chips, Chip.new(Vec2d:new(100, 100), amount))
    end
    self:setChipsPosition()
end

function Player:setCardPosition()
    local screenWidth = love.graphics.getWidth()
    local totalHandWidth = (#self.hand * displayConstant.CARD_WIDTH) +
                           ((#self.hand - 1) * displayConstant.SPACING_X)
    local startX = (screenWidth - totalHandWidth) / 2
    local startY = love.graphics.getHeight() - displayConstant.CARD_HEIGHT - displayConstant.BOTTOM_MARGIN

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

function Player:setChipsPosition()
    local screenWidth = love.graphics.getWidth()
    local totalChipsWidth = (#self.chips * displayConstant.CHIP_WIDTH) +
                            ((#self.chips - 1) * displayConstant.SPACING_X)
    local startX = (screenWidth - totalChipsWidth) / 4
    local startY = love.graphics.getHeight() - displayConstant.CHIP_HEIGHT - displayConstant.BOTTOM_MARGIN

    for i, chip in ipairs(self.chips) do
        local x = startX + (i - 1) * (displayConstant.CHIP_WIDTH + displayConstant.SPACING_X)
        chip.positionOriginal:set(x, startY)
        if chip.state == "MOVING" then
            return
        else
            chip.targetPosition:set(x, startY)
        end
    end

end

function Player:addCard(card)
    table.insert(self.hand, card)
    self:setCardPosition()
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
    self:stay(dealer)
end

function Player:split()
    -- Implement splitting logic
end

function Player:displayHand()
    for i, card in ipairs(self.hand) do
        card:draw(card.position.x, card.position.y)
    end
end

function Player:displayHandTotal()
    love.graphics.print("Player's Total: " .. Helper.calculateHandTotal(self.hand), 5, love.graphics.getHeight() - displayConstant.CARD_HEIGHT/2 - displayConstant.BOTTOM_MARGIN)
end

function Player:draw()
    self:displayHand()
    self:displayHandTotal()
    self.options:draw()
    for _, chip in ipairs(self.chips) do
        chip:draw(100, 100)
    end
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

function Player:mousepressed(x, y, button)
    for _, chip in ipairs(self.chips) do
        chip:mousepressed(x, y, button)
    end
    self.options:mousepressed(x, y, button)
    
    for _, card in pairs(self.hand) do
        card:mousepressed(x, y, button)
    end
end

function Player:mousereleased(x, y, button)
    for _, chip in ipairs(self.chips) do
        chip:mousereleased(x, y, button)
    end
    for _, card in pairs(self.hand) do
        card:mousereleased(x, y, button)
    end
end

function Player:mousemoved(x, y, dx, dy)
    for _, chip in ipairs(self.chips) do
        chip:mousemoved(x, y, dx, dy)
    end
    for _, card in pairs(self.hand) do
        card:mousemoved(x, y, dx, dy)
    end
end

return Player