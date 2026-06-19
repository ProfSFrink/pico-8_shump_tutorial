-- Enemies definitions.

-- Setup for an enemy.
-- name: Enemy name.
-- cols: table of color pairs for the enemy, first is
--       entry matches sprite colours.
-- ani: Table of animation settings.
--      start: First sprite index of the animation.
--      fin: Last sprite index of the animation.
--      flash: Sprite index to use when hit.
--      aniDelay: Frames between animation changes.
-- spd: Enemy speed when moving.
-- moveTime: Frames enemy moves before stopping (Optional).
-- stopTime: Frames enemy stops before moving again (Optional).
-- hp: Enemy health points.
-- rof: Rate of fire when attacking.
-- points: Enemy score value.
-- hitBoxW: Collision width - defaults to 7 (Optional).
-- hitBoxH: Collision height - defaults to 7 (Optional).
-- sprSize: Size the sprite - defaults to 7x7 (Optional).
-- move: Movement function to use.
eDefs = {
    alien = {
        cols = {
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 10, c2 = 9 }, -- Orange.
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 6, c2 = 13 } -- Grey.
        },
        hitBoxW = 5,
        hitBoxH = 5,
        hitBoxOffX = 1,
        hitBoxOffY = 1,
        ani = { 80, 81, 82, 83 },
        nAni = {
            start = 80,
            fin = 81,
            delay = 0.4
        },
        flash = 84,
        aniDelay = 0.4,
        xSpd = 0,
        ySpd = 1.25,
        hp = 2,
        rof = 15,
        points = 100,
        weapon = singlePinkBullet,
        move = stationary
    },
    ufo = {
        cols = {
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        hitBoxW = 5,
        hitBoxH = 3,
        hitBoxOffX = 1,
        hitBoxOffY = 3,
        ani = { 64, 65, 66, 67 },
        nAni = {
            start = 64,
            fin = 67,
            delay = 0.4
        },
        flash = 68,
        aniDelay = 0.4,
        xSpd = 1,
        ySpd = 1,
        hp = 2,
        rof = 10,
        points = 175,
        weapon = singlePinkBullet,
        move = downWaveSlow
    },
    eyeball = {
        cols = {
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        hitBoxW = 5,
        hitBoxH = 5,
        hitBoxOffX = 1,
        hitBoxOffY = 1,
        ani = { 69, 70, 71, 72 },
        nAni = {
            start = 69,
            fin = 72,
            delay = 0.4
        },
        flash = 73,
        aniDelay = 0.4,
        xSpd = 0.6,
        ySpd = 0.6,
        hp = 3,
        rof = 10,
        points = 150,
        weapon = singlePinkBullet,
        move = downWave
    },
    redeye = {
        cols = {
            { c1 = 5, c2 = 8 }, -- Grey / Red.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        hitBoxW = 4,
        hitBoxH = 4,
        hitBoxOffX = 1,
        hitBoxOffY = 1,
        ani = { 88, 89, 90, 91, 92 },
        nAni = {
            start = 88,
            fin = 92,
            delay = 0.4
        },
        flash = 93,
        aniDelay = 0.4,
        xSpd = 1.5,
        ySpd = 1.2,
        hp = 3,
        rof = 10,
        points = 200,
        weapon = singlePinkBullet,
        move = downTowardCenterBackUp
    },
    flame = {
        cols = {
            { c1 = 8, c2 = 2 }, -- Grey / Red.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        hitBoxW = 5,
        hitBoxH = 4,
        hitBoxOffX = 1,
        hitBoxOffY = 3,
        ani = { 85, 86 },
        nAni = {
            start = 85,
            fin = 86,
            delay = 0.4
        },
        flash = 87,
        aniDelay = 0.4,
        xSpd = 2.5,
        ySpd = 2.5,
        waveLen = 20,
        hp = 1,
        rof = 10,
        points = 200,
        weapon = singlePinkBullet,
        move = downWave
    },
    fighter = {
        cols = {
            { c1 = 1, c2 = 5 }, -- Blue / Grey.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        hitBoxW = 5,
        hitBoxH = 4,
        hitBoxOffX = 1,
        hitBoxOffY = 1,
        ani = { 74, 75, 76, 77 },
        nAni = {
            start = 74,
            fin = 77,
            delay = 0.4
        },
        flash = 78,
        aniDelay = 0.4,
        xSpd = 0,
        ySpd = 0,
        hp = 2,
        rof = 10,
        points = 300,
        weapon = singlePinkBullet,
        move = downAcross
    },
    boss = {
        cols = {
            { c1 = 6, c2 = 14 }, -- Grey / Yellow.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        hitBoxW = 11,
        hitBoxH = 9,
        hitBoxOffX = 2,
        hitBoxOffY = 3,
        sprSize = 2,
        ani = { 96, 98 },
        nAni = {
            start = 96,
            fin = 81,
            delay = 0.4
        },
        flash = 100,
        aniDelay = 0.4,
        xSpd = 0,
        ySpd = 0.35,
        hp = 30,
        rof = 10,
        points = 1000,
        weapon = "spreadShot",
        moveTime = 45,
        stopTime = 5,
        move = down
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
-- @return: A new enemy object.
function newEnemy(enemyCfg, eneX, eneY, eneRowNum)
    -- Local references to global scope.
    local enemies = enemies
    local player = player
    local spawnShockWave = spawnShockWave
    local swConfig = lgSwCfg
    local spawnExp = spawnExp
    local print = print
    local sfx = sfx
    local expCols = eneCols
    local uiHeight = uiHeight
    local chargePlayer = chargePlayer
    local g = _g

    return {
        name = enemyCfg.name,
        x = eneX,
        y = eneY,
        rowNum = eneRowNum,
        xSpd = enemyCfg.xSpd,
        ySpd = enemyCfg.ySpd,
        waveLen = enemyCfg.waveLen or 45,
        hp = enemyCfg.hp or 1,
        rof = enemyCfg.rof,
        weapon = enemyCfg.weapon,
        bullXOffset = -1,
        bullYOffset = 6,
        moveDelay = 0,
        shake = 0,
        points = enemyCfg.points,
        moving = false,
        movingLeft = false,

        cols = enemyCfg.cols,
        -- Randomly select a color palette.
        --colId = ranInt(1, #enemyCfg.cols),

        -- Use default colour palette.
        colId = 1,

        -- Hit box size, defaults to 8x8.
        hitBoxW = enemyCfg.hitBoxW or hitDefault,
        hitBoxH = enemyCfg.hitBoxH or hitDefault,
        hitBoxOffX = enemyCfg.hitBoxOffX or 0,
        hitBoxOffY = enemyCfg.hitBoxOffY or 0,

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

        move = enemyCfg.move,

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

        -- Attack the player ship.
        attack = function(_ENV)
            fireDelay -= 1
            moveDelay -= 1

            if fireDelay > 0 and fireDelay <= flashTimerDefault then
                curSpr = flashSpr
            end


            if moveDelay <= 0 then
                move(_ENV, g.gameT)
            end

            if fireDelay <= 0 then
                g.fireWeapon(
                    g.weapons[weapon],
                    x + bullXOffset,
                    y + bullYOffset,
                    g.owner.enemy
                )
                fireDelay = rof + g.rnd(20)
            end
        end,

        -- Have enemy charge player ship.
        charge = function(_ENV)
            if state != eneState.stopped then return end
            aniDelay *= 3
            moveDelay = 30
            shake = 30
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

            sfx(3)
            if hp <= 0 then
                -- If player destroys attacking enemy
                -- have new enemy start attacking.
                if state == eneState.attacking then
                    if g.rnd() < 0.5 then
                        chargePlayer(enemies)
                    end
                    points = g.flr(points * 0.3)
                end

                state = eneState.dead
                player.score += points
                -- Spawn explosion.
                spawnExp(x, y, ySpd, expCols)
                -- Spawn large shockwave.
                spawnShockWave(x, y, swConfig)
            else
                state = eneState.flashing
            end
        end,

        -- Handle flash state timing and transition back to normal state.
        flash = function(_ENV)
            curSpr = flashSpr
            flashTimer -= 1
            if flashTimer <= 0 then
                state = eneState.attacking
                flashTimer = flashTimerDefault
            end
        end,

        -- Handle dead state timing and removal.
        dead = function(_ENV)
            curSpr = flashSpr
            deathTimer -= 1

            if deathTimer <= 0 then
                del(enemies, _ENV)
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
                if x < 0 or x > 128 or y > 128 then
                    del(enemies, _ENV)
                end
            end
        end,

        -- Draw function for the enemy.
        draw = function(_ENV)

            pal(cols[1].c1, cols[colId].c1)
            pal(cols[1].c2, cols[colId].c2)

            local sprX = x

            if shake > 0 then
                shake -= 1
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
-- @return: The spawned enemy object.
function spawnEnemy(enemy, spawnX, spawnY, spawnRowNum)
    local newE = newEnemy(enemy, spawnX, spawnY, spawnRowNum)

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