-- Game state logic.

-- Wave spawn data.
-- Format per row: 'startX,startY,enemyType:activateAt,...'
-- activateAt: wave timer value (frames) when the enemy begins attacking.

spawnEvents =
	{
	-- Wave #1 - Basic aliens / fixed shots.
	{ '1',
		'-8,14,alien:140,alien:160,alien:210,gap,alien:210,gap,alien:210,alien:160,alien:140',
		'136,34,alien:180,alien:210,alien:240,alien:240,alien:210,alien:180',
		'136,34,gap,alien:80,gap,alien:110,gap',
	},
	-- Wave #2 - Introduce aimed shots / Flame enemies.
	{ '2',
		'-8,14,alien:90,alien:100,gap,gap,flame:200,flame:200,gap,gap,alien:100,alien:90',
		'136,34,alien:110,alien:125,gap,flame:155,flame:155,gap,alien:125,alien:110',
		'64,-12,alien:120,alien:150,alien:60,alien:150,alien:150,alien:150,alien:120',
	},
	-- Wave #3 -- Introduce redeye (High HP) teach player to move.
	{ '3',
		'-8,14,redeye:30,gap,gap,gap,gap,redeye:120',
		'136,34,flame:125,gap,gap,gap,gap,gap,gap,gap,gap,flame:125',
		'64,-12,alien:45,alien:55,alien:60,gap,gap,alien:60,alien:55,alien:45',
	},
	-- Wave #4. -- TODO: Re-work this / add fighters.
	{ '4',
		'-8,14,ufo:110,gap,ufo:140,gap,ufo:170',
		'136,34,gap,ufo:80,gap,ufo:110,gap',
		'64,-12,gap,redeye:60,gap,redeye:90,gap'
	},
	-- Wave #5.
	{ '5',
		'-8,14,ufo:200,gap,ufo:200,gap,ufo:200',
		'136,34,fighter:120,alien:45,alien:47,gap,ufo:200,gap,alien:45,alien:47,fighter:200',
		'136,50,alien:35,alien:37,gap,redeye:150,redeye:150,redeye:150,redeye:150,redeye:130,gap,alien:37,alien:35'
	},
	-- Wave #6.
	{ '6',
		'-8,14,boss:45',
		'136,34,ufo:240,gap,alien:40,alien:40,gap,alien:40,alien:40,gap,ufo:240',
		'-8,54,redeye:30,alien:140,alien:120,redeye:30,alien:120,alien:140,redeye:30',
		'136,74,gap,gap,alien:140,alien:120,alien:100,alien:120,alien:140,gap,gap'
	},

}

-- Sets up the game.
function setupGame()
	-- Setup game (frames).
	gameT = 0

	spawnDur = 40
	attackDur = 40

	-- Setup player ship.
	ship = newShip()

	-- Setup player.
	-- score: The current player score.
	-- lives: The current number of lives.
	-- bombs: The current number of bombs.
	-- rof: The rate of fire of player in frames.
	player = {
		score = 0,
		lives = 4,
		bombs = 2,
		rof = 0
	}

	-- Setup for projectiles.
	projectiles = {}
	enemyProjectiles = {}

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
-- Format: x,y,enemy1:activateAt,enemy2:activateAt,...
function parseWaveRow(s)
	local parts = split(s, ',')
	local rowEnemies = {}

	-- Get enemies for the row.
	for i = 3, #parts do
		local token = parts[i]
		if token == 'gap' then
			add(rowEnemies, 'gap')
		else
			local p = split(token, ':')
			add(rowEnemies, { def = eDefs[p[1]], activateAt = tonum(p[2]) })
		end
	end

	-- Return row data.
	return {
		x = tonum(parts[1]),
		y = tonum(parts[2]),
		rowEnemies = rowEnemies
	}
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

        local firstDef = firstEnemy and firstEnemy.def or nil
        local hitW = firstDef and (firstDef.hitBox.w or 7) or 7

        local rowSpacing = max(spacing, hitW + 4)

        local rowDelay = (rowIdx-1)*baseGapDelay - ((rowIdx-1)*(rowIdx-2)*delayReduction)/2

        local rowWidth = (#row.rowEnemies - 1) * rowSpacing

        -- rowStartHitCenterX is the x of the first enemy's hitbox centre.
        local rowStartHitCenterX = flr(centerX - rowWidth / 2)

        -- Spawn each enemy in the row.
        for i = 1, #row.rowEnemies do
			local targetY = 0 + rowIdx * 13
			local delay = flr(rowDelay)

			if row.rowEnemies[i] ~= 'gap' then
				local entry = row.rowEnemies[i]
				local eHitOffX = entry.def.hitBox.offX or 0
				local eHitW = entry.def.hitBox.w or 7
				local hitCenterX = rowStartHitCenterX + (i - 1) * rowSpacing
				local targetX = flr(hitCenterX - eHitOffX - eHitW / 2)

				local e = spawnEnemy(entry.def, row.x, row.y, currentRow, entry.activateAt)

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
	waveT += 1

	if spawnT == spawnDur then
		canPlay = true
		for e in all(enemies) do
			e:activate()
		end
	end

	if canPlay then
		for e in all(enemies) do
			if waveT >= e.activateAt then
				e:shake()
			end
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

	-- Spawn the next wave of enemies.
	spawnWaveRows(waveNum)

	waveT = -10
end