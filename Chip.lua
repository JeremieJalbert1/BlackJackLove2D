local Draggable = require("Draggable")

local Chip = setmetatable({}, {__index = Draggable})

function Chip.new(position, value)
    local self = setmetatable(Draggable:new(position), {__index = Chip})

    self.image = love.graphics.newImage('Images/ChipsA_Outline-64x72-removebg-preview.png')
    self.value = value
    self.width = 64
    self.height = 72
    self.quad = self:selectImage(value)

    return self
end

function Chip:returnToPlayer()
    self.targetPosition = self.originalPosition
end

function Chip:selectImage(value)
    if value == 1 then
        return love.graphics.newQuad(0, 0, 64, 72, self.image:getDimensions())
    elseif value == 5 then
        return love.graphics.newQuad(64, 0, 64, 72, self.image:getDimensions())
    elseif value == 10 then
        return love.graphics.newQuad(128, 0, 64, 72, self.image:getDimensions())
    elseif value == 25 then
        return love.graphics.newQuad(192, 0, 64, 72, self.image:getDimensions())
    elseif value == 100 then
        return love.graphics.newQuad(256, 0, 64, 72, self.image:getDimensions())
    end
end

function Chip:drawContent(x, y)
    love.graphics.draw(self.image, self.quad, x, y)
end

return Chip