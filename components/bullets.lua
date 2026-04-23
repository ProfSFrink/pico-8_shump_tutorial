-- Factory function for creating bullets
	-- @param x: The x position of the bullet.
	-- @param y: The y position of the bullet.
	-- @param sprStart: The starting frame of the bullet's animation.
	-- @param sprEnd: The ending frame of the bullet's animation.
	-- @param speed: The speed of the bullet.
	-- @return: A new bullet object.
function newBullet(x, y, sprStart, sprEnd, speed)
	return {
		x=x,
		y=y,
		speed=speed,
		currentFrame=sprStart,
		spriteStart=sprStart,
		spriteEnd=sprEnd,

		-- Update the bullet's position.
		update=function(self)
            self.y=self.y-self.speed

			-- Animate the bullet.
            self.currentFrame=self.currentFrame+1
            if self.currentFrame >= self.spriteEnd then
                self.currentFrame=self.spriteStart
            end

			-- Remove the bullet if it
			-- disappears behind the UI.
			if self.y < uiHeight-bullHeight then
				del(bullets, self)
			end
		end,

		-- Draw the bullet to the screen.
		draw=function(self)
			spr(self.currentFrame, self.x, self.y)
		end
	}
end