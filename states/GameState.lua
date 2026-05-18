-- Game state logic.

-- Sets up the game.
function setupGame()
	-- Setup game timer (frames).
	gameT = 0

	-- Points towards next spawn event.
	spawnEventsIndex = 1

	spawnEvents = {
		{
			wave = 1, x = 30, y = 14, num = 6, dur = 20,
			kind = eTypes.alien
		},
		{
			wave = 1, x = 30, y = 26, num = 6, dur = 20,
			kind = eTypes.alien
		},
		{
			wave = 1, x = 30, y = 38, num = 6, dur = 20,
			kind = eTypes.alien
		},

		{
			wave = 2, x = 30, y = 12, num = 5, dur = 20,
			kind = eTypes.ufo
		},
		{
			wave = 2, x = 30, y = 24, num = 5, dur = 20,
			kind = eTypes.redeye
		},

		{
			wave = 3, x = 49, y = 12, num = 1, dur = 20,
			kind = eTypes.boss
		}
	}

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

-- Returns the first spawn event index for the requested wave.
function getWaveStartEventIndex(wave)
	for i = 1, #spawnEvents do
		if spawnEvents[i].wave == wave then
			return i
		end
	end
end

-- Returns the next spawn event index for the requested wave.
function getNextWaveEventIndex(wave, startIndex)
	for i = startIndex, #spawnEvents do
		local event = spawnEvents[i]
		if event.wave == wave then
			return i
		elseif event.wave > wave then
			return nil
		end
	end
end

-- Returns true if the requested wave has any spawn events.
function hasWaveSpawnEvents(wave)
	return getWaveStartEventIndex(wave) ~= nil
end

-- Spawns the enemies for a wave based on the spawn events.
function spawnWaveRows(wave)
	local eventIndex = getWaveStartEventIndex(wave)

	if not eventIndex then
		spawnEventsIndex = #spawnEvents + 1
		return
	end

	while eventIndex <= #spawnEvents and spawnEvents[eventIndex].wave == wave do
		local event = spawnEvents[eventIndex]
		local xOff = 9

		for i = 1, event.num do
			local spawnX = event.x + xOff
			local spawnY = event.y
			spawnEnemy(event.kind, spawnX, spawnY)
			xOff += 9
		end

		eventIndex += 1
	end

	spawnEventsIndex = eventIndex
end

-- Updates the game screen.
function updateGame()
	updateGameScene()

	-- Check for end of wave.
	local moreWaves = getNextWaveEventIndex(waveNum, spawnEventsIndex) == nil and #enemies == 0

	-- Either start next wave or go to win screen.
	if moreWaves then
		if hasWaveSpawnEvents(waveNum + 1) then
			enterNewWave()
			return
		else
			enterWin()
			return
		end
	end
end

-- Enter the game state.
function enterGame()
	state = stateNames.game
	gameT = 0
	proT = 0
	for e in all(enemies) do
		e:activate()
	end
end