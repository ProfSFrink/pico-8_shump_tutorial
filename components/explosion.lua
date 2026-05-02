-- Explosion Factory data & logic.

-- NOTE: Explosions currently only work with 8x8 sprites. Adjustments would be needed to support larger sprites.

-- Initial explosion definitions.

-- No of explosions when enemy is
-- destroyed.
numOfExps = 20

-- Factory function for creating explosions.
-- @param x: The x position of the explosion.
-- @param y: The y position of the explosion.
-- @return: A new explosion object.
function newExp(expX, expY)
    -- Colours for explosions.
    local cols = { 5, 9, 10, 7 }
    return {
        x = expX + 4,
        y = expY + 4,
        spdX = 1 - rnd(2),
        spdY = 1 - rnd(2),
        scale = 2 + rnd(2),
        life = 5,

        update = function(_ENV)
            x += spdX
            y += spdY
            scale -= .1
            life -= .1
            col = flr(life)

            if life <= 0 then
                del(exps, _ENV)
            end
        end,

        draw = function(_ENV)
            circfill(x, y, scale, cols[col])
        end
    }
end

-- Create Explosion.
-- @param x: The x position of the explosion.
-- @param y: The y position of the explosion.
function spawnExp(expX, expY)
    for i = 1, numOfExps do
        add(exps, newExp(expX, expY))
    end
    sfx(rnd(2) + 2)
end