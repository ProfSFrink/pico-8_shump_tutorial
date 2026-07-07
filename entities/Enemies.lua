-- Enemies definitions.

-- Setup for an enemy.
-- name: Enemy name.

-- cols: table of color pairs for the enemy, first is
--       entry matches sprite colours.

-- hitBox.w: Collision width - defaults to 7.
-- hitBox.h: Collision height - defaults to 7
-- hitBox.offX: X-Offset for hit box - defaults to 0.
-- hitBox.offY: Y-Offset for hit box  - defaults to 0.

-- sprSize: Size the sprite - defaults to 7x7 (Optional).
-- ani: Table of animation settings.
--      start: First sprite index of the animation.
--      fin: Last sprite index of the animation.
--      flash: Sprite index to use when hit.
--      aniDelay: Frames between animation changes.

-- xSpd: Enemy speed when moving on x-axis.
-- ySpd: Enemy speed when moving on y-axis.
-- movements: Table of movement patterns.
--       normal: General movement behavior.
--       onHit: Movement upon being hit.
-- move: Movement function to use.
-- waveLen: Wave length enemy moves in (Optional).

-- hp: Enemy health points.

-- rof: Rate of fire when attacking.
-- dam: Damage of projectile fired.
-- ang: Angle to fire projectiles.
-- pSpd: Speed fired projectiles move at.
-- points: Enemy score value.

-- Enemy string literals.
alien = "alien"
ufo = "ufo"
eyeball = "eyeball"
redeye = "redeye"
flame= "flame"
fighter = "fighter"
boss = "boss"

eDefs = {
    alien = {
        name = alien,

        cols = {
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 10, c2 = 9 }, -- Orange.
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 6, c2 = 13 } -- Grey.
        },

        hitBox = { w = 7, h = 5, offX = 0, offY = 1 },

        ani = { 80, 81, 82, 83 },
        flash = 84,
        aniDelay = 0.4,

        xSpd = 0,
        ySpd = 1,

        movements = { normal = stationary, onHit = stationary },
        move = stationary,

        hp = 1,

        rof = 30,
        dam = 1,
        ang = 1,
        pSpd = 2,

        points = 100,
    },
    ufo = {
        name = ufo,

        cols = {
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 14, c2 = 2 } -- Pink.
        },

        hitBox = { w = 5, h = 3, offX = 1, offY = 3 },

        ani = { 64, 65, 66, 67 },
        flash = 68,
        aniDelay = 0.4,

        spd = 0.8,
        xSpd = 0.8,
        ySpd = 0.8,

        movements = {
                normal = leftRight,
                onHit = downWaveSlow,
            },
        move = leftRight,

        hp = 2,

        rof = 45,
        dam = 2,
        ang = 0.875,
        pSpd = 1,

        points = 175,
    },
    eyeball = {
        name = eyeball,

        cols = {
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },

        hitBox = { w = 5, h = 5, offX = 1, offY = 1 },

        ani = { 69, 70, 71, 72 },
        flash = 73,
        aniDelay = 0.4,

        xSpd = 0.2,
        ySpd = 0.4,

        movements = {
            normal = downWave,
            onHit = downWave
        },
        move = downWave,

        hp = 2,

        rof = 20,
        dam = 1,
        ang = 0.5,

        points = 150,
    },
    redeye = {
        name = redeye,

        cols = {
            { c1 = 5, c2 = 8 }, -- Grey / Red.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },

        hitBox = { w = 4, h = 4, offX = 1, offY = 1 },

        ani = { 88, 89, 90, 91, 92 },
        flash = 93,
        aniDelay = 0.4,

        spd = 1.25,
        xSpd = 1.5,
        ySpd = 1.2,

        movements = {
            normal = stationary,
            onHit = stationary
        },
        move = stationary,

        hp = 4,

        rof = 60,
        dam = 1,
        pSpd = 0.8,

        points = 200,
    },
    flame = {
        name = flame,

        cols = {
            { c1 = 8, c2 = 2 }, -- Grey / Red.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },

        hitBox = { w = 5, h = 4, offX = 1, offY = 3 },

        ani = { 85, 86 },
        flash = 87,
        aniDelay = 0.4,

        xSpd = 1.4,
        ySpd = 1.2,

        movements = { normal = downWave, onHit = downWave },
        move = downWave,
        waveLen = 20,

        hp = 2,
        rof = 35,
        dam = 1,
        pSpd = 2,

        points = 200,
    },
    fighter = {
        name = fighter,

        cols = {
            { c1 = 1, c2 = 5 }, -- Blue / Grey.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },

        hitBox = { w = 5, h = 4, offX = 1, offY = 1 },

        ani = { 74, 75, 76, 77 },
        flash = 78,
        aniDelay = 0.4,

        spd = 1.5,
        xSpd = 0,
        ySpd = 2,

        movements = { normal = downAcross, onHit = downAcross },
        move = downAcross,

        hp = 2,
        rof = 20,
        dam = 1,
        pSpd = 2.5,

        points = 300,
    },
    boss = {
        name = boss,

        cols = {
            { c1 = 6, c2 = 14 }, -- Grey / Yellow.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },

        hitBox = { w = 11, h = 9, offX = 2, offY = 4 },

        bullXOffset = 4,
        bullYOffset = 12,

        sprSize = 2,
        ani = { 96, 98 },
        flash = 100,
        aniDelay = 0.4,

        xSpd = -0.5,
        ySpd = 0.35,

        movements = { normal = leftRightUpDown, onHit = leftRightUpDown },
        move = leftRightUpDown,

        hp = 40,

        rof = 10,
        dam = 1,

        points = 1000,
    }
}

-- Enemy Factory logic.

-- Flash state frame timer.
local flashTimerDefault = 3
-- Death state frame timer.
local deathTimerDefault = 10

-- String literals for enemy state names.
local eneState = {
    spawning = "spawning",
    stopped = "stopped",
    flashing = "flashing",
    attacking = "attacking",
    dead = "dead"
}

-- Factory function for creating enemies.
-- @param enemyCfg: Enemy configuration object.
-- @param eneX: Spawn x position.
-- @param eneY: Spawn y position.
-- @param eneRowNum: Spawn row number.
-- @param activateAt: Wave timer value at which this enemy starts attacking.
-- @return: A new enemy object.
function newEnemy(enemyCfg, eneX, eneY, eneRowNum, activateAt)
    -- Local reference to global scope.
    local g = _g

    return {
        name = enemyCfg.name,

        x = eneX,
        y = eneY,
        rowNum = eneRowNum,
        activateAt = activateAt or 0,

        spd = enemyCfg.spd or 0,
        xSpd = enemyCfg.xSpd,
        ySpd = enemyCfg.ySpd,
        movements = {
                     normal = enemyCfg.movements.normal,
                     onHit = enemyCfg.movements.onHit
                    },
        move = enemyCfg.movements.normal,
        waveLen = enemyCfg.waveLen or 45,

        -- Hit box size.

        hitBox = {
                w = enemyCfg.hitBox.w or hitDefault,
                h = enemyCfg.hitBox.h or hitDefault,
                offX = enemyCfg.hitBox.offX or 0,
                offY = enemyCfg.hitBox.offY or 0
            },

        -- Offset for where projectile leave enemy.
        -- Defaults to 8x8 sprite size.

        bullXOffset = enemyCfg.bullXOffset or -1,
        bullYOffset = enemyCfg.bullYOffset or 6,

        hp = enemyCfg.hp or 1,
        rof = enemyCfg.rof,
        dam = enemyCfg.dam,
        ang = enemyCfg.ang or 1,
        pSpd = enemyCfg.pSpd or 1,

        moveDelay = 0,
        shakeTimer = 0,
        points = enemyCfg.points,

        -- Needed by some enemies to change movement
        -- movement behavior if certain conditions are
        -- met (Redeye only atm).
        moveSwitch = false,

        -- Use default colour palette.
        colId = 1,
        cols = enemyCfg.cols,
        -- Randomly select a color palette.
        --colId = ranInt(1, #enemyCfg.cols),


        -- Size of sprite, defaults to small.
        sprSize = enemyCfg.sprSize or 1,

        -- Sprites for animation.
        ani = enemyCfg.ani,

        -- Sprite to use when flashing.
        flashSpr = enemyCfg.flash,

        -- Enemies current sprite.
        curSpr = enemyCfg.ani[1],

        -- Current frame of animation.
        aniFrame = 1,

        -- Frames before animation advances.
        aniDelay = enemyCfg.aniDelay,

        -- Delay between firing bullets.
        fireDelay = enemyCfg.rof,

        -- Setup flash & death timers.
        flashTimer = flashTimerDefault,
        deathTimer = deathTimerDefault,

        -- Enemy current state.
        state = eneState.spawning,

        -- Activate the enemy after spawning.
        activate = function(_ENV)
            state = eneState.stopped
        end,

        -- Run looping enemy animation.
        animate = function(_ENV)
            aniFrame += aniDelay
            if flr(aniFrame) > #ani then
                aniFrame = 1
            end

            curSpr = ani[flr(aniFrame)]
        end,

        -- Fire a projectile.
        fire = function(_ENV, overP)
            local proCfg = g.getProConfig(g.pinkBullet)

            -- Calculate enemy projectile spawn point.
            local firing = {
                            x = x + bullXOffset,
                            y = y + bullYOffset
                        }

            if name == g.boss then
                g.spreadShot(proCfg, firing.x, firing.y,
                             8, 1.3, 0, dam,
                             g.owner.enemy)

            elseif name == g.ufo then
                g.aimedSpreadShot(proCfg, firing.x, firing.y,
                             3, 2, dam,
                             g.owner.enemy)

            elseif (name == g.flame) or (name == g.fighter) then
                local proCfg = g.getProConfig(g.blueBullet)

                g.aimedSingleShot(proCfg, firing.x, firing.y,
                                  pSpd, dam, g.owner.enemy)

            elseif name == g.redeye then
                local proCfg = g.getProConfig(g.blueBullet)

                g.aimedMultiShot(proCfg, firing.x, firing.y,
                                  2, pSpd, dam, g.owner.enemy)
            else
                g.singleShot(proCfg, firing.x, firing.y,
                             ang, pSpd, dam, g.owner.enemy)
            end
        end,

        -- Attack the player ship.
        attack = function(_ENV)
            fireDelay -= 1
            moveDelay -= 1

            if fireDelay > 0 and fireDelay <= flashTimerDefault then
                curSpr = flashSpr
            end

            if moveDelay <= 0 then
                move(_ENV, g.gameT)
                if fireDelay <= 0 then
                    fire(_ENV)

                    fireDelay = rof + g.ranInt(1, 4)
                    g.sfx(29)
                end
            end

        end,

        -- Have enemy shake before attacking.
        shake = function(_ENV)
            if state != eneState.stopped then return end
            aniDelay *= 3
            moveDelay = 15
            shakeTimer = 30 -- enemy shakes for 1 second.
            state = eneState.attacking
        end,

        -- Handle enemy being hit, determines switch
        -- to flashing or dead state.
        -- @param damage: Damage to apply to the enemy.
        hit = function(_ENV, damage)
            if state == eneState.spawning or state == eneState.dead then
                return
            end

            -- If no damage value is provided, use the enemy's remaining hp to ensure kill.
            hp -= damage or hp

            g.sfx(3)
            if hp <= 0 then
                if state == eneState.attacking then
                    points += g.flr(points * 0.3)
                end

                state = eneState.dead
                eCentre = g.getCentre(_ENV)

                g.player.score += points
                -- Spawn explosion.
                g.spawnExp(eCentre.x, eCentre.y, ySpd, g.eneCols)
                -- Spawn large shockwave.
                g.spawnShockWave(eCentre.x, eCentre.y, g.lgSwCfg)
            else
                state = eneState.flashing
            end
        end,

        -- Handle flash state timing and transition back to normal state.
        flash = function(_ENV)
            curSpr = flashSpr
            flashTimer -= 1
            if flashTimer <= 0 then
                flashTimer = flashTimerDefault

                -- Change movement to on hit.
                move = movements.onHit
                state = eneState.attacking
            end
        end,

        -- Handle dead state timing and removal.
        dead = function(_ENV)
            curSpr = flashSpr
            deathTimer -= 1

            if deathTimer <= 0 then
                del(g.enemies, _ENV)
            end
        end,

        -- Getter function for if the enemy can collide with the player or projectiles.
        canCollide = function(_ENV)
            -- Check if in bounds to prevent off-screen collisions.
            return state != eneState.dead
               and state != eneState.spawning
               and g.inBounds(_ENV)
        end,

        -- Update function for the enemy.
        update = function(_ENV)
            if state == eneState.dead then
                dead(_ENV)
            elseif state == eneState.flashing then
                flash(_ENV)
            elseif state == eneState.spawning then
                animate(_ENV)
            elseif state == eneState.stopped then
                animate(_ENV)
            elseif state == eneState.attacking then
                animate(_ENV)
                attack(_ENV)
            end

            -- Remove if off-screen and not spawning.
            if state != eneState.spawning then
                if x < -25 or x > 153 or y > 153 then
                    del(g.enemies, _ENV)
                end
            end
        end,

        -- Draw function for the enemy.
        draw = function(_ENV)

            pal(cols[1].c1, cols[colId].c1)
            pal(cols[1].c2, cols[colId].c2)

            local sprX = x

            if shakeTimer > 0 then
                shakeTimer -= 1
                if g.gameT % 4 < 2 then
                    sprX += 1
                end
            end

            if state == eneState.dead then
                spr(curSpr, x, y, sprSize, sprSize, false, deathTimer % 2 == 0)
            else
                spr(curSpr, sprX, y, sprSize, sprSize)
            end

            if g.debugMode then
                g.showHitBox(_ENV)
            end

            pal()
        end
    }
end

-- Spawns one enemy using shared enemy config.
-- @param enemy: Enemy configuration object.
-- @param x: Enemy spawn x position.
-- @param y: Enemy spawn y position.
-- @param spawnRowNum: Enemies row number.
-- @param activateAt: Wave timer value at which this enemy starts attacking.
-- @return: The spawned enemy object.
function spawnEnemy(enemy, spawnX, spawnY, spawnRowNum, activateAt)
    local newE = newEnemy(enemy, spawnX, spawnY, spawnRowNum, activateAt)

    add(enemies, newE)

    return newE
end

-- Update all enemies.
function updateEnemies()
    for e in all(enemies) do
        e:update()
    end
end

-- Draw all enemies.
function drawEnemies()
    for e in all(enemies) do
        e:draw()
    end
end