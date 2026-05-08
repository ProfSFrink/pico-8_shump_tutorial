-- New Wave state logic.

local exitTimer = 0
local waveNum = 0

-- Update the new wave screen.
function updateNewWave()
    exitTimer -= 1

    if exitTimer <= 0 then
        spawnOn = true
        enterGame()
    end

    updateGame()
end

-- Draw the new wave screen.
function drawNewWave()
    drawGame()

    local waveText = "WAVE " .. waveNum

    ?waveText, calcCenX(#waveText), 30, 7
end

-- Enter the new wave state.
function enterNewWave()
    state = stateNames.newWave
    exitTimer = 60 -- 2 seconds until state change.
    waveNum += 1
end