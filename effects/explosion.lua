-- Explosion Factory data & logic.

-- NOTE: Explosions currently only work with 8x8 sprites. Adjustments would be needed to support larger sprites.

-- Initial explosion definitions.

-- No of particles used for creating
-- an explosion when enemy / ship is destroyed.
numOfParts = 50

-- Colours for enemy explosions.
eneCols = { 5, 9, 10, 7 }

-- Colours for ship explosions.
shipCols = { 1, 1, 12, 7 }

-- Factory function for creating enemy and
-- ship explosions.
-- @param x: The x pos of the explosion.
-- @param y: The y pos of the explosion.
-- @param objSpdY: The speed of the exploding object.
-- @param expCols: The colour palette for the explosion.
-- @return: A new explosion object.
function newExpObj(expX, expY, objSpdY, expCols)
     -- Local references to global scope.
     local exps = exps

    -- Colours for explosions.
    local cols = expCols
    return {
        x = expX + 4,
        y = expY + 4,
        spdX = (rnd() - 0.5) * 5,
        spdY = objSpdY + (rnd() - 0.5) * 5,
        scale = ranFloat(1, 4),
        life = ranFloat(1, 4),
        maxLife = ranFloat(1, 4),
        small = ranFloat(1,2) <= 1.2,

        update = function(_ENV)
            x += spdX
            y += spdY

            if small then
                spdX *= 1
                spdY *= 1
            else
                spdX *= .85
                spdY *= .85
            end

            scale -= .1
            life -= .1

            -- Change colour as explosion expires.
            if life / maxLife < .25 then
                col = cols[1]
            elseif life / maxLife < .5 then
                col = cols[2]
            elseif life / maxLife < .75 then
                col = cols[3]
            else
                col = cols[4]
            end

            if life <= 0 then
                del(exps, _ENV)
            end
        end,

        draw = function(_ENV)
            if small then
                pset(x, y, 7)
            else
                circfill(x, y, scale, col)
            end
        end
    }
end

-- Creates a one shot flash effect.
-- @param expX: The x pos of the flash.
-- @param expY: The y pos of the flash.
-- @param expScale: The initial scale of the flash.
-- @param expLife: The life of the flash.
-- @param expCol: The colour of the flash.
function newFlash(expX, expY, expScale, expLife, expCol)
     -- Local references to global scope.
     local exps = exps

     return {
        x = expX + 4,
        y = expY + 4,
        scale = expScale,
        life = expLife,
        col = expCol,

        update = function(_ENV)
            life -= .5
            scale -= .5

            if life <= 0 then
                del(exps, _ENV)
            end
        end,

        draw = function(_ENV)
            circfill(x, y, scale, col)
        end
    }
end

-- Create Explosion for an exploding object.
-- @param x: The x position of the explosion.
-- @param y: The y position of the explosion.
-- @param objSpdY: The speed of the exploding object.
-- @param expCols: The colour palette for the explosion.
function spawnExp(expX, expY, objSpdY, expCols)
    for i = 1, numOfParts do
        add(exps, newExpObj(expX, expY, objSpdY, expCols))
    end

    add(exps, newFlash(expX, expY, 8, 4, 7))

    sfx(1)
end

-- Update all explosions.
function updateExplosions()
    for x in all(exps) do
        x:update()
    end
end

-- Draw all explosions.
function drawExplosions()
    for x in all(exps) do
        x:draw()
    end
end