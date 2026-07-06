-- Game state logic.

-- Table containing, wave information.
-- row number.
-- row attack rate (higher is less infrequent, x spawn, y spawn.

spawnEvents = {
	-- Wave #1.
	{ '1',
		'5,-8,14,alien,alien,alien,alien,alien,alien,alien',
		'10,136,34,alien,alien,alien,alien,alien,alien',
		'15,64,-12,alien,alien,gap,alien,alien'
	},
	-- Wave #2.
	{ '2',
		'5,-8,14,alien,alien,gap,flame,flame,gap,alien,alien',
		'10,136,34,alien,alien,gap,flame,flame,gap,alien,alien',
		'15,64,-12,alien,alien,alien,alien,alien,alien,alien,alien'
	},
	-- Wave #3.
	{ '3',
		'5,-8,14,ufo,gap,ufo,gap,ufo',
		'10,136,34,alien,alien,alien,alien,alien,alien',
	},
	-- Wave #4.
	{ '4',
		'2,-8,14,ufo,gap,ufo,gap,ufo',
		'5,136,34,gap,ufo,gap,ufo,gap',
		'10,64,-12,gap,gap,ufo,gap,gap',
	},
	-- Wave #5.
	{ '5',
		'0,-8,14,ufo,gap,ufo,gap,ufo',
		'3,136,34,fighter,alien,alien,gap,ufo,gap,alien,alien,fighter',
		'5,136,50,alien,alien,gap,redeye,redeye,redeye,redeye,redeye,gap,alien,alien',
	},
	-- Wave #6.
	{ '6',
		'0,136,34,alien,gap,boss,gap,alien',
		'0,0,0,gap',
		'10,-8,14,alien,alien,alien,alien,alien',
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
-- Format: attackRate,x,y,enemy1,enemy2,...
function parseWaveRow(s)
	local parts = split(s, ',')
	local rowEnemies = {}

	-- Get enemies for the row.
	for i = 4, #parts do
		local name = parts[i]
		add(rowEnemies, name == 'gap' and 'gap' or eDefs[name])
	end

	-- Return row data.
	return {
		attackRate = tonum(parts[1]),
		x = tonum(parts[2]),
		y = tonum(parts[3]),
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
    rowAttackRate = {}
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

		add(rowAttackRate, row.attackRate)

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
			local targetY = 0 + rowIdx * 13
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

-- Have an enemy shake before attacking.
-- @param ene: The table of enemies to choose from.
function shakeEnemy(ene)
	local e = rnd(ene)
	if e and e:canCollide() then
		e:shake()
	end
end

-- Updates the game screen.
function updateGame()
	updateGameScene()

	spawnT += 1

	canAttack = gameT % (rowAttackRate[activeRow] or 1) == 0

	if spawnT == spawnDur then
		canPlay = true
		for e in all(enemies) do
			e:activate()
		end
	end

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
		shakeEnemy(rowEnemies)
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

	rowEnemies = {}
	activeRow = 1
end