	-- Starfield component data.
	stars = {}

	numOfStars = 80

	farStar = { col = 5, spd = 0.25 }

	midStar = { col = 6, spd = 0.75, isAsteroid = false }

	nearStar = { col = 7, twinkleCol = 10, spd = 2 }

-- Starfield component logic.

-- Factory function for creating stars.
-- @param col: The colour of the star.
-- @param spd: How fast the star moves.
-- @param isStart: If true, the star is
-- for the title/start screen, otherwise
-- it's for the game/game over screen.
-- @return: A new star object.
function newStar(sCol, sSpd, isStart)
    -- References to global scope.
    local g = _g

    local uiOffset = isStart and 0 or uiHeight

    return {
        x = flr(rnd(118) + 10),
        y = flr(rnd(118) + 10),
        col = sCol,
        spd = sSpd,

        -- Update the star's position.
        update = function(_ENV)
            y += spd

            --[[reset the star to the top of the screen
            if it goes off the bottom.]]
            if y > 128 then
                y = uiOffset
                x = g.flr(g.rnd(128))
            end

            -- Twinkle the star if it's a near star.
            if col == g.nearStar.col then
                col = g.nearStar.twinkleCol
            elseif col == g.nearStar.twinkleCol then
                col = g.nearStar.col
            end
        end
    }
end

-- Creates starfield background.
-- @param isStart: whether this is
-- for the title / start screen (true)
-- or the in-game / game over screen (false).
function createStarfield(isStart)
    for i = 1, numOfStars do
        local col = flr(rnd(3)) + 5
        local spd

        -- Set far stars.
        if col == farStar.col then
            spd = farStar.spd
            -- Set mid stars.
        elseif col == midStar.col then
            spd = midStar.spd
            -- Set near stars.
        else
            spd = nearStar.spd
        end

        stars[i] = newStar(col, spd, isStart)
    end
end

-- Update star positions.
function updateStarfield()
    for s in all(stars) do
        s:update()
    end
end

-- Draw stars to the screen.
function drawStarfield()
    for s in all(stars) do
        pset(s.x, s.y, s.col)
    end
end

-- Fade map for fading out stars on game over.
local starFadeMap = { [10] = 7, [7] = 6, [6] = 5, [5] = 0, [0] = 0 }
-- Timer for fading out stars.
local fadeTimer = 0
-- Fade speed in frames for fading out stars.
local fadeSpeed = 13

-- Fade out the starfield when the game is over.
function fadeOutStarfield()
    fadeTimer += 1

    if fadeTimer >= fadeSpeed then
        fadeTimer = 0

        for s in all(stars) do
            s.col = starFadeMap[s.col] or 0
        end
    end

    for s in all(stars) do
        pset(s.x, s.y, s.col)
    end
end