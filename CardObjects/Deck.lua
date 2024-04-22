local class = require('Helpers.middleclass')
local Card = require("CardObjects.Card")
local Vector = require("Helpers.brinevector")

local Deck = class('Deck')

function Deck:initialize()
    self.image = love.graphics.newImage('Images/Card_DeckA-88x140.png')
    self.quad = love.graphics.newQuad(88, 0, 88, 140, self.image:getDimensions())
    self.position = Vector(50, love.graphics.getHeight() / 2 - 70)
    self.cards = {}
    self.cardsInDeck = 52
    self:generate()
end

function Deck:draw(x, y)
    love.graphics.draw(self.image, self.quad, self.position.x, self.position.y)
end

function Deck:resetPosition()
    for _, card in ipairs(self.cards) do
        card.position:set(self.position.x, self.position.y)
    end
end

function Deck:generate()
    local suits = {'Hearts', 'Diamonds', 'Clubs', 'Spades'}
    local values = {'Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King'}

    local suitImages = {
        Hearts = love.graphics.newImage('Images/Hearts-88x124.png'),
        Diamonds = love.graphics.newImage('Images/Diamonds-88x124.png'),
        Clubs = love.graphics.newImage('Images/Clubs-88x124.png'),
        Spades = love.graphics.newImage('Images/Spades-88x124.png')
    }

    local cardsPerRow = 5  -- Update this with the actual number of cards per row in your spritesheet
end

return Deck