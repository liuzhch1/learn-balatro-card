local Deck = require("deck")

local screen_width = love.graphics.getWidth()
local screen_height = love.graphics.getHeight()

local sounds = {}

function queue_sound(sound, delay, pitch)
    table.insert(sounds, {
        sound = sound,
        delay = delay,
        pitch = pitch
    })
end

function love.load()
    deck = Deck.new(screen_width / 2 - 60, screen_height / 2 - 168)
    card_drop = love.audio.newSource("card_drop.wav", "static")
    love.window.setTitle("Card Game")
end

function love.draw()
    love.graphics.clear(0.95, 0.95, 0.95)
    deck:draw()
end

function love.mousepressed(x, y)
    for i = #deck.cards, 1, -1 do
        local card = deck.cards[i]
        if card:is_hovering(x, y) then
            card:start_dragging()
            break
        end
    end
end

function love.mousereleased(x, y)
    for _, card in ipairs(deck.cards) do
        if card.dragging then
            card:stop_dragging()
            break
        end
    end
end

function love.update(dt)
    for _, card in ipairs(deck.cards) do
        if card.dragging then
            card:move_to(love.mouse.getX(), love.mouse.getY())
        end
        card:move(dt)
    end

    local count = 1
    for idx, sound in ipairs(sounds) do
        if sound.delay <= 0 then
            sound.sound:setPitch(sound.pitch)
            love.audio.play(sound.sound)
            table.remove(sounds, idx)
            sound.sound:setPitch(sound.pitch)
        else
            sound.delay = sound.delay - dt
        end
    end
end

function love.keypressed(key)
    if key == "space" then
        deck:collect()
    end
end
