-- Enemy component logic.

-- Factory function for creating enemies.
-- @param x: The x position.
-- @param y: The y position.
-- @param spd: The speed of the enemy.
-- @param strtFram: Starting frame of the enemy's animation.
-- @param endFram: Ending frame of the enemy's animation.
-- @param animDelay: Frames before the enemy's animation advances.
-- @return: A new enemy object.
function newEnemy(x, y, spd, strtFram,
    endFram,animDelay)
    return {
        x=x,
        y=y,
        spd=spd,
        curFram=strtFram,
        strtFram=strtFram,
        endFram=endFram,
        frameDelay=0,
        animDelay=animDelay,

        update=function(self)
            self.y=self.y+self.spd

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

-- Creates the initial set of enemies.
function createEnemy()
    local y = -8
    for i=1,noOfEnemies do
        add(enemies, newEnemy(32,
            y, enemy.spd, enemy.strtFram, enemy.endFram, enemy.animDelay))
        y -= 10
    end
end