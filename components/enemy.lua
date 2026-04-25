-- Enemy component data & logic.

-- Shared enemy type IDs used game-wide.
eneTyp={
    green="green",
    blue="blue"
}

function initEnemies()
    -- Setup for an enemy.
    -- x: x coordinate.
    -- y: y coordinate.
    -- strtFram: Starting frame of the enemy's animation.
    -- endFram: Ending frame of the enemy's animation.
    -- animDelay: Frames before the enemy's animation advances.
    -- spd: Enemy speed.
    -- animFunc: Custom animation function(self).
    eneDefs={
        [eneTyp.green]={
            x=0,
            y=-8,
            strtFram=48,
            endFram=51,
            animDelay=3,
            spd=0.5,
            animFunc=function(self)
                self.x = self.x + cos(self.y/16)*0.5
            end
        },
        [eneTyp.blue]={
            x=0,
            y=-8,
            strtFram=32,
            endFram=35,
            animDelay=3,
            spd=0.75,
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
        x=enemyCfg.x,
        y=enemyCfg.y,
        spd=enemyCfg.spd,
        curFram=enemyCfg.strtFram,
        strtFram=enemyCfg.strtFram,
        endFram=enemyCfg.endFram,
        frameDelay=0,
        animDelay=enemyCfg.animDelay,
        animFunc=enemyCfg.animFunc,

        update=function(self)
            self.y=self.y+self.spd
            self.animFunc(self)

            -- Animate the enemy.
            self.frameDelay+=1
            if self.frameDelay >= self.animDelay then
                self.frameDelay=0
                if self.curFram < self.endFram then
                    self.curFram+=1
                else
                    self.curFram=self.strtFram
                end
            end

            if self.y > 128 then
                del(enemies, self)
            end
        end,

        draw=function(self)
            spr(self.curFram, self.x, self.y)
        end
    }
end

-- Spawns one enemy using shared enemy config.
-- @param x: X position.
function spawnEnemy(enemy,x)
    local def

    if enemy == eneTyp.green then
        def=eneDefs[eneTyp.green]
    end

    if enemy == eneTyp.blue then
        def=eneDefs[eneTyp.blue]
    end

    add(enemies, newEnemy({
        x=x,
        y=def.y,
        spd=def.spd,
        strtFram=def.strtFram,
        endFram=def.endFram,
        animDelay=def.animDelay,
        animFunc=def.animFunc
    }))
end