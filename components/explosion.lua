-- Explosion Factory data & logic.

-- NOTE: Explosions currently only work with 8x8 sprites. Adjustments would be needed to support larger sprites.

-- Initial explosion definitions.
clrs = { 5, 9, 10, 7 }
numOfExps = 20
ls = 5 -- Explosion lifetime.

-- Factory function for creating explosions.
-- @param x: The x position of the explosion.
-- @param y: The y position of the explosion.
-- @return: A new explosion object.
function newExp(x, y)
    return {
        x = x + 4,
        y = y + 4,
        spdX = 1 - rnd(2),
        spdY = 1 - rnd(2),
        scale = 2 + rnd(2),
        life = ls,

        update = function(self)
            self.x += self.spdX
            self.y += self.spdY
            self.scale -= .1
            self.life -= .1
            self.col = flr(self.life)

            if self.life <= 0 then
                del(exps, self)
            end
        end,

        draw = function(self)
            circfill(self.x, self.y, self.scale, clrs[self.col])
        end
    }
end

-- Create Explosion.
-- @param x: The x position of the explosion.
-- @param y: The y position of the explosion.
function spawnExp(x, y)
    for i = 1, numOfExps do
        add(exps, newExp(x, y))
    end
    sfx(rnd(2) + 2)
end