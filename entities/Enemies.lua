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
-- points: Enemy score value.
-- colW: Collision width - defaults to 7 (Optional).
-- colH: Collision height - defaults to 7 (Optional).
-- sprSize: Size the sprite - defaults to 7x7 (Optional).
-- move: Move function to use.
eDefs = {
    alien = {
        cols = {
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 10, c2 = 9 }, -- Orange.
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 6, c2 = 13 } -- Grey.
        },
        ani = { 80, 81, 82, 83 },
        flash = 84,
        aniDelay = 0.4,
        spd = 1.25,
        hp = 2,
        points = 100,
        move = downWave
    },
    ufo = {
        cols = {
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        ani = { 64, 65, 66, 67 },
        flash = 68,
        aniDelay = 0.4,
        spd = 1,
        hp = 2,
        points = 175,
        move = down
    },
    eyeball = {
        cols = {
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        ani = { 69, 70, 71, 72 },
        flash = 73,
        aniDelay = 0.4,
        spd = 0.6,
        hp = 3,
        points = 150,
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
        colW = 6,
        colH = 6,
        ani = { 88, 89, 90, 91, 92 },
        flash = 93,
        aniDelay = 0.4,
        spd = 0.6,
        hp = 3,
        points = 200,
        move = down
    },
    flame = {
        cols = {
            { c1 = 8, c2 = 2 }, -- Grey / Red.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        ani = { 85, 86 },
        flash = 87,
        aniDelay = 0.4,
        spd = 0.8,
        hp = 2,
        points = 200,
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
        ani = { 74, 75, 76, 77 },
        flash = 78,
        aniDelay = 0.4,
        spd = 2.5,
        hp = 3,
        points = 300,
        move = downTowardCenter
    },
    boss = {
        cols = {
            { c1 = 6, c2 = 14 }, -- Grey / Yellow.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        colW = 14,
        colH = 14,
        sprSize = 2,
        ani = { 96, 98 },
        flash = 100,
        aniDelay = 0.4,
        spd = 0.6,
        hp = 30,
        points = 1000,
        moveTime = 45,
        stopTime = 5,
        move = downWaveSlow
    }
}

-- Enemy Factory logic.

-- Flash state frame timer.
local flashTimerDefault = 3
-- Death state frame timer.
local deathTimerDefault = 10

-- State names for enemy state machine.
local eneState = {
    spawning = "spawning",
    stopped = "stopped",
    flashing = "flashing",
    attacking = "attacking",
    dead = "dead"
}

-- TODO: Add projectiles and firing patterns for enemies.
-- TODO: Improve enemy movement patterns.

-- Factory function for creating enemies.
-- @param enemyCfg: Enemy configuration object.
-- @param eneX: Spawn x position.
-- @param eneY: Spawn y position.
-- @return: A new enemy object.
function newEnemy(enemyCfg, eneX, eneY)
    -- Local references to global scope.
    local enemies = enemies
    local player = player
    local spawnShockWave = spawnShockWave
    local swConfig = lgSwCfg
    local spawnExp = spawnExp
    local sfx = sfx
    local expCols = eneCols
    local uiHeight = uiHeight

    return {
        name = enemyCfg.name,
        x = eneX,
        y = eneY,
        spd = enemyCfg.spd,
        hp = enemyCfg.hp or 1,
        points = enemyCfg.points,

        cols = enemyCfg.cols,
        -- Randomly select a color palette.
        --colId = ranInt(1, #enemyCfg.cols),

        -- Use default colour palette.
        colId = 1,

        -- Collision box size, defaults to 8x8.
        colW = enemyCfg.colW or colDefault,
        colH = enemyCfg.colH or colDefault,

        -- Size of sprite, defaults to small.
        sprSize = enemyCfg.sprSize or 1,

        -- Sprites for animation.
        ani = enemyCfg.ani,

        -- Sprite to use when flashing.
        flashSpr = enemyCfg.flash,

        -- Enemies current sprite.
        enemySpr = enemyCfg.ani[1],

        -- Current frame of animation.
        aniFrame = 1,

        -- Frames before animation advances.
        aniDelay = enemyCfg.aniDelay,

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

            enemySpr = ani[flr(aniFrame)]
        end,

        -- Handle enemy in attacking state.
        attack = function(_ENV)
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
                state = eneState.dead
                player.score += points
                -- Spawn explosion.
                spawnExp(x, y, spd, expCols)
                -- Spawn large shockwave.
                spawnShockWave(x, y, swConfig)
            else
                state = eneState.flashing
            end
        end,

        -- Handle flash state timing and transition back to normal state.
        flash = function(_ENV)
            enemySpr = flashSpr
            flashTimer -= 1
            if flashTimer <= 0 then
                state = eneState.attacking
                flashTimer = flashTimerDefault
            end
        end,

        -- Handle dead state timing and removal.
        dead = function(_ENV)
            enemySpr = flashSpr
            deathTimer -= 1
            if deathTimer <= 0 then
                del(enemies, _ENV)
            end
        end,

        -- Getter function for if the enemy can collide with the player or projectiles.
        canCollide = function(_ENV)
            -- Check if in bounds to prevent off-screen collisions.
            local inBounds = mid(0, x, 128) == x and mid(0 + uiHeight, y, 128) == y

            return state != eneState.dead and state != eneState.spawning and inBounds
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
                move(_ENV)
            end

            -- Remove if off-screen and not spawning.
            if y > 128 and state != eneState.spawning then
                del(enemies, _ENV)
            end
        end,

        -- Draw function for the enemy.
        draw = function(_ENV)

            pal(cols[1].c1, cols[colId].c1)
            pal(cols[1].c2, cols[colId].c2)

            if state == eneState.dead then
                spr(enemySpr, x, y, sprSize, sprSize, false, deathTimer % 2 == 0)
            else
                spr(enemySpr, x, y, sprSize, sprSize)
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
    local newE = newEnemy(enemy, spawnX, spawnY)
    newE.rowNum = spawnRowNum

    add(
        enemies, newE
    )

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