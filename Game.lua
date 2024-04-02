local Deck = require("Deck")
local Player = require("Player")
local Dealer = require("Dealer")
local Options = require("Option")
local Helper = require("Helper")

Game = {}
Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)

    self.deck = Deck.new()
    self.dealer = Dealer.new(self.deck)
    self.player = Player.new()
    self.dealer:startDealing()
    self:createOptions()
    return self
end

function Game:createOptions()
    local screenWidth = love.graphics.getWidth()
    local optionWidth = 100
    local optionHeight = 50
    local optionSpacing = 20  -- The spacing between each option

    -- Calculate the total width all the options will take
    local totalOptionsWidth = (4 * optionWidth) + ((4 - 1) * optionSpacing)

    -- Calculate the starting X position for the first option to center them
    local startX = (screenWidth - totalOptionsWidth) / 2

    -- Define the Y position for all options
    local optionY = (love.graphics.getHeight() - optionHeight) / 2  -- You can adjust this as needed

    -- Create each option with calculated X and Y positions
    self.options = {
        hit = Option.new("Hit", startX, optionY, optionWidth, optionHeight, function() self.player:hit(self.dealer) end),
        stay = Option.new("Stay", startX + (optionWidth + optionSpacing) * 1, optionY, optionWidth, optionHeight, function() self.player:stay(self.dealer) end),
        double = Option.new("Double", startX + (optionWidth + optionSpacing) * 2, optionY, optionWidth, optionHeight, function() self.player:double(self.dealer) end),
        split = Option.new("Split", startX + (optionWidth + optionSpacing) * 3, optionY, optionWidth, optionHeight, function() self.player:split(self.dealer) end)
    }
end

function Game:dealHand()
    self.dealer.dealIndex = self.dealer.dealIndex + 1
        if self.dealer.dealIndex == 1 then
            self.player:addCard(self.dealer:dealCard())
        elseif self.dealer.dealIndex == 2 then
            self.dealer:addCard(self.dealer:dealCard(true))
        elseif self.dealer.dealIndex == 3 then
            self.player:addCard(self.dealer:dealCard())
        elseif self.dealer.dealIndex == 4 then
            self.dealer:addCard(self.dealer:dealCard())
            self.dealer.isDealing = false  -- End the dealing process
        end
end

function Game:update(deltaTime)
    -- Update the dealer's timer and deal cards if necessary
    self.dealer.dealTimer = self.dealer.dealTimer - deltaTime
    if self.dealer.dealTimer <= 0 and self.dealer.isDealing then
        self.dealer.dealTimer = self.dealer.dealDelay
        self:dealHand()

        -- Once dealing is done, check if it's time for the player to act
        if not self.dealer.isDealing and not self.player.hasActed then
            self.player.isTurn = true
        end
    end

    if not self.player.isTurn and not self.dealer.isDealing then
        self.dealer.isPlaying = true
    end

    if self.dealer.isPlaying then
        self.dealer:turnActions(deltaTime)
    end

    -- Placeholder for end-of-round logic
    if not self.dealer.isPlaying and not self.dealer.isDealing and not self.player.isTurn then
        print(Helper.whichHandWon(self.player.hand, self.dealer.hand))
    end

    self.options.hit:changeState(self.player.isTurn)
    self.options.stay:changeState(self.player.isTurn)
    if Helper.canDouble(self.player.hand) then
        self.options.double:changeState(self.player.isTurn)
    else
        self.options.double:changeState(false)
    end
    if Helper.canSplit(self.player.hand) then
        self.options.split:changeState(self.player.isTurn)
    else
        self.options.split:changeState(false)
    end

    for _, card in ipairs(self.dealer.hand) do
        card:update(deltaTime)
    end

    for _, card in ipairs(self.player.hand) do
        card:update(deltaTime)
    end
end

function Game:draw()
    self.options.hit:draw()
    self.options.stay:draw()
    self.options.double:draw()
    self.options.split:draw()
    self.deck:draw(100, 100)

    self.player:displayHand()
    self.dealer:displayHand()

    self.player:displayHandTotal() -- player
    self.dealer:displayHandTotal() -- dealer
end

function Game:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for _, option in pairs(self.options) do
            option:clicked()
        end

        for _, card in pairs(self.player.hand) do
            card:mousepressed(x, y, button)
        end
    end
end

function Game:mousereleased(x, y, button, istouch, presses)
    for _, card in pairs(self.player.hand) do
        card:mousereleased(x, y, button)
    end
end

function Game:mousemoved(x, y, dx, dy, istouch)
    for _, card in pairs(self.player.hand) do
        card:mousemoved(x, y, dx, dy)
    end
end

return Game