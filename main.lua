-- runs once on startup
function _init()
	cls()

	--ship's horizontal position
	shipX=64

	--ship's vertical position
	shipY=64

	--ships' horizontal speed
	SHIPSPDX=2

	--ships' vertical speed
	SHIPSPDY=2
end

-- update is for gameplay
-- hard 30fps
function _update()
--controls
	SHIPSPDX=0
	SHIPSPDY=0

	--checking for input
	--Left ARROW
	if btn(0) then
		SHIPSPDX=-2
	end

	--Right ARROW
	if btn(1) then
		SHIPSPDX=2
	end

	--Up ARROW
	if btn(2) then
		SHIPSPDY=-2
	end

	--Down ARROW
	if btn(3) then
		SHIPSPDY=2
	end

	--moving the ship
	shipX = shipX + SHIPSPDX
	shipY = shipY + SHIPSPDY

	--checking if we hit the
	--horizontal bounds of the screen
	if shipX > 120 then
		shipX = 0
	end

	if shipX < 0 then
		shipX = 120
	end

	if shipY > 120 then
		shipY = 0
	end

	if shipY < 0 then
		shipY = 120
	end
end

-- called when a new frame is
-- drawn to the screen (30fps).
function _draw()
	cls(0)
	spr(1, shipX, shipY)
end
