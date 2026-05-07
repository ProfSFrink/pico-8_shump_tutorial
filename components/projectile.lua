-- Projectile component data.

-- Setup for bullets & lasers.
-- strtFram: Starting frame.
-- endFram: Ending frame.
-- animDelay: Frames before animation advances.
-- spd: Speed.
-- rof: Rate of fire in frames.
-- sfx: Sound effect to play when firing.
-- btn: Button to fire.
-- upFunc: Custom update function.
pTypes = {
    bullet = {
        type = bullet,
        strtFram = 16,
        endFram = 17,
        animDelay = 5,
        spd = 3,
        rof = 4,
        dam = 1,
        sfx = 0,
        btn = 5,
        upFunc = function(_ENV)
            if curFram == strtFram then
                curFram = endFram
            else
                curFram = strtFram
            end
        end
    },
    laser = {
        type = laser,
        strtFram = 18,
        endFram = 21,
        animDelay = 6,
        spd = 4,
        rof = 8,
        dam = 2,
        sfx = 1,
        btn = 4,
        upFunc = function(_ENV)
            if curFram < endFram then
                curFram += 1
            else
                curFram = strtFram
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
        curFram = proCfg.strtFram,
        strtFram = proCfg.strtFram,
        endFram = proCfg.endFram,
        animTimer = 0,

        -- Frames before animation advances.
        animDelay = proCfg.animDelay,

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