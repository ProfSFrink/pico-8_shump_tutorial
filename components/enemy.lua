-- Enemy component data & logic.

function initEnemies()
    -- Setup for an enemy.
    -- x: x coordinate.
    -- y: y coordinate.
    -- strtFram: Starting frame of the enemy's animation.
    -- endFram: Ending frame of the enemy's animation.
    -- animDelay: Frames before the enemy's animation advances.
    -- spd: Enemy speed.
    enemyType={
        green={
            x=0,
            y=-8,
            strtFram=48,
            endFram=51,
            animDelay=3,
            spd=0.5
        },
        blue={
            x=0,
            y=-8,
            strtFram=32,
            endFram=35,
            animDelay=3,
            spd=0.75
        },
    }
end

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

-- Factory functions for specific enemy types.

-- Spawn a green enemy at a specific x coordinate.
-- @param x: The x coordinate to spawn the enemy at.
function newGreenEnemy(x)
    return newEnemy(x, enemyType.green.y, enemyType.green.spd,
        enemyType.green.strtFram, enemyType.green.endFram,
        enemyType.green.animDelay)
end

-- Spawn a blue enemy at a specific x coordinate.
-- @param x: The x coordinate to spawn the enemy at.
function newBlueEnemy(x)
    return newEnemy(x, enemyType.blue.y, enemyType.blue.spd,
        enemyType.blue.strtFram, enemyType.blue.endFram,
        enemyType.blue.animDelay)
end

-- Spawns one enemy using shared enemy config.
-- @param x: X position.
function spawnEnemy(enemyType,x)
    if enemyType == enemyType.green then
        add(enemies, newGreenEnemy(x))
    elseif enemyType == enemyType.blue then
        add(enemies, newBlueEnemy(x))
    end
end