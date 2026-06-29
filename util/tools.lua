-- Utility functions for the game.

-- Shows debug info on the screen.
function showDebugUI()
    ?state, 0, 12
    ?#projectiles, 0, 123, 7
    ?#enemyProjectiles, 10, 123, 10
    ?#enemies, 20, 123, 3
    ?#routines, 30, 123, 15
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

-- Returns a random float between the provided min and max values.
-- @param min: the minimum value.
-- @param max: the maximum value.
function ranFloat(min, max)
    return rnd(max - min) + min
end

-- Returns a random integer between the provided min and max values.
-- @param min: the minimum value.
-- @param max: the maximum value.
function ranInt(min, max)
    return flr(rnd(max - min + 1)) + min
end

-- Calculates the angle between two objects.
-- @param a: the first object.
-- @param b: the second object.
function calcAngle(a, b)
    return atan2((b.y - a.y), (b.x - a.x))
end

-- Logs text to a file for debugging purposes.
-- @param text: the text to log.
-- @param overwrite: if true, start new log file.
function log(text, overwrite)
    printh(text, "logs/log", overwrite)
end

-- Draws an entity's hitbox as a filled rectangle for debugging.
-- @param e: the entity to draw the hitbox for.
function showHitBox(e)
    local x = e.x + (e.hitBoxOffX or 0)
    local y = e.y + (e.hitBoxOffY or 0)
    local w = e.hitBoxW or hitDefault
    local h = e.hitBoxH or hitDefault
    rectfill(x, y, x + w, y + h, 7)
end

-- Checks if both fire buttons are released.
-- @return: true if both fire buttons released.
function hasStoppedFiring()
    return btn(4) == false and btn(5) == false
end

-- Check if an entity is inbounds
-- @return: true if an entity in bounds.
function inBounds(e)
    return mid(0, e.x, 128) == e.x and mid(0 + uiHeight, e.y, 128) == e.y
end