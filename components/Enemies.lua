-- Enemies definitions.

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
    -- upFunc: Custom update function.
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
        ani = { start = 80,
                fin = 83,
                flash = 84,
                delay = 3 },
        spd = 0.5,
        hp = 2,
        points = 100,
        upFunc = function(_ENV)
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
        ani = { start = 64,
                fin = 67,
                flash = 68,
                delay = 3 },
        spd = 0.75,
        hp = 4,
        points = 175,
        upFunc = function(_ENV)
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
        ani = { start = 69,
                fin = 72,
                flash = 73,
                delay = 3 },
        spd = 0.6,
        hp = 3,
        points = 150,
        upFunc = function(_ENV)
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
        ani = { start = 88,
                fin = 92,
                flash = 93,
                delay = 5 },
        spd = 0.3,
        hp = 5,
        points = 200,
        upFunc = function(_ENV)
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
        ani = { start = 85,
                fin = 86,
                flash = 87,
                delay = 2 },
        spd = 0.8,
        hp = 2,
        points = 200,
        upFunc = function(_ENV)
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
        ani = { start = 74,
                fin = 77,
                flash = 78,
                delay = 2 },
        spd = 0.4,
        hp = 4,
        points = 300,
        upFunc = function(_ENV)
            x = x + cos(y / 16) * spd
            y += spd
        end
    },
}

-- Enemy Factory logic.

-- Hit state frame timer.
local hTimerLim = 3
-- Death state frame timer.
local dTimerLim = 10

-- TODO: Add projectiles for enemies.
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

        -- Current sprite being animated.
        curSpr = enemyCfg.ani.start,

        startSpr = enemyCfg.ani.start,
        endSpr = enemyCfg.ani.fin,
        flSpr = enemyCfg.ani.flash,

        -- Frames since last animation change.
        animTimer = 0,

        animDelay = enemyCfg.ani.delay,
        upFunc = enemyCfg.upFunc,
        hit = false, -- if enemy in hit state.
        hTimer = hTimerLim,
        dead = false, -- if enemy in dead state.
        dTimer = dTimerLim,

        update = function(_ENV)
            y += spd

            -- Check if in dead state.
            if dead then
                dTimer -= 1
                if dTimer <= 0 then
                    del(ene, _ENV)
                end
                -- Check if in hit state.
            elseif hit then
                hTimer -= 1
                if hTimer <= 0 then
                    hit = false
                    hTimer = hTimerLim
                end
                -- Otherwise, run normal animation function.
            else
                upFunc(_ENV)
            end

            animTimer += 1
            if dead or hit then
                curSpr = flSpr
            else
                if animTimer >= animDelay then
                    animTimer = 0
                    if curSpr < endSpr then
                        curSpr += 1
                    else
                        curSpr = startSpr
                    end
                end
            end

            if y > 128 then
                del(ene, _ENV)
            end
        end,

        draw = function(_ENV)
            if ranIdx >= 1 then
                pal(cols[1].c1, cols[ranIdx].c1)
                pal(cols[1].c2, cols[ranIdx].c2)
            end

            if dead then
                spr(curSpr, x, y, 1, 1, false, dTimer % 2 == 0)
            else
                spr(curSpr, x, y)
            end

            if ranIdx >= 1 then pal() end
        end,

        -- Handle being hurt.
        -- @param dam: Damage to apply to the enemy.
        hurt = function(_ENV, dam)
            -- If no damage value is provided, use the enemy's remaining hp to ensure kill.
            dam = dam or hp
            hit = true
            hp -= dam

            sfx(3)
            if hp <= 0 then
                dead = true
                pl.score += points
                -- Spawn explosion.
                spawnExp(x, y, spd, expCols)
                -- Spawn large shockwave.
                spawnShockWave(x, y, swConfig)
            end
        end
    }
end

-- Spawns one enemy using shared enemy config.
-- @param x: X position.
-- @param y: Y position.
function spawnEnemy(enemy, x, y)
    local def

    if enemy.name == eTypes.alien.name then
        def = eTypes.alien
    end

    if enemy.name == eTypes.ufo.name then
        def = eTypes.ufo
    end

    if enemy.name == eTypes.eyeball.name then
        def = eTypes.eyeball
    end

    if enemy.name == eTypes.redeye.name then
        def = eTypes.redeye
    end

    if enemy.name == eTypes.flame.name then
        def = eTypes.flame
    end

    if enemy.name == eTypes.fighter.name then
        def = eTypes.fighter
    end

    add(
        enemies, newEnemy(def, x, y)
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