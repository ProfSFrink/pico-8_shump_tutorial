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
            upFunc = function(self)
                self.x = self.x + cos(self.y / 16) * 0.5
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
            upFunc = function(self)
                self.x = self.x + cos(self.y / 16) * 0.75
            end
        }
    }
end

-- Factory function for creating enemies.
-- @param enemyCfg: Enemy configuration object.
-- @return: A new enemy object.
function newEnemy(enemyCfg)
    return {
        name = enemyCfg.name,
        x = enemyCfg.x,
        y = -8,
        spd = enemyCfg.spd,
        hp = enemyCfg.hp,
        points = enemyCfg.points,

        cols = enemyCfg.cols,
        ranCol = flr(rnd(#enemyCfg.cols)) + 1,

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

        update = function(self)
            self.y = self.y + self.spd

            -- Check if in dead state.
            if self.dead then
                self.dTimer -= 1
                if self.dTimer <= 0 then
                    del(enemies, self)
                end
                -- Check if in hit state.
            elseif self.hit then
                self.hTimer -= 1
                if self.hTimer <= 0 then
                    self.hit = false
                    self.hTimer = hTimerLim
                end
                -- Otherwise, run normal animation function.
            else
                self.upFunc(self)
            end

            self.animTimer += 1
            if self.dead or self.hit then
                self.curFram = self.flFram
            else
                if self.animTimer >= self.animDelay then
                    self.animTimer = 0
                    if self.curFram < self.endFram then
                        self.curFram += 1
                    else
                        self.curFram = self.strtFram
                    end
                end
            end

            if self.y > 128 then
                del(enemies, self)
            end
        end,

        draw = function(self)
            if self.ranCol >= 1 then
                pal(self.cols[1].c1, self.cols[self.ranCol].c1)
                pal(self.cols[1].c2, self.cols[self.ranCol].c2)
            end

            if self.dead then
                spr(self.curFram, self.x, self.y, 1, 1, false, self.dTimer % 2 == 0)
            else
                spr(self.curFram, self.x, self.y)
            end

            if self.ranCol >= 1 then pal() end
        end,

        -- Handle being hurt.
        -- @param dam: Damage to apply to the enemy.
        hurt = function(self, dam)
            -- If no damage value is provided, use the enemy's remaining hp to ensure kill.
            dam = dam or self.hp
            self.hit = true
            self.hp -= dam
            sfx(5)
            if self.hp <= 0 then
                self.dead = true
                player.score += self.points
                -- Spawn explosion.
                spawnExp(self.x, self.y)
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