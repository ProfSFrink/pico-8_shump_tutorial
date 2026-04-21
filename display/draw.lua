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

function drawStart()
    cls(1)
    ?"PICO-8 SHUMP", 40, 50, 10
    ?"PRESS Z OR X TO START", 23, 80, 7
end

function drawGameOver()
    cls(8)
    ?"GAME OVER", 45, 50, 7
    ?"PRESS Z OR X TO RESTART", 20, 80, 7
end