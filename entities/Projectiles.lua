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
-- spd: (Player Only) Speed of projectile.
-- dam: (Player Only) Damage of projectile.
-- rof: (Player Only) Rate of fire in frames.
-- sfx: Sound effect to play when firing.
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

-- String literals for entities that can own a projectile.
owner = { player = "player", enemy = "enemy"}

-- Get the configuration for a projectile type.
-- @param proType: The projectile type.
-- @return: The projectile configuration.
function getProConfig(proType)
    return pTypes[proType]
end

-- Projectile Factory logic.

-- Factory function for creating projectiles.
-- @param proCfg: Projectile type config object.
-- @param proX: The x position.
-- @param proY: The y position.
-- @param ang: The angle the projectile moves in.
-- @param spd: The base speed of the projectile.
-- @param dam: Damage value.
-- @param proOwner: Player or enemy.
-- @return: A new projectile object.
function newProjectile(proCfg, proX, proY, ang, spd, dam, proOwner)
    local g = _g

    return {
        x = proX + 2,
        y = proY,

        spd = spd,
        ang = ang,

        xSpd = g.sin(ang) * spd,
        ySpd = g.cos(ang) * spd,

        owner = proOwner,
        dam = dam or 1,

        hitBoxW = proCfg.hitBoxW or hitDefault,
        hitBoxH = proCfg.hitBoxH or hitDefault,
        hitBoxOffX = proCfg.hitBoxOffX or 0,
        hitBoxOffY = proCfg.hitBoxOffY or 0,

        animate = proCfg.animate,
        curSpr = proCfg.ani.start,
        ani = proCfg.ani,
        animTimer = 0,
        animDelay = proCfg.ani.delay,

        update = function(_ENV)

            x += xSpd
            y += ySpd

            animTimer += 1
            if animTimer >= animDelay then
                animTimer = 0
                animate(_ENV)
            end

            if x < 0 or x > 128 or
               y < g.uiHeight - g.bullHeight or y > 128 then
                g.removeProjectile(_ENV)
            end
        end,

        draw = function(_ENV)
            spr(curSpr, x, y)
            if g.debugMode then g.showHitBox(_ENV) end
        end
    }
end

-- Firing functions.

-- Fires a spread shot, using all 360 degrees.
-- @param proCfg: The config of the projectile to use.
-- @param x: Spawn x position.
-- @param y: Spawn y position.
-- @param num: The number of projectiles.
-- @param ang: Angle in PICO-8 units.
-- @param spd: Projectile speed.
-- @param base: Base offset to apply to the angle.
-- @param dam: Damage from the weapon definition.
-- @param proOwner: The owner of the projectile.
function spreadShot(proCfg, x, y, num, spd, base, dam, proOwner)
    local base = base or 0

    for i = 1, num do

    addProjectile(
        newProjectile(proCfg, x, y,
                      1 / num * i + base, spd,
                      dam, proOwner)
        )
    end
end

-- Fires a spread shot, using all 360 degrees.
-- @param proCfg: The config of the projectile to use.
-- @param x: Spawn x position.
-- @param y: Spawn y position.
-- @param num: The number of projectiles.
-- @param ang: Angle of direction to fire in (pico-8 units).
-- @param spd: Projectile speed.
-- @param dam: Damage from the weapon definition.
-- @param proOwner: The owner of the projectile.
function directedSpreadShot(proCfg, x, y, num, spd, ang, dam, proOwner)
  -- ang is the center direction (1 for down, 0.5 for up)
  local ang = ang or 0.25

  -- width of the total spread cone (0.15 is roughly 54 degrees)
  local spreadArc = 0.15

  for i = 1, num do

    local offset = (i - 1) / (num - 1) - 0.5
    if num == 1 then offset = 0 end

    local finalAngle = ang + (offset * spreadArc)

    addProjectile(
      newProjectile(proCfg, x, y, finalAngle, spd, dam, proOwner)
    )
  end

end

-- Fires a single projectile.
-- @param proCfg: The config of the projectile to use.
-- @param x: Spawn x position.
-- @param y: Spawn y position.
-- @param ang: Angle in PICO-8 units.
-- @param spd: Projectile speed.
-- @param dam: Damage from the weapon definition.
-- @param proOwner: The owner of the projectile.
function singleShot(proCfg, x, y, ang, spd, dam, proOwner)
    addProjectile(
        newProjectile(proCfg, x, y,
                        ang, spd, dam, proOwner)
    )
end

-- Util functions.

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