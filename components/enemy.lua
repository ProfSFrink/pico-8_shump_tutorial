-- Enemy component data & logic.

-- TODO: Add hp property.
-- TODO: Add projectiles for enemies.

-- Initial enemy definitions.
function initEnemies()
    -- Setup for an enemy.
    -- type: Enemy type.
    -- x: x coordinate.
    -- y: y coordinate.
    -- strtFram: Starting frame of the enemy's animation.
    -- endFram: Ending frame of the enemy's animation.
    -- animDelay: Frames before the enemy's animation advances.
    -- spd: Enemy speed.
    -- points: Enemy points value.
    -- animFunc: Custom animation function(self).
    eneDefs={
        green={
            type="green",
            x=0,
            y=-8,
            strtFram=48,
            endFram=51,
            deadFram=52,
            animDelay=3,
            spd=0.5,
            points=100,
            animFunc=function(self)
                self.x = self.x + cos(self.y/16)*0.5
            end
        },
        blue={
            type="blue",
            x=0,
            y=-8,
            strtFram=32,
            endFram=35,
            deadFram=36,
            animDelay=3,
            spd=0.75,
            points=150,
            animFunc=function(self)
                self.x = self.x + cos(self.y/16)*0.75
            end
        },
    }
end

-- Factory function for creating enemies.
-- @param enemyCfg: Enemy configuration object.
-- @return: A new enemy object.
function newEnemy(enemyCfg)
    return {
        type=enemyCfg.type,
        x=enemyCfg.x,
        y=enemyCfg.y,
        spd=enemyCfg.spd,
        points=enemyCfg.points,
        curFram=enemyCfg.strtFram,
        strtFram=enemyCfg.strtFram,
        endFram=enemyCfg.endFram,
        deadFram=enemyCfg.deadFram,
        frameDelay=0,
        animDelay=enemyCfg.animDelay,
        animFunc=enemyCfg.animFunc,
        dead=false,
        dTimer=10, -- Death animation frame timer.

        update=function(self)
            self.y=self.y+self.spd
            if not self.dead then
                self.animFunc(self)
            else
                -- Play death animation.
                self.dTimer-=1
                if self.dTimer<=0 then
                    del(enemies, self)
                end
            end

            -- Animate the enemy.
            self.frameDelay+=1
            if self.dead == true then
                self.curFram=self.deadFram
            else
                if self.frameDelay >= self.animDelay then
                    self.frameDelay=0
                    if self.curFram < self.endFram then
                        self.curFram+=1
                    else
                        self.curFram=self.strtFram
                    end
                end
            end

            if self.y > 128 then
                del(enemies, self)
            end
        end,

        draw=function(self)
            if self.dead then
                spr(self.curFram, self.x, self.y, 1, 1, false, self.dTimer%2==0)
            else
                spr(self.curFram, self.x, self.y)
            end
        end,

        kill=function(self)
            self.dead=true
            player.score+=self.points
        end
    }
end

-- Spawns one enemy using shared enemy config.
-- @param x: X position.
function spawnEnemy(enemy,x)
    local def

    if enemy.type == eneDefs.green.type then
        def=eneDefs.green
    end

    if enemy.type == eneDefs.blue.type then
        def=eneDefs.blue
    end

    add(enemies, newEnemy({
        type=def.type,
        x=x,
        y=def.y,
        spd=def.spd,
        points=def.points,
        strtFram=def.strtFram,
        endFram=def.endFram,
        deadFram=def.deadFram,
        animDelay=def.animDelay,
        animFunc=def.animFunc
    }))
end