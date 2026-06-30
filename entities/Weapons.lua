-- Weapon fire functions.

-- Fires a single shot.
-- @param x: The x position.
-- @param y: The y position.
-- @param wepCfg: The weapon config to use.
function fireSingleShot(x, y, wepCfg)
    local proCfg = getProConfig(wepCfg.pCfg)

    singleShot(proCfg, x, y, ship.ang, wepCfg.spd,
               wepCfg.dam, owner.player)
    sfx(wepCfg.sfx)
end

-- Fires a spread shot.
-- @param x: The x position.
-- @param y: The y position.
-- @param wepCfg: The weapon config to use.
function fireSpreadShot(x, y, wepCfg)
    local proCfg = getProConfig(wepCfg.pCfg)

    directedSpreadShot(
        proCfg, x, y, wepCfg.num,
        wepCfg.spd, wepCfg.ang,
        wepCfg.dam, owner.player
    )
    sfx(wepCfg.sfx)
end

-- Get the configuration of a ship weapon type.
-- @param wepType: The weapon type.
-- @return: The weapon configuration.
function getWepConfig(wepType)
    return weapons[wepType]
end

-- String literals for weapon types.

singleBullet = "singleBullet"
singleLaser = "singleLaser"
threeShotBullet = "threeShotBullet"

-- Weapon definitions (Player Ship ONLY).
-- Weapon name.
-- pCfg: The config of the projectile to use.
-- spd: The speed to the weapons projectiles.
-- dam: The damage of the weapon.
-- rof: The rate of fire of the weapon.
-- sfx: the sound effect of the weapon to use.
-- fireFunc: The fire function the weapon uses.

weapons = {
    singleBullet = {
        pCfg = yellowBullet,
        spd = 3,
        dam = 1,
        rof = 4,
        sfx = 0,
        fireFunc = fireSingleShot
    },
    singleLaser = {
        pCfg = yellowLaser,
        spd = 4,
        dam = 2,
        rof = 8,
        sfx = 2,
        fireFunc = fireSingleShot
    },
    threeShotBullet = {
        pCfg = yellowBullet,
        spd = 3,
        dam = 1,
        rof = 4,
        num = 3,
        ang = 0.5,
        sfx = 0,
        fireFunc = fireSpreadShot
    }
}
