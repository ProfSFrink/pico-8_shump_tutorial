--[[updates screen when
running in game mode]]--
function updateGame()
--controls
	shipSpdX=0
	shipSpdY=0
	shipSpr=3

	--checking for input
	--Left arrow
	if btn(0) then
		shipSpr=1
		shipSpdX=-spdX
	end

	--Right arrow
	if btn(1) then
		shipSpr=5
		shipSpdX=spdX
	end

	--Up arrow
	if btn(2) then
		shipSpr=2
		shipSpdY=-spdY
	end

	--Down arrow
	if btn(3) then
		shipSpr=2
		shipSpdY=spdY
	end

	--fire laser if z pressed
	if btnp(4) then
		--add(bullets, newBullet(shipX,
		--	shipY - shipBullOffset,
		--	laser.sprStart, laser.spriteEnd,
		--	laser.speed))

		sfx(laser.sfx)
		--muzzle=4
		mode=states.gameOver
	end

	--fire bullet if x pressed
	if btnp(5) then
		add(bullets, newBullet(shipX,
			shipY - shipBullOffset,
			bullet.sprStart, bullet.spriteEnd,
			bullet.speed))

		sfx(bullet.sfx)
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

--updates the title screen
function updateTitle()
	if btnp(4) or btnp(5) then
		showStart()
	end
end

--update the start screen
function updateStart()
	if btnp(4) or btnp(5) then
		startGame()
	end
end

--update the game over screen
function updateGameOver()
	if btnp(4) or btnp(5) then
		restartGame()
	end
end