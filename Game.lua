local Deck = require("Deck")
local Player = require("Player")
local Dealer = require("Dealer")
local Hand = require("Hand")
local BetZone = require("BetZone")
local Helper  = require("Helper")
local Option = require("Option")

Game = {}
Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)

    self.deck = Deck.new()
    self.dealer = Dealer.new(self.deck)
    self.player = Player.new(self.dealer)
    self.hand = Hand.new()
    self.betZone = BetZone.new()
    self.hand:setState("BETTING")
    self.betZone:setStates("ACTIVE")
    
    self.startGame = Option.new("Start Game", 100, 500, 100, 50, function ()
        self.hand:setState("DEALING")
        self.betZone:setStates("INACTIVE")
        self.dealer:setState("DEALING")
        self.player:setState("WAITING")
        self.startGame:setState("INACTIVE")
    end, "ACTIVE")

    return self
end

function Game:update(dt)
    self.dealer:update(dt, self.player, self.hand)
    self.player:update(dt, self.dealer)
    self.hand:update(dt, self.player, self.dealer)
end

function Game:draw()
    self.deck:draw(100, 100)
 
    self.player:draw()
    self.dealer:displayHand()

    self.dealer:displayHandTotal() -- dealer
    self.betZone:draw()
    
    self.startGame:draw()
end

function Game:mousepressed(x, y, button, istouch, presses)
    self.player:mousepressed(x, y, button)
    self.betZone:mousepressed(x, y, button, self.player)
    self.startGame:clicked()
end

function Game:mousereleased(x, y, button, istouch, presses)
    self.player:mousereleased(x, y, button)

    for _, chip in ipairs(self.player.chips) do
        if Helper.isColliding(chip, self.betZone) then
            self.hand:playerBet(chip, self.player, self.betZone)
        end
    end
end

function Game:mousemoved(x, y, dx, dy, istouch)
    self.player:mousemoved(x, y, dx, dy)
end

return Game