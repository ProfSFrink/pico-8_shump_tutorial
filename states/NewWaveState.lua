-- New Wave state logic.

local exitTimer = 0

-- Update the new wave screen.
function updateNewWave()
    blinkT += 1
    exitTimer -= 1

    updateGameScene()

    if exitTimer <= 0 then
        spawnWaveRows(waveNum)
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
    exitTimer = 60 -- 2 seconds until state change.
    waveNum += 1
    if waveNum == 1 then
        music(0)
    else
        music(3)
    end
end