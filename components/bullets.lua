-- Factory function for creating bullets
	-- @param x: The x position of the bullet.
	-- @param y: The y position of the bullet.
	-- @param strtFram: The starting frame of the bullet's animation.
	-- @param endFram: The ending frame of the bullet's animation.
	-- @param spd: The speed of the bullet.
	-- @return: A new bullet object.
function newBullet(x, y, strtFram, endFram, spd)
	return {
		x=x,
		y=y,
		spd=spd,
		curFram=strtFram,
		strtFram=strtFram,
		endFram=endFram,
		framDelay=0,

		-- Update the bullet's position.
		update=function(self)
            self.y=self.y-self.spd

			-- Animate the bullet.
            self.framDelay+=1
            if self.framDelay>=5 then
				self.framDelay=0
                self.curFram+=1

                if self.curFram == self.endFram then
                    self.curFram=self.endFram
				else
					self.curFram=self.strtFram
				end
            end

			-- Remove the bullet if it
			-- disappears behind the UI.
			if self.y < uiHeight-bullHeight then
				del(bullets, self)
			end
		end,

		-- Draw the bullet to the screen.
		draw=function(self)
			spr(self.curFram, self.x, self.y)
		end
	}
end

-- Factory function for creating lasers
	-- @param x: The x position of the laser.
	-- @param y: The y position of the laser.
	-- @param strtFram: The starting frame of the laser's animation.
	-- @param endFram: The ending frame of the laser's animation.
	-- @param spd: The speed of the laser.
	-- @return: A new laser object.
function newLaser(x, y, strtFram, endFram, spd)
	return {
		x=x,
		y=y,
		spd=spd,
		curFram=strtFram,
		strtFram=strtFram,
		endFram=endFram,
		framDelay=0,

		-- Update the laser's position.
		update=function(self)
            self.y=self.y-self.spd

			-- Animate the laser.
            self.framDelay+=1
            if self.framDelay>=6 then
				self.framDelay=0
                self.curFram+=1

                if self.curFram == self.endFram then
                    self.curFram=self.endFram
				end
            end

			-- Remove the laser if it
			-- disappears behind the UI.
			if self.y < uiHeight-bullHeight then
				del(bullets, self)
			end
		end,

		-- Draw the laser to the screen.
		draw=function(self)
			spr(self.curFram, self.x, self.y)
		end
	}
end