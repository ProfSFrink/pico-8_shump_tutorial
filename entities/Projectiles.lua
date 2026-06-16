-- Projectile component data.

-- Setup for various projectiles.
-- type: Player or enemy projectile.
-- ani: Table of animation settings.
--      start: First sprite index of the animation.
--      fin: Last sprite index of the animation.
--      delay: Frames between animation changes.
-- spd: Speed.
-- rof: Rate of fire in frames.
-- sfx: Sound effect to play when firing.
-- btn: Button to fire.
-- animate: Custom update function.
-- pattern: The firing pattern to use.
pTypes = {
    bullet = {
        type = "player",
        ani = { start = 16,
                fin = 17,
                delay = 5 },
        spd = 3,
        colW = 3,
        colH = 3,
        rof = 4,
        dam = 1,
        sfx = 0,
        btn = 5,
        animate = function(_ENV)
            if curSpr == ani.start then
                curSpr = ani.fin
            else
                curSpr = ani.start
            end
        end,
        pattern = fireUp
    },
    laser = {
        type = "player",
        ani = { start = 18,
        fin = 21,
        delay = 6 },
        spd = 4,
        colW = 3,
        colH = 3,
        rof = 8,
        dam = 2,
        sfx = 2,
        btn = 4,
        animate = function(_ENV)
            if curSpr < ani.fin then
                curSpr += 1
            else
                curSpr = ani.start
            end
        end,
        pattern = fireUp,
    },
    enemyBullet = {
        type = "enemy",
        ani = { start = 32,
                fin = 33,
                delay = 5 },
        spd = 3,
        colW = 3,
        colH = 3,
        rof = 4,
        dam = 1,
        sfx = 0,
        animate = function(_ENV)
            if curSpr == ani.start then
                curSpr = ani.fin
            else
                curSpr = ani.start
            end
        end,
        pattern = fireDown,
    },
}

-- Get the configuration for a projectile type.
-- @param proType: The projectile type.
-- @return: The projectile configuration.
function getConfig(proType)
    return pTypes[proType]
end

-- Projectile Factory logic.

-- factory function for creating player projectiles.
-- @param proCfg: Projectile type definition.
-- @param x: The x position.
-- @param y: The y position.
-- @return: A new projectile object.
function newProjectile(proCfg, proX, proY)
    -- Local references to global scope.
    local uiHeight = uiHeight
    local bullHeight = bullHeight

    -- Point to either player or enemy
    -- projectile table depending on type.
    if proCfg.type == "player" then
        typeTable = projectiles
    else
        typeTable = enemyProjectiles
    end

    return {
        type = proCfg.type,
        x = proX + 2,
        y = proY,
        type = proCfg.type,
        spd = proCfg.spd,
        dam = proCfg.dam,
        animate = proCfg.animate,
        pattern = proCfg.pattern,
        typeTable = typeTable,

        -- Current sprite being animated.
        curSpr = proCfg.ani.start,
        ani = proCfg.ani,
        animTimer = 0,

        -- Frames before animation advances.
        animDelay = proCfg.ani.delay,


        -- Update the projectile.
        update = function(_ENV)
            pattern(_ENV)

            animTimer += 1
            if animTimer >= animDelay then
                animTimer = 0
                animate(_ENV)
            end

            -- Remove if off-screen.
            if  x < 0 or
                x > 128 or
                y < uiHeight - bullHeight or 
                y > 128 then
                del(typeTable, _ENV)
            end
        end,

        -- Draw the projectile.
        draw = function(_ENV)
            spr(curSpr, x, y)
        end
    }
end

-- Projectile spawner function.

-- Spawns a player projectile.
-- @param proCfg: Projectile type definition.
-- @param x: Spawn x position.
-- @param y: Spawn y position.
function spawnPlayerProjectile(proCfg, x, y)
    add(projectiles, newProjectile(proCfg, x, y))
    sfx(proCfg.sfx)
end

-- Spawns a enemy projectile.
-- @param x: Spawn x position.
-- @param y: Spawn y position.
function spawnEnemyProjectile(x, y)
    local proCfg = getConfig("enemyBullet")

    add(enemyProjectiles, newProjectile(proCfg, x, y))
    sfx(proCfg.sfx)
end

-- Update all projectiles.
function updateProjectiles()
    for p in all(projectiles) do
        p:update()
    end

    for ep in all(enemyProjectiles) do
        ep:update()
    end
end

-- Draw all projectiles.
function drawProjectiles()
    for p in all(projectiles) do
        p:draw()
    end

    for ep in all(enemyProjectiles) do
        ep:draw()
    end
end