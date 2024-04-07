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
        self.startGame:setState("INACTIVE")
    end, "ACTIVE")

    return self
end

function Game:update(dt)
    self.dealer:update(dt, self.player, self.hand)
    self.player:update(dt, self.dealer)
end

function Game:checkActorsState()
    if self.hand.state == "DEALING" then -- DEALING PHASE
        self.betZone:setStates("INACTIVE")
        self.dealer:setState("DEALING")
        self.hand:setState("PLAYING")

    elseif self.hand.state == "FINISHED" then -- FINISHED PHASE
        self.hand:setState("BETTING")
        self.startGame:setState("ACTIVE")
        self.dealer:setState("IDLE")

    elseif self.hand.state == "PLAYER" then -- PLAYER PHASE
        self.dealer:setState("WAITING")
        self.player:setState("PLAYING")

    elseif self.hand.state == "BETTING" then -- BETTING PHASE
        self.betZone:setStates("ACTIVE")
        self.player:setState("BETTING")

    elseif self.hand.state == "RESETTING" then -- RESETTING PHASE
        self.hand:checkResult(self.player, self.dealer)

    elseif self.hand.state == "DEALER" or self.player.state == "WAITING" then
        self.dealer:setState("PLAYING")
    end
end

function Game:draw()
    self.deck:draw(100, 100)

    self:checkActorsState()
 
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