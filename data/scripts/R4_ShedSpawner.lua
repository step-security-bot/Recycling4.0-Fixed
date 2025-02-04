
function Create()
end

function Update(timePassed)
	newShed = Object.Spawn("R4_Shed2",this.Pos.x,this.Pos.y)
	this.Delete()
end
