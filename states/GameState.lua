-- Game state logic.

spawnEvents = {
	{ '1',
		'-8,14,alien,alien,gap,alien,alien,alien,gap,alien,alien',
		'136,34,alien,alien,gap,alien,alien,alien,gap,alien,alien',
		'64,-12,alien,alien,gap,gap,gap,gap,alien,alien'
	},
	{ '2',
		'-8,-24,ufo,ufo,ufo,ufo,ufo,',
		'136,34,ufo,gap,gap,gap,ufo,',
		'64,-12,ufo,ufo,ufo,ufo,ufo,'
	},
	{ '3',
		'-8,-24,fighter,gap,gap,flame,flame,gap,gap,fighter',
		'136,34,fighter,gap,gap,flame,flame,gap,gap,fighter',
	},
	{ '4',
		'-8,-24,redeye,redeye,redeye',
		'136,34,redeye,gap,redeye',
		'64,-12,redeye,redeye,redeye'
	},
	{
		'5',
		'-8,-24,eyeball,eyeball,eyeball',
		'136,34,eyeball,eyeball,eyeball',
		'64,-12,eyeball,eyeball,eyeball'
	},
	{ '6',
		'60,-12,boss'
	}
}

-- Sets up the game.
function setupGame()
	-- Setup game & Projectile timers (frames).
	gameT = 0
	proT = 0

	spawnDur = 40
	attackDur = 40

	-- Setup player ship.
	ship = newShip()

	-- Setup player.
	player = {
		score = 0,
		lives = 2,
		bombs = 2
	}

	-- Setup for projectiles.
	projectiles = {}

	-- Tracks frames between shots.
	proT = 0

	-- Reset enemies table.
	enemies = {}

	-- Reset explosions table.
	exps = {}

	-- Reset spark table.
	sparks = {}

	-- Reset shockwave table.
	shwaves = {}

	createStarfield(false)
end

-- Parses a row string into row data.
function parseWaveRow(s)
	local parts = split(s, ',')
	local rowEnemies = {}

	for i = 3, #parts do
		local name = parts[i]
		add(rowEnemies, name == 'gap' and 'gap' or eDefs[name])
	end

	return { x = tonum(parts[1]), y = tonum(parts[2]), rowEnemies = rowEnemies }
end

-- Returns the wave data for the requested wave number.
function getWaveData(wave)
	for i = 1, #spawnEvents do
		if tonum(spawnEvents[i][1]) == wave then
			return spawnEvents[i]
		end
	end
end

-- Returns true if the requested wave has any spawn events.
function hasWaveSpawnEvents(wave)
	return getWaveData(wave) ~= nil
end

-- Spawns all enemy rows for a wave.
function spawnWaveRows(wave)
    local waveRows = getWaveData(wave)

    if not waveRows then
        return
    end

	local currentRow = #waveRows - 1

    -- Delay for spawning rows.
    local baseGapDelay = 10
    local delayReduction = 2

    local centerX = 64 -- Center of the screen on x-axis.
    local spacing = 11 -- Spacing between small sprites in a row.

    -- Iterate through each row in the wave (index 1 is the wave number).
    for rowNum = 2, #waveRows do
        local row = parseWaveRow(waveRows[rowNum])
        local rowIdx = rowNum - 1

        local firstEnemy = nil
        for _, e in pairs(row.rowEnemies) do
            if e ~= 'gap' then firstEnemy = e break end
        end

        local spriteW = (firstEnemy and firstEnemy.sprSize or 1) * 8

        local rowSpacing = max(spacing, spriteW + 4)

        local rowDelay = (rowIdx-1)*baseGapDelay - ((rowIdx-1)*(rowIdx-2)*delayReduction)/2

        local rowWidth = (#row.rowEnemies - 1) * rowSpacing

        local rowStartX = flr(centerX - spriteW / 2 - rowWidth / 2)

        -- Spawn each enemy in the row.
        for i = 1, #row.rowEnemies do
			local targetX = rowStartX + (i - 1) * rowSpacing
			local targetY = 10 + rowIdx * 13
			local delay = flr(rowDelay)

			if row.rowEnemies[i] ~= 'gap' then
				local e = spawnEnemy(row.rowEnemies[i], row.x, row.y, currentRow)

				async(function()
					wait(delay)
					animate(e, "x", targetX, spawnDur, easeOutQuart)
				end)
				async(function()
					wait(delay)
					animate(e, "y", targetY, spawnDur, easeOutQuart)
				end)
			end
        end

		currentRow -= 1
    end

	sfx(28)
end

-- Updates the game screen.
function updateGame()
	updateGameScene()

	spawnT += 1

	canAttack = gameT % 30 == 0

	if spawnT == spawnDur then
		canPlay = true
		for e in all(enemies) do
			e:activate()
		end
	end

	rowEnemies = {}
	for e in all(enemies) do
		if e.rowNum == activeRow then
			add(rowEnemies, e)
		end
	end

	if canPlay then
		local rowActive = false
		for e in all(rowEnemies) do
			if e:canCollide() then
				rowActive = true
				break
			end
		end

		if not rowActive then
			activeRow += 1
			for e in all(enemies) do
				if e.rowNum == activeRow then
					add(rowEnemies, e)
				end
			end
		end
	end

	if canAttack then
		local e = rnd(rowEnemies)
		if e and e:canCollide() then
			e:attack()
		end
	end

	-- Check for end of wave.
	if #enemies == 0 then
		-- Either start next wave or go to win screen.
		if hasWaveSpawnEvents(waveNum + 1) then
			enterNewWave()
			return
		else
			enterWin()
			return
		end
	end

	-- Check for game over.
	if player.lives <= 0 then
		if ship:isDead() then
			enterGameOver()
			return
		end
	end
end

-- Enter the game state.
function enterGame()
	state = stateNames.game
	spawnT = 0

	rowEnemies = {}
	activeRow = 1
end