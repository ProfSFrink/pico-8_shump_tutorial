-- Title state logic

-- Updates the title screen.
function updateTitle()
	if btnp(4) or btnp(5) then
		showStart()
	end
end

-- Draws the title screen.
function drawTitle()
    cls(0)

	updateStarfield()

	local title="SHUMP TUTORIAL"
	local start=pressAKey.."START"

	?title,calcCenX(#title)+1, 41, 1
	?title,calcCenX(#title), 40, 10

	?start,calcCenX(#start), 80, blink()
end