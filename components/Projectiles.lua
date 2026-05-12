-- Projectile component data.

-- Setup for bullets & lasers.
-- ani: Table of animation settings.
--      start: First sprite index of the animation.
--      fin: Last sprite index of the animation.
--      delay: Frames between animation changes.
-- spd: Speed.
-- rof: Rate of fire in frames.
-- sfx: Sound effect to play when firing.
-- btn: Button to fire.
-- upFunc: Custom update function.
pTypes = {
    bullet = {
        type = bullet,
        ani = { start = 16,
                fin = 17,
                delay = 5 },
        spd = 3,
        rof = 4,
        dam = 1,
        sfx = 0,
        btn = 5,
        upFunc = function(_ENV)
            if curSpr == ani.start then
                curSpr = ani.fin
            else
                curSpr = ani.start
            end
        end
    },
    laser = {
        type = laser,
        ani = { start = 18,
                fin = 21,
                delay = 6 },
        spd = 4,
        rof = 8,
        dam = 2,
        sfx = 2,
        btn = 4,
        upFunc = function(_ENV)
            if curSpr < ani.fin then
                curSpr += 1
            else
                curSpr = ani.start
            end
        end
    }
}

-- Get the configuration for a projectile type.
-- @param proType: The projectile type.
-- @return: The projectile configuration.
function getConfig(proType)
    return pTypes[proType]
end

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
        upFunc = proCfg.upFunc,

        -- Current sprite being animated.
        curSpr = proCfg.ani.start,
        ani = proCfg.ani,
        animTimer = 0,

        -- Frames before animation advances.
        animDelay = proCfg.ani.delay,

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
            spr(curSpr, x, y)
        end
    }
end

-- Projectile spawner function.

-- Spawns one projectile using shared projectile config.
-- @param proCfg: Projectile type definition.
-- @param x: Spawn x position.
-- @param y: Spawn y position.
function spawnProjectile(proCfg, x, y)
    add(projectiles, newProjectile(proCfg, x, y))
    sfx(proCfg.sfx)
end

-- Update all projectiles.
function updateProjectiles()
    for p in all(projectiles) do
        p:update()
    end
end

-- Draw all projectiles.
function drawProjectiles()
    for p in all(projectiles) do
        p:draw()
    end
end