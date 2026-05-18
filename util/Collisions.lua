-- Check for a collision between two objects.
-- @param a: The first object with x and y properties.
-- @param b: The second object with x and y properties.
-- @return: true if the objects are colliding.
function hasCollided(a, b)
    -- Use provided size or default 8x8 sprites.
    local aColW = a.colW or colDefault
    local aColH = a.colH or colDefault

    local aLeft = a.x
    local aTop = a.y
    local aRight = a.x + aColW
    local aBottom = a.y + aColH

    local bColW = b.colW or colDefault
    local bColH = b.colH or colDefault

    local bLeft = b.x
    local bTop = b.y
    local bRight = b.x + bColW
    local bBottom = b.y + bColH

    if aTop > bBottom
        or bTop > aBottom
        or aLeft > bRight
        or bLeft > aRight then

        return false
    end

    return true
end