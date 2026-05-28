-- Enemy movement patterns.

function moveDown(_ENV)
    y += spd
end

-- Enemy moves down the screen, while also moving left and right in a wave pattern.
function moveDownLeftRight(_ENV)
    x = x + cos(y / 16) * spd
    y += spd
end

-- Enemy moves down the screen, while also moving left and right in a wave pattern, but slower than the above.
function moveDownLeftRightSlow(_ENV)
    x = x + cos(y / 16) * spd
    y += spd / 2
end