Card = require("Card")
Vec2d = require("Vec2d")

Deck = {}
Deck.__index = Deck

function Deck.new()
    local self = setmetatable({}, Deck)
    self.image = love.graphics.newImage('Images/Card_DeckA-88x140.png')
    self.quad = love.graphics.newQuad(88, 0, 88, 140, self.image:getDimensions())
    self.position = Vec2d:new(50, love.graphics.getHeight() / 2 - 70)
    self.cards = {}
    self.cardsInDeck = 52
    self:generate()
    return self
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
    local cardWidth = 88
    local cardHeight = 124

    for suitIndex, suit in ipairs(suits) do
        for valueIndex, value in ipairs(values) do
            local row = math.floor((valueIndex - 1) / cardsPerRow)
            local col = (valueIndex - 1) % cardsPerRow
            local x = col * cardWidth
            local y = row * cardHeight
            local quad = love.graphics.newQuad(x, y, cardWidth, cardHeight, suitImages[suit]:getDimensions())
            table.insert(self.cards, Card:new(suit, value, suitImages[suit], quad, true, Vec2d:new(self.position.x, self.position.y)))
        end
    end
end

function Deck:shuffle()
    for i = #self.cards, 2, -1 do
        local j = math.random(i)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
end

function Deck:dealCard(isFaceUp)
    local card = table.remove(self.cards)
    card.isFaceUp = isFaceUp
    self.cardsInDeck = self.cardsInDeck - 1
    return card
end

return Deck