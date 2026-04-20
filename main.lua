--runs once on startup
function _init()
	cls()

	--set up the ship

	--ship's x and y coordinates
	shipX=64
	shipY=64

	--ships' speed in x and y direction
	shipSpdX=2
	shipSpdY=2

	--sHip sprite
	shipSpr=3

	--ship flame sprite
	flameSpr=7

	--ship bullet offset
	shipBullOffset=3

	--setup for bullets
	bullets = {}

	bullSprStart=16
	bullSprEnd=17
	bulletSpeed=3
	bulletSfx=0

	laserSprStart=18
	laserSprEnd=21
	laserSpeed=4
	laserSfx=1

	muzzle=0

	--setup score
	score=10000

	lives=3
end

--factory function for creating bullets
function new_bullet(x, y, sprStart, sprEnd, speed)
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

--update is for gameplay
--hard 30fps
function _update()
--controls
	shipSpdX=0
	shipSpdY=0
	shipSpr=3

	--checking for input
	--Left arrow
	if btn(0) then
		shipSpr=1
		shipSpdX=-2
	end

	--Right arrow
	if btn(1) then
		shipSpr=5
		shipSpdX=2
	end

	--Up arrow
	if btn(2) then
		shipSpr=2
		shipSpdY=-2
	end

	--Down arrow
	if btn(3) then
		shipSpr=2
		shipSpdY=2
	end

	--fire laser if z pressed
	if btnp(4) then
		add(bullets, new_bullet(shipX, shipY - shipBullOffset,
			laserSprStart, laserSprEnd, laserSpeed))

		sfx(laserSfx)
		muzzle=4
	end

	--fire bullet if x pressed
	if btnp(5) then
		add(bullets, new_bullet(shipX, shipY - shipBullOffset,
			bullSprStart, bullSprEnd, bulletSpeed))

		sfx(bulletSfx)
		muzzle=4
	end


	--moving the ship
	shipX=shipX+shipSpdX
	shipY=shipY+shipSpdY

	--moving the bullet
	for b in all(bullets) do
		b:update()
	end

	--animate ship flame
	flameSpr=flameSpr+1

	--loop the flame animation
	if flameSpr > 11 then
		flameSpr=7
	end

	--animate the muzzle flash
	if muzzle >= 0 then
		muzzle=muzzle-1
	end

	--checking if we hit the
	--Horizontal bounds of the screen
	if shipX > 120 then
		shipX=120
	end

	if shipX < 0 then
		shipX=0
	end

	if shipY > 120 then
		shipY=120
	end

	if shipY < 0 then
		shipY=0
	end
end

--called when a new frame is
--drawn to the screen (30fps).
function _draw()
	cls(0)

	spr(shipSpr,shipX,shipY)
	spr(flameSpr,shipX,shipY+8)

	for b in all(bullets) do
		b:draw()
	end

	circfill(shipX+3,shipY-2,muzzle,7)
	circfill(shipX+4,shipY-2,muzzle,7)

	?"SCORE: "..score,40,1,12

	for i=1,4 do
		if lives >= i then
			spr(13,i*9-8,1)
		else
			spr(14,i*9-8,1)
		end
	end

end
