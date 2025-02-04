
local timeTot = 0
local timePerUpdate = 2+math.random()+math.random()

function Create()
end

function Update(timePassed)
	timeTot = timeTot+timePassed
	if timeTot > timePerUpdate then
		this.Delete()
	end
end
