--returns the x value to centre text on the screen
function calcCentreX(text)
    return (128-#text*4)/2
end

---returns a value to make text blink
function blink()
    local banim={5,5,5,5,5,5,5,5,5,5,6,6,7,7,6,5}

    if blinkT>#banim then
        blinkT=1
    end

    return banim[blinkT]
end