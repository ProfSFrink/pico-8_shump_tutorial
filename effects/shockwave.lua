-- Shockwave effect & logic.

-- Shockwave configs.

-- x: X position.
-- y: Y position.
-- spd: Speed of shockwave radius increase.
-- col: Color of shockwave.

slSwCfg = { r = 2, tr = 4, spd = 1, col = 9 }
lgSwCfg = { r = 2, tr = 28, spd = 3.5, col = 7 }

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

-- Update all shockwaves.
function updateShockWaves()
    for w in all(shwaves) do
        w:update()
    end
end

-- Draw all shockwaves.
function drawShockWaves()
    for w in all(shwaves) do
        w:draw()
    end
end