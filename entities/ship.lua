-- Ship component logic.

-- TODO: Animate the flame when the ship is moving up and down.

-- Create a new ship with default properties.
-- @return: A new ship object.
function newShip()
    -- Local reference to global scope.
    local g = _ENV

    return {
		-- Starting position.
		x = g.shipStartX,
		y = g.shipStartY,

		-- Speed the ship is allowed to move on each axis.
		xMaxSpeed = 2,
		yMaxSpeed = 2,

        -- Ship's current speed on each axis.
        xSpeed = 0,
		ySpeed = 0,

        -- Hit box size, defaults to 8x8.

        hitBox = { w = 3, h = 2, offX = 2, offY = 4 },

        -- Starting ship sprite.
        startSprite = 3,
		-- Current ship sprite.
		sprite = 3,
		-- Ship flame start & end sprites.
		flameStartSprite = 7,
		flameEndSprite = 11,
        -- Current ship flame sprite.
		flameSprite = 7,

		-- Offset for bullets.
		bulletOffset = 3,
        -- Angle of fired-projectiles.
        ang = 0.5,
        -- Ship's current rate of fire.
        rof = 0,
		-- Size of muzzles flash.
		muzzle = 0,

        weaponOne = singleBullet,
        weaponTwo = nil,

		-- Invulnerability timer in frames.
		invul = 0,
		-- Delay between losing last life
        -- showing game over screen.
		deathTimer = 30,

        -- Move the ship in a direction based on input.
        -- @param button: The button index for the direction to move.
        move = function(_ENV, button)
            if button == "left" then
                sprite = 1
                xSpeed = -xMaxSpeed
            elseif button == "right" then
                sprite = 5
                xSpeed = xMaxSpeed
            elseif button == "up" then
                sprite = startSprite
                ySpeed = -yMaxSpeed
            elseif button == "down" then
                sprite = startSprite
                ySpeed = yMaxSpeed
            end
        end,

        -- Handles ship being hit by an entity.
        hit = function(_ENV)
            g.sfx(1)
            if g.player.lives <= 0 then
                invul = 30
                g.spawnExp(x, y, 0, g.shipCols)
                g.spawnShockWave(x, y, g.lgSwCfg)
            else
                invul = 60 -- 2 secs of invulnerability.
            end
        end,

        -- Reset ship properties to default.
        reset = function(_ENV)
            sprite = startSprite
            xSpeed = 0
            ySpeed = 0
        end,

        -- Checks if death animation is complete.
        -- @returns true if death animation is complete.
        isDead = function(_ENV)
            deathTimer -= 1

            if deathTimer <= 0 then
                return true
            else
                return false
            end
        end,

        -- Check if collision with ship are allowed
        -- @returns true if allowed.
        canCollide = function(_ENV)
            return g.state != g.stateNames.newWave
               and g.inBounds(_ENV)
        end,

        -- Update ship position and animation.
        update = function(_ENV)
            x += xSpeed
            y += ySpeed

            -- Check if we hit the
            -- bounds of the screen.
            x = mid(0, x, 120)
            y = mid(0 + g.uiHeight, y, 120)

            if invul > 0 then
                invul -= 1
            end

            -- Animate ship flame.
            flameSprite += 1
            if flameSprite > flameEndSprite then
                flameSprite = flameStartSprite
            end

            -- Animate the muzzle flash.
            if muzzle >= 0 then
                muzzle -= 1
            end
        end,

        -- Draw the ship and its flame.
        draw = function(_ENV, gameT)
            if invul <= 0 then
                spr(sprite, x, y)
                spr(flameSprite, x, y + 8)
            else
                if sin(gameT / 5) < 0.1 then
                    pal(2,6)
                    spr(sprite, x, y)
                    spr(flameSprite, x, y + 8)
                    pal()
                end
            end

            -- Muzzle flash.
            circfill(x + 3, y - 2, muzzle, 7)
            circfill(x + 4, y - 2, muzzle, 7)

            if g.debugMode then
                g.showHitBox(_ENV)
            end
        end,
    }
end