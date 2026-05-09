-- Start state logic.

-- Updates the start screen.
function updateStart()
	blinkT += 1

	if btnp(4) or btnp(5) then
		enterNewWave()
	end
end

-- Draws the start game screen.
function drawStart()
	cls(0)

	startTimer += 1

	local start = "PLAYER 1 START"
	local getReady = "GET READY"

	?start, calcCenX(#start) + 1, 41, 1
	?start, calcCenX(#start), 40, 8
	?getReady,calcCenX(#getReady), 60, blink()

	-- Holds screen for 60 frames (2 secs).

	if startTimer > 60 then
		enterNewWave()
	end
end

-- enter start screen state.
function enterStart()
	state = stateNames.start
	startTimer = 0
	music(-1,2000)
end