
local myTimeWarpFactor = 0

local timeTot = 0
local timeSweep = 0
local timePerSweep = 0.1

local maxAge = 24		-- 24 game hours
local deathAge = 32
local Get = Object.GetProperty
local Set = Object.SetProperty
local CurrentHour = math.floor(math.mod(World.TimeIndex,1440) /60)
local CurrentMinute = math.floor(math.mod(World.TimeIndex,60))
local myHarvestHour = 0		-- set to 0 (midnight) (=disabled)

local HourToHarvest = { [0] = "disabled", [1] = "01:00", [2] = "02:00", [3] = "03:00", [4] = "04:00", [5] = "05:00", [6] = "06:00", [7] = "07:00", [8] = "08:00", [9] = "09:00", [10] = "10:00", [11] = "11:00", [12] = "12:00", [13] = "13:00", [14] = "14:00", [15] = "15:00", [16] = "16:00", [17] = "17:00", [18] = "18:00", [19] = "19:00", [20] = "20:00", [21] = "21:00", [22] = "22:00", [23] = "23:00" }

local subToPlantType = { GardenTomato = 3, GardenCucumber = 4, GardenRose = 5, GardenLily = 6, Ingredients = 7, Potatoes = 8, Cotton = 9 }
local plantTypeToSub = { [3] = "GardenTomato", [4] = "GardenCucumber", [5] = "GardenRose", [6] = "GardenLily", [7] = "Ingredients", [8] = "Potatoes", [9] = "Random" }
local PlantToFind = "R4_GardenPot"
local plantType = 9

-- local subToPlantType = { Cotton = 4 }
-- local plantTypeToSub = { [4] = "Cotton" }
-- local PlantToFind = "M4_CottonPlant"
-- local plantType = 4

local setPlantType = ""
local CoveredArea = {}
local plantRange = 3

local StackTypes = { "R4_SuperCompost", "R4_GardenSeed", "R4_GardenCompost", "R4_GardenFertilizer", "R4_GardenDDT", "R4_GreenhouseSeed", "R4_GreenhouseCompost", "R4_GreenhouseFertilizer", "R4_GreenhouseDDT" }

-- local StackTypes = { "R4_SuperCompost", "M4_CottonSeed", "M4_CottonCompost", "M4_CottonFertilizer", "M4_CottonDDT" }

-- local CottonCompostNr = 1
-- local CottonSeedNr = 1
-- local CottonFertiNr = 1
-- local CottonDDTNr = 1
--local RawCottonNr = 1

local GardenCompostNr = 1
local GardenSeedNr = 1
local GardenFertiNr = 1
local GardenDDTNr = 1
local GreenhouseSeedNr = 1
local GreenhouseCompostNr = 1
local GreenhouseFertiNr = 1
local GreenhouseDDTNr = 1

local TomatoNr = 1
local CucumberNr = 1
local RoseNr = 1
local LilyNr = 1

local SuperCompostNr = 1
local IngredientsNr = 1

local AtCurrentPlant = 0
local TotalPlantsFound = 0

function Create()
	if CurrentHour == 0 then							-- when placed at midnight set harvest hour to 11pm, otherwise it would say -1
		myHarvestHour = 23
	end
	Set(this,"HarvestHour", myHarvestHour)
	Set(this,"PlantType","Random")
	-- Set(this,"PlantType","Cotton")
	Set(this,"HarvestDone","No")
	Set(this,"DoorTimerDone","No")
	Set(this,"Range",3)
	Set(this,"NightLight","Night")
	Set(this,"LightSpawned",false)
	Set(this,"Lightning","Off")
end

function FindStackNumbers()
	local totalFound = 0
	local newStack = Object.Spawn("Stack", this.Pos.x-1, this.Pos.y)
	for i = 1,2000 do
		Set(newStack,"Quantity",2)
		Set(newStack,"Contents",i)
		if newStack.Contents == "Ingredients" then
			IngredientsNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_SuperCompost" then
			SuperCompostNr = i
			totalFound = totalFound + 1
		-- elseif newStack.Contents == "M4_CottonSeed" then
			-- CottonSeedNr = i
			-- totalFound = totalFound + 1
		-- elseif newStack.Contents == "M4_CottonCompost" then
			-- CottonCompostNr = i
			-- totalFound = totalFound + 1
		-- elseif newStack.Contents == "M4_CottonFertilizer" then
			-- CottonFertiNr = i
			-- totalFound = totalFound + 1
		-- elseif newStack.Contents == "M4_CottonDDT" then
			-- CottonDDTNr = i
			-- totalFound = totalFound + 1
		-- elseif newStack.Contents == "M4_RawCotton" then
			-- RawCottonNr = i
			-- totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GardenSeed" then
			GardenSeedNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GardenCompost" then
			GardenCompostNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GardenFertilizer" then
			GardenFertiNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GardenDDT" then
			GardenDDTNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GreenhouseSeed" then
			GreenhouseSeedNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GreenhouseCompost" then
			GreenhouseCompostNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GreenhouseFertilizer" then
			GreenhouseFertiNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GreenhouseDDT" then
			GreenhouseDDTNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GardenTomato" then
			TomatoNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GardenCucumber" then
			CucumberNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GardenRose" then
			RoseNr = i
			totalFound = totalFound + 1
		elseif newStack.Contents == "R4_GardenLily" then
			LilyNr = i
			totalFound = totalFound + 1
		end
		if totalFound == 14 then
		-- if totalFound == 7 then
			newStack.Delete()
			break
		end
	end
end

function FindMyStacks()
	local myStacks = Find("Stack",this.Range+10)
	if next(myStacks) then
		for thatStack, dist in pairs(myStacks) do
			if thatStack.IsGardenControlStack and thatStack.ControlUID == this.Id.u then
				-- if thatStack.Contents == "M4_CottonFertilizer"	 then myFertilizer = thatStack
				-- elseif thatStack.Contents == "M4_CottonSeed"	 then mySeed = thatStack
				-- elseif thatStack.Contents == "M4_CottonCompost"	 then myCompost = thatStack
				-- elseif thatStack.Contents == "M4_CottonDDT"		 then myDDT = thatStack
				-- elseif thatStack.Contents == "R4_SuperCompost"  then mySuperCompost = thatStack end
				if thatStack.Contents == "R4_GardenFertilizer" 	or thatStack.Contents == "R4_GreenhouseFertilizer"	 then myFertilizer = thatStack
				elseif thatStack.Contents == "R4_GardenSeed" 	or thatStack.Contents == "R4_GreenhouseSeed"		 then mySeed = thatStack
				elseif thatStack.Contents == "R4_GardenCompost" or thatStack.Contents == "R4_GreenhouseCompost"		 then myCompost = thatStack
				elseif thatStack.Contents == "R4_GardenDDT"		or thatStack.Contents == "R4_GreenhouseDDT"			 then myDDT = thatStack
				elseif thatStack.Contents == "R4_SuperCompost"  then mySuperCompost = thatStack end
			end
		end
	end
	myStacks = nil
	FindMySuperCompost()
end

function FindMySuperCompost()
	-- print("FindMySuperCompost")
	local myStacks = Find("Stack",2)
	if next(myStacks) then
		for thatStack, dist in pairs(myStacks) do
			if thatStack.Id.u == this.Slot4.u then
				mySuperCompost = thatStack
				Set(mySuperCompost,"IsGardenControlStack",true)
				-- Set(mySuperCompost,"IsCottonControlStack",true)
				Set(mySuperCompost,"ControlUID",this.Id.u)
			end
		end
	end
	myStacks = nil
end

function RemoveMyStacks()
	local myStacks = Find("Stack",this.Range+10)
	if next(myStacks) then
		for thatStack, dist in pairs(myStacks) do
			if thatStack.IsGardenControlStack and thatStack.ControlUID == this.Id.u then
			-- if thatStack.IsCottonControlStack and thatStack.ControlUID == this.Id.u then
				thatStack.Delete()
			end
		end
	end
end

function toggleTypeClicked()
	plantType = plantType + 1
	if plantType > 9 then
		plantType = 3
	end
	setPlantType = plantTypeToSub[plantType]
	Set(this,"PlantType",setPlantType)
	this.SetInterfaceCaption("toggleType", "tooltip_R4_button_PlantType","tooltip_R4_button_"..this.PlantType,"X")
	
	if TotalPlantsFound > 0 then
		for T = 1, TotalPlantsFound do
			local thisPlant = MyPlants[T]
			if Exists(thisPlant) then
				if thisPlant.AgeHours ~= nil then
					if thisPlant.IsEmpty == "No" and thisPlant.IsDead == "No" then
						if plantType == 9 then setPlantType = plantTypeToSub[math.random(3,8)] end
						Set(thisPlant,"PlantType",setPlantType)
						local subType = 1
						if thisPlant.AgeHours >= maxAge and myHarvestHour == 0 then					-- plant life at 100% then harvest if myHarvestHour is disabled
							subType = subToPlantType[Get(thisPlant,"PlantType")]
							Set(thisPlant,"IsRipe", "Yes")
						elseif thisPlant.AgeHours >= 18 then
							subType = subToPlantType[Get(thisPlant,"PlantType")]
						elseif thisPlant.AgeHours >= 12 then
							subType = 2
						end
						if Get(thisPlant,"SubType") ~= subType then
							Set(thisPlant,"SubType", subType)
						end
						SetPlantTooltip(thisPlant)
					end
				else
					InitPlant(thisPlant)
				end
			end
		end
	end
	SetMyTooltip()
end

function togglePlantRangePlusClicked()
	if plantRange <= 27 then
		if Covered == true then
			-- HideCoveredArea("R4_Garden")
			-- HideCoveredArea("M4_Cotton")
			Covered = false
		end
		plantRange = plantRange + 2
		Set(this,"Range",plantRange)
				
		if Exists(mySeed) then mySeed.Delete() end
		toggleScanAreaClicked()
		
		this.SetInterfaceCaption("toggleShowCoveredPlantArea", "tooltip_R4_button_ShowHideRange",this.Range,"X")
		ShowCoveredArea(this.Range,"R4_Garden")
		-- this.SetInterfaceCaption("toggleShowCoveredPlantArea", "tooltip_M4_button_ShowHideRange",this.Range,"X")
		-- ShowCoveredArea(this.Range,"M4_Cotton")
		Covered = true
	end
	SetMyTooltip()
end

function toggleShowCoveredPlantAreaClicked()
--	if Covered==true then
--		HideCoveredArea("R4_Garden")
--		HideCoveredArea("M4_Cotton")
--		Covered=false
--	else
		ShowCoveredArea(this.Range,"R4_Garden")
		-- ShowCoveredArea(this.Range,"M4_Cotton")
--		Covered=true
--	end
end

function togglePlantRangeMinusClicked()
	if plantRange >= 5 then
		if Covered == true then
			-- HideCoveredArea("R4_Garden")
			-- HideCoveredArea("M4_Cotton")
			Covered = false
		end
		
		if TotalPlantsFound > 0 then
			for T = 1, TotalPlantsFound do
				local thisPlant = MyPlants[T]
				if Exists(thisPlant) then
					Set(thisPlant,"SubType",9)
					-- Set(thisPlant,"Tooltip","tooltip_M4_CottonPlantNotManaged")
					Set(thisPlant,"Tooltip","tooltip_R4_GardenPotNotManaged")
				end
			end
		end
		plantRange = plantRange - 2
		Set(this,"Range",plantRange)
		
		if Exists(mySeed) then mySeed.Delete() end
		toggleScanAreaClicked()
		
		-- this.SetInterfaceCaption("toggleShowCoveredPlantArea", "tooltip_M4_button_ShowHideRange",this.Range,"X")
		-- ShowCoveredArea(this.Range,"M4_Cotton")
		this.SetInterfaceCaption("toggleShowCoveredPlantArea", "tooltip_R4_button_ShowHideRange",this.Range,"X")
		ShowCoveredArea(this.Range,"R4_Garden")
		Covered = true
	end
	SetMyTooltip()
end

function toggleHarvestHourPlusClicked()
	myHarvestHour = myHarvestHour + 1
	if myHarvestHour > 23 then
		myHarvestHour = 0
	end
	Set(this,"HarvestHour",myHarvestHour)
	-- this.SetInterfaceCaption("toggleHarvestHour", "tooltip_M4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
	this.SetInterfaceCaption("toggleHarvestHour", "tooltip_R4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
	if myHarvestHour > 0 then
		local newAge = 0
		if CurrentHour > myHarvestHour then
			newAge = CurrentHour - myHarvestHour
		else
			newAge = CurrentHour - myHarvestHour + 24
		end
		if CurrentHour == myHarvestHour then
			newAge = 0
		end
		AgePlants(newAge)
	else
		ResetHarvestHour()
	end
	SetMyTooltip()
end

function toggleHarvestHourClicked()
	if myHarvestHour > 0 then
		myHarvestHour = 0
	else
		myHarvestHour = CurrentHour
		Set(this,"HarvestDone","Yes")
		AgePlants(0.0)
	end
	Set(this,"HarvestHour",myHarvestHour)
	-- this.SetInterfaceCaption("toggleHarvestHour", "tooltip_M4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
	this.SetInterfaceCaption("toggleHarvestHour", "tooltip_R4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
	ResetHarvestHour()
	SetMyTooltip()
end

function toggleHarvestHourMinusClicked()
	myHarvestHour = myHarvestHour - 1
	if myHarvestHour < 0 then
		myHarvestHour = 23
	end
	Set(this,"HarvestHour",myHarvestHour)
	-- this.SetInterfaceCaption("toggleHarvestHour", "tooltip_M4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
	this.SetInterfaceCaption("toggleHarvestHour", "tooltip_R4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
	if myHarvestHour > 0 then
		local newAge = 0
		if CurrentHour > myHarvestHour then
			newAge = CurrentHour - myHarvestHour
		else
			newAge = CurrentHour - myHarvestHour + 24
		end
		if CurrentHour == myHarvestHour then
			newAge = 0
		end
		AgePlants(newAge)
	else
		ResetHarvestHour()
	end
	SetMyTooltip()
end

function toggleLightningStrikeClicked()
	if this.Lightning == "Off" then
		Set(this,"Lightning","On")
	else
		Set(this,"Lightning","Off")
	end
	-- this.SetInterfaceCaption("toggleLightningStrike", "tooltip_M4_button_ToggleLightning","tooltip_M4_button_"..this.Lightning,"X")
	this.SetInterfaceCaption("toggleLightningStrike", "tooltip_R4_button_ToggleLightning","tooltip_R4_button_"..this.Lightning,"X")
end

function AgePlants(theAge)
	if TotalPlantsFound > 0 then
		for T = 1, TotalPlantsFound do
			local thisPlant = MyPlants[T]
			if Exists(thisPlant) then
				if thisPlant.IsEmpty ~= nil then
					if thisPlant.IsEmpty == "No" and thisPlant.IsDead == "No" then
						local subType = 1
						local rndSubType = 0
						-- if math.random() > 0.5 then
							-- rndSubType = 4
						-- end
						
						Set(thisPlant,"AgeHours",theAge)
						Set(thisPlant,"HarvestHour",myHarvestHour)
													
						if thisPlant.AgeHours >= maxAge and myHarvestHour == 0 then					-- plant life at 100% then harvest if myHarvestHour is disabled
							subType = subToPlantType[Get(thisPlant,"PlantType")]+rndSubType
							Set(thisPlant,"IsRipe", "Yes")						
						elseif thisPlant.AgeHours >= 18 then
							subType = subToPlantType[Get(thisPlant,"PlantType")]+rndSubType
						elseif thisPlant.AgeHours >= 12 then
							-- subType = 3+rndSubType
							subType = 2
						-- elseif thisPlant.AgeHours >=6 then
							-- subType = 2+rndSubType
						end
						if thisPlant.SubType ~= subType then
							thisPlant.SubType = subType
						end
						SetPlantTooltip(thisPlant)
					end
				else
					InitPlant(thisPlant)
				end
			end
		end
	end
end

function ResetHarvestHour()
	if TotalPlantsFound > 0 then
		for T = 1, TotalPlantsFound do
			local thisPlant = MyPlants[T]
			if Exists(thisPlant) then
				if thisPlant.IsEmpty ~= nil then
					if thisPlant.IsEmpty == "No" and thisPlant.IsDead == "No" then
						Set(thisPlant,"HarvestHour",myHarvestHour)
						SetPlantTooltip(thisPlant)
					end
				else
					InitPlant(thisPlant)
				end
			end
		end
	end
end

function HarvestPlants(thisPlant)
	if Exists(thisPlant) then
		if thisPlant.IsEmpty ~= nil then
			if thisPlant.IsEmpty == "No" and thisPlant.IsDead == "No" and thisPlant.NeedsPruning == "No" then
				Set(thisPlant,"IsRipe", "Yes")
				Set(thisPlant,"NeedsPruning","No")
				Set(thisPlant,"NeedsTending","No")
				Set(thisPlant,"NeedsWater","No")
				Set(thisPlant,"NeedsFerti","No")
				Set(thisPlant,"NeedsDDT","No")
				Set(thisPlant,"IsEmpty","No")
				Set(thisPlant,"IsDead","No")
				Set(thisPlant,"SeedOrdered",nil)
				Set(thisPlant,"CompostOrdered",nil)
				Set(thisPlant,"FastGrowing",nil)
				Set(thisPlant,"SuperCompostOrdered",nil)
				Set(thisPlant,"FertiOrdered",nil)
				Set(thisPlant,"DDTOrdered",nil)
				Set(thisPlant,"AgeHours",0.0)
				Set(thisPlant,"AgeMinutes",0.0)
				Set(thisPlant,"SubType",subToPlantType[Get(thisPlant,"PlantType")])
				Set(thisPlant,"HarvestHour",myHarvestHour)
				-- Set(thisPlant,"RawCottonNr",RawCottonNr)
				Set(thisPlant,"IngredientsNr",IngredientsNr)
				Set(thisPlant,"TomatoNr",TomatoNr)
				Set(thisPlant,"CucumberNr",CucumberNr)
				Set(thisPlant,"RoseNr",RoseNr)
				Set(thisPlant,"LilyNr",LilyNr)
				
				CancelAllJobs(thisPlant)
				
				-- Object.CreateJob(thisPlant,"M4_HarvestCottonPlant")
				if IsIndoor(thisPlant) == false then
					Object.CreateJob(thisPlant,"R4_HarvestGardenPlant")
				else
					Object.CreateJob(thisPlant,"R4_HarvestGreenhousePlant")
				end
				SetPlantTooltip(thisPlant)
			end
		else
			InitPlant(thisPlant)
		end
	end
end

function SpawnMaterial(thisPlant,T,theAmount)
	if T == "Seed" then
		if not Exists(mySeed) then
			mySeed = Object.Spawn("Stack",this.Pos.x-1.25,this.Pos.y+0.65)
			-- Set(mySeed,"IsCottonControlStack",true)
			Set(mySeed,"IsGardenControlStack",true)
			Set(mySeed,"ControlUID",this.Id.u)
			this.Slot0.i,this.Slot0.u = mySeed.Id.i,mySeed.Id.u
			if IsIndoor(thisPlant) == false then Set(mySeed,"Contents",GardenSeedNr) else Set(mySeed,"Contents",GreenhouseSeedNr) end
			-- Set(mySeed,"Contents",CottonSeedNr)
			Set(mySeed,"Quantity",2)
		else
			Set(mySeed,"Quantity",mySeed.Quantity + theAmount)
		end
		Set(thisPlant,"SeedOrdered",true)
		
	elseif T == "Compost" then
		if not Exists(myCompost) then
			myCompost = Object.Spawn("Stack",this.Pos.x-0.25,this.Pos.y+0.75)
			-- Set(myCompost,"IsCottonControlStack",true)
			Set(myCompost,"IsGardenControlStack",true)
			Set(myCompost,"ControlUID",this.Id.u)
			this.Slot1.i,this.Slot1.u = myCompost.Id.i,myCompost.Id.u
			if IsIndoor(thisPlant) == false then Set(myCompost,"Contents",GardenCompostNr) else Set(myCompost,"Contents",GreenhouseCompostNr) end
			-- Set(myCompost,"Contents",CottonCompostNr)
			Set(myCompost,"Quantity",2)
		else
			Set(myCompost,"Quantity",myCompost.Quantity + theAmount)
		end
		Set(thisPlant,"CompostOrdered",true)
		
	elseif T == "Fertilizer" then
		if not Exists(myFertilizer) then
			myFertilizer = Object.Spawn("Stack",this.Pos.x+0.25,this.Pos.y+0.75)
			-- Set(myFertilizer,"IsCottonControlStack",true)
			Set(myFertilizer,"IsGardenControlStack",true)
			Set(myFertilizer,"ControlUID",this.Id.u)
			this.Slot2.i,this.Slot2.u = myFertilizer.Id.i,myFertilizer.Id.u
			if IsIndoor(thisPlant) == false then Set(myFertilizer,"Contents",GardenFertiNr) else Set(myFertilizer,"Contents",GreenhouseFertiNr) end
			-- Set(myFertilizer,"Contents",CottonFertiNr)
			Set(myFertilizer,"Quantity",2)
		else
			Set(myFertilizer,"Quantity",myFertilizer.Quantity + theAmount)
		end
		Set(thisPlant,"FertiOrdered",true)
		
	elseif T == "DDT" then
		if not Exists(myDDT) then
			myDDT = Object.Spawn("Stack",this.Pos.x+1.25,this.Pos.y+0.65)
			-- Set(myDDT,"IsCottonControlStack",true)
			Set(myDDT,"IsGardenControlStack",true)
			Set(myDDT,"ControlUID",this.Id.u)
			this.Slot3.i,this.Slot3.u = myDDT.Id.i,myDDT.Id.u
			if IsIndoor(thisPlant) == false then Set(myDDT,"Contents",GardenDDTNr) else Set(myDDT,"Contents",GreenhouseDDTNr) end
			-- Set(myDDT,"Contents",CottonDDTNr)
			Set(myDDT,"Quantity",2)
		else
			Set(myDDT,"Quantity",myDDT.Quantity + theAmount)
		end
		Set(thisPlant,"DDTOrdered",true)
	end
end

function InitPlant(thisPlant)
	if Exists(thisPlant) then
		-- local material = World.GetCell(thisPlant.Pos.x,thisPlant.Pos.y)
		-- if material.Mat ~= "Farmland" then
			-- Set(thisPlant,"SubType",9)
			-- thisPlant.Tooltip = "tooltip_M4_Need_Compost"
		-- elseif thisPlant.IsEmpty == nil then
		if thisPlant.IsEmpty == nil then
			CancelAllJobs(thisPlant)
				
			Set(thisPlant,"SubType",0)
			Set(thisPlant,"IsEmpty","Yes")
			Set(thisPlant,"NeedsPruning","No")
			Set(thisPlant,"NeedsTending","No")
			Set(thisPlant,"NeedsWater","No")
			Set(thisPlant,"NeedsFerti","No")
			Set(thisPlant,"NeedsDDT","No")
			Set(thisPlant,"IsRipe","No")
			Set(thisPlant,"IsDead","No")
			Set(thisPlant,"HarvestHour",myHarvestHour)
			Set(thisPlant,"AgeHours",0.0)
			Set(thisPlant,"AgeMinutes",0.0)
			-- thisPlant.Tooltip = { "tooltip_M4_PlantSeed",this.Id.u,"X" }
			thisPlant.Tooltip = { "tooltip_R4_PlantSeed",this.Id.u,"X" }
			Set(thisPlant,"SeedOrdered",true)
			Set(thisPlant,"CompostOrdered",nil)
			Set(thisPlant,"FastGrowing",nil)
			Set(thisPlant,"SuperCompostOrdered",nil)
			Set(thisPlant,"FertiOrdered",nil)
			Set(thisPlant,"DDTOrdered",nil)
			SpawnMaterial(thisPlant,"Seed",1)
			-- Object.CreateJob(thisPlant,"M4_PlantCottonSeed")
			if IsIndoor(thisPlant) == false then
				Object.CreateJob(thisPlant,"R4_PlantGardenSeed")
			else
				Object.CreateJob(thisPlant,"R4_PlantGreenhouseSeed")
			end
		end
	end
end

function Update( timePassed )
	if timePerUpdate == nil then
		InitControl()
	end
		
	if TotalPlantsFound > 0 then
	
		timeTot = timeTot + timePassed
		if timeTot > timePerUpdate then
			timeTot = 0
		
			timePerUpdate = 15 / myTimeWarpFactor
			
			PreviousHour = CurrentHour
			CurrentHour = math.floor(math.mod(World.TimeIndex,1440) /60)
			CurrentMinute = math.floor(math.mod(World.TimeIndex,60))
			
			if this.NightLight == "Night" then
				if (CurrentHour >= 20 or CurrentHour < 6) and this.LightSpawned == false then
					LightOn()
					Set(this,"LightSpawned",true)
				elseif CurrentHour >= 6 and CurrentHour < 20 and this.LightSpawned == true then
					LightOff()
					Set(this,"LightSpawned",false)
				end
			end
			-- forced harvest by game hour
			
			if CurrentHour == myHarvestHour and myHarvestHour > 0 then
				if not DoHarvestSweep then
					AtCurrentPlant = 0
					DoHarvestSweep = true
				end
			else
				if DoHarvestSweep == true then
					DoHarvestSweep = nil
				end
			end
			
			-- end harvest
			
			
			-- forced harvest by doortimer
			
			local hasPower = ( this.Triggered or 0 ) > 0
			if hasPower then
				if this.DoorTimerDone == "No" then
					myHarvestHour = CurrentHour
					Set(this,"HarvestHour",myHarvestHour)
					-- this.SetInterfaceCaption("toggleHarvestHour", "tooltip_M4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
					this.SetInterfaceCaption("toggleHarvestHour", "tooltip_R4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
					AtCurrentPlant = 0
					DoHarvestSweep = true
					Set(this,"DoorTimerDone","Yes")
					return
				end
			else
				if this.DoorTimerDone == "Yes" then
					Set(this,"DoorTimerDone","No")
				end
			end
			-- end doortimer
			
			UpdatePlants = true
		end
	
		if this.Slot4.i > -1 and not Exists(mySuperCompost) then FindMySuperCompost() end
		if not Exists(mySeed) then SpawnMaterial(MyPlants[1],"Seed",1) end
		if not Exists(myCompost) then SpawnMaterial(MyPlants[1],"Compost",1) end
		if not Exists(myFertilizer) then SpawnMaterial(MyPlants[1],"Fertilizer",1) end
		if not Exists(myDDT) then SpawnMaterial(MyPlants[1],"DDT",1) end
	
		timeSweep = timeSweep + timePassed
		if timeSweep > timePerSweep and UpdatePlants == true then
			timeSweep = 0
			
			AtCurrentPlant = AtCurrentPlant + 1
			if AtCurrentPlant > TotalPlantsFound then
				AtCurrentPlant,UpdatePlants,DoHarvestSweep = 0,nil,nil
				CheckLightning()
				SetMyTooltip()
				return
			end
			if AtCurrentPlant > 0 then
				local myPlant = MyPlants[AtCurrentPlant]
			
				if Exists(myPlant) then
				
					if DoHarvestSweep == true then
						HarvestPlants(myPlant)
						return
					elseif myPlant.IsEmpty == nil then
						InitPlant(myPlant)
						
					else
						if myPlant.IsEmpty == "No" then
							if myHarvestHour == 0 then	-- myHarvestHour 0 = forced harvest disabled, just let the plants grow until they reach maxAge
								Set(myPlant,"AgeMinutes", myPlant.AgeMinutes+15)
								if myPlant.AgeMinutes >= 60 then
									Set(myPlant,"AgeHours", myPlant.AgeHours+1)
									Set(myPlant,"AgeMinutes",myPlant.AgeMinutes-60)
									if myPlant.AgeHours == 12 then myPlant.NeedsWater = "Yes" end
								end
							else					-- forced harvest at specific hour, stricter growing times so all plants grow at same age
								Set(myPlant,"AgeMinutes", CurrentMinute)
								if PreviousHour ~= CurrentHour then	-- set the exact age after the first hour passes, to not have big plants showing up after a seed was planted, this should somewhat cover it up
									if myPlant.IsRipe == "No" and myPlant.NeedsPruning == "No" then	
										local newAge = 0
										if CurrentHour > myHarvestHour then
											newAge = CurrentHour-myHarvestHour
										else
											newAge = CurrentHour-myHarvestHour+24
										end
										Set(myPlant,"AgeHours",newAge)
									else		-- if the plant is ripe then let the hours count up to maxAge+4
										Set(myPlant,"AgeHours",myPlant.AgeHours+1)
									end
								end
							end
							IssueWaterOrFertiJobs(myPlant)
							if myPlant.NeedsPruning == "No" and myPlant.IsRipe == "No" and myPlant.IsEmpty == "No" and myPlant.IsDead == "No" then
								-- local subType = myPlant.SubType
								local subType = 1
								local rndSubType = 0
								-- if math.random() > 0.5 then
									-- rndSubType = 4
								-- end
								if myPlant.AgeHours >= deathAge then	-- harvest failed within reasonable time, plant dies
									Set(myPlant,"IsDead","Yes")
									-- if math.random() > 0.5 then
										-- subType = 10
									-- else
										-- subType = 11
									-- end
									subType = 1
								elseif myPlant.AgeHours >= maxAge then		-- plant life at 100% then harvest if myHarvestHour is disabled
									subType = subToPlantType[Get(myPlant,"PlantType")]+rndSubType
									Set(myPlant,"IsRipe", "Yes")
								elseif myPlant.AgeHours >= 18 then		-- show...
									subType = subToPlantType[Get(myPlant,"PlantType")]+rndSubType
								elseif myPlant.AgeHours >= 12 then		-- ...different ...
									-- subType = 3+rndSubType
									subType = 2
								-- elseif myPlant.AgeHours >= 6 then		-- ...random...
									-- subType = 2+rndSubType
								end
								if math.random(0,666) == 11 then		-- oops, plant died for some reason
									Set(myPlant,"IsDead","Yes")
									-- if math.random() > 0.5 then
										-- subType = 10
									-- else
										-- subType = 11
									-- end
									subType = 1
								end
								if myPlant.SubType ~= subType then
									myPlant.SubType = subType
								end
							end
						end
						
						if myPlant.IsRipe == "Yes" then
							-- Set(myPlant,"RawCottonNr",RawCottonNr)
							Set(myPlant,"IngredientsNr",IngredientsNr)
							Set(myPlant,"TomatoNr",TomatoNr)
							Set(myPlant,"CucumberNr",CucumberNr)
							Set(myPlant,"RoseNr",RoseNr)
							Set(myPlant,"LilyNr",LilyNr)
							Set(myPlant,"SeedOrdered",nil)
							Set(myPlant,"CompostOrdered",nil)
							Set(myPlant,"FastGrowing",nil)
							Set(myPlant,"SuperCompostOrdered",nil)
							Set(myPlant,"FertiOrdered",nil)
							Set(myPlant,"DDTOrdered",nil)
							Set(myPlant,"NeedsPruning","No")
							Set(myPlant,"NeedsTending","No")
							Set(myPlant,"NeedsWater","No")
							Set(myPlant,"NeedsFerti","No")
							Set(myPlant,"NeedsDDT","No")
							
							CancelAllJobs(myPlant)
							
							-- Object.CreateJob(myPlant,"M4_HarvestCottonPlant")
							if IsIndoor(myPlant) == false then
								Object.CreateJob(myPlant,"R4_HarvestGardenPlant")
							else
								Object.CreateJob(myPlant,"R4_HarvestGreenhousePlant")
							end
							
						elseif myPlant.IsEmpty == "Yes" then						
							if not myPlant.SeedOrdered then SpawnMaterial(myPlant,"Seed",1) end
							-- Object.CreateJob(myPlant,"M4_PlantCottonSeed")
							if IsIndoor(myPlant) == false then Object.CreateJob(myPlant,"R4_PlantGardenSeed") else Object.CreateJob(myPlant,"R4_PlantGreenhouseSeed") end
							
						elseif myPlant.IsDead == "Yes" or myPlant.Damage > 0 then
							CancelAllJobs(myPlant)							
							-- Object.CreateJob(myPlant,"M4_RemoveDeadCottonPlant")
							if IsIndoor(myPlant) == false then Object.CreateJob(myPlant,"R4_RemoveDeadGardenPlant") else Object.CreateJob(myPlant,"R4_RemoveDeadGreenhousePlant") end
							
						elseif myPlant.NeedsPruning == "Yes" then
							-- Object.CreateJob(myPlant,"M4_PruneCottonPlant")
							if IsIndoor(myPlant) == false then Object.CreateJob(myPlant,"R4_PruneGardenPlant") else Object.CreateJob(myPlant,"R4_PruneGreenhousePlant") end
							
						elseif CurrentHour >= 8 and CurrentHour <= 22 then
						
							if myPlant.NeedsTending == "Yes" then
							
								if Exists(mySuperCompost) and not myPlant.SuperCompostOrdered then
									local AvailableSuperCompost = mySuperCompost.Quantity - 1
									if AvailableSuperCompost > 0 then
										Set(myPlant,"SuperCompostOrdered",true)
										-- Object.CreateJob(myPlant,"M4_SuperTendCottonPlant")
										Object.CreateJob(myPlant,"R4_SuperTendGardenPlant")
									end
								end
								
								if not myPlant.CompostOrdered then SpawnMaterial(myPlant,"Compost",1) end
								-- Object.CreateJob(myPlant,"M4_TendCottonPlant")
								if IsIndoor(myPlant) == false then Object.CreateJob(myPlant,"R4_TendGardenPlant") else Object.CreateJob(myPlant,"R4_TendGreenhousePlant") end
								
							elseif myPlant.NeedsWater == "Yes" then
							
								-- Object.CreateJob(myPlant,"M4_WaterCottonPlant")
								if IsIndoor(myPlant) == false then Object.CreateJob(myPlant,"R4_WaterGardenPlant") else Object.CreateJob(myPlant,"R4_WaterGreenhousePlant") end
								
							elseif myPlant.NeedsFerti == "Yes" then
							
								if not myPlant.FertiOrdered then SpawnMaterial(myPlant,"Fertilizer",1) end
								-- Object.CreateJob(myPlant,"M4_FertilizeCottonPlant")
								if IsIndoor(myPlant) == false then Object.CreateJob(myPlant,"R4_FertilizeGardenPlant") else Object.CreateJob(myPlant,"R4_FertilizeGreenhousePlant") end
								
							elseif myPlant.NeedsDDT == "Yes" then
							
								if not myPlant.DDTOrdered then SpawnMaterial(myPlant,"DDT",1) end
								-- Object.CreateJob(myPlant,"M4_DDTCottonPlant")
								if IsIndoor(myPlant) == false then Object.CreateJob(myPlant,"R4_DDTGardenPlant") else Object.CreateJob(myPlant,"R4_DDTGreenhousePlant") end
							end
						end
						SetPlantTooltip(myPlant)
					end					
				else
					table.remove(MyPlants,AtCurrentPlant)
					TotalPlantsFound = TotalPlantsFound - 1
					SetMyTooltip()
				end
			end
		end
	end
end

function IssueWaterOrFertiJobs(thePlant)
	if CurrentHour ~= myHarvestHour and PreviousHour ~= CurrentHour then
		if CurrentHour == 8 or CurrentHour == 12 or CurrentHour == 16 or CurrentHour == 20 then
			if thePlant.NeedsPruning == "No" and thePlant.NeedsDDT == "No" and thePlant.NeedsTending == "No" and thePlant.NeedsFerti == "No" and thePlant.IsRipe == "No" and thePlant.IsEmpty == "No" and thePlant.IsDead == "No" then
				thePlant.NeedsFerti = "Yes"	-- do this stuff once at certain hours
			end
		end
	end
	if CurrentHour >= 8 and CurrentHour <= 22 then
		if thePlant.NeedsPruning == "No" and thePlant.NeedsDDT == "No" and thePlant.NeedsTending == "No" and thePlant.NeedsFerti == "No" and thePlant.IsRipe == "No" and thePlant.IsEmpty == "No" and thePlant.IsDead == "No" then
			thePlant.NeedsWater = "Yes" -- damn these plants drink a lot of water, up to 4x during these hours when they get to it
		end
	end
end

function SetMyTooltip()
	local Available = "No"
	if Exists(mySuperCompost) then
		Available = mySuperCompost.Quantity
	end
	-- this.Tooltip = { "tooltip_M4_PlantControl",this.Id.u,"X",HourToHarvest[this.HarvestHour],"A",TotalPlantsFound,"B",this.Range,"C",Available,"D" }
	this.Tooltip = { "tooltip_R4_PlantControl",this.Id.u,"X",HourToHarvest[this.HarvestHour],"A",TotalPlantsFound,"B",this.Range,"C",Available,"D" }
end

function SetPlantTooltip(thePlant)
	if thePlant.IsDead == "Yes" then
		-- thePlant.Tooltip = { "tooltip_M4_PlantSeed",this.Id.u,"X" }
		thePlant.Tooltip = { "tooltip_R4_PlantSeed",this.Id.u,"X" }
	elseif thePlant.IsEmpty == "Yes" then
		-- thePlant.Tooltip = { "tooltip_M4_PlantSeed",this.Id.u,"X" }
		thePlant.Tooltip = { "tooltip_R4_PlantSeed",this.Id.u,"X" }
	else
		if thePlant.FastGrowing == true then
			-- thePlant.Tooltip = { "tooltip_M4_PlantStatus",this.Id.u,"X","tooltip_M4_button_"..thePlant.PlantType,"A","tooltip_M4_FastGrowYes","L",thePlant.AgeHours,"B",thePlant.AgeMinutes,"C",HourToHarvest[thePlant.HarvestHour],"D","tooltip_M4_button_Needs"..thePlant.NeedsTending,"E","tooltip_M4_button_Needs"..thePlant.NeedsWater,"F","tooltip_M4_button_Needs"..thePlant.NeedsDDT,"G","tooltip_M4_button_Needs"..thePlant.NeedsFerti,"H","tooltip_M4_button_Needs"..thePlant.NeedsPruning,"I","tooltip_M4_button_Needs"..thePlant.IsRipe,"J",thePlant.RemainHarvest,"K"}
			thePlant.Tooltip = { "tooltip_R4_PlantStatus",this.Id.u,"X","tooltip_R4_button_"..thePlant.PlantType,"A","tooltip_R4_FastGrowYes","L",thePlant.AgeHours,"B",thePlant.AgeMinutes,"C",HourToHarvest[thePlant.HarvestHour],"D","tooltip_R4_button_Needs"..thePlant.NeedsTending,"E","tooltip_R4_button_Needs"..thePlant.NeedsWater,"F","tooltip_R4_button_Needs"..thePlant.NeedsDDT,"G","tooltip_R4_button_Needs"..thePlant.NeedsFerti,"H","tooltip_R4_button_Needs"..thePlant.NeedsPruning,"I","tooltip_R4_button_Needs"..thePlant.IsRipe,"J",thePlant.RemainHarvest,"K"}
		else
			-- thePlant.Tooltip = { "tooltip_M4_PlantStatus",this.Id.u,"X","tooltip_M4_button_"..thePlant.PlantType,"A","tooltip_M4_FastGrowNo","L",thePlant.AgeHours,"B",thePlant.AgeMinutes,"C",HourToHarvest[thePlant.HarvestHour],"D","tooltip_M4_button_Needs"..thePlant.NeedsTending,"E","tooltip_M4_button_Needs"..thePlant.NeedsWater,"F","tooltip_M4_button_Needs"..thePlant.NeedsDDT,"G","tooltip_M4_button_Needs"..thePlant.NeedsFerti,"H","tooltip_M4_button_Needs"..thePlant.NeedsPruning,"I","tooltip_M4_button_Needs"..thePlant.IsRipe,"J",thePlant.RemainHarvest,"K"}
			thePlant.Tooltip = { "tooltip_R4_PlantStatus",this.Id.u,"X","tooltip_R4_button_"..thePlant.PlantType,"A","tooltip_R4_FastGrowNo","L",thePlant.AgeHours,"B",thePlant.AgeMinutes,"C",HourToHarvest[thePlant.HarvestHour],"D","tooltip_R4_button_Needs"..thePlant.NeedsTending,"E","tooltip_R4_button_Needs"..thePlant.NeedsWater,"F","tooltip_R4_button_Needs"..thePlant.NeedsDDT,"G","tooltip_R4_button_Needs"..thePlant.NeedsFerti,"H","tooltip_R4_button_Needs"..thePlant.NeedsPruning,"I","tooltip_R4_button_Needs"..thePlant.IsRipe,"J",thePlant.RemainHarvest,"K"}
		end
	end
end

function LightOn()
	local myLight = Object.Spawn("Light",this.Pos.x,this.Pos.y)
	this.SubType = 1
end

function LightOff()
	local myLight = this.GetNearbyObjects("Light",1)
	for thatLight, dist in pairs(myLight) do
		thatLight.Delete()
	end
	local myLight = this.GetNearbyObjects("LightOff",1)
	for thatLight, dist in pairs(myLight) do
		thatLight.Delete()
	end
	myLight = nil
	this.SubType = 0
end

function toggleLightClicked()
	if this.NightLight == "On" then
		Set(this,"NightLight","Night")
		if (CurrentHour >= 20 or CurrentHour < 6) and this.LightSpawned == false then
			LightOn()
			Set(this,"LightSpawned",true)
		end
	elseif this.NightLight == "Night" then
		Set(this,"NightLight","Off")
		Set(this,"LightSpawned",false)
		LightOff()
	else
		Set(this,"NightLight","On")
		Set(this,"LightSpawned",true)
		LightOn()
	end
	-- this.SetInterfaceCaption("toggleLight", "tooltip_M4_button_ToggleLights","tooltip_M4_button_"..this.NightLight,"X")
	this.SetInterfaceCaption("toggleLight", "tooltip_R4_button_ToggleLights","tooltip_R4_button_"..this.NightLight,"X")
end

function IsIndoor(thePlant)
	if Exists(thePlant) then
		local cell = World.GetCell(math.floor(thePlant.Pos.x),math.floor(thePlant.Pos.y))
		if cell.Ind == true then return true else return false end
	else
		return false
	end
end

function CheckLightning()
	if this.Lightning == "On" then
		if math.random(1,10000) == 666 then	-- sometimes shit just happens and lightning struck the plantation...
		
			local location = math.random(1,TotalPlantsFound)
			for T = 1, TotalPlantsFound do
				local thatLocation = MyPlants[T]
				if T == location and Exists(thatLocation) and IsIndoor(thatLocation) == false then
					-- local Lightning = Object.Spawn("M4_LightningStrike",thatLocation.Pos.x,thatLocation.Pos.y)
					local Lightning = Object.Spawn("R4_LightningStrike",thatLocation.Pos.x,thatLocation.Pos.y)
					Lightning.Intensity = 2
					Lightning.Start = true
					-- if math.random() > 0.5 then
						-- thatLocation.SubType = 12
					-- else
						-- thatLocation.SubType = 13
					-- end
					Set(thatLocation,"SubType", 10)
					Set(thatLocation,"Damage", 0.85)
					Set(thatLocation,"IsDead","Yes")
					
					-- thatLocation.Sound("CottonPlant","Lightning")
					-- thatLocation.Tooltip = { "tooltip_M4_PlantStruck",this.Id.u,"X" }
					-- Object.CreateJob(thatLocation,"M4_RemoveStruckCottonPlant")
					-- this.Tooltip = { "tooltip_M4_PlantControlLightning",this.Id.u,"X" }
					
					thatLocation.Sound("GardenPlant","Lightning")
					thatLocation.Tooltip = { "tooltip_R4_PlantStruck",this.Id.u,"X" }
					Object.CreateJob(thatLocation,"R4_RemoveStruckGardenPlant")
					this.Tooltip = { "tooltip_R4_PlantControlLightning",this.Id.u,"X" }
					
					Object.Spawn("Fire",thatLocation.Pos.x-0.5+math.random(),thatLocation.Pos.y-0.5+math.random())
					Object.Spawn("Fire",thatLocation.Pos.x-0.5+math.random(),thatLocation.Pos.y-0.5+math.random())
					Object.Spawn("Fire",thatLocation.Pos.x-0.5+math.random(),thatLocation.Pos.y-0.5+math.random())
					break
				end
			end
			return
		end
	end
end

function InitControl()
	FindStackNumbers()
	RemoveMyStacks()
	if not this.FloorMade then
	
		local CompactFloor = {
					{ 2, 1, 1, 1, 2},
					{ 1, 1, 1, 1, 1},
					{ 1, 1, 1, 1, 1},
					}
					
		local OutdoorTiles = {
					[1] = "Stone",
					[2] = "LongGrass"
					}
					
		-- local IndoorTiles = {
					-- [1] = "ConcreteTiles",
					-- [2] = "ConcreteFloor"
					-- }
					
		local x = this.Pos.x-3
		local y = this.Pos.y-2
			
		for X = 1,5 do
			for Y = 1,3 do
				local cell = World.GetCell(x+X,y+Y)
				if cell.Ind == true then
					-- cell.Mat = IndoorTiles[CompactFloor[Y][X]]
				else
					cell.Mat = OutdoorTiles[CompactFloor[Y][X]]
				end
			end
		end
		Set(this,"FloorMade",true)
	end
	myHarvestHour = Get(this,"HarvestHour")
	myTimeWarpFactor = World.TimeWarpFactor
	plantRange = Get(this,"Range")
	
	-- Interface.AddComponent(this,"toggleScanArea", "Button", "tooltip_M4_button_ScanArea")
	-- Interface.AddComponent(this,"CaptionSeparatorCotton1", "Caption", "tooltip_M4_SeparatorLine")
	-- Interface.AddComponent(this,"togglePlantRangePlus", "Button", "tooltip_M4_button_ChangeRangePlus")
	-- Interface.AddComponent(this,"toggleShowCoveredPlantArea", "Button", "tooltip_M4_button_ShowHideRange",this.Range,"X")
	-- Interface.AddComponent(this,"togglePlantRangeMinus", "Button", "tooltip_M4_button_ChangeRangeMinus")
	
	-- Interface.AddComponent(this,"CaptionSeparatorCotton2", "Caption", "tooltip_M4_SeparatorLine")
	-- Interface.AddComponent(this,"toggleType", "Button", "tooltip_M4_button_PlantType","tooltip_M4_button_"..this.PlantType,"X")
	-- Interface.AddComponent(this,"toggleLight", "Button", "tooltip_M4_button_ToggleLights","tooltip_M4_button_"..this.NightLight,"X")
	-- Interface.AddComponent(this,"CaptionSeparatorCotton3", "Caption", "tooltip_M4_SeparatorLine")
		
	-- Interface.AddComponent(this,"toggleHarvestHourPlus", "Button", "tooltip_M4_button_HarvestHourPlus")
	-- Interface.AddComponent(this,"toggleHarvestHour", "Button", "tooltip_M4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
	-- Interface.AddComponent(this,"toggleHarvestHourMinus", "Button", "tooltip_M4_button_HarvestHourMinus")

	-- if World.EnabledEvents == true or World.EnabledWeather == true then
		-- Interface.AddComponent(this,"CaptionSeparatorWeather", "Caption", "tooltip_M4_SeparatorWeather")
		-- Interface.AddComponent(this,"toggleLightningStrike", "Button", "tooltip_M4_button_ToggleLightning","tooltip_M4_button_"..this.Lightning,"X")
	-- end
	
	Interface.AddComponent(this,"toggleScanArea", "Button", "tooltip_R4_button_ScanArea")
	Interface.AddComponent(this,"CaptionSeparatorGarden1", "Caption", "tooltip_R4_SeparatorLine")
	Interface.AddComponent(this,"togglePlantRangePlus", "Button", "tooltip_R4_button_ChangeRangePlus")
	Interface.AddComponent(this,"toggleShowCoveredPlantArea", "Button", "tooltip_R4_button_ShowHideRange",this.Range,"X")
	Interface.AddComponent(this,"togglePlantRangeMinus", "Button", "tooltip_R4_button_ChangeRangeMinus")
	
	Interface.AddComponent(this,"CaptionSeparatorGarden2", "Caption", "tooltip_R4_SeparatorLine")
	Interface.AddComponent(this,"toggleType", "Button", "tooltip_R4_button_PlantType","tooltip_R4_button_"..this.PlantType,"X")
	Interface.AddComponent(this,"toggleLight", "Button", "tooltip_R4_button_ToggleLights","tooltip_R4_button_"..this.NightLight,"X")
	Interface.AddComponent(this,"CaptionSeparatorGarden3", "Caption", "tooltip_R4_SeparatorLine")
		
	Interface.AddComponent(this,"toggleHarvestHourPlus", "Button", "tooltip_R4_button_HarvestHourPlus")
	Interface.AddComponent(this,"toggleHarvestHour", "Button", "tooltip_R4_button_HarvestHour",HourToHarvest[this.HarvestHour],"X")
	Interface.AddComponent(this,"toggleHarvestHourMinus", "Button", "tooltip_R4_button_HarvestHourMinus")

	if World.EnabledEvents == true or World.EnabledWeather == true then
		Interface.AddComponent(this,"CaptionSeparatorWeather", "Caption", "tooltip_R4_SeparatorWeather")
		Interface.AddComponent(this,"toggleLightningStrike", "Button", "tooltip_R4_button_ToggleLightning","tooltip_R4_button_"..this.Lightning,"X")
	end
	
	CurrentMinute = math.floor(math.mod(World.TimeIndex,60))
	if CurrentMinute >= 45 then
		timePerUpdate = (60 - CurrentMinute )+math.random()+math.random()+math.random() / myTimeWarpFactor	-- next update is 1 minute after the next whole hour.
	elseif CurrentMinute >= 30 then
		timePerUpdate = (45 - CurrentMinute )+math.random()+math.random()+math.random() / myTimeWarpFactor	-- next update is 15 minutes before the next whole hour.
	elseif CurrentMinute >= 15 then
		timePerUpdate = (30 - CurrentMinute )+math.random()+math.random()+math.random() / myTimeWarpFactor	-- next update is 30 minutes past current hour.
	else
		timePerUpdate = (15 - CurrentMinute )+math.random()+math.random()+math.random() / myTimeWarpFactor	-- next update is 15 minutes past current hour.
	end
	toggleScanAreaClicked()
	SetMyTooltip()
end

function toggleScanAreaClicked()
	print("ScanArea")
	MyPlants = {}
	AtCurrentPlant = 0
	TotalPlantsFound = 0
	local myPlants = Find(PlantToFind,this.Range)
	if next(myPlants) then
		for myPlant, dist in pairs(myPlants) do
			TotalPlantsFound = TotalPlantsFound + 1
			MyPlants[TotalPlantsFound] = myPlant
			Set(myPlant,"ControlUID",this.Id.u)
			if myPlant.IsEmpty ~= nil then
				CancelAllJobs(myPlant)
				if myPlant.IsEmpty == "Yes" then Set(myPlant,"SeedOrdered",nil) end
				Set(myPlant,"CompostOrdered",nil)
				Set(myPlant,"SuperCompostOrdered",nil)
				Set(myPlant,"FertiOrdered",nil)
				Set(myPlant,"DDTOrdered",nil)
				if myPlant.IsEmpty == "No" and myPlant.IsDead == "No" then
					local subType = 1
					local rndSubType = 0
					-- if math.random() > 0.5 then
						-- rndSubType = 4
					-- end
					if myPlant.AgeHours >= deathAge then	-- harvest failed within reasonable time, plant dies
						Set(myPlant,"IsDead","Yes")
						-- if math.random() > 0.5 then
							-- subType = 10
						-- else
							-- subType = 11
						-- end
						subType = 1
					elseif myPlant.AgeHours >= maxAge and myHarvestHour == 0 then					-- plant life at 100% then harvest if myHarvestHour is disabled
						subType = subToPlantType[Get(myPlant,"PlantType")]+rndSubType
						Set(myPlant,"IsRipe", "Yes")
					elseif myPlant.AgeHours >= 18 then
						subType = subToPlantType[Get(myPlant,"PlantType")]+rndSubType
					elseif myPlant.AgeHours >= 12 then
						-- subType = 3+rndSubType
						subType = 2
					-- elseif myPlant.AgeHours >=6 then
						-- subType = 2+rndSubType
					end
					if math.random(0,666) == 11 then		-- oops, plant died for some reason
						Set(myPlant,"IsDead","Yes")
						-- if math.random() > 0.5 then
							-- subType = 10
						-- else
							-- subType = 11
						-- end
						subType = 1
					end
					if myPlant.SubType ~= subType then
						myPlant.SubType = subType
					end
					SetPlantTooltip(myPlant)
				end
			else
				InitPlant(myPlant)
			end				
		end
	end
	myPlants = nil
	SetMyTooltip()
end

function CancelAllJobs(thisPlant)
	-- Object.CancelJob(thisPlant,"M4_PlantCottonSeed")
	-- Object.CancelJob(thisPlant,"M4_RemoveDeadCottonPlant")
	-- Object.CancelJob(thisPlant,"M4_PruneCottonPlant")
	-- Object.CancelJob(thisPlant,"M4_TendCottonPlant")
	-- Object.CancelJob(thisPlant,"M4_SuperTendCottonPlant")
	-- Object.CancelJob(thisPlant,"M4_WaterCottonPlant")
	-- Object.CancelJob(thisPlant,"M4_FertilizeCottonPlant")
	-- Object.CancelJob(thisPlant,"M4_DDTCottonPlant")
	-- Object.CancelJob(thisPlant,"M4_HarvestCottonPlant")
	
	if IsIndoor(thisPlant) == false then
		Object.CancelJob(thisPlant,"R4_PlantGardenSeed")
		Object.CancelJob(thisPlant,"R4_RemoveDeadGardenPlant")
		Object.CancelJob(thisPlant,"R4_PruneGardenPlant")
		Object.CancelJob(thisPlant,"R4_TendGardenPlant")
		Object.CancelJob(thisPlant,"R4_SuperTendGardenPlant")
		Object.CancelJob(thisPlant,"R4_WaterGardenPlant")
		Object.CancelJob(thisPlant,"R4_FertilizeGardenPlant")
		Object.CancelJob(thisPlant,"R4_DDTGardenPlant")
		Object.CancelJob(thisPlant,"R4_HarvestGardenPlant")
	else
		Object.CancelJob(thisPlant,"R4_PlantGreenhouseSeed")
		Object.CancelJob(thisPlant,"R4_RemoveDeadGreenhousePlant")
		Object.CancelJob(thisPlant,"R4_PruneGreenhousePlant")
		Object.CancelJob(thisPlant,"R4_TendGreenhousePlant")
		Object.CancelJob(thisPlant,"R4_SuperTendGardenPlant")
		Object.CancelJob(thisPlant,"R4_WaterGreenhousePlant")
		Object.CancelJob(thisPlant,"R4_FertilizeGreenhousePlant")
		Object.CancelJob(thisPlant,"R4_DDTGreenhousePlant")
		Object.CancelJob(thisPlant,"R4_HarvestGreenhousePlant")
	end
end

function Find(theObject,theRange) -- returns target objects in a square around the object
	local Xmin = math.ceil(this.Pos.x-theRange/2)
	local Xmax = math.ceil(this.Pos.x+theRange/2)
	local Ymin = math.ceil(this.Pos.y-theRange/2)
	local Ymax = math.ceil(this.Pos.y+theRange/2)
	local ListOfObjects = this.GetNearbyObjects(theObject,theRange*1.2)
	for thatObject, distance in pairs(ListOfObjects) do
		if (thatObject.Pos.x >= Xmin and thatObject.Pos.x <= Xmax) and (thatObject.Pos.y >= Ymin and thatObject.Pos.y <= Ymax) then
		-- it's ok, put other stuff here if you need
		else
			ListOfObjects[thatObject] = nil -- remove the out of bounds object from the list
		end
	end
	return ListOfObjects
end	

-- function HideCoveredArea(theCoverType)
	-- for n,v in pairs(CoveredArea[theCoverType]) do
		-- CoveredArea[theCoverType][n].Delete()
	-- end
	-- CoveredArea[theCoverType] = nil
-- end

function ShowCoveredArea(theRange,theCoverType)
	local Xmin = math.ceil(this.Pos.x-theRange/2)
	local Xmax = math.ceil(this.Pos.x+theRange/2)
	local Ymin = math.ceil(this.Pos.y-theRange/2)
	local Ymax = math.ceil(this.Pos.y+theRange/2)
	local n = 0
	CoveredArea[theCoverType] = {}
	for i = Ymin,Ymax do
		CoveredArea[theCoverType][n] = Object.Spawn(theCoverType.."AreaCovered",Xmin,i)
		-- CoveredArea[theCoverType][n].Tooltip={"tooltip_M4_CoveredPlantArea"}
		CoveredArea[theCoverType][n].Tooltip={"tooltip_R4_CoveredPlantArea"}
		n = n + 1
	end
	for i = Xmin,Xmax do
		CoveredArea[theCoverType][n] = Object.Spawn(theCoverType.."AreaCovered",i,Ymin)
		-- CoveredArea[theCoverType][n].Tooltip={"tooltip_M4_CoveredPlantArea"}
		CoveredArea[theCoverType][n].Tooltip={"tooltip_R4_CoveredPlantArea"}
		n = n + 1
	end
	for i = Ymin,Ymax do
		CoveredArea[theCoverType][n] = Object.Spawn(theCoverType.."AreaCovered",Xmax,i)
		-- CoveredArea[theCoverType][n].Tooltip={"tooltip_M4_CoveredPlantArea"}
		CoveredArea[theCoverType][n].Tooltip={"tooltip_R4_CoveredPlantArea"}
		n = n + 1
	end
	for i = Xmin,Xmax do
		CoveredArea[theCoverType][n] = Object.Spawn(theCoverType.."AreaCovered",i,Ymax)
		-- CoveredArea[theCoverType][n].Tooltip={"tooltip_M4_CoveredPlantArea"}
		CoveredArea[theCoverType][n].Tooltip={"tooltip_R4_CoveredPlantArea"}
		n = n + 1
	end
end

function Exists(theObject)
	if theObject ~= nil and theObject.SubType ~= nil then
		return true
	else
		return false
	end
end
