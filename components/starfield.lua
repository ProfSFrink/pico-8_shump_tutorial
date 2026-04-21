--factory function for creating stars
function newStar(colour,speed)
	return {
		x=flr(rnd(118)+10),
		y=flr(rnd(118)+10),
		colour=colour,
		speed=speed,

        --update the star's position
		update=function(self)
			self.y=self.y+self.speed

			if self.y > 128 then
				self.y=starUiOffset
				self.x=flr(rnd(128))
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

        if colour == farStar.colour then
            speed=farStar.speed
        elseif colour == midStar.colour then
            speed=midStar.speed
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
        pset(s.x, s.y, s.colour)
    end
end