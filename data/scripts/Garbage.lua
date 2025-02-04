
function Create()
	local newGarbage = Object.Spawn( "R4_UnsortedTrash", this.Pos.x+0.100000,this.Pos.y+.010000)
	Object.SetProperty(newGarbage,"Tooltip","tooltip_R4_UnsortedTrash")
end

function Update(timePassed)
	this.Delete()
end
