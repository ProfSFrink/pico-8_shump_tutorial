-- runs once on startup
function _init()
	cls()

	--ship's x and y coordinates
	shipX = 64
	shipY = 64

	--ships' speed in x and y direction
	SHIPSPDX = 2
	SHIPSPDY = 2

	--bullet's x and y coordinates
	bullX = 64
	bullY = 40
end

-- update is for gameplay
-- hard 30fps
function _update60()
--controls
	SHIPSPDX = 0
	SHIPSPDY = 0

	--checking for input
	--Left ARROW
	if btn(0) then
		SHIPSPDX = -2
	end

	--Right ARROW
	if btn(1) then
		SHIPSPDX = 2
	end

	--Up ARROW
	if btn(2) then
		SHIPSPDY = -2
	end

	--Down ARROW
	if btn(3) then
		SHIPSPDY = 2
	end

	--FIRE button if z PRESSED
	if btnp(5) then
		bullX = shipX
		bullY = shipY - 3
		sfx(0)
	end

	--moving the ship
	shipX = shipX + SHIPSPDX
	shipY = shipY + SHIPSPDY

	--moving the bullet
	bullY = bullY - 2

	--checking if we hit the
	--horizontal bounds of the screen
	if shipX > 120 then
		shipX = 120
	end

	if shipX < 0 then
		shipX = 0
	end

	if shipY > 120 then
		shipY = 120
	end

	if shipY < 0 then
		shipY = 0
	end
end

--called when a new frame is
--drawn to the screen (30fps).
function _draw()
	cls(0)
	spr(1, shipX, shipY)
	spr(6, bullX, bullY)
end
