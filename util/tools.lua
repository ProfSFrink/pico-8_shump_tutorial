-- Utility functions for the game.

-- Shows debug info on the screen.
function showDebugUI()
    ?state, 0, 12
    ?#projectiles, 0, 123, 7
    ?#enemies, 6, 123, 3
    ?#routines, 16, 123, 15
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

-- Logs text to a file for debugging purposes.
-- @param text: the text to log.
-- @param overwrite: if true, start new log file.
function log(text, overwrite)
    printh(text, "logs/log", overwrite)
end

-- Checks if both fire buttons are released.
-- @return: true if both fire buttons released.
function hasStoppedFiring()
    return btn(4) == false and btn(5) == false
end