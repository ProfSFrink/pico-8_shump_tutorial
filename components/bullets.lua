-- Shared factory function for creating projectiles
-- @param x: The x position.
-- @param y: The y position.
-- @param strtFram: Starting frame.
-- @param endFram: Ending frame.
-- @param spd: Speed.
-- @param animDelay: Frames before animation advances.
-- @param animFunc: Custom animation function(self).
-- @return: A new projectile object.
function newProjectile(x, y, strtFram, endFram, spd, animDelay, animFunc)
    return {
        x=x,
        y=y,
        spd=spd,
        curFram=strtFram,
        strtFram=strtFram,
        endFram=endFram,
        framDelay=0,
        animDelay=animDelay,
        animFunc=animFunc,

        update=function(self)
            self.y=self.y-self.spd

            -- Animate the projectile.
            self.framDelay+=1
            if self.framDelay >= self.animDelay then
                self.framDelay=0
                self.animFunc(self)
            end

            -- Remove if off-screen.
            if self.y < uiHeight-bullHeight then
                del(projectiles, self)
            end
        end,

        draw=function(self)
            spr(self.curFram, self.x, self.y)
        end
    }
end

-- Creates a new bullet object.
function newBullet(x, y, strtFram, endFram, spd)
    local pulseFn = function(self)
        if self.curFram == self.strtFram then
            self.curFram = self.endFram
        else
            self.curFram = self.strtFram
        end
    end
    return newProjectile(x, y, strtFram, endFram, spd, 5, pulseFn)
end

-- Creates a new laser object.
function newLaser(x, y, strtFram, endFram, spd)
    local incrementFn = function(self)
        if self.curFram < self.endFram then
            self.curFram += 1
        end
    end
    return newProjectile(x, y, strtFram, endFram, spd, 6, incrementFn)
end