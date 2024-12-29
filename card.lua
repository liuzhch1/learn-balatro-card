local CARD_WIDTH = 120
local CARD_HEIGHT = 168

local card_sprite = love.graphics.newImage("card.png")

local Card = {}
Card.__index = Card

function Card.new(deck, id, x, y, target_x, target_y)
    local self = setmetatable({
        id = id,
        deck = deck,
        dragging = false,
        transform = {
            x = x,
            y = y,
            width = CARD_WIDTH,
            height = CARD_HEIGHT
        },
        target_transform = {
            x = target_x,
            y = target_y,
            width = CARD_WIDTH,
            height = CARD_HEIGHT
        },
        mouse_delta = {
            x = 0,
            y = 0
        },
        velocity = {
            x = 0,
            y = 0
        },
        on_deck = true,
        movement = {
            x = 0,
            y = 0,
            max_distance = 0
        }
    }, Card)
    return self
end

function Card:is_hovering(x, y)
    return x > self.transform.x and x < self.transform.x + self.transform.width and y > self.transform.y and y <
               self.transform.y + self.transform.height
end

function Card:start_dragging()
    self.deck:bring_to_front(self.id)
    self.dragging = true
    self.mouse_delta.x = love.mouse.getX() - self.transform.x
    self.mouse_delta.y = love.mouse.getY() - self.transform.y
    self.on_deck = false -- TODO: better way to do this
end

function Card:reset_movement()
    self.movement.x = self.transform.x
    self.movement.y = self.transform.y
    self.movement.max_distance = 0
end

function Card:update_movement(dt)
    self.movement.max_distance = math.max(self.movement.max_distance, math.abs(
        self.target_transform.x - self.transform.x) + math.abs(self.target_transform.y - self.transform.y))
end

function Card:stop_dragging()
    self.mouse_delta.x = 0
    self.mouse_delta.y = 0
    self.dragging = false
    if self.movement.max_distance > 0.1 then
        love.audio.play(card_drop)
    end
    self:reset_movement()
end

function Card:move_to(x, y)
    self.target_transform.x = x - self.mouse_delta.x
    self.target_transform.y = y - self.mouse_delta.y
end

function Card:move(dt)
    local momentum = 0.5
    if (self.target_transform.x ~= self.transform.x or self.velocity.x ~= 0) or
        (self.target_transform.y ~= self.transform.y or self.velocity.y ~= 0) then
        self.velocity.x = momentum * self.velocity.x + (1 - momentum) * (self.target_transform.x - self.transform.x) *
                              20 * dt
        self.velocity.y = momentum * self.velocity.y + (1 - momentum) * (self.target_transform.y - self.transform.y) *
                              20 * dt
        self.transform.x = self.transform.x + self.velocity.x
        self.transform.y = self.transform.y + self.velocity.y
    end
end

function Card:draw()
    self:update_movement(dt)
    love.graphics.draw(card_sprite, self.transform.x, self.transform.y)
    love.graphics.print(self.id, self.transform.x + CARD_WIDTH / 2, self.transform.y + CARD_HEIGHT / 2)
end

return Card
