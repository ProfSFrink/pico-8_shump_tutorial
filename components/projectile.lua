-- Projectile component data & logic.

function initProjectiles()
    -- Setup for bullets & lasers.
    -- strtFram: Starting frame.
    -- endFram: Ending frame.
    -- animDelay: Frames before animation advances.
    -- spd: Speed.
    -- rof: Rate of fire in frames.
    -- sfx: Sound effect to play when firing.
    -- btn: Button to fire.
    -- upFunc: Custom update function.
    pTypes = {
        bullet = {
            type = "bullet",
            strtFram = 16,
            endFram = 17,
            animDelay = 5,
            spd = 3,
            rof = 4,
            dam = 1,
            sfx = 0,
            btn = 5,
            upFunc = function(self)
                if self.curFram == self.strtFram then
                    self.curFram = self.endFram
                else
                    self.curFram = self.strtFram
                end
            end,
            factory = newBullet
        },
        laser = {
            type = "laser",
            strtFram = 18,
            endFram = 21,
            animDelay = 6,
            spd = 4,
            rof = 8,
            dam = 2,
            sfx = 1,
            btn = 4,
            upFunc = function(self)
                if self.curFram < self.endFram then
                    self.curFram += 1
                end
            end,
            factory = newLaser
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
-- @param upFunc: Custom animation function(self).
-- @return: A new projectile object.
function newProjectile(type, x, y, strtFram, endFram, spd, dam, animDelay, upFunc)
    return {
        type = type,
        x = x,
        y = y,
        spd = spd,
        dam = dam,

        -- Current sprite being animated.
        curFram = strtFram,
        strtFram = strtFram,
        endFram = endFram,
        animTimer = 0,

        -- Frames before animation advances.
        animDelay = animDelay,

        upFunc = upFunc,

        -- Update the projectile.
        update = function(self)
            self.y = self.y - self.spd

            self.animTimer += 1
            if self.animTimer >= self.animDelay then
                self.animTimer = 0
                self.upFunc(self)
            end

            -- Remove if off-screen.
            if self.y < uiHeight - bullHeight then
                del(projectiles, self)
            end
        end,

        -- Draw the projectile.
        draw = function(self)
            spr(self.curFram, self.x, self.y)
        end
    }
end

-- Compatibility wrapper for bullet projectile creation.
function newBullet(x, y, strtFram, endFram, spd, dam, animDelay)
    local def = pTypes.bullet

    return newProjectile(
        def.type, x, y, strtFram, endFram, spd, dam, animDelay, def.upFunc
    )
end

-- Compatibility wrapper for laser projectile creation.
function newLaser(x, y, strtFram, endFram, spd, dam, animDelay)
    local def = pTypes.laser

    return newProjectile(
        def.type, x, y, strtFram, endFram, spd, dam, animDelay, def.upFunc
    )
end