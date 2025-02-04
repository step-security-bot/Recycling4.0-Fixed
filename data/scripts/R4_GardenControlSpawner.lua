
function Create()
	local newControl = Object.Spawn( "R4_GardenControl", this.Pos.x,this.Pos.y-0.5)
end

function Update(timePassed)
	this.Delete()
end
