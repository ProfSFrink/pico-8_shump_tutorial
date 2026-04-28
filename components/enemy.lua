-- Enemy component data & logic.

local hTimerLim = 3
-- Hit state frame timer.
local dTimerLim = 10
-- Death state frame timer.

-- TODO: Add projectiles for enemies.

-- Initial enemy definitions.
function initEnemies()
    -- Setup for an enemy.
    -- type: Enemy type.
    -- strtFram: Starting sprite of the enemy's animation.
    -- endFram: Ending sprite of the enemy's animation.
    -- flFram: Flash sprite when hit or dead.
    -- animDelay: Delay between animation frames.
    -- spd: Enemy speed.
    -- hp: Enemy health points.
    -- points: Enemy score value.
    -- upFunc: Custom update function.
    eTypes = {
        green = {
            type = "green",
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
        blue = {
            type = "blue",
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
        type = enemyCfg.type,
        x = enemyCfg.x,
        y = -8,
        spd = enemyCfg.spd,
        hp = enemyCfg.hp,
        points = enemyCfg.points,

        -- Current sprite being animated.
        curFram = enemyCfg.strtFram,

        strtFram = enemyCfg.strtFram,
        endFram = enemyCfg.endFram,
        flFram = enemyCfg.flFram,

        -- Frames since last animation change.
        animTimer = 0,

        animDelay = enemyCfg.animDelay,
        upFunc = enemyCfg.upFunc,
        hit = false,
        hTimer = hTimerLim,
        dead = false,
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
            if self.dead then
                spr(self.curFram, self.x, self.y, 1, 1, false, self.dTimer % 2 == 0)
            else
                spr(self.curFram, self.x, self.y)
            end
        end,

        dam = function(self, dam)
            self.hit = true
            self.hp -= dam
            sfx(5)
            if self.hp <= 0 then
                self.dead = true
                player.score += self.points
                spawnExp(self.x, self.y)
            end
        end,
    }
end

-- Spawns one enemy using shared enemy config.
-- @param x: X position.
function spawnEnemy(enemy, x)
    local def

    if enemy.type == eTypes.green.type then
        def = eTypes.green
    end

    if enemy.type == eTypes.blue.type then
        def = eTypes.blue
    end

    add(
        enemies, newEnemy({
            type = def.type,
            x = x,
            spd = def.spd,
            hp = def.hp,
            points = def.points,
            strtFram = def.strtFram,
            endFram = def.endFram,
            flFram = def.flFram,
            animDelay = def.animDelay,
            upFunc = def.upFunc
        })
    )
end