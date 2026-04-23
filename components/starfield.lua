-- Factory function for creating stars.
-- @param colour: The colour of the star.
-- @param speed: How fast the star moves.
-- @param isStart: If true, the star is
-- for the title/start screen, otherwise
-- it's for the game/game over screen.
-- @return: A new star object.
function createStar(colour,speed,isStart)
	return {
		x=flr(rnd(118)+10),
		y=flr(rnd(118)+10),
		colour=colour,
		speed=speed,
		isAsteroid=false,

        -- Update the star's position.
		update=function(self)
			self.y=self.y+self.speed

            --[[reset the star to the top of the screen
            if it goes off the bottom.]]--
			if self.y > 128 then
                local uiOffset = isStart and 0 or uiHeight

				self.isAsteroid = self.colour == midStar.colour
                and rnd(1) < 0.01

				self.y = uiOffset
				self.x = flr(rnd(128))
			end

            -- Twinkle the star if it's a near star.
            if self.colour == nearStar.colour then
                self.colour=nearStar.twinkleColour
            elseif self.colour == nearStar.twinkleColour then
                self.colour=nearStar.colour
            end
		end
	}
end

-- Creates starfield background.
-- @param isStart: whether this is
-- for the title/start screen (true)
-- or the game/game over screen (false).
function createStarfield(isStart)
    for i=1,numOfStars do
        colour=flr(rnd(3))+5

        -- Set far stars.
        if colour == farStar.colour then
            speed=farStar.speed
        -- Set mid stars.
        elseif colour == midStar.colour then
            speed=midStar.speed
        -- Set near stars.
        else
            speed=nearStar.speed
        end

        stars[i] = createStar(colour, speed, isStart)
    end
end

-- Update stars and draw them to the screen.
function updateStarfield()
    for s in all(stars) do
        s:update()
        if s.isAsteroid then
            spr(23, s.x, s.y)
        else
            pset(s.x, s.y, s.colour)
        end
    end
end


-- Fade map for fading out stars on game over.
local starFadeMap = {[10]=7,[7]=6,[6]=5,[5]=0,[0]=0}
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
            s.colour = starFadeMap[s.colour] or 0
        end
    end

    for s in all(stars) do
        pset(s.x, s.y, s.colour)
    end

end