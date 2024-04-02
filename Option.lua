Option = {}
Option.__index = Option

function Option.new(text, x, y, width, height, action)
    local self = setmetatable({}, Option)
    self.text = text
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.enabled = true
    self.action = action  -- This should be a function that defines the action when the option is chosen
    return self
end

function Option:draw()
    if not self.enabled then
        love.graphics.setColor(0.8, 0.8, 0.8, 0.5) -- Disabled: lower opacity (0.5)
    else
        love.graphics.setColor(0.8, 0.8, 0.8, 1) -- Enabled: full opacity
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Text color remains the same, but you might also want to adjust it for disabled state
    love.graphics.setColor(0, 0, 0, 1) -- Button text color, full opacity
    love.graphics.print(self.text, self.x + self.width / 2 - love.graphics.getFont():getWidth(self.text) / 2, self.y + self.height / 2 - love.graphics.getFont():getHeight() / 2)

    love.graphics.setColor(1, 1, 1, 1) -- Reset to default color with full opacity
end

function Option:isMouseOver()
    local mouseX, mouseY = love.mouse.getPosition()
    return mouseX >= self.x and mouseX <= self.x + self.width and mouseY >= self.y and mouseY <= self.y + self.height
end

function Option:clicked()
    if self:isMouseOver() and self.enabled then
        self.action()
    end
end

function Option:changeState(state)
    self.enabled = state
end

return Option