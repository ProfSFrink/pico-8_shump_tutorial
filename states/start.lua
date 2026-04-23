-- Start state logic.

-- Updates the start screen.
function updateStart()
	if btnp(4) or btnp(5) then
		startGame()
	end
end

-- Draws the start game screen.
function drawStart()
	cls(0)

	startTimer += 1

	local start="PLAYER 1 START"
	local getReady="GET READY"

	?start,calcCenX(#start)+1, 41, 1
	?start,calcCenX(#start), 40, 8

	?getReady,calcCenX(#getReady), 60, blink()

	-- Holds screen for 60 frames (2 secs).
	if startTimer > 60 then
		startGame()
	end
end

-- Start game screen.
function showStart()
	startTimer=0

	state=stateNames.start
end