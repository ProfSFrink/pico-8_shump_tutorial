-- New Wave state logic.

local exitTimer = 0

-- Update the new wave screen.
function updateNewWave()
    blinkT += 1
    exitTimer -= 1

    updateGameScene()

    if exitTimer <= 0 then
        enterGame()
        return
    end
end

-- Draw the new wave screen.
function drawNewWave()
    drawGameScene()

    local waveText = "WAVE " .. waveNum

    ?waveText, calcCenX(#waveText), 30, blink()
end

-- Enter the new wave state.
function enterNewWave()
    state = stateNames.newWave
    canPlay = false
    exitTimer = 50

    removeAllProjectiles()

    -- Move ship to starting position for new wave. 
    async(function()
        animate(ship,"x", shipStartX, 60, easeOutQuad)
    end)

    async(function()
        animate(ship,"y", shipStartY, 60, easeOutQuad)
    end)

    waveNum += 1

    -- TODO: Remove at end of dev.
    if waveNum == 2 or waveNum == 4 or waveNum == 5 then
        ship.weaponTwo = threeShotBullet
    end

    if waveNum == 3 then
        ship.weaponTwo = blastShot
    end

    if waveNum == 1 then
        music(0)
    else
        music(3)
    end
end