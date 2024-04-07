local Vec2d = require("Vec2d")
local Helper = require("Helper")

local BetZone = {}
BetZone.__index = BetZone

local states = {
    ACTIVE = "ACTIVE",
    INACTIVE = "INACTIVE"
}

function BetZone.new()
    local self = setmetatable({}, BetZone)
    self.chips = {}
    self.totalBet = 0
    self.width = 100
    self.height = 100
    self.position = Vec2d:new(love.graphics.getWidth() / 2 - self.width/2, love.graphics.getHeight() / 2 + 50)
    
    return self
end

function BetZone:update(dt)
    for _, chip in ipairs(self.chips) do
        chip:update(dt)
    end
end

function BetZone:setStates(state)
    self.state = states[state]
end

function BetZone:addChip(chip)
    if Helper.objectInTable(chip, self.chips) then
        chip:newOriginalPosition(love.mouse.getPosition().x, love.mouse.getPosition().y)
        return
    end
    table.insert(self.chips, chip)
    chip:newOriginalPosition(chip.position.x, chip.position.y)
    chip.canReset = true
    self.totalBet = self.totalBet + chip.value
end

function BetZone:draw()
    for _, chip in ipairs(self.chips) do
        chip:draw()
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.width, self.height)
    love.graphics.print("Total Bet: " .. self.totalBet, self.position.x, self.position.y - 20)
end

function BetZone:mousepressed(x, y, button, player)
    for _, chip in ipairs(self.chips) do
        if chip:mousepressed(x, y, button) then
            self.totalBet = self.totalBet - chip.value
            table.remove(self.chips, Helper.findIndex(self.chips, chip))
            table.insert(player.chips, chip)
        end
    end
end

return BetZone