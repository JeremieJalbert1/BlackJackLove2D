local Hand = {}
Hand.__index = Hand

Hand.states = {
    PLAYING = "PLAYING",
    WAITING = "WAITING",
    FINISHED = "FINISHED"
}

function Hand.new()
    local self = setmetatable({}, Hand)
    self.cards = {}
    self.state = Hand.states.WAITING
    return self
end

function Hand:setState(state)
    self.state = Hand.states[state]
end

return Hand