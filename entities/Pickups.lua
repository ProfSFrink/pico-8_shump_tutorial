-- Pickup component data.

-- String literals for pickup types.
redCherry = "redCherry"

-- Pickup definitions.
pickUpTypes = {
    redCherry = {
        wep = threeShotBullet,
        curSpr = 54,
    },
}

-- Factory functions for creating pickups.
-- @param pickUpCfg: The pickUpCfg: Pick-up config object.
-- @param pickUpX: The x position of the pick-up.
-- @param pickUpY: The y position of the pick-up.
-- @param pickUpSpawnT: The time in frames when the pick-up appears.
-- @return: A new pick-up object.
function newPickUp(pickUpCfg, pickUpX, pickUpY, pickUpSpawnT)
    local g = _g

    return {
        wep = pickUpCfg.wep,
        curSpr = pickUpCfg.curSpr,
        x = pickUpX,
        y = pickUpY,
        pickUpSpawnT = pickUpSpawnT or 0,
        pickUpActive = false,

        hitBox = {
            w = hitDefault,
            h = hitDefault,
            offX = 0,
            offY = 0,
        },

        activate = function(_ENV)
            pickUpActive = true
        end,

        update = function(_ENV)
            if pickUpActive then
                y += 0.5
            end
        end,

        draw = function(_ENV)
            if not pickUpActive then return end

            spr(curSpr, x, y)

            if g.debugMode then g.showHitBox(_ENV) end
        end,
    }
end

-- Util functions.

-- Get the configuration for a pick-up type.
-- @param pickUpType: The pick-up type.
-- @return: The pick-up configuration.
function getPickUpConfig(pickUpType)
    return pickUpTypes[pickUpType]
end

-- Adds pick-up to the game.
-- @param p: The name of the pickup to add.
function addPickUp(pickUp, pickUpX, pickUpY)
    local pickUpCfg = getPickUpConfig(pickUp)

    add(pickups, newPickUp(pickUpCfg, pickUpX, pickUpY))
end

-- Remove pick-up from the game.
-- @param p: The pick-up to remove.
function removePickUp(p)
    del(pickups, p)
end

-- Update all pick-ups.
function updatePickUps()
    for p in all(pickups) do
        p:update()
    end
end

-- Draw all pick-ups.
function drawPickUps()
    for p in all(pickups) do
        p:draw()
    end
end