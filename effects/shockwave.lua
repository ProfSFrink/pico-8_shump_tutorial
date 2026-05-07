-- Shockwave effect & logic.

-- Shockwave configs.

-- x: X position.
-- y: Y position.
-- spd: Speed of shockwave radius increase.
-- col: Color of shockwave.

slSwCfg = { r = 2, tr = 4, spd = 1, col = 9 }
lgSwCfg = { r = 2, tr = 24, spd = 2.5, col = 7 }

-- Spawn a shockwave at the given position.
-- @param sx: X position.
-- @param sy: Y position.
-- @param swConfig: Shockwave config object.
function spawnShockWave(sx, sy, swConfig)
    local sws = shwaves

    local s = {
        x = sx + 4,
        y = sy + 4,
        r = swConfig.r, -- current radius.
        tr = swConfig.tr,
        spd = swConfig.spd,
        col = swConfig.col,

        update = function(_ENV)
            r += spd

            if r > tr then
                del(sws, _ENV)
                return
            end

        end,

        draw = function(_ENV)
            circ(x, y, r, col)
        end
    }

    add(sws, s)
end