-- Projectile component data & logic.

function initProjectiles()
    -- Setup for bullets & lasers.
    -- strtFram: Starting frame.
    -- endFram: Ending frame.
    -- animDelay: Frames before animation advances.
    -- spd: Speed.
    -- sfx: Sound effect to play when firing.
    -- btn: Button to fire.
    -- animFunc: Custom animation function(self).
    projectileTypes={
        bullet={
            strtFram=16,
            endFram=17,
            animDelay=5,
            spd=3,
            sfx=0,
            btn=5,
            animFunc=function(self)
                if self.curFram == self.strtFram then
                    self.curFram=self.endFram
                else
                    self.curFram=self.strtFram
                end
            end,
            factory=newBullet
        },
        laser={
            strtFram=18,
            endFram=21,
            animDelay=6,
            spd=4,
            sfx=1,
            btn=4,
            animFunc=function(self)
                if self.curFram < self.endFram then
                    self.curFram+=1
                end
            end,
            factory=newLaser
        }
    }
end

-- Shared factory function for creating projectiles.
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
        animFunc=animFunc or function() end,

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

-- Compatibility wrapper for bullet projectile creation.
function newBullet(x, y, strtFram, endFram, spd, animDelay)
    local def=projectileTypes.bullet
    return newProjectile(
        x, y, strtFram, endFram, spd, animDelay, def.animFunc
    )
end

-- Compatibility wrapper for laser projectile creation.
function newLaser(x, y, strtFram, endFram, spd, animDelay)
    local def=projectileTypes.laser
    return newProjectile(
        x, y, strtFram, endFram, spd, animDelay, def.animFunc
    )
end