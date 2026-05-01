-- Enemy component data & logic.

-- Hit state frame timer.
local hTimerLim = 3
-- Death state frame timer.
local dTimerLim = 10

-- TODO: Add projectiles for enemies.
-- TODO: Get rid of boolean hit and dead values and just use timers.

-- Initial enemy definitions on game load.
function initEnemies()
    -- Setup for an enemy.
    -- name: Enemy name.
    -- cols: table of color pairs for the enemy, first is
    --       entry matches sprite colours.
    -- strtFram: Starting sprite of the enemy's animation.
    -- endFram: Ending sprite of the enemy's animation.
    -- flFram: Flash sprite when hit or dead.
    -- animDelay: Delay between animation frames.
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
            strtFram = 48,
            endFram = 51,
            flFram = 52,
            animDelay = 3,
            spd = 0.5,
            hp = 3,
            points = 100,
            upFunc = function(_ENV)
                x = x + cos(y / 16) * 0.5
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
            strtFram = 32,
            endFram = 35,
            flFram = 36,
            animDelay = 3,
            spd = 0.75,
            hp = 5,
            points = 150,
            upFunc = function(_ENV)
                x = x + cos(y / 16) * 0.75
            end
        }
    }
end

-- Factory function for creating enemies.
-- @param enemyCfg: Enemy configuration object.
-- @return: A new enemy object.
function newEnemy(enemyCfg)
    -- Local references to global scope.
    local ene = enemies
    local pl = player
    local spk = newSpark
    local exp = spawnExp
    local playSfx = sfx

    return {
        name = enemyCfg.name,
        x = enemyCfg.x,
        y = -8,
        spd = enemyCfg.spd,
        hp = enemyCfg.hp,
        points = enemyCfg.points,

        cols = enemyCfg.cols,
        ranIdx = flr(rnd(#enemyCfg.cols)) + 1,

        -- Current sprite being animated.
        curFram = enemyCfg.strtFram,

        strtFram = enemyCfg.strtFram,
        endFram = enemyCfg.endFram,
        flFram = enemyCfg.flFram,

        -- Frames since last animation change.
        animTimer = 0,

        animDelay = enemyCfg.animDelay,
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
                curFram = flFram
            else
                if animTimer >= animDelay then
                    animTimer = 0
                    if curFram < endFram then
                        curFram += 1
                    else
                        curFram = strtFram
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
                spr(curFram, x, y, 1, 1, false, dTimer % 2 == 0)
            else
                spr(curFram, x, y)
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
            spk(x, y, spd)

            playSfx(5)
            if hp <= 0 then
                dead = true
                pl.score += points
                -- Spawn explosion.
                exp(x, y)
            end
        end
    }
end

-- Spawns one enemy using shared enemy config.
-- @param x: X position.
function spawnEnemy(enemy, x)
    local def

    if enemy.name == eTypes.alien.name then
        def = eTypes.alien
    end

    if enemy.name == eTypes.ufo.name then
        def = eTypes.ufo
    end

    add(
        enemies, newEnemy({
            name = def.name,
            x = x,
            spd = def.spd,
            hp = def.hp,
            points = def.points,
            cols = def.cols,
            strtFram = def.strtFram,
            endFram = def.endFram,
            flFram = def.flFram,
            animDelay = def.animDelay,
            upFunc = def.upFunc
        })
    )
end