-- Projectile firing patterns.

-- Projectile fires straight up.
-- @param p projectile to move.
function fireUp(p)
    p.y -= p.spd
end

-- Projectile fires straight down.
-- @param p projectile to move.
function fireDown(p)
    p.y += p.spd
end