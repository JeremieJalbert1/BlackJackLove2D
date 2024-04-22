local middleclass = require("Helpers.middleclass")
local Helper = require("Helpers.HelperFunction")
local Deck = require("CardObjects.Deck")
local displayConstant = require("Constants.displayConstant")

local Player = middleclass("Player")

Player.static.states = {
    DRAW = "DRAW",
    WAITTING = "WAITTING",
    BETTING = "BETTING"
}

function Player:initialize()
    self.hand = {}
    self.deck = Deck:new()
    self.money = 0
    self.bet = 0
    self.score = 0
    self.state = Player.states.WAITTING

    self.chips = {}
    self.options = {} -- TODO: Implement options
end

function Player:setState(state)
    self.state = Player.states[state]
end

Player.static.BET = E.newEvent()
Player.static.HIT = E.newEvent()
Player.static.STAND = E.newEvent()
Player.static.DOUBLE = E.newEvent()
Player.static.SPLIT = E.newEvent()

Player.static.BET:addAction(
    function(self, chip)
        self.bet = self.bet + chip.values
        self.money = self.money - chip.values
        self:removeChip(chip)
    end
)

Player.static.HIT:addAction(
    function(self)
        self.states = Player.states.DRAW
    end
)

Player.static.STAND:addAction(
    function(self)
        self.states = Player.states.WAITTING
    end
)

function Player:addCard(card)
    table.insert(self.hand, card)
end

function Player:removeCard(card)
    table.remove(self.hand, helperFunction.findIndex(card, self.hand))
end

function Player:addChip(chip)
    table.insert(self.chips, chip)
end

function Player:removeChip(chip)
    table.remove(self.chips, helperFunction.findIndex(chip, self.chips))
end

function Player:displayHand()
    for i, card in ipairs(self.hand) do
        card:draw(card.position.x, card.position.y)
    end
end

function Player:displayHandTotal()
    love.graphics.print("Player's Total: " .. Helper.calculateHandTotal(self.hand), 5, love.graphics.getHeight() - displayConstant.CARD_HEIGHT/2 - displayConstant.BOTTOM_MARGIN)
end

function Player:displayMoney()
    love.graphics.print("Money: " .. self.money, 5, love.graphics.getHeight() - displayConstant.CARD_HEIGHT/2 - displayConstant.BOTTOM_MARGIN - 20)
end

function Player:draw()
    self:displayHand()
    self:displayHandTotal()
    self:displayMoney()
    -- self.options:draw()
    -- for _, chip in ipairs(self.chips) do
    --     chip:draw(100, 100)
    -- end
end

return Player