-- Game over state logic.

-- Update the game over screen.
function updateGameOver()
    if btnp(4) or btnp(5) then
        restartGame()
    end
end

-- Draws the game over screen.
function drawGameOver()
    cls(0)

    startTimer += 1

    fadeOutStarfield()
    if startTimer >= 50 then
        if bg.x1 < 0 and bg.x2 > 128 then
            cls(bgCol)
        else
            local bgSpd = 7
            bg.x1 -= bgSpd
            bg.y1 -= bgSpd
            bg.x2 += bgSpd
            bg.y2 += bgSpd
            rectfill(bg.x1, bg.y1, bg.x2, bg.y2, bgCol)
        end

        local gameOver = "GAME OVER"
        local restart = pressAKey .. "RESTART"

        ?gameOver, calcCenX(#gameOver), 50, 7 
        ?restart, calcCenX(#restart), 80, blink()
    end
end

-- Show the game over screen.
function showGameOver()
    state = stateNames.gameOver
    bg = { x1 = 64, y1 = 64, x2 = 64, y2 = 64 }
    bgCol = 8
    startTimer = 0
end

-- Restart the game and
-- return to the title screen.
function restartGame()
    state = stateNames.title
    createStarfield(true)
end