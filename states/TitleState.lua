-- Title state logic

-- Updates the title screen.
function updateTitle()
	blinkT += 1

	if btnp(4) or btnp(5) then
		enterStart()
	end

	updateStarfield()
end

-- Draws the title screen.
function drawTitle()
	cls(0)

	drawStarfield()

	local title = "SHUMP TUTORIAL"
	local start = pressAKey .. "START"

	?title, calcCenX(#title) + 1, 41, 1
	?title, calcCenX(#title), 40, 10
	?start, calcCenX(#start), 80, blink()
end

-- Runs on state entry.
function enterTitle()
	state = stateNames.title
	onEntered = false

	-- Get's game ready now so we
	-- can show in the background
	-- of the new wave state.
	setupGame()
end