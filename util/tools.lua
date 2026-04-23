-- Returns the x value to centre an object on the screen.
-- @param width: the width of the object in pixels.
function calcCenX(width)
    return (128-width*4)/2
end

-- Cycles through colors for blinking text.
-- @return: the color value for the current blink frame.
function blink()
    local banim={5,5,5,5,5,5,5,5,5,5,6,6,7,7,6,5}

    if blinkT>#banim then
        blinkT=1
    end

    return banim[blinkT]
end