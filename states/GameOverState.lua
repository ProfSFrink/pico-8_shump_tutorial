-- Game over state logic.

-- Update the game over screen.
function updateGameOver()
    blinkT += 1
    if not readyForInput then
        if stoppedFiring() then
            readyForInput = true
        end
        return
    end

    if btnp(4) or btnp(5) then
        exitGameOver()
    end
end

-- Draws the game over screen.
function drawGameOver()
    drawGame()

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

-- Enter the game over state.
function enterGameOver()
    state = stateNames.gameOver
    readyForInput = false
    bg = { x1 = 64, y1 = 64, x2 = 64, y2 = 64 }
    bgCol = 8
    startTimer = 0
    music(6)
end

-- Exit the game over state and
-- return to the title screen.
function exitGameOver()
    enterTitle()
    createStarfield(true)
end