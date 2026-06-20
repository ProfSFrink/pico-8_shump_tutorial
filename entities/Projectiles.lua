-- Projectile component data.

-- String literals for projectile types.
yellowBullet = "yellowBullet"
yellowLaser = "yellowLaser"
pinkBullet = "pinkBullet"

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
pTypes = {
    yellowBullet = {
        ani = { start = 16,
                fin = 17,
                delay = 5
            },
        hitBoxW = 1,
        hitBoxH = 1,
        hitBoxOffX = 1,
        hitBoxOffY = 1,
        animate = function(_ENV)
            if curSpr == ani.start then
                curSpr = ani.fin
            else
                curSpr = ani.start
            end
        end,
    },
    yellowLaser = {
        ani = { start = 18,
                fin = 21,
                delay = 6
            },
        hitBoxW = 1,
        hitBoxH = 5,
        hitBoxOffX = 1,
        hitBoxOffY = 1,
        animate = function(_ENV)
            if curSpr < ani.fin then
                curSpr += 1
            else
                curSpr = ani.start
            end
        end,
    },
    pinkBullet = {
        ani = { start = 32,
                fin = 34,
                delay = 5
            },
        hitBoxW = 1,
        hitBoxH = 1,
        hitBoxOffX = 2,
        hitBoxOffY = 2,
        animate = function(_ENV)
            if curSpr < ani.fin then
                curSpr += 1
            else
                curSpr = ani.start
            end
        end,
    },
}

-- String literals for weapon types.
singleYellowBullet = "singleYellowBullet"
singleYellowLaser = "singleYellowLaser"
singlePinkBullet = "singlePinkBullet"
spreadYellowBullet = "spreadYellowBullet"


-- Weapon definitions.
-- rof: Rate of fire in frames.
-- sfx: Sound effect to play when firing.
-- shots: Table of projectiles fired per trigger pull.
--   pType: Projectile type key into pTypes.
--   player: Movement pattern function used when owner is player.
--   enemy:  Movement pattern function used when owner is enemy.
weapons = {
    singleYellowBullet = {
        rof = 4,
        sfx = 0,
        xSpd = 0.5,
        ySpd = 3,
        dam = 1,
        shots = {
            { pType = yellowBullet, player = up, enemy = down }
        }
    },
    singleYellowLaser = {
        rof = 8,
        sfx = 2,
        xSpd = 4,
        ySpd = 4,
        dam = 2,
        shots = {
            { pType = yellowLaser, player = up, enemy = down }
        }
    },
    singlePinkBullet = {
        rof = 4,
        sfx = 29,
        xSpd = 3,
        ySpd = 3,
        dam = 1,
        shots = {
            { pType = pinkBullet, player = up, enemy = down }
        }
    },
    spreadYellowBullet = {
        rof = 4,
        sfx = 0,
        xSpd = 0.5,
        ySpd = 3,
        dam = 1,
        shots = {
            { pType = yellowBullet, player = upLeft,  enemy = downLeft  },
            { pType = yellowBullet, player = up,      enemy = down      },
            { pType = yellowBullet, player = upRight, enemy = downRight },
        }
    }
}

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
-- @param proCfg: Projectile type config object.
-- @param proX: The x position.
-- @param proY: The y position.
-- @param proOwner: Player or enemy.
-- @param pattern: Movement pattern function.
-- @param xSpd: Horizontal speed from the weapon definition.
-- @param ySpd: Vertical speed from the weapon definition.
-- @param dam: Damage from the weapon definition.
-- @return: A new projectile object.
function spawnProjectile(proCfg, proX, proY, proOwner, pattern, xSpd, ySpd, dam)
    -- Local references to global scope.
    local g = _g

    return {
        x = proX + 2,
        y = proY,
        xSpd = xSpd,
        ySpd = ySpd,
        owner = proOwner,
        dam = dam,

        -- Hit box size, defaults to 8x8.
        hitBoxW = proCfg.hitBoxW or hitDefault,
        hitBoxH = proCfg.hitBoxH or hitDefault,
        hitBoxOffX = proCfg.hitBoxOffX or 0,
        hitBoxOffY = proCfg.hitBoxOffY or 0,

        animate = proCfg.animate,
        pattern = pattern,

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

-- Weapon functions.

-- Fires a weapon definition, spawning all its shots.
-- @param wDef: Weapon definition from the weapons table.
-- @param x: Spawn x position.
-- @param y: Spawn y position.
-- @param proOwner: The owner of the projectile.
function fireWeapon(wDef, x, y, proOwner)
    local isPlayer = (proOwner == owner.player)

    for shot in all(wDef.shots) do
        local proCfg = getConfig(shot.pType)
        local pat = isPlayer and shot.player or shot.enemy
        addProjectile(
                spawnProjectile(proCfg, x, y, proOwner, pat,
                wDef.xSpd, wDef.ySpd, wDef.dam)
            )
    end

    if isPlayer then
        ship.rof = wDef.rof
    end

    sfx(wDef.sfx)
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