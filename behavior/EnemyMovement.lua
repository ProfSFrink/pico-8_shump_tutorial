-- Enemy movement patterns.

function down(e)
    e.y += e.ySpd
end

-- Enemy moves down while weaving left and right in a sine wave.
function downWave(e, t)
    e.xSpd = sin(t / 45)

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
function downWaveSlow(e)
    e.x += cos(e.y / 32) * e.xSpd
    e.y += e.ySpd / 2
end

-- Enemy moves down toward the horizontal center of the screen.
function downTowardCenter(e)
    local angle = atan2(64 - e.x, 140 - e.y)

    e.x += cos(angle) * e.xSpd
    e.y += sin(angle) * e.ySpd
end