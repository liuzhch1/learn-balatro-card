require("card")

local DECK_SIZE = 52

Deck = {}
Deck.__index = Deck
function Deck.new(x, y)
    local self = setmetatable({
        cards = {},
        transform = {
            x = x,
            y = y
        }
    }, Deck)
    local deck_delta = 10 / DECK_SIZE
    for id = 1, DECK_SIZE do
        local card = Card.new(self, id, x, y, x - deck_delta * id, y + deck_delta * id)
        table.insert(self.cards, card)
    end
    return self
end

function Deck:collect()
    local deck_delta = 10 / #self.cards
    local count = 0
    for _, card in ipairs(self.cards) do
        if not card.on_deck then
            card:move_to(self.transform.x - deck_delta * _, self.transform.y + deck_delta * _)
            queue_sound(card_drop, 0.02 * count, 1)
            count = count + 1
            card.on_deck = true
        end
    end
end

function Deck:draw()
    for _, card in ipairs(self.cards) do
        card:draw()
    end
end

function Deck:bring_to_front(id)
    for i, card in ipairs(self.cards) do
        if (card.id == id) then
            table.remove(self.cards, i)
            table.insert(self.cards, card)
            break
        end
    end
end

return Deck

