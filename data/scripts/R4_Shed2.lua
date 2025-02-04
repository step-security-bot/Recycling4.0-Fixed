
local MaximumAge = 24			-- 24 hours
local timeTot=0
local Find = this.GetNearbyObjects
local Get = Object.GetProperty
local Set = Object.SetProperty
local CurrentHour = math.floor(math.mod(World.TimeIndex,1440) /60)
local myHarvestHour = 0		-- set to 0 (midnight) (=disabled)
local myTimeWarpFactor = 1
local IngredientsNr = 1
local eggsQuantity=0
local baconQuantity=0
local HourToHarvest = { [0] = "disabled", [1] = "01:00", [2] = "02:00", [3] = "03:00", [4] = "04:00", [5] = "05:00", [6] = "06:00", [7] = "07:00", [8] = "08:00", [9] = "09:00", [10] = "10:00", [11] = "11:00", [12] = "12:00", [13] = "13:00", [14] = "14:00", [15] = "15:00", [16] = "16:00", [17] = "17:00", [18] = "18:00", [19] = "19:00", [20] = "20:00", [21] = "21:00", [22] = "22:00", [23] = "23:00" }

function FindStackNumbers()
	local newStack = Object.Spawn("Stack", this.Pos.x-1, this.Pos.y)
	for i = 1,2000 do
		Set(newStack,"Quantity",2)
		Set(newStack,"Contents",i)
		if newStack.Contents == "Ingredients" then
			IngredientsNr = i
		end
		if IngredientsNr > 1 then
			newStack.Delete()
			print("Stack Ingredients: "..IngredientsNr)
			break
		end
	end
end

function Create()
	Set(this,"EggsQuantity",20)
	Set(this,"BaconQuantity",20)
	Set(this,"AgeHours", 0.0 )
	Set(this,"AgeMinutes", 0.0)
	if CurrentHour == 0 then							-- when placed at midnight set harvest hour to 11pm, otherwise it would say -1
		myHarvestHour = 23
	end
	Set(this,"HarvestHour", myHarvestHour)
	Set(this,"HarvestDone","No")
	Set(this,"DoorTimerDone","No")
	CurrentMinute = math.floor(math.mod(World.TimeIndex,60))
	if CurrentMinute > 45 then
		Set(this,"AgeMinutes",60-CurrentMinute)
	elseif CurrentMinute > 30 then
		Set(this,"AgeMinutes",45-CurrentMinute)
	elseif CurrentMinute > 15 then
		Set(this,"AgeMinutes",30-CurrentMinute)
	else
		Set(this,"AgeMinutes",15-CurrentMinute)
	end
end

function toggleEggsClicked()
	eggsQuantity=eggsQuantity+20
	if eggsQuantity>100 then
		eggsQuantity=0
	end
	Set(this,"EggsQuantity",eggsQuantity)
	this.SetInterfaceCaption("toggleEggs", "tooltip_R4_button_ToggleEggs",this.EggsQuantity,"X")
	SetMyTooltip()
end

function toggleBaconClicked()
	baconQuantity=baconQuantity+20
	if baconQuantity>100 then
		baconQuantity=0
	end
	Set(this,"BaconQuantity",baconQuantity)
	this.SetInterfaceCaption("toggleBacon", "tooltip_R4_button_ToggleBacon",this.BaconQuantity,"X")
	SetMyTooltip()
end

function toggleHarvestHourPlusClicked()
	myHarvestHour = myHarvestHour + 1
	if myHarvestHour > 23 then
		myHarvestHour = 0
	end
	Set(this,"HarvestHour",myHarvestHour)
	this.SetInterfaceCaption("toggleHarvestHourPlus", "tooltip_R4_button_HarvestHourPlus")
	this.SetInterfaceCaption("toggleHarvestHour", "tooltip_R4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
	this.SetInterfaceCaption("toggleHarvestHourMinus", "tooltip_R4_button_HarvestHourMinus")
	if myHarvestHour > 0 then
		local newAge = 0
		if CurrentHour > myHarvestHour then
			newAge = CurrentHour-myHarvestHour
		else
			newAge= CurrentHour-myHarvestHour+24
		end
		Set(this,"AgeHours",newAge)
	end
	SetMyTooltip()
end

function toggleHarvestHourMinusClicked()
	myHarvestHour = myHarvestHour - 1
	if myHarvestHour < 0 then
		myHarvestHour = 23
	end
	Set(this,"HarvestHour",myHarvestHour)
	this.SetInterfaceCaption("toggleHarvestHourPlus", "tooltip_R4_button_HarvestHourPlus")
	this.SetInterfaceCaption("toggleHarvestHour", "tooltip_R4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
	this.SetInterfaceCaption("toggleHarvestHourMinus", "tooltip_R4_button_HarvestHourMinus")
	if myHarvestHour > 0 then
		local newAge = 0
		if CurrentHour > myHarvestHour then
			newAge = CurrentHour-myHarvestHour
		else
			newAge= CurrentHour-myHarvestHour+24
		end
		Set(this,"AgeHours",newAge)
	end
	SetMyTooltip()
end

function SpawnEggsAndBacon()
	FindStackNumbers()
	if this.EggsQuantity > 0 then
		newEggs1 = Object.Spawn("Stack", this.Pos.x-1.5, this.Pos.y+3)
		Set(newEggs1,"Contents", IngredientsNr)
		Set(newEggs1,"SubType",3)
		Set(newEggs1,"Quantity",this.EggsQuantity/4)
	
		newEggs2 = Object.Spawn("Stack", this.Pos.x-0.5, this.Pos.y+3)
		Set(newEggs2,"Contents", IngredientsNr)
		Set(newEggs2,"SubType",3)
		Set(newEggs2,"Quantity",this.EggsQuantity/4)
	
		newEggs3 = Object.Spawn("Stack", this.Pos.x+0.5, this.Pos.y+3)
		Set(newEggs3,"Contents", IngredientsNr)
		Set(newEggs3,"SubType",3)
		Set(newEggs3,"Quantity",this.EggsQuantity/4)
	
		newEggs4 = Object.Spawn("Stack", this.Pos.x+1.5, this.Pos.y+3)
		Set(newEggs4,"Contents", IngredientsNr)
		Set(newEggs4,"SubType",3)
		Set(newEggs4,"Quantity",this.EggsQuantity/4)
	end
	if this.BaconQuantity > 0 then
		newBacon1 = Object.Spawn("Stack", this.Pos.x-1.5, this.Pos.y+4)
		Set(newBacon1,"Contents", IngredientsNr)
		Set(newBacon1,"SubType",2)
		Set(newBacon1,"Quantity",this.BaconQuantity/4)
	
		newBacon2 = Object.Spawn("Stack", this.Pos.x-0.5, this.Pos.y+4)
		Set(newBacon2,"Contents", IngredientsNr)
		Set(newBacon2,"SubType",2)
		Set(newBacon2,"Quantity",this.BaconQuantity/4)
	
		newBacon3 = Object.Spawn("Stack", this.Pos.x+0.5, this.Pos.y+4)
		Set(newBacon3,"Contents", IngredientsNr)
		Set(newBacon3,"SubType",2)
		Set(newBacon3,"Quantity",this.BaconQuantity/4)
	
		newBacon4 = Object.Spawn("Stack", this.Pos.x+1.5, this.Pos.y+4)
		Set(newBacon4,"Contents", IngredientsNr)
		Set(newBacon4,"SubType",2)
		Set(newBacon4,"Quantity",this.BaconQuantity/4)
	end
	Set(this,"AgeHours", 0.0)
	Set(this,"AgeMinutes", 0.0)
end

function Update( timePassed )
	if timePerUpdate==nil then
		if not Get(this,"TimerCreated") then
			newTimer = Object.Spawn( "DoorTimer", this.Pos.x+1.35,this.Pos.y+2)
			Set(newTimer,"ShedUID",this.Id.u)
			Set(this,"TimerCreated",true)
		end
		myTimeWarpFactor = World.TimeWarpFactor
		myHarvestHour = Get(this,"HarvestHour")
		eggsQuantity = Get(this,"EggsQuantity")
		baconQuantity = Get(this,"BaconQuantity")
		Interface.AddComponent(this,"toggleDelete", "Button", "tooltip_R4_button_Delete")
		Interface.AddComponent(this,"toggleEggs", "Button", "tooltip_R4_button_ToggleEggs",this.EggsQuantity,"X")
		Interface.AddComponent(this,"toggleBacon", "Button", "tooltip_R4_button_ToggleBacon",this.BaconQuantity,"X")
		Interface.AddComponent(this,"CaptionSeparatorShed", "Caption", "tooltip_R4_separatorline")
		Interface.AddComponent(this,"toggleHarvestHourPlus", "Button", "tooltip_R4_button_HarvestHourPlus")
		Interface.AddComponent(this,"toggleHarvestHour", "Button", "tooltip_R4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
		Interface.AddComponent(this,"toggleHarvestHourMinus", "Button", "tooltip_R4_button_HarvestHourMinus")
		CurrentMinute = math.floor(math.mod(World.TimeIndex,60))
		if CurrentMinute > 45 then
			timePerUpdate = (60 - CurrentMinute ) / myTimeWarpFactor	-- next update is 1 minute after the next whole hour.
		elseif CurrentMinute > 30 then
			timePerUpdate = (45 - CurrentMinute ) / myTimeWarpFactor	-- next update is 15 minutes before the next whole hour.
		elseif CurrentMinute > 15 then
			timePerUpdate = (30 - CurrentMinute ) / myTimeWarpFactor	-- next update is 30 minutes past current hour.
		else
			timePerUpdate = (15 - CurrentMinute ) / myTimeWarpFactor	-- next update is 15 minutes past current hour.
		end
		SetMyTooltip()
	end
	timeTot = timeTot + timePassed
	if timeTot>=timePerUpdate then
		timeTot=0
		
		if myTimeWarpFactor < 1 then
			if myTimeWarpFactor == 0.75 then
				timePerUpdate = 20
			elseif myTimeWarpFactor == 0.5 then
				timePerUpdate = 30
			end
		else
			timePerUpdate = 15
		end
		
		Set(this,"SubType",0)
		
		-- harvest by game hour
		CurrentHour = math.floor(math.mod(World.TimeIndex,1440) /60)
		
		if CurrentHour == myHarvestHour and myHarvestHour ~= 0 then	-- myHarvestHour 0 = disabled, but you can still harvest around midnight via doortimer or well timed placement of the pots
			if this.HarvestDone == "No" then
				Set(this,"SubType",1)
				Set(this,"HarvestDone","Yes")
			end
		else
			if this.HarvestDone == "Yes" then
				Set(this,"HarvestDone","No")
			end
		end
		
		
		-- harvest by age
		local ageHours = Get(this,"AgeHours")
		local ageMinutes = Get(this,"AgeMinutes")+15
		Set(this,"AgeMinutes", ageMinutes)
		if ageMinutes >= 60 then
			Set(this,"AgeHours", ageHours+1)
			ageMinutes = ageMinutes - 60
			Set(this,"AgeMinutes",ageMinutes)
		end
		if ageHours >= MaximumAge and myHarvestHour == 0 then
			Set(this,"SubType",1)
		end
		
		
		-- harvest by doortimer
		
		local hasPower = ( this.Triggered or 0 ) > 0
		if hasPower then
			if this.DoorTimerDone == "No" then
				myHarvestHour = CurrentHour
				Set(this,"HarvestHour",myHarvestHour)
				this.SetInterfaceCaption("toggleHarvestHour", "tooltip_R4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
				Set(this,"SubType",1)
				Set(this,"DoorTimerDone","Yes")
			end
		else
			if this.DoorTimerDone == "Yes" then
				Set(this,"DoorTimerDone","No")
			end
		end
		
		-- end doortimer
		
		if this.SubType == 1 then
			SpawnEggsAndBacon()
		end
		
		SetMyTooltip()
	end
end

function SetMyTooltip()

	this.Tooltip = {"tooltip_R4_statusShed",eggsQuantity,"A",baconQuantity,"B",this.AgeHours,"C",this.AgeMinutes,"D",HourToHarvest[this.HarvestHour],"E"}

	if this.HarvestHour==0 then
		this.Tooltip = {"tooltip_R4_statusShedNotForced",eggsQuantity,"A",baconQuantity,"B",this.AgeHours,"C",this.AgeMinutes,"D"}
	end
	
	if this.HarvestDone=="Yes" then
		this.Tooltip = {"tooltip_R4_statusShedHarvest",eggsQuantity,"A",baconQuantity,"B",this.AgeHours,"C",this.AgeMinutes,"D",HourToHarvest[this.HarvestHour],"E"}
	end
	
	if this.DoorTimerDone=="Yes" then
		this.Tooltip = {"tooltip_R4_statusShedDoorTimer",eggsQuantity,"A",baconQuantity,"B",this.AgeHours,"C",this.AgeMinutes,"D",HourToHarvest[this.HarvestHour],"E"}
	end
	
end

function toggleDeleteClicked()
	for thatTimer in next, Find(this,"DoorTimer",3) do
		if thatTimer.ShedUID ~= nil and thatTimer.ShedUID == this.Id.u then thatTimer.Delete() end
	end
	this.Delete()
end
