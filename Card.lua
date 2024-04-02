local Draggable = require("Draggable")
local Vec2d = require("Vec2d")

local Card = setmetatable({}, {__index = Draggable})

function Card:new(suit, value, image, quad, isFaceUp, position)
    local instance = setmetatable(Draggable:new(position), {__index = Card})

    -- Create a new Draggable object for Card to inherit from
    local faceDownImage = love.graphics.newImage('Images/Card_Back-88x124.png')
    local faceDownQuad = love.graphics.newQuad(0, 0, 88, 124, faceDownImage:getDimensions())
    instance.suit = suit
    instance.value = value
    instance.image = image
    instance.quad = quad
    if isFaceUp == nil then
        instance.isFaceUp = true
    else
        instance.isFaceUp = isFaceUp
    end
    instance.width = 88
    instance.height = 124
    instance.faceDownImage = faceDownImage
    instance.faceDownQuad = faceDownQuad

    return instance
end

-- Function to draw a card
function Card:drawContent(x, y)
    if not self.isFaceUp then
        love.graphics.draw(self.image, self.quad, x, y)
    else
        love.graphics.draw(self.faceDownImage, self.faceDownQuad, x, y)
    end
end

return Card