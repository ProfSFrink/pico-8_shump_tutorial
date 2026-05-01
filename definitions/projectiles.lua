-- Projectile component data.

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
        upFunc = function(_ENV)
            if curFram == strtFram then
                curFram = endFram
            else
                curFram = strtFram
            end
        end
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
        upFunc = function(_ENV)
            if curFram < endFram then
                curFram += 1
            else
                curFram = strtFram
            end
        end
    }
}