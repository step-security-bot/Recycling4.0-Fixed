
local timeTot = 0

local Find = Object.GetNearbyObjects
local Get = Object.GetProperty
local Set = Object.SetProperty

-- local DoorTypes = { "JailDoor", "JailDoorLarge", "StaffDoor", "SolitaryDoor", "Door", "VisitorDoor", "RemoteDoor", "RoadGate",
 -- "FenceGateStandard", "FenceGateStaff", "FenceGateVisitor", "FenceGateGuard",
 -- "JailDoorRed", "JailDoorGrey", "JailDoorOrange", "JailDoorYellow", "JailDoorWhite",
 -- "JailDoorLargeRed", "JailDoorLargeGrey", "JailDoorLargeOrange", "JailDoorLargeYellow", "JailDoorLargeWhite",
 -- "SecureDoor", "SecretDoor", "BambooDoor", "BarnDoor", "WhitePicketGate" }

function Create()
	this.trashAmount = 1
end

function FindSurroundingTrash()
	this.trashAmount = 1
	local nearbyTrash = Find(this,"R4_GardenPrunedPlant",3)
	if next(nearbyTrash) then
		for thatTrash, dist in pairs(nearbyTrash) do
			if thatTrash.Id.i ~= this.Id.i then
				if thatTrash.trashAmount ~= nil then
					this.trashAmount = this.trashAmount + thatTrash.trashAmount
				else
					this.trashAmount = this.trashAmount + 1
				end
				thatTrash.Delete()
			end
		end
	end
	nearbyTrash = nil
	
	local nearbyStack = Find(this,"Stack",3)
	if next(nearbyStack) then
		for thatStack, dist in pairs(nearbyStack) do
			if thatStack.Contents == "R4_GardenPrunedPlant" then
				if thatStack.Quantity ~= nil then
					this.trashAmount = this.trashAmount + thatStack.Quantity
				else
					this.trashAmount = this.trashAmount + 1
				end
				thatStack.Delete()
			end
		end
	end
	nearbyStack = nil
	
	if this.trashAmount > 1 then
		local TrashNr = 0
		local newStack = Object.Spawn("Stack", this.Pos.x, this.Pos.y)
		for i = 1,2000 do
			Set(newStack,"Quantity",2)
			Set(newStack,"Contents",i)
			if newStack.Contents == "R4_GardenPrunedPlant" then
				TrashNr = i
			end
			if TrashNr > 1 then
				Set(newStack,"Quantity",this.trashAmount)
				break
			end
			-- Set(newStack,"Tooltip","tooltip_R4_UnsortedTrash")
		end
		this.Delete()
	end
end

function FindBlockedDoor()
	for _, typ in pairs(DoorTypes) do
		local nearbyDoors = Find(this,typ,1)
		for thatDoor, _ in pairs(nearbyDoors) do
			this.Pos.x = this.Pos.x + thatDoor.Or.x
			this.Pos.y = this.Pos.y + thatDoor.Or.y
			found = true
			break
		end
		if found == true then break end
	end
end

function Update(timePassed)
	if timePerUpdate == nil then
		-- FindBlockedDoor()
		timePerUpdate = (0.25+math.random()+math.random()) / World.TimeWarpFactor
	end
	timeTot = timeTot+timePassed
	if timeTot > timePerUpdate then
		timeTot = 0
		if not ScannedForTrash then
			if not this.Loaded then
				FindSurroundingTrash()
			end
			ScannedForTrash = true
		end
	end
end
