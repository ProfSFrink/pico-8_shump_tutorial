-- Spark effect & logic.

-- Function for creating a spark effect
-- at a given position and colour.
-- @param sx: The x pos of the spark.
-- @param sy: The y pos of the spark.
-- @param col: The colour of the spark.
function spawnSparks(sx, sy, col)
    local sps = sparks

    local s = {
        x = sx + 4,
        y = sy + 4,
        spdX = (rnd() - 0.5) * 2,
        spdY = (rnd() - 1) * 2,
        col = col,
        life = ranFloat(1, 3),

        update = function(_ENV)
            x += spdX
            y += spdY
            life -= .2

            if life <= 0 then
                del(sps, _ENV)
                return
            end
        end,

        draw = function(_ENV)
            pset(x, y, col)
        end
    }

    add(sps, s)
end