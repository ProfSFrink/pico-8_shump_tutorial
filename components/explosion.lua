-- Explosion Factory data & logic.

-- NOTE: Explosions currently only work with 8x8 sprites. Adjustments would be needed to support larger sprites.

--todo: add flash effect to appear at centre of explosions.

-- Initial explosion definitions.

-- No of particles used for creating
-- an explosion when enemy / ship is destroyed.
numOfParts = 25

-- Factory function for creating enemy and
-- ship explosions.
-- @param x: The x pos of the explosion.
-- @param y: The y pos of the explosion.
-- @param objSpdY: The speed of the exploding object.
-- @return: A new explosion object.
function newExpObj(expX, expY, objSpdY)
     -- Local references to global scope.
     local exps = exps

     --
    -- Colours for explosions.
    local cols = { 5, 9, 10, 7 }
    return {
        x = expX + 4,
        y = expY + 4,
        spdX = (rnd() - 0.5) * 5,
        spdY = objSpdY + (rnd() - 0.5) * 5,
        scale = (rnd(4)) + 1,
        life = (rnd(4)) + 1,
        maxLife = (rnd(4)) + 1,

        update = function(_ENV)
            x += spdX
            y += spdY

            spdX *= .85
            spdY *= .85

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
            circfill(x, y, scale, col)
        end
    }
end

-- Factory function creating particle flashes.
function newFlash()
end

-- Create Explosion for an exploding object.
-- @param x: The x position of the explosion.
-- @param y: The y position of the explosion.
-- @param objSpdY: The speed of the exploding object.
function spawnExp(expX, expY, objSpdY)
    for i = 1, numOfParts do
        add(exps, newExpObj(expX, expY, objSpdY))
    end
    sfx(rnd(2) + 2)
end