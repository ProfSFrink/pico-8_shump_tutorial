--factory function for creating bullets
function newBullet(x, y, sprStart, sprEnd, speed)
	return {
		x=x,
		y=y,
		speed=speed,
		--current frame of the bullet's animation
		currentFrame=sprStart,
		--starting and ending frames of the bullet's animation
		spriteStart=sprStart,
		spriteEnd=sprEnd,

		--update the bullet's position
		update=function(self)
            self.y=self.y-self.speed

			--animate the bullet
            self.currentFrame=self.currentFrame+1
            if self.currentFrame >= self.spriteEnd then
                self.currentFrame=self.spriteStart
            end
		end,

		--draw the bullet to the screen
		draw=function(self)
			spr(self.currentFrame, self.x, self.y)
		end
	}
end