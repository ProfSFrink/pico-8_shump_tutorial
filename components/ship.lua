-- Ship component logic.

-- TODO: Animate the flame when the ship is moving up and down.

-- Create a new ship with default properties.
-- @return: A new ship object.
function newShip()
    -- Local reference to global scope.
    local g = _g

    return {
		-- Starting position.
		x = 64,
		y = 108,
		-- Speed the ship can move on each axis.
		spdX = 2,
		spdY = 2,
        -- Ships current speed on each axis.
        currSpdX = 0,
		currSpdY = 0,
        -- Starting ship sprite.
        strtSpr = 3,
		-- Current ship sprite.
		currSpr = 3,
		-- Ship flame start & end sprites.
		flStrtSpr = 7,
		flEndSpr = 11,
        -- Current ship flame sprite.
		flCurrSpr = 7,
		-- Offset for bullets.
		bullOffset = 3,
		-- Size of muzzles flash.
		muzzle = 0,
		-- Invulnerability timer in frames.
		invul = 0,
		-- Death timer in frames.
		dTimer = 0,

        -- Update ship position and animation.
        update = function(_ENV)
            x += currSpdX
            y += currSpdY

            -- Check if we hit the
            -- bounds of the screen.
            x = mid(0, x, 120)
            y = mid(0 + g.uiHeight, y, 120)

            if invul > 0 then
                invul -= 1
            end

            -- Animate ship flame.
            flCurrSpr += 1
            if flCurrSpr > flEndSpr then
                flCurrSpr = flStrtSpr
            end

            -- Animate the muzzle flash.
            if muzzle >= 0 then
                muzzle -= 1
            end
        end,

        -- Draw the ship and its flame.
        draw = function(_ENV, gameT)
            if invul <= 0 then
                spr(currSpr, x, y)
                spr(flCurrSpr, x, y + 8)
            else
                if sin(gameT / 5) < 0.1 then
                    pal(2,6)
                    spr(currSpr, x, y)
                    spr(flCurrSpr, x, y + 8)
                    pal()
                end
            end

            -- Muzzle flash.
            circfill(x + 3, y - 2, muzzle, 7)
            circfill(x + 4, y - 2, muzzle, 7)
        end,

        -- Move the ship in a direction based on input.
        -- @param button: The button index for the direction to move.
        move = function(_ENV, button)
            if button == "left" then
                currSpr = 1
                currSpdX = -spdX
            elseif button == "right" then
                currSpr = 5
                currSpdX = spdX
            elseif button == "up" then
                currSpr = strtSpr
                currSpdY = -spdY
            elseif button == "down" then
                currSpr = strtSpr
                currSpdY = spdY
            end
        end,

        -- Reset ship properties to default.
        reset = function(_ENV)
            currSpr = strtSpr
            currSpdX = 0
            currSpdY = 0
        end,

        -- Trigger death state.
        dead = function(_ENV)
            dTimer -= 1

            if dTimer <= 0 then
                return true
            else
                return false
            end
        end
    }
end