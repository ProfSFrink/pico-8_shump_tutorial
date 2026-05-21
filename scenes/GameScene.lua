-- Game Scene - Shared gameplay simulation and rendering.

-- Updates gameplay simulation.
function updateGameScene()
	-- advance game timer.
	gameT += 1

	-- Decrease projectile timer.
	proT -= 1

	-- Reset ship sprite and speed.
	ship:reset()

	local inGame = state == stateNames.game

	-- Controls.

	-- Checking for input.
	-- Left arrow.
	if btn(0) then
		ship:move("left")
	end

	-- Right arrow.
	if btn(1) then
		ship:move("right")
	end

	-- Up arrow.
	if btn(2) and inGame then
		ship:move("up")
	end

	-- Down arrow.
	if btn(3) then
		ship:move("down")
	end

	-- Fire bullet if X pressed.
	if btn(5) and inGame then
		local proCfg = getConfig(bullet)

		if proT <= 0 then
			spawnProjectile(proCfg, ship.x, ship.y - ship.bullOffset)
			ship.muzzle = 4
			proT = proCfg.rof
		end
	end

	-- Fire laser if Z pressed.
	if btn(4) and inGame then
		local proCfg = getConfig(laser)

		if proT <= 0 then
			spawnProjectile(proCfg, ship.x, ship.y - ship.bullOffset)
			ship.muzzle = 4
			proT = proCfg.rof
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
	for enemy in all(enemies) do
		enemy:update()

		if enemy:canCollide() then
			-- Handle projectile collisions.
			for projectile in all(projectiles) do
				if hasCollided(enemy, projectile) then
					enemy:hit(projectile.dam)
					spawnShockWave(projectile.x, projectile.y, slSwCfg)
					spawnSparks(enemy.x, enemy.y, 7)
					del(projectiles, projectile)
				end
			end

			-- Handle collision with ship.
			if hasCollided(enemy, ship) and ship.invul <= 0 then
				player.lives -= 1
				enemy:hit()
				if player.lives <= 0 then
					ship.invul = 30
					spawnExp(ship.x, ship.y, 0, shipCols)
					spawnShockWave(ship.x, ship.y, lgSwCfg)
				else
					ship.invul = 60 -- 2 secs of invulnerability.
				end
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

	print(scoreStr, calcCenX(#scoreStr), 2, 12)

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
