local Vec2d = require("Vec2d")
local Draggable = {}
Draggable.__index = Draggable

-- TODO: CHANGE POSITION SYSTEM
-- 2. target position
-- 3. actual position
-- 4. reset position (original position)

function Draggable:new(position)
    local instance = setmetatable({}, Draggable)
    instance.isDragging = false
    self.__index = self
    instance.offsetX = 0
    instance.offsetY = 0
    instance.angle = 0
    instance.resetPosition = Vec2d:new(0, 0)
    instance.initialAngle = 0
    instance.position = position or Vec2d:new(0, 0)
    instance.positionOriginal = Vec2d:new(0, 0)
    instance.targetPosition = Vec2d:new(0, 0) 
    return instance
end

function Draggable:newOriginalPosition(x, y)
    self.resetPosition = self.positionOriginal
    self.positionOriginal = Vec2d:new(x, y)
end

function Draggable:update(dt)
    if self.isDragging then
        -- Interpolate the current position towards the target position
        local lerpFactor = 0.07
        self.position.x = self.position.x + (self.targetPosition.x - self.position.x) * lerpFactor
        self.position.y = self.position.y + (self.targetPosition.y - self.position.y) * lerpFactor
    end
    if not self.isDragging then
        local resetSpeedPos = 0.07 -- Adjust this value as needed
        local resetSpeedAngle = 3.5 -- Adjust this value as needed
        -- LERP for position
        if math.abs(self.position.x - self.positionOriginal.x) > 0.1 or math.abs(self.position.y - self.positionOriginal.y) > 0.1 then
            self.position.x = self.position.x + (self.positionOriginal.x - self.position.x) * resetSpeedPos
            self.position.y = self.position.y + (self.positionOriginal.y - self.position.y) * resetSpeedPos
            self.targetPosition:set(self.position.x, self.position.y)
        else
            self.position:set(self.positionOriginal.x, self.positionOriginal.y)
            self.targetPosition:set(self.position.x, self.position.y)
        end

        -- LERP: Linearly interpolate the angle back to zero
        if math.abs(self.angle) < 0.01 then
            self.angle = 0
        else
            self.angle = self.angle - resetSpeedAngle * self.angle * dt
        end
    end
end

function Draggable:mousepressed(x, y, button)
    if button == 1 and self:isMouseOver(x, y) then
        self.isDragging = true
        self.offsetX = x - self.position.x
        self.offsetY = y - self.position.y
        local centerX = self.width / 2
        local centerY = self.height / 2
        self.initialAngle = math.atan2(self.offsetY - centerY, self.offsetX - centerX)
    end
end

function Draggable:mousereleased(x, y, button)
    if button == 1 and self.isDragging then
        self.isDragging = false
    end
end

function Draggable:mousemoved(x, y, dx, dy)
    if self.isDragging then
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
    if self.drawContent then
        -- Draw at the origin of the translated and rotated coordinate system
        self:drawContent(0, 0)
    end
    love.graphics.pop()
end

return Draggable