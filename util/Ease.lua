-- Linear movement not easing.
-- param t: current time (between 0 and 1).
-- returns: eased value.
function linear(t)
    return t
end

-- Ease out, starts fast and decelerates.
-- param t: current time (between 0 and 1).
-- returns: eased value.
function easeOutQuad(t)
    t -= 1
    return 1 - t * t
end