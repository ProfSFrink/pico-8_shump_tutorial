-- Enemies definitions.

    -- Setup for an enemy.
    -- name: Enemy name.
    -- cols: table of color pairs for the enemy, first is
    --       entry matches sprite colours.
    -- strtFram: Starting sprite of the enemy's animation.
    -- endFram: Ending sprite of the enemy's animation.
    -- flFram: Flash sprite when hit or dead.
    -- animDelay: Delay between animation frames.
    -- spd: Enemy speed.
    -- hp: Enemy health points.
    -- points: Enemy score value.
    -- upFunc: Custom update function.
eTypes = {
    alien = {
        name = "alien",
        cols = {
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 10, c2 = 9 }, -- Orange.
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 6, c2 = 13 } -- Grey.
        },
        strtFram = 48,
        endFram = 51,
        flFram = 52,
        animDelay = 3,
        spd = 0.5,
        hp = 3,
        points = 100,
        upFunc = function(_ENV)
            x = x + cos(y / 16) * 0.5
        end
    },
    ufo = {
        name = "ufo",
        cols = {
            { c1 = 12, c2 = 1 }, -- Blue.
            { c1 = 9, c2 = 4 }, -- Brown.
            { c1 = 11, c2 = 3 }, -- Green.
            { c1 = 8, c2 = 2 }, -- Red.
            { c1 = 14, c2 = 2 } -- Pink.
        },
        strtFram = 32,
        endFram = 35,
        flFram = 36,
        animDelay = 3,
        spd = 0.75,
        hp = 5,
        points = 150,
        upFunc = function(_ENV)
            x = x + cos(y / 16) * 0.75
        end
    }
}