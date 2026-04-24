 -- Projectile component data & logic.

 function initProjectiles()
  	-- Setup for bullets & lasers.
	-- strtFram: Starting frame of the bullet's animation.
	-- endFram: Ending frame of the bullet's animation.
	-- animDelay: Frames before the bullet's animation advances.
	-- spd: Speed of the bullet.
	-- sfx: Sound effect to play when firing the bullet.
	-- btn: Button to fire the bullet.
	projectileTypes={
		bullet={
			strtFram=16,
			endFram=17,
			animDelay=5,
			spd=3,
			sfx=0,
			btn=5,
			factory=newBullet
		},
		laser={
			strtFram=18,
			endFram=21,
			animDelay=6,
			spd=4,
			sfx=1,
			btn=4,
			factory=newLaser
		}
	}
 end

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
-- param x: The x position.
-- param y: The y position.
-- param strtFram: Starting frame.
-- param endFram: Ending frame.
-- param spd: Speed.
-- param animDelay: Frames before animation advances.
-- return: A new bullet object.
function newBullet(x, y, strtFram, endFram, spd, animDelay)
    local pulseFn = function(self)
        if self.curFram == self.strtFram then
            self.curFram = self.endFram
        else
            self.curFram = self.strtFram
        end
    end
    return newProjectile(x, y, strtFram, endFram, spd, animDelay, pulseFn)
end

-- Creates a new laser object.
-- param x: The x position.
-- param y: The y position.
-- param strtFram: Starting frame.
-- param endFram: Ending frame.
-- param spd: Speed.
-- param animDelay: Frames before animation advances.
-- return: A new laser object.
function newLaser(x, y, strtFram, endFram, spd, animDelay)
    local incrementFn = function(self)
        if self.curFram < self.endFram then
            self.curFram += 1
        end
    end
    return newProjectile(x, y, strtFram, endFram, spd, animDelay, incrementFn)
end