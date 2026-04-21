--factory function for creating stars
function newStar(colour,speed)
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
				self.isAsteroid = self.colour == midStar.colour
                and rnd(1) < 0.01

				self.y = starUiOffset
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
function createStarfield()
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

        stars[i] = newStar(colour, speed)
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