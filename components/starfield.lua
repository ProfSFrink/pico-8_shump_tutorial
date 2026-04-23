--factory function for creating stars
function newStar(colour,speed,isStart)
	return {
		x=flr(rnd(118)+10),
		y=flr(rnd(118)+10),
		colour=colour,
		speed=speed,
		isAsteroid=false,

        --update the star's position
		update=function(self)
			self.y=self.y+self.speed

            --[[reset the star to the top of the screen
            if it goes off the bottom]]--
			if self.y > 128 then
                local uiOffset = isStart and 0 or uiHeight

				self.isAsteroid = self.colour == midStar.colour
                and rnd(1) < 0.01

				self.y = uiOffset
				self.x = flr(rnd(128))
			end

            --twinkle the star if it's a near star
            if self.colour == nearStar.colour then
                self.colour=nearStar.twinkleColour
            elseif self.colour == nearStar.twinkleColour then
                self.colour=nearStar.colour
            end
		end
	}
end

--creates starfield on game start
function createStarfield(isStart)
    for i=1,numOfStars do
        colour=flr(rnd(3))+5

        --set far stars
        if colour == farStar.colour then
            speed=farStar.speed
        --set mid stars
        elseif colour == midStar.colour then
            speed=midStar.speed
        --set near stars
        else
            speed=nearStar.speed
        end

        stars[i] = newStar(colour, speed, isStart)
    end
end

--update starfield and draw to screen
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

--fade out the starfield when the game is over

local starFadeMap = {[10]=7,[7]=6,[6]=5,[5]=0,[0]=0}
local starFadeTimer = 0
local starFadeSpeed = 13

function fadeOutStarfield()
    starFadeTimer += 1

    if starFadeTimer >= starFadeSpeed then
        starFadeTimer = 0

        for s in all(stars) do
            s.colour = starFadeMap[s.colour] or 0
        end
    end

    for s in all(stars) do
        pset(s.x, s.y, s.colour)
    end

end