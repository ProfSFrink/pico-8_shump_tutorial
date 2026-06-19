-- Game Scene - Shared gameplay simulation and rendering.

-- Updates gameplay simulation.
function updateGameScene()
	-- advance game timer.
	gameT += 1

	-- Decrease player projectile timer.
	player.shotDelay -= 1

	-- Reset ship sprite and speed.
	ship:reset()

	-- Controls.

	-- Checking for input.
	-- Left arrow.
	if btn(0) and canPlay then
		ship:move("left")
	end

	-- Right arrow.
	if btn(1) and canPlay then
		ship:move("right")
	end

	-- Up arrow.
	if btn(2) and canPlay then
		ship:move("up")
	end

	-- Down arrow.
	if btn(3) and canPlay then
		ship:move("down")
	end

	-- Fire bullet if X pressed.
	if btn(5) and canPlay then
		local proCfg = getConfig(yellowSingleBullet)

		if player.shotDelay <= 0 then
			spawnPlayerProjectile(proCfg, ship.x, ship.y - ship.bulletOffset)
			ship.muzzle = 4
			player.shotDelay = proCfg.rof
		end
	end

	-- Fire laser if Z pressed.
	if btn(4) and canPlay then
		local proCfg = getConfig(yellowSingleLaser)

		if player.shotDelay <= 0 then
			spawnPlayerProjectile(proCfg, ship.x, ship.y - ship.bulletOffset)
			ship.muzzle = 4
			player.shotDelay = proCfg.rof
		end
	end

    -- NOTE: This will only allows co-routines in the game scene,
    -- if we want to use them in other scenes we will need to move this somewhere more global.

    for r in all(routines) do
        if costatus(r) == "dead" then
            del(routines, r)
        else
            coresume(r)
        end
    end

	-- Update ship position.
	ship:update()

	-- Move the starfield.
	updateStarfield()

	-- Move the projectiles.
	updateProjectiles()

	-- Move any shockwaves.
	updateShockWaves()

	-- Move any sparks.
	updateSparks()

	-- Move the explosions.
	updateExplosions()

	-- Move the enemies and
	-- check for collisions.
	for e in all(enemies) do
		e:update()

		if e:canCollide() then
			-- Handle projectile collisions.
			for p in all(projectiles) do
				if hasCollided(e, p) then
					e:hit(p.dam)
					spawnShockWave(p.x, p.y, slSwCfg)
					spawnSparks(e.x, e.y, 7)
					removeProjectile(p)
				end
			end

			-- Handle collision with ship.
			if hasCollided(e, ship) and ship.invul <= 0 then
				player.lives -= 1
				e:hit()
				ship:hit()
			end
		end
	end

	-- Handle collisions between enemy
	-- projectiles and ship.
	for ep in all(enemyProjectiles) do
		if ship:canCollide() then
			if hasCollided(ep, ship) and ship.invul <= 0 then
				player.lives -= 1
				ship:hit()
				removeProjectile(ep)			
			end
		end
	end
end

-- Draws the game scene.
function drawGameScene()
	cls()
	drawStarfield()

	-- Debug info.
	if debugMode then
		showDebugUI()
	end

	-- Game screen.
	if player.lives > 0 then
		ship:draw(gameT)
	end

	-- Projectiles.
	drawProjectiles()

	-- Enemies.
	drawEnemies()

	-- Sparks.
	drawSparks()

	-- Shockwaves.
	drawShockWaves()

	-- Explosions.
	drawExplosions()

	-- UI.

	-- TODO: Abstract UI.

	rectfill(0, 0, 127, uiHeight, 1)

	local scoreStr = "SCORE: " .. player.score

	?scoreStr, calcCenX(#scoreStr), 2, 12

	local uiX = 0

	for i = 1, 4 do
		uiX = i * 9 - 8
		if player.lives >= i then
			spr(13, uiX, 1)
		else
			spr(14, uiX, 1)
		end
	end
end
