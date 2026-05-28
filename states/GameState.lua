-- Game state logic.

spawnEvents = {
	{ '1',
		'-8,-24,alien,alien,gap,alien,alien,alien,gap,alien,alien',
		'136,34,alien,alien,gap,alien,alien,alien,gap,alien,alien',
		'64,-12,alien,alien,gap,gap,gap,gap,alien,alien'
	},
	{ '2',
		'-8,-24,ufo,ufo,gap,ufo,ufo,ufo,gap,ufo,ufo',
		'136,34,ufo,ufo,gap,ufo,ufo,ufo,gap,ufo,ufo',
		'64,-12,ufo,ufo,gap,gap,gap,gap,ufo,ufo'
	},
	{ '3',
		'-8,-24,fighter,gap,gap,flame,flame,gap,gap,fighter',
		'136,34,fighter,gap,gap,flame,flame,gap,gap,fighter',
	},
	{ '4',
		'-8,-24,eyeball,gap,redeye,redeye,gap,eyeball',
		'136,34,eyeball,gap,redeye,redeye,gap,eyeball',
		'64,-12,eyeball,gap,redeye,redeye,gap,eyeball'
	},
	{ '5',
		'60,-12,boss'
	}
}

-- Sets up the game.
function setupGame()
	-- Setup game timers (frames).
	gameT = 0
	proT = 0

	spawnDur = 50

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
				local e = spawnEnemy(row.rowEnemies[i], row.x, row.y)
				async(function()
					wait(delay)
					animate(e, "x", targetX, spawnDur, easeOutQuad)
				end)
				async(function()
					wait(delay)
					animate(e, "y", targetY, spawnDur, easeOutQuad)
				end)
			end
        end
    end

	sfx(28)
end

-- Updates the game screen.
function updateGame()
	updateGameScene()

	spawnT += 1

	if spawnT == spawnDur then
		canPlay = true
		for e in all(enemies) do
			e:activate()
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
end