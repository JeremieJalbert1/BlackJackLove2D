local Vec2d = {
    x = 0,
    y = 0
}

function Vec2d:new(x, y)
    local newObj = {
        x = x or 0,
        y = y or 0
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function Vec2d:copy()
    return Vec2d:new(self.x, self.y)
end

function Vec2d:set(x, y)
    self.x = x
    self.y = y
end

return Vec2d