
local timeTot = 0
local timePerUpdate = 0.05

function Create()
	this.Start = false
	this.Intensity = 10
	this.repeatCounter = 0
end

function Update(timePassed)
	if this.Start == true then
		timeTot = timeTot+timePassed
		if timeTot >= timePerUpdate then
			timeTot = 0
			this.SubType = this.SubType+1
			if this.SubType >= 8 then
				this.repeatCounter = this.repeatCounter + 1
				this.SubType = 0
			end
			if this.repeatCounter >= this.Intensity then
				this.Slot0.i = -1
				this.Slot0.u = -1
				this.Delete()
			end
		end
	end
end
