local Vec2d = require("Vec2d")

local BetZone = {}
BetZone.__index = BetZone

function BetZone.new()
    local self = setmetatable({}, BetZone)
    self.chips = {}
    self.totalBet = 0
    self.width = 100
    self.height = 100
    self.position = Vec2d:new(love.graphics.getWidth() / 2 - self.width/2, love.graphics.getHeight() / 2 + 50)
    
    return self
end

function BetZone:addChip(chip)
    table.insert(self.chips, chip)
    chip:newOriginalPosition(chip.targetPosition.x, chip.targetPosition.y)
    chip.inBetZone = true
    self.totalBet = self.totalBet + chip.value
end

function BetZone:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.width, self.height)
    love.graphics.print("Total Bet: " .. self.totalBet, self.position.x, self.position.y - 20)
end

return BetZone