--[[draws the screen when
running in game mode]]--
function drawGame()
	cls(0)
	updateStarfield()

	spr(shipSpr,shipX,shipY)
	spr(flameSpr,shipX,shipY+8)

	for b in all(bullets) do
		b:draw()
	end

	circfill(shipX+3,shipY-2,muzzle,7)
	circfill(shipX+4,shipY-2,muzzle,7)

	?"SCORE: "..score,40,1,12

	for i=1,4 do
		if lives >= i then
			spr(13,i*9-8,1)
		else
			spr(14,i*9-8,1)
		end
	end

	for i=1,bombs do
		spr(29,90+i*9-8,1)
	end

end

--draws the title screen
function drawTitle()
    cls(0)

	updateStarfield()

	local title="SHUMP TUTORIAL"
	local start=pressAKey.."START"

	?title,calcCentreX(title)+1, 41, 1
	?title,calcCentreX(title), 40, 10

	?start,calcCentreX(start), 80, blink()
end

--draw the start game screen
function drawStart()
	cls(0)

	startTimer += 1

	local start="PLAYER 1 START"
	local getReady="GET READY"

	?start,calcCentreX(start)+1, 41, 1
	?start,calcCentreX(start), 40, 8

	?getReady,calcCentreX(getReady), 60, blink()

	--holds screen for 60 frames (2 secs)
	if startTimer > 60 then
		startGame()
	end
end

--draws the game over screen
function drawGameOver()
    cls(0)

	fadeOutStarfield()

	local restart=pressAKey.."RESTART"

    ?"GAME OVER",calcCentreX("GAME OVER"), 50, 7
    ?restart,calcCentreX(restart), 80, blink()
end