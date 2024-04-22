local class = require('Helpers.middleclass')
local Deck = require("CardObjects.Deck")
local Player = require("Actors.Player")
local Dealer = require("Actors.Dealer") 
-- local BetZone = require("Actors.BetZone")
local Helper  = require("Helpers.HelperFunction")
local Option = require("Options.Option")

local Game = class('Game')

function Game:initialize()
    self.player = Player:new()
    self.dealer = Dealer:new(self.player.deck)
    -- self.betZone = BetZone:new()
    -- self.betZone:setStates("ACTIVE")
end

function Game:update(dt)
    -- self.player:update(dt)
    -- self.betZone:update(dt)
    
    if self.player.state ~= Player.states.WAITTING then
        if self.player.state == Player.states.BETTING then
            i = 1
        elseif self.player.state == Player.states.DRAW then
            self.player:addCard(self.dealer:dealCard())
        end
    end
    if self.dealer.state ~= Dealer.states.WAITING then
        if self.dealer.state == Dealer.states.DEALING then
            self.dealer:dealFirstHand()
        elseif self.dealer.state == Dealer.states.PLAYING then
            self.dealer:turnActions(self.dealer.hand)
        end
    
    end


end

function Game:firstHand()
    self.player:addCard(self.dealer.dealCard:trigger())
    self.dealer:addCard(self.dealer.dealCard:trigger(true))
    self.player:addCard(self.dealer.dealCard:trigger())
    self.dealer:addCard(self.dealer.dealCard:trigger())
end

function Game:draw()
    self.player:draw()
    self.dealer:draw()
    self.startGame:draw()
end

function Game:mousepressed(x, y, button, istouch, presses)

end

function Game:mousereleased(x, y, button, istouch, presses)
   
end

function Game:mousemoved(x, y, dx, dy, istouch)
end

return Game
