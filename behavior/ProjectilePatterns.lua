-- Projectile movement patterns.

-- Shared Patterns.

function left(p)
    p.x -= p.xSpd
end

function right(p)
    p.x += p.xSpd
end

-- Player patterns.

-- Projectile moves up.
-- @param p projectile to move.
function up(p)
    p.y -= p.ySpd
end

-- Projectile move up and left.
-- @param p projectile to move.
function upLeft(p)
    up(p)
    left(p)
end

-- Projectile move up and right.
-- @param p projectile to move.
function upRight(p)
    up(p)
    right(p)
end

-- Enemy Patterns.

-- Projectile fires straight down.
-- @param p projectile to move.
function down(p)
    p.y += p.ySpd
end


-- Projectile move down and left.
-- @param p projectile to move.
function downLeft(p)
    down(p)
    left(p)
end

-- Projectile move down and right.
-- @param p projectile to move.
function downRight(p)
    down(p)
    right(p)
end