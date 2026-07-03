-- Check for a collision between two objects
-- based on there hit boxes.
-- @param a: The first object with x and y properties.
-- @param b: The second object with x and y properties.
-- @return: true if the objects are colliding.
function hasCollided(a, b)
    local aHitBoxW = a.hitBox.w or hitDefault
    local aHitBoxH = a.hitBox.h or hitDefault

    local aLeft = a.x + (a.hitBox.offX or 0)
    local aTop = a.y + (a.hitBox.offY or 0)
    local aRight = aLeft + aHitBoxW
    local aBottom = aTop + aHitBoxH

    local bHitBoxW = b.hitBox.w or hitDefault
    local bHitBoxH = b.hitBox.h or hitDefault

    local bLeft = b.x + (b.hitBox.offX or 0)
    local bTop = b.y + (b.hitBox.offY or 0)
    local bRight = bLeft + bHitBoxW
    local bBottom = bTop + bHitBoxH

    if aTop > bBottom
        or bTop > aBottom
        or aLeft > bRight
        or bLeft > aRight then

        return false
    end

    return true
end