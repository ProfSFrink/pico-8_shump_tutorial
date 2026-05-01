-- Projectile Factory logic.

-- factory function for creating projectiles.
-- @param proCfg: Projectile type definition.
-- @param x: The x position.
-- @param y: The y position.
-- @return: A new projectile object.
function newProjectile(proCfg, proX, proY)
    -- Local references to global scope.
    local proj = projectiles
    local uiH = uiHeight
    local bullH = bullHeight

    return {
        type = proCfg.type,
        x = proX,
        y = proY,
        spd = proCfg.spd,
        dam = proCfg.dam,

        -- Current sprite being animated.
        curFram = proCfg.strtFram,
        strtFram = proCfg.strtFram,
        endFram = proCfg.endFram,
        animTimer = 0,

        -- Frames before animation advances.
        animDelay = proCfg.animDelay,

        upFunc = proCfg.upFunc,

        -- Update the projectile.
        update = function(_ENV)
            y -= spd

            animTimer += 1
            if animTimer >= animDelay then
                animTimer = 0
                upFunc(_ENV)
            end

            -- Remove if off-screen.
            if y < uiH - bullH then
                del(proj, _ENV)

            end
        end,

        -- Draw the projectile.
        draw = function(_ENV)
            spr(curFram, x, y)
        end
    }
end

-- Spawns one projectile using shared projectile config.
-- @param proCfg: Projectile type definition.
-- @param x: Spawn x position.
-- @param y: Spawn y position.
function spawnProjectile(proCfg, x, y)
    add(projectiles, newProjectile(proCfg, x, y))
    sfx(proCfg.sfx)
end