-- Courtesy of ValerADHD @ https://www.lexaloffle.com/bbs/?tid=40577

-- Linear movement not easing.
-- param time: current time (between 0 and 1).
-- returns: eased value.
function linear(time)
    return time
end

-- Ease out, starts fast and decelerates.
-- param time: current time (between 0 and 1).
-- returns: eased value.
function easeOutQuad(time)
    time -= 1
    return 1 - time * time
end

-- Ease out, same as above but with more pronounced deceleration.
-- param time: current time (between 0 and 1).
-- returns: eased value.
function easeOutQuart(time)
    time -= 1
    return 1 - time * time * time * time
end