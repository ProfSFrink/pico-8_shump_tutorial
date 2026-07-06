-- Enemy movement patterns.

-- Enemy stays in place.
-- @param e: Enemy to move.
function stationary(e)
end

-- Enemy moves straight down.
-- @param e: Enemy to move.
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

-- Enemy moves horizontally between sides of the screen.
-- @param e: Enemy to move.
function leftRight(e)
    if e.x < 12 then
        e.xSpd = switchSign(e.xSpd)
    end

    if e.x > 116 then
        e.xSpd = switchSign(e.xSpd)
    end

    e.x += e.xSpd
end

-- Enemy moves horizontally between sides of the screen.
-- enemy will also move between top and bottom of the screen.
-- @param e: Enemy to move.
function leftRightUpDown(e)
    if e.x < 12 then
        e.xSpd = switchSign(e.xSpd)
    end

    if e.x > 116 then
        e.xSpd = switchSign(e.xSpd)
    end

    if e.y < 10 then
        e.ySpd = switchSign(e.ySpd)
    end

    if e.y > 95 then
        e.ySpd = switchSign(e.ySpd)
    end

    e.x += e.xSpd
    e.y += e.ySpd
end

-- Enemy moves down slowly while weaving left and right using cosine of its y position.
-- @param e: Enemy to move.
function downWaveSlow(e)
    e.x += cos(e.y / 32) * e.xSpd
    e.y += e.ySpd / 2
end

-- Enemy moves down toward the horizontal center of the screen.
-- @param e: Enemy to move.
function downTowardCenter(e)
    local angle = atan2(64 - e.x, 140 - e.y)

    e.x += cos(angle) * e.xSpd
    e.y += sin(angle) * e.ySpd
end

-- NOTE: Only used by fighter.
-- Enemy moves down until it reaches the player's y position, then moves horizontally toward the player.
-- @param e: Enemy to move.
function downAcross(e)
    if e.xSpd == 0 then
        e.ySpd = e.spd
        if ship.y <= e.y then
            e.ySpd = 0

            if ship.x < e.x then
                e.xSpd -= e.spd
            else
                e.xSpd += e.spd
            end

            e:fire()
        end
    end

    e.x += e.xSpd
    e.y += e.ySpd
end

-- Enemy moves down toward the horizontal center of the screen, then back up.
-- @param e: Enemy to move.
function downTowardCenterBackUp(e)
    if not e.moveSwitch and e.y > 70 then
        e.moveSwitch = true

        if ship.x < 63 then
            e.ang = calcAngle(e.x, e.y, 0, 0)
        else
            e.ang = calcAngle(e.x, e.y, 128, 0)
        end
    end

    if e.moveSwitch then
        e.x += sin(e.ang) * e.xSpd
    end

    e.y += cos(e.ang) * e.spd
end