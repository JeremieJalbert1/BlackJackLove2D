local Deck = require("Deck")
local Player = require("Player")
local Dealer = require("Dealer")
local Hand = require("Hand")
local BetZone = require("BetZone")
local Helper  = require("Helper")

Game = {}
Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)

    self.deck = Deck.new()
    self.dealer = Dealer.new(self.deck)
    self.player = Player.new(self.dealer)
    self.hand = Hand.new()
    self.betZone = BetZone.new()
    self.dealer:startDealing()

    return self
end

function Game:update(dt)
    self.hand:setState("PLAYING")
    if self.hand.state == Hand.states.PLAYING then
        self.dealer:update(dt, self.player, self.hand)
        self.player:update(dt, self.dealer)
    end
end

function Game:draw()
    self.deck:draw(100, 100)

    self.player:draw()
    self.dealer:displayHand()

    self.dealer:displayHandTotal() -- dealer
    self.betZone:draw()
    
end

function Game:mousepressed(x, y, button, istouch, presses)
    self.player:mousepressed(x, y, button)
end

function Game:mousereleased(x, y, button, istouch, presses)
    self.player:mousereleased(x, y, button)
    for _, chip in ipairs(self.player.chips) do
        if Helper.isColliding(chip, self.betZone) then
            self.betZone:addChip(chip)
        end
    end
end

function Game:mousemoved(x, y, dx, dy, istouch)
    self.player:mousemoved(x, y, dx, dy)
end

return Game