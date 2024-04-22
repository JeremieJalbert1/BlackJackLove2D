-- TODO: CHANGE POSITION SYSTEM
-- 2. target position
-- 3. actual position
-- 4. reset position (original position)

local class = require('Helpers.middleclass')

local Draggable = class('Draggable')

Draggable.states = {
    MOVING = "MOVING",
    NOT_MOVING = "NOT_MOVING",
    RESET = "RESET"
}

function Draggable:initialize()
    self.offsetX = 0
    self.offsetY = 0
    self.angle = 0
    self.canReset = false
    self.resetPosition = Vec2d:new(0, 0)
    self.initialAngle = 0
    self.position = position or Vec2d:new(0, 0)
    self.positionOriginal = Vec2d:new(0, 0)
    self.targetPosition = Vec2d:new(0, 0) 
end

function Draggable:mousepressed(x, y, button)
    if button == 2 and self:isMouseOver(x, y) and self.canReset then
        self.state = Draggable.states.RESET
        self.targetPosition = self.resetPosition
        return true
    end
end

function Draggable:mousereleased(x, y, button)
    if button == 1 and self.state == Draggable.states.MOVING then
        self.state = Draggable.states.NOT_MOVING
    end
end

function Draggable:mousemoved(x, y, dx, dy)
    if self.state == Draggable.states.MOVING then
        self.targetPosition.x = x - self.offsetX
        self.targetPosition.y = y - self.offsetY
        local maxAngle = math.rad(15)
        self.angle = math.max(math.min(dx * 0.01, maxAngle), -maxAngle)
    end
end

function Draggable:isMouseOver(x, y)
    return x >= self.position.x and x <= self.position.x + self.width and y >= self.position.y and y <= self.position.y + self.height
end

function Draggable:draw()
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.rotate(self.angle)
    -- Draw at the origin of the translated and rotated coordinate system
    self:drawContent(0, 0)
    love.graphics.pop()
end

return Draggable