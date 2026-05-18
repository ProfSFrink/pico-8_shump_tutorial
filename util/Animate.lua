-- Animate a property of an object over time.
-- param obj: the object to animate.
-- param key: the property of the object to animate.
-- param value: the target value of the property.
-- param frame: the number of frames to animate over (default 30).
-- param ease: the easing function to use (default linear).
function animate(obj, key, value, frame, ease)
    local init = obj[key]
    frame = frame or 30
    ease = ease or linear

    for i = 1, frame do
        obj[key] = lerp(init, value, ease(i / frame))
        yield()
    end
end

-- Linear interpolation between a and b by t.
-- param a: start value.
-- param b: end value.
-- param t: interpolation factor (between 0 and 1).
-- returns: interpolated value.
function lerp(a, b, t)
    return a + (b - a) * t
end