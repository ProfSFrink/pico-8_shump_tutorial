-- Enemy movement patterns.

-- Enemy stays in place.
-- @param e Enemy.
function stationary(e)
    e.x += e.xSpd
end

-- Enemy moves straight down.
-- @param e Enemy to move.
function down(e)
    e.y += e.ySpd
end

-- Enemy moves down while weaving left and right in a sine wave.
-- @param e Enemy to move.
function downWave(e, t)
    e.xSpd = sin(t / (e.waveLen))

    if e.x < 32 then
        e.xSpd += 1 - (e.x / 32)
    end

    if e.x > 88 then
        e.xSpd -= (e.x - 88) / 32
    end

    e.x += e.xSpd
    e.y += e.ySpd
end

-- Enemy moves down slowly while weaving left and right using cosine of its y position.
-- @param e Enemy to move.
function downWaveSlow(e)
    e.x += cos(e.y / 32) * e.xSpd
    e.y += e.ySpd / 2
end

-- Enemy moves down toward the horizontal center of the screen.
-- @param e Enemy to move.
function downTowardCenter(e)
    local angle = atan2(64 - e.x, 140 - e.y)

    e.x += cos(angle) * e.xSpd
    e.y += sin(angle) * e.ySpd
end

-- NOTE: Only used by fighter.
-- Enemy moves down until it reaches the player's y position, then moves horizontally toward the player.
-- @param e Enemy to move.
function downAcross(e)
    if e.xSpd == 0 then
        e.ySpd = 2
        if ship.y <= e.y then
            e.ySpd = 0

            if ship.x < e.x then
                e.xSpd = -2
            else
                e.xSpd = 2
            end
        end
    end

    e.x += e.xSpd
    e.y += e.ySpd
end

-- Enemy moves down toward the horizontal center of the screen, then back up.
-- @param e Enemy to move.
function downTowardCenterBackUp(e)

    if e.x < 64 and e.y > 70 and not e.moving then
        e.moving = true
        e.movingLeft = false
        e.x += e.xSpd
        e.ySpd = 0.6

    elseif e.x > 64 and e.y > 70 and not e.moving then
        e.moving = true
        e.movingLeft = true
        e.x -= e.xSpd
        e.ySpd = 0.6
    end

    if e.moving == true then
        if e.movingLeft == true then
            e.x -= e.xSpd
        else
            e.x += e.xSpd
        end
    end

    e.y += e.ySpd
end