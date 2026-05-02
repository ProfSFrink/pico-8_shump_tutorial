-- Utility functions for the game.

-- Shows debug info on the screen.
function showDebugUI()
    ?#projectiles, 0, 123, 7
    ?#enemies, 7, 123, 3
    ?ship.x, 0, 63, 7
    ?ship.y, 0, 70, 7
    ?"i:" .. ship.invul, 110, 113, 7
    ?"t:" .. gameT, 105, 123, 7
end

-- Returns the x value to centre an object on the screen.
-- @param width: the width of the object in pixels.
function calcCenX(width)
    return (128 - width * 4) / 2
end

-- Cycles through colors for blinking text.
-- @return: the color value for the current blink frame.
function blink()
    local banim = { 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 7, 7, 6, 5 }

    if blinkT > #banim then
        blinkT = 1
    end

    return banim[blinkT]
end

-- Collision detection between two objects.
-- @param a: The first object with x and y properties.
-- @param b: The second object with x and y properties.
-- @return: true if the objects are colliding, false otherwise.
function col(a, b)
    local a_left = a.x
    local a_top = a.y
    local a_right = a.x + 7
    local a_bottom = a.y + 7

    local b_left = b.x
    local b_top = b.y
    local b_right = b.x + 7
    local b_bottom = b.y + 7

    if a_top > b_bottom then
        return false
    end

    if b_top > a_bottom then
        return false
    end

    if a_left > b_right then
        return false
    end

    if b_left > a_right then
        return false
    end

    return true
end