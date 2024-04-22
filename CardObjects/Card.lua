local class = require('Helpers.middleclass')
local Draggable = require("Draggable")
local Vector = require("Helpers.brinevector")

local Card = class('Card', Draggable)

function Card:initialize(suit, value, image, quad, isFaceUp, position)
    Draggable.initialize(self, position)
    local faceDownImage = love.graphics.newImage('Images/Card_Back-88x124.png')
    local faceDownQuad = love.graphics.newQuad(0, 0, 88, 124, faceDownImage:getDimensions())
    self.suit = suit
    self.value = value
    self.image = image
    self.quad = quad
    self.isFaceUp = isFaceUp or true
    self.width = 88
    self.height = 124
    self.faceDownImage = faceDownImage
    self.faceDownQuad = faceDownQuad
    self.position = Vector(position.x, position.y)
end

function Card:drawContent(x, y)
    if not self.isFaceUp then
        love.graphics.draw(self.image, self.quad, x, y)
    else
        love.graphics.draw(self.faceDownImage, self.faceDownQuad, x, y)
    end
end

return Card