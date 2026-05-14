-- Enemies definitions.
-- todo: Review animation delays.

    -- Setup for an enemy.
    -- name: Enemy name.
    -- cols: table of color pairs for the enemy, first is
    --       entry matches sprite colours.
    -- ani: Table of animation settings.
    --      start: First sprite index of the animation.
    --      fin: Last sprite index of the animation.
    --      flash: Sprite index to use when hit.
    --      delay: Frames between animation changes.
    -- spd: Enemy speed.
    -- hp: Enemy health points.
    -- points: Enemy score value.
    -- colW: Collision width - defaults to 7 (Optional).
    -- colH: Collision height - defaults to 7 (Optional).
    -- sprSize: Size the sprite - defaults to 7x7 (Optional).
    -- move: Custom move function.
eTypes = {
    alien = {
        name = "alien",
        cols = {
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 10, c2 = 9 }, -- Orange.
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 6, c2 = 13 } -- Grey.
        },
        ani = { 80, 81, 82, 83 },
        flash = 84,
        delay = 0.4,
        spd = 0.5,
        hp = 2,
        points = 100,
        move = function(_ENV)
            x = x + cos(y / 16) * spd
        end
    },
    ufo = {
        name = "ufo",
        cols = {
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        ani = { 64, 65, 66, 67 },
        flash = 68,
        delay = 0.4,
        spd = 0.75,
        hp = 4,
        points = 175,
        move = function(_ENV)
            y += spd
        end
    },
    eyeball = {
        name = "eyeball",
        cols = {
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        ani = { 69, 70, 71, 72 },
        flash = 73,
        delay = 0.4,
        spd = 0.6,
        hp = 3,
        points = 150,
        move = function(_ENV)
            x = x + cos(y / 16) * spd
        end
    },
        redeye = {
            name = "redeye",
            cols = {
                { c1 = 5, c2 = 8 }, -- Grey / Red.
                -- { c1 = 9, c2 = 4 }, -- Brown.
                -- { c1 = 11, c2 = 3 }, -- Green.
                -- { c1 = 12, c2 = 1 }, -- Blue.
                -- { c1 = 14, c2 = 2 } -- Pink.
            },
            colW = 6,
            colH = 6,
            ani = { 88, 89, 90, 91, 92 },
            flash = 93,
            delay = 0.4,
            spd = 0.3,
            hp = 5,
            points = 200,
            move = function(_ENV)
                y += spd
            end
    },
        flame = {
        name = "flame",
        cols = {
            { c1 = 8, c2 = 2 }, -- Grey / Red.
            -- { c1 = 9, c2 = 4 }, -- Brown.
            -- { c1 = 11, c2 = 3 }, -- Green.
            -- { c1 = 12, c2 = 1 }, -- Blue.
            -- { c1 = 14, c2 = 2 } -- Pink.
        },
        ani = { 85, 86 },
        flash = 87,
        delay = 0.4,
        spd = 0.8,
        hp = 2,
        points = 200,
        move = function(_ENV)
            x = x + cos(y / 16) * spd
            y += spd
        end
    },
        fighter = {
        name = "fighter",
        cols = {
            { c1 = 1, c2 = 5 }, -- Blue / Grey.
            -- { c1 = 9, c2 = 4 }, -- Brown.
            -- { c1 = 11, c2 = 3 }, -- Green.
            -- { c1 = 12, c2 = 1 }, -- Blue.
            -- { c1 = 14, c2 = 2 } -- Pink.
        },
        ani = { 74, 75, 76, 77 },
        flash = 78,
        delay = 0.4,
        spd = 0.4,
        hp = 4,
        points = 300,
        move = function(_ENV)
            x = x + cos(y / 16) * spd
            y += spd
        end
    },
    boss = {
        name = "boss",
        cols = {
            { c1 = 10, c2 = 0 }, -- Green.
        },
        colW = 14,
        colH = 14,
        sprSize = 2,
        ani = { 96, 98 },
        flash = 100,
        delay = 0.4,
        spd = 0.5,
        hp = 10,
        points = 1000,
        move = function(_ENV)
            x = x + cos(y / 16) * spd
        end
    },
}

-- Enemy Factory logic.

-- Flash state frame timer.
local fTimerLim = 3
-- Death state frame timer.
local dTimerLim = 10

-- State name for enemy state machine.
local eneState = {
    normal = "normal",
    flashing = "flashing",
    dead = "dead"
}

-- TODO: Add projectiles and firing patterns for enemies.
-- TODO: Add spawning animation for enemies.
-- TODO: Improve enemy movement patterns.
-- TODO: Get rid of boolean hit and dead values and just use timers.

-- Factory function for creating enemies.
-- @param enemyCfg: Enemy configuration object.
-- @param eneX: Spawn x position.
-- @param eneY: Spawn y position.
-- @return: A new enemy object.
function newEnemy(enemyCfg, eneX, eneY)
    -- Local references to global scope.
    local ene = enemies
    local pl = player
    local spawnShockWave = spawnShockWave
    local swConfig = lgSwCfg
    local spawnExp = spawnExp
    local sfx = sfx
    local expCols = eneCols

    return {
        name = enemyCfg.name,
        x = eneX,
        y = eneY,
        spd = enemyCfg.spd,
        hp = enemyCfg.hp,
        points = enemyCfg.points,

        cols = enemyCfg.cols,
        -- Randomly select a color palette.
        --ranIdx = ranInt(1, #enemyCfg.cols),
        ranIdx = 1,

        -- Collision box size, defaults to 8x8.
        colW = enemyCfg.colW or colDefault,
        colH = enemyCfg.colH or colDefault,

        -- Size of sprite, defaults to small.
        sprSize = enemyCfg.sprSize or 1,

        -- Sprites for animation and flash when hit.
        ani = enemyCfg.ani,

        -- Sprite to use when flashing.
        flashSpr = enemyCfg.flash,

        -- Enemies current sprite.
        EnemySpr = enemyCfg.ani[1],

        -- Current frame of animation.
        aniFrame = 1,

        -- Frames before animation advances.
        aniDelay = enemyCfg.delay,

        move = enemyCfg.move,
        fTimer = fTimerLim,
        dTimer = dTimerLim,

        -- Enemy state, can be normal, flashing, or dead.
        state = eneState.normal,

        -- Animate enemy sprite.
        animate = function(_ENV)
            aniFrame += aniDelay
            if flr(aniFrame) > #ani then
                aniFrame = 1
            end

            EnemySpr = ani[flr(aniFrame)]
        end,

        -- TODO: Add firing state and logic for enemies.

        -- Handle being Damaged.
        -- @param dam: Damage to apply to the enemy.
        hit = function(_ENV, dam)
            -- If no damage value is provided, use the enemy's remaining hp to ensure kill.
            dam = dam or hp
            state = eneState.flashing
            hp -= dam

            sfx(3)
            if hp <= 0 then
                state = eneState.dead
                pl.score += points
                -- Spawn explosion.
                spawnExp(x, y, spd, expCols)
                -- Spawn large shockwave.
                spawnShockWave(x, y, swConfig)
            end
        end,

        -- Handle flash state timing and transition back to normal state.
        flash = function(_ENV)
            EnemySpr = flashSpr
            fTimer -= 1
            if fTimer <= 0 then
                state = eneState.normal
                fTimer = fTimerLim
            end
        end,

        -- Handle dead state timing and removal.
        dead = function(_ENV)
            EnemySpr = flashSpr
            dTimer -= 1
            if dTimer <= 0 then
                del(ene, _ENV)
            end
        end,

        -- Getter function for checking if the enemy is dead.
        isDead = function(_ENV)
            return state == eneState.dead
        end,

        -- Update function for the enemy.
        update = function(_ENV)
            y += spd

            -- Animate enemy if in normal state.
            if state == eneState.normal then
                animate(_ENV)
            end

            -- TODO: Call spawning logic.

            -- Remove if off-screen.
            if y > 128 then
                del(ene, _ENV)
            end

            -- Handle normal movement.
            move(_ENV)

            -- Update depending on state.
            if state == eneState.dead then
                dead(_ENV)
            elseif state == eneState.flashing then
                flash(_ENV)
            end
        end,

        -- Draw function for the enemy.
        draw = function(_ENV)
            if ranIdx >= 1 then
                pal(cols[1].c1, cols[ranIdx].c1)
                pal(cols[1].c2, cols[ranIdx].c2)
            end

            if state == eneState.dead then
                spr(EnemySpr, x, y, sprSize, sprSize, false, dTimer % 2 == 0)
            else
                spr(EnemySpr, x, y, sprSize, sprSize)
            end

            if ranIdx >= 1 then pal() end
        end
    }
end

-- Spawns one enemy using shared enemy config.
-- @param x: X position.
-- @param y: Y position.
function spawnEnemy(enemy, x, y)
    add(
        enemies, newEnemy(eTypes[enemy.name], x, y)
    )
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