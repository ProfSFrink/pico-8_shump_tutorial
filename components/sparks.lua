-- Sparks effect & logic.

-- Adds a new shockwave at the given position.
-- @param sx: X position.
-- @param sy: Y position.
-- @param sspd: Shockwave speed.
function newShockWave(sx, sy, sspd)
    local sws = shwaves

    local s = {
        x = sx + 4,
        y = sy + 4,
        spd = sspd,
        radius = 0,
        life = 4,

        update = function(_ENV)
            y += spd
            life -= 1

            if life <= 0 then
                del(sws, _ENV)
                return
            end

            radius += 1
        end,

        draw = function(_ENV)
            circ(x, y, radius, 7)
        end
    }

    add(sws, s)
end