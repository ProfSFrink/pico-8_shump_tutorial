-- Projectile component data.

-- Setup for various projectiles.
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
    yellowBullet = {
        ani = { start = 16,
                fin = 17,
                delay = 5
            },
        spd = 3,
        hitBoxW = 1,
        hitBoxH = 1,
        hitBoxOffX = 1,
        hitBoxOffY = 1,
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
    yellowLaser = {
        ani = { start = 18,
                fin = 21,
                delay = 6
            },
        spd = 4,
        hitBoxW = 1,
        hitBoxH = 5,
        hitBoxOffX = 1,
        hitBoxOffY = 1,
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
    pinkBullet = {
        ani = { start = 32,
                fin = 34,
                delay = 5
            },
        spd = 3,
        hitBoxW = 1,
        hitBoxH = 1,
        hitBoxOffX = 2,
        hitBoxOffY = 2,
        rof = 4,
        dam = 1,
        sfx = 29,
        animate = function(_ENV)
            if curSpr < ani.fin then
                curSpr += 1
            else
                curSpr = ani.start
            end
        end,
        pattern = fireDown,
    },
}

-- Projectile string literals.
yellowBullet = "yellowBullet"
yellowLaser = "yellowLaser"
pinkBullet = "pinkBullet"

-- String literals for entities that can own a projectile.
owner = { player = "player", enemy = "enemy"}

-- Get the configuration for a projectile type.
-- @param proType: The projectile type.
-- @return: The projectile configuration.
function getConfig(proType)
    return pTypes[proType]
end

-- Projectile Factory logic.

-- factory function for creating a single projectile.
-- @param proCfg: Projectile type definition.
-- @param proX: The x position.
-- @param proY: The y position.
-- @param proOwner: Player or enemy. 
-- @return: A new projectile object.
function newProjectile(proCfg, proX, proY, proOwner)
    -- Local references to global scope.
    local g = _g

    return {
        x = proX + 2,
        y = proY,
        owner = proCfg.owner,
        spd = proCfg.spd,
        dam = proCfg.dam,

        -- Hit box size, defaults to 8x8.
        hitBoxW = proCfg.hitBoxW or hitDefault,
        hitBoxH = proCfg.hitBoxH or hitDefault,
        hitBoxOffX = proCfg.hitBoxOffX or 0,
        hitBoxOffY = proCfg.hitBoxOffY or 0,

        animate = proCfg.animate,
        pattern = proCfg.pattern,

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
                y < g.uiHeight - g.bullHeight or 
                y > 128 then
                    g.removeProjectile(_ENV)
            end
        end,

        -- Draw the projectile.
        draw = function(_ENV)
            spr(curSpr, x, y)

            if g.debugMode then
                g.showHitBox(_ENV)
            end
        end
    }
end

-- Projectile spawner function.

-- Spawns a player projectile.
-- @param proCfg: Projectile type definition.
-- @param x: Spawn x position.
-- @param y: Spawn y position.
function spawnPlayerProjectile(proCfg, x, y)
    add(projectiles,
        newProjectile(proCfg, x, y, owner.player))
    sfx(proCfg.sfx)
end

-- Spawns a enemy projectile.
-- @param x: Spawn x position.
-- @param y: Spawn y position.
-- @param proOwner: The owner of the projectile.
function singlePinkBullet(x, y, proOwner)
    local proCfg = getConfig(pinkBullet)

    if proOwner == owner.player then
        proCfg.pattern = fireUp
        player.rof = proCfg.rof
    else
        proCfg.pattern = fireDown
    end

    proCfg.owner = proOwner

    addProjectile(newProjectile(proCfg,x,y))

    sfx(proCfg.sfx)
end

-- Adds projectile to game based on its owner.
-- p: Projectile to add.
function addProjectile(p)
    if p.owner == owner.player then
        add(projectiles,p)
    else
        add(enemyProjectiles,p)
    end
end

-- Removes a projectile based on its owner.
-- p: Projectile to remove.
function removeProjectile(p)
    if p.owner == owner.player then
        del(projectiles,p)
    else
        del(enemyProjectiles,p)
    end
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