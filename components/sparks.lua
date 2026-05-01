-- Sparks effect & logic.
sparks = {}

-- Adds a new spark at the given position.
-- @param sx: X position.
-- @param sy: Y position.
-- @param sspd: Spark speed.
function newSpark(sx, sy, sspd)
    local spks = sparks

    local s = {
        x = sx,
        y = sy + 4,
        spd = sspd,
        life = 8,

        curFram = 55,
        strtFram = 55,
        endFram = 58,
        animDelay = 2,
        animTimer = 0,

        update = function(_ENV)
            y += spd
            life -= 1

            if life <= 0 then
                del(spks, _ENV)
                return
            end

            animTimer += 1
            if animTimer >= animDelay then
                animTimer = 0
                if curFram < endFram then
                    curFram += 1
                end
            end
        end,

        draw = function(_ENV)
            spr(curFram, x, y)
        end
    }

    add(spks, s)
end