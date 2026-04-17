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

	--ship bullet offset
	shipBullOffset=2

	--setup for bullets
	bullets = {}

	bulletSprite=3
	bulletSpeed=3
	bulletSfx=0

	laserSprite=4
	laser_speed=4
	laserSfx=1
end

--factory function for creating bullets
function new_bullet(x, y, sprite, speed)
	return {
		x=x,
		y=y,
		speed=speed,

		-- update the bullet's position
		update=function(self)
			self.x=self.x
			self.y=self.y-self.speed
		end,

		-- draw the bullet to the screen
		draw = function(self)
			spr(sprite, self.x, self.y)
		end
	}
end

--update is for gameplay
--hard 30fps
function _update()
--controls
	shipSpdX=0
	shipSpdY=0

	--checking for input
	--Left ARROW
	if btn(0) then
		shipSpdX=-2
	end

	--Right ARROW
	if btn(1) then
		shipSpdX=2
	end

	--Up ARROW
	if btn(2) then
		shipSpdY=-2
	end

	--Down ARROW
	if btn(3) then
		shipSpdY=2
	end

	--FIRE bullet if x PRESSED
	if btnp(5) then
		add(bullets, new_bullet(shipX, shipY - shipBullOffset,
			bulletSprite, bulletSpeed))

		sfx(bulletSfx)
	end

	--FIRE laser if z PRESSED
	if btnp(4) then
		add(bullets, new_bullet(shipX, shipY - shipBullOffset,
			laserSprite, laser_speed))

		sfx(laserSfx)
	end

	--moving the ship
	shipX=shipX+shipSpdX
	shipY=shipY+shipSpdY

	--moving the bullet
	for b in all(bullets) do
		b:update()
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
	spr(1, shipX, shipY)
	for b in all(bullets) do
		b:draw()
	end
end
