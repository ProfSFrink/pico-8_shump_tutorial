-- Update the game over screen.
function updateGameOver()
	if btnp(4) or btnp(5) then
		restartGame()
	end
end

-- Draws the game over screen.
function drawGameOver()
    cls(0)

	fadeOutStarfield()

	local restart=pressAKey.."RESTART"

    ?"GAME OVER",calcCenX(#"GAME OVER"), 50, 7
    ?restart,calcCenX(#restart), 80, blink()
end

-- Restart the game and
-- return to the title screen.
function restartGame()
	state=stateNames.title
	createStarfield(true)
end