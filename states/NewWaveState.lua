-- New Wave state logic.

local exitTimer = 0

-- Update the new wave screen.
function updateNewWave()
    blinkT += 1
    exitTimer -= 1

    updateGameplay()

    if exitTimer <= 0 then
        spawnOn = true
        enterGame()
        return
    end
end

-- Draw the new wave screen.
function drawNewWave()
    drawGame()

    local waveText = "WAVE " .. waveNum

    ?waveText, calcCenX(#waveText), 30, blink()
end

-- Enter the new wave state.
function enterNewWave()
    state = stateNames.newWave
    spawnOn = false
    exitTimer = 60 -- 2 seconds until state change.
    waveNum += 1
end