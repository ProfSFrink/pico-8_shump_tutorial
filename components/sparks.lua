-- Sparks effect & logic.
sparks = {}

-- Adds a new spark at the given position.
-- @param x: X position.
-- @param y: Y position.
function newSpark(x, y)
    local s = {
        x = x,
        y = y+8, -- Offset to appear at bottom of enemy.
        life = 8,-- Frames until the spark disappears.

        -- Current sprite being animated.
        curFram = 55,

        strtFram = 55,
        endFram = 58,
        -- Frames before animation advances.
        animDelay = 2,

        -- Frames since last animation change.
        animTimer = 0,

        update = function(self)
            self.life -= 1
            if self.life <= 0 then
                del(sparks, self)
            end

            self.animTimer += 1
            if self.animTimer >= self.animDelay then
                self.animTimer = 0
                if self.curFram < self.endFram then
                    self.curFram += 1
                end
            end
        end,

        draw = function(self)
            spr(self.curFram, self.x, self.y)
        end
    }

    add(sparks, s)
end