-- Win state logic.

-- Update the win screen.
function updateWin()
    blinkT += 1

	if btnp(4) or btnp(5) then
		enterTitle()
	end
end

-- Draw the win screen.
function drawWin()
    cls(0)

    local winText = "YOU WIN!"
    local restart = pressAKey .. "RESTART"

    ?winText, calcCenX(#winText) + 1, 41, 1
    ?winText, calcCenX(#winText), 40, 10
    ?restart, calcCenX(#restart), 80, blink()
end

-- Enter the win state.
function enterWin()
    state = stateNames.win
end