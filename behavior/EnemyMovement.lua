-- Enemy movement patterns.

function down(_ENV)
    y += spd
end

-- Enemy moves down the screen, while also moving left and right in a wave pattern.
function downWave(_ENV)
    x = x + cos(y / 16) * spd
    y += spd
end

-- Enemy moves down the screen, while also moving left and right in a wave pattern, but slower than the above.
function downWaveSlow(_ENV)
    x = x + cos(y / 32) * spd
    y += spd / 2
end

-- Enemy moves down the screen toward the center.
function downTowardCenter(_ENV)
    local centerX = 64

    local angle = atan2(centerX - x, 140 - y)

    x += cos(angle) * spd
    y += sin(angle) * spd
end