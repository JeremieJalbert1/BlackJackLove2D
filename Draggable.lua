local Vec2d = require("Vec2d")
local Draggable = {}
Draggable.__index = Draggable

function Draggable:new(position)
    local instance = setmetatable({}, Draggable)
    instance.isDragging = false
    self.__index = self
    instance.offsetX = 0
    instance.offsetY = 0
    instance.angle = 0
    instance.initialAngle = 0
    instance.vec2d = position or Vec2d:new(0, 0)
    instance.vec2dOriginal = Vec2d:new(0, 0)
    instance.targetVec2d = Vec2d:new(0, 0) 
    return instance
end

function Draggable:update(dt)
    if self.isDragging then
        -- Interpolate the current position towards the target position
        local lerpFactor = 0.09
        self.vec2d.x = self.vec2d.x + (self.targetVec2d.x - self.vec2d.x) * lerpFactor
        self.vec2d.y = self.vec2d.y + (self.targetVec2d.y - self.vec2d.y) * lerpFactor
    end
    if not self.isDragging then
        local resetSpeedPos = 0.1 -- Adjust this value as needed
        local resetSpeedAngle = 3.5 -- Adjust this value as needed
        -- LERP for position
        if math.abs(self.vec2d.x - self.vec2dOriginal.x) > 0.1 or math.abs(self.vec2d.y - self.vec2dOriginal.y) > 0.1 then
            self.vec2d.x = self.vec2d.x + (self.vec2dOriginal.x - self.vec2d.x) * resetSpeedPos
            self.vec2d.y = self.vec2d.y + (self.vec2dOriginal.y - self.vec2d.y) * resetSpeedPos
            self.targetVec2d:set(self.vec2d.x, self.vec2d.y)
        else
            self.vec2d:set(self.vec2dOriginal.x, self.vec2dOriginal.y)
            self.targetVec2d:set(self.vec2d.x, self.vec2d.y)
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
        self.offsetX = x - self.vec2d.x
        self.offsetY = y - self.vec2d.y
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
        self.targetVec2d.x = x - self.offsetX
        self.targetVec2d.y = y - self.offsetY
        local maxAngle = math.rad(15)
        self.angle = math.max(math.min(dx * 0.01, maxAngle), -maxAngle)
    end
end

function Draggable:isMouseOver(x, y)
    return x >= self.vec2d.x and x <= self.vec2d.x + self.width and y >= self.vec2d.y and y <= self.vec2d.y + self.height
end

function Draggable:draw()
    love.graphics.push()
    love.graphics.translate(self.vec2d.x, self.vec2d.y)
    love.graphics.rotate(self.angle)
    if self.drawContent then
        -- Draw at the origin of the translated and rotated coordinate system
        self:drawContent(0, 0)
    end
    love.graphics.pop()
end

return Draggable