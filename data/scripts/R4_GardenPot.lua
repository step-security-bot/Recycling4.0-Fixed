
local Get = Object.GetProperty
local Set = Object.SetProperty

local HourToHarvest = { [0] = "disabled", [1] = "01:00", [2] = "02:00", [3] = "03:00", [4] = "04:00", [5] = "05:00", [6] = "06:00", [7] = "07:00", [8] = "08:00", [9] = "09:00", [10] = "10:00", [11] = "11:00", [12] = "12:00", [13] = "13:00", [14] = "14:00", [15] = "15:00", [16] = "16:00", [17] = "17:00", [18] = "18:00", [19] = "19:00", [20] = "20:00", [21] = "21:00", [22] = "22:00", [23] = "23:00" }

function Create()
	-- Set(this,"PlantType", "Cotton")
	-- Set(this,"Tooltip","tooltip_M4_need_CottonControl")
	Set(this,"Tooltip","tooltip_R4_need_GardenControl")
end


---


function JobComplete_R4_SuperTendGardenPlant()
	Object.CancelJob(myPlant,"R4_TendGardenPlant")
	Object.CancelJob(myPlant,"R4_TendGreenhousePlant")
	Set(this,"SuperCompostOrdered",nil)
	Set(this,"CompostOrdered",nil)
    Set(this,"NeedsTending","No")
	if this.NeedsDDT == "No" and this.IsRipe == "No" and this.IsDead == "No" then
		Set(this,"NeedsDDT","Yes")
	end
	Set(this,"FastGrowing",true)
	Set(this,"AgeHours", this.AgeHours + 1) -- grow faster
	SetPlantTooltip()
end


---


function JobComplete_R4_PlantGardenSeed()
	Set(this,"SeedOrdered",nil)
    Set(this,"IsEmpty", "No")
	Set(this,"AgeHours", 0.0)
	Set(this,"AgeMinutes", 0.0)
--	if math.random() > .5 then
		Set(this,"SubType", 1)
--			else
--		Set(this,"SubType", 5)
--	end
	Set(this,"RemainHarvest", math.random(3,6))			-- can be harvested 3-6 times before the plant is dead and a new seed must be planted

	if this.NeedsTending == "No" and this.IsRipe == "No" and this.IsDead == "No" then
		Set(this,"NeedsTending", "Yes")
	end
	SetPlantTooltip()
end

function JobComplete_R4_TendGardenPlant()
	Object.CancelJob(myPlant,"R4_SuperTendGardenPlant")
	Set(this,"SuperCompostOrdered",nil)
	Set(this,"CompostOrdered",nil)
    Set(this,"NeedsTending","No")
	if this.NeedsDDT == "No" and this.IsRipe == "No" and this.IsDead == "No" then
		Set(this,"NeedsDDT","Yes")
	end
	if this.FastGrowing == true then Set(this,"AgeHours", this.AgeHours + 1) end -- due to SuperCompost
	SetPlantTooltip()
end

function JobComplete_R4_PruneGardenPlant()
	Set(this,"AgeHours", 0.0)
	Set(this,"AgeMinutes", 0.0)
--	if math.random() > .5 then
		Set(this,"SubType", 0)
	-- else
--		Set(this,"SubType", 5)
--	end
	local name = Object.Spawn( "R4_GardenPrunedPlant", this.Pos.x, this.Pos.y )
	local velX = -1.0 + math.random() + math.random()
	local velY = -1.0 + math.random() + math.random()
	Object.ApplyVelocity(name, velX, velY)
	
	Set(this,"NeedsPruning","No")
	if this.NeedsTending == "No" and this.IsRipe == "No" and this.IsDead == "No" then
		Set(this,"NeedsTending","Yes")
	end
	SetPlantTooltip()
end

function JobComplete_R4_WaterGardenPlant()
    Set(this,"NeedsWater","No")
	if this.FastGrowing then Set(this,"AgeHours", this.AgeHours + 1) end -- due to SuperCompost
	SetPlantTooltip()
end

function JobComplete_R4_FertilizeGardenPlant()
	Set(this,"FertiOrdered",nil)
    Set(this,"NeedsFerti","No")
	if this.NeedsDDT == "No" and this.IsRipe == "No" and this.IsDead == "No" then
		Set(this,"NeedsDDT","Yes")
	end
	if this.FastGrowing then Set(this,"AgeHours", this.AgeHours + 1) end -- due to SuperCompost
	SetPlantTooltip()
end

function JobComplete_R4_DDTGardenPlant()
	Set(this,"DDTOrdered",nil)
    Set(this,"NeedsDDT","No")
	SetPlantTooltip()
end

function JobComplete_R4_RemoveStruckGardenPlant()
	Object.CancelJob(this,"R4_RemoveDeadGardenPlant")
	local name = Object.Spawn( "R4_GardenPlantStruck", this.Pos.x, this.Pos.y )
	local velX = -1.0 + math.random() + math.random()
	local velY = -1.0 + math.random() + math.random()
	Object.ApplyVelocity(name, velX, velY)
	Set(this,"IsEmpty",nil)
	Set(this,"SeedOrdered",nil)
	Set(this,"SubType",0)
	SetPlantTooltip()
end

function JobComplete_R4_RemoveDeadGardenPlant()
	Object.CancelJob(this,"R4_RemoveStruckGardenPlant")
	local name = Object.Spawn( "R4_GardenDeadPlant", this.Pos.x, this.Pos.y )
	local velX = -1.0 + math.random() + math.random()
	local velY = -1.0 + math.random() + math.random()
	Object.ApplyVelocity(name, velX, velY)
	Set(this,"IsEmpty",nil)
	Set(this,"SeedOrdered",nil)
	Set(this,"SubType",0)
	SetPlantTooltip()
end

function JobComplete_R4_HarvestGardenPlant()
	Set(this,"AgeHours", 0.0)
	Set(this,"AgeMinutes", 0.0)
	Set(this,"IsRipe","No")
	
	if IngredientsNr == nil then FindStackNumbers() end
	
	if this.PlantType=="Potatoes" then
		local name = Object.Spawn("Stack", this.Pos.x, this.Pos.y )
		Set(name, "Contents",IngredientsNr)	-- http://devwiki.introversion.co.uk/pa/index.php/ModSchema
	 	Set(name, "SubType",1)
		if this.FastGrowing == true and this.HarvestHour > 0 then Set(name, "Quantity",20) else Set(name, "Quantity",10) end
		local velX = -1.0 + math.random() + math.random()
		local velY = -1.0 + math.random() + math.random()
		Object.ApplyVelocity(name, velX, velY)
	elseif this.PlantType=="Ingredients" then
		local name = Object.Spawn("Stack", this.Pos.x, this.Pos.y )
		Set(name, "Contents",IngredientsNr)	-- http://devwiki.introversion.co.uk/pa/index.php/ModSchema
	 	Set(name, "SubType",0)
		if this.FastGrowing == true and this.HarvestHour > 0 then Set(name, "Quantity",20) else Set(name, "Quantity",10) end
		local velX = -1.0 + math.random() + math.random()
		local velY = -1.0 + math.random() + math.random()
		Object.ApplyVelocity(name, velX, velY)
	else
		local myContents = TomatoNr
		if this.PlantType == "GardenCucumber" then myContents = CucumberNr
		elseif this.PlantType == "GardenRose" then myContents = RoseNr
		elseif this.PlantType == "GardenLily" then myContents = LilyNr end
		
		local name = Object.Spawn("Stack", this.Pos.x, this.Pos.y )
		Set(name, "Contents",myContents)
		if this.FastGrowing == true and this.HarvestHour > 0 then Set(name, "Quantity",20) else Set(name, "Quantity",10) end
		local velX = -1.0 + math.random() + math.random()
		local velY = -1.0 + math.random() + math.random()
		Object.ApplyVelocity(name, velX, velY)
	end
	
	Set(this,"FastGrowing",nil) -- stop fast growing after harvest due to SuperCompost
	
--	if math.random() > .5 then
--		Set(this,"SubType", 10)
--			else
		Set(this,"SubType", 1)
--	end
	if this.RemainHarvest == 0 then		-- harvest times before plant is dead and needs replacement
		Set(this,"IsDead", "Yes")
	else
		if this.NeedsPruning == "No" and this.IsRipe == "No" and this.IsDead == "No" then
			Set(this,"NeedsPruning","Yes")
		end
		if this.PlantType~="Potatoes" and this.PlantType~="Ingredients" then
			Set(this,"RemainHarvest", this.RemainHarvest-1)
		end
	end
	
	SetPlantTooltip()
end







function JobComplete_R4_PlantGreenhouseSeed()
	Set(this,"SeedOrdered",nil)
    Set(this,"IsEmpty", "No")
	Set(this,"AgeHours", 0.0)
	Set(this,"AgeMinutes", 0.0)
--	if math.random() > .5 then
		Set(this,"SubType", 1)
--			else
--		Set(this,"SubType", 5)
--	end
	Set(this,"RemainHarvest", math.random(3,6))			-- can be harvested 3-6 times before the plant is dead and a new seed must be planted

	if this.NeedsTending == "No" and this.IsRipe == "No" and this.IsDead == "No" then
		Set(this,"NeedsTending", "Yes")
	end
	SetPlantTooltip()
end

function JobComplete_R4_TendGreenhousePlant()
	Object.CancelJob(myPlant,"R4_SuperTendGardenPlant")
	Set(this,"SuperCompostOrdered",nil)
	Set(this,"CompostOrdered",nil)
    Set(this,"NeedsTending","No")
	if this.NeedsDDT == "No" and this.IsRipe == "No" and this.IsDead == "No" then
		Set(this,"NeedsDDT","Yes")
	end
	if this.FastGrowing then Set(this,"AgeHours", this.AgeHours + 1) end -- due to SuperCompost
	SetPlantTooltip()
end

function JobComplete_R4_PruneGreenhousePlant()
	Set(this,"AgeHours", 0.0)
	Set(this,"AgeMinutes", 0.0)
--	if math.random() > .5 then
		Set(this,"SubType", 1)
--			else
--		Set(this,"SubType", 5)
--	end
	local name = Object.Spawn( "R4_GardenPrunedPlant", this.Pos.x, this.Pos.y )
	local velX = -1.0 + math.random() + math.random()
	local velY = -1.0 + math.random() + math.random()
	Object.ApplyVelocity(name, velX, velY)
	
	Set(this,"NeedsPruning","No")
	if this.NeedsTending == "No" and this.IsRipe == "No" and this.IsDead == "No" then
		Set(this,"NeedsTending","Yes")
	end
	SetPlantTooltip()
end

function JobComplete_R4_WaterGreenhousePlant()
    Set(this,"NeedsWater","No")
	if this.FastGrowing then Set(this,"AgeHours", this.AgeHours + 1) end -- due to SuperCompost
	SetPlantTooltip()
end

function JobComplete_R4_FertilizeGreenhousePlant()
	Set(this,"FertiOrdered",nil)
    Set(this,"NeedsFerti","No")
	
	if this.NeedsDDT == "No" and this.IsRipe == "No" and this.IsDead == "No" then
		Set(this,"NeedsDDT","Yes")
	end
	if this.FastGrowing then Set(this,"AgeHours", this.AgeHours + 1) end -- due to SuperCompost
	SetPlantTooltip()
end

function JobComplete_R4_DDTGreenhousePlant()
	Set(this,"DDTOrdered",nil)
    Set(this,"NeedsDDT","No")
	SetPlantTooltip()
end

function JobComplete_R4_RemoveStruckGreenhousePlant()
	Object.CancelJob(this,"R4_RemoveDeadGardenPlant")
	local name = Object.Spawn( "R4_GardenPlantStruck", this.Pos.x, this.Pos.y )
	local velX = -1.0 + math.random() + math.random()
	local velY = -1.0 + math.random() + math.random()
	Object.ApplyVelocity(name, velX, velY)
	Set(this,"IsEmpty",nil)
	Set(this,"SeedOrdered",nil)
	Set(this,"SubType",0)
	SetPlantTooltip()
end

function JobComplete_R4_RemoveDeadGreenhousePlant()
	Object.CancelJob(this,"R4_RemoveStruckGardenPlant")
	local name = Object.Spawn( "R4_GardenDeadPlant", this.Pos.x, this.Pos.y )
	local velX = -1.0 + math.random() + math.random()
	local velY = -1.0 + math.random() + math.random()
	Object.ApplyVelocity(name, velX, velY)
	Set(this,"IsEmpty",nil)
	Set(this,"SeedOrdered",nil)
	Set(this,"SubType",0)
	SetPlantTooltip()
end

function JobComplete_R4_HarvestGreenhousePlant()
	Set(this,"AgeHours", 0.0)
	Set(this,"AgeMinutes", 0.0)
	Set(this,"IsRipe","No")
	
	if IngredientsNr == nil then FindStackNumbers() end
	
	if this.PlantType=="Potatoes" then
		local name = Object.Spawn("Stack", this.Pos.x, this.Pos.y )
		Set(name, "Contents",IngredientsNr)	-- http://devwiki.introversion.co.uk/pa/index.php/ModSchema
	 	Set(name, "SubType",1)
		if this.FastGrowing == true and this.HarvestHour > 0 then Set(name, "Quantity",20) else Set(name, "Quantity",10) end
		local velX = -1.0 + math.random() + math.random()
		local velY = -1.0 + math.random() + math.random()
		Object.ApplyVelocity(name, velX, velY)
	elseif this.PlantType=="Ingredients" then
		local name = Object.Spawn("Stack", this.Pos.x, this.Pos.y )
		Set(name, "Contents",IngredientsNr)	-- http://devwiki.introversion.co.uk/pa/index.php/ModSchema
	 	Set(name, "SubType",0)			
		if this.FastGrowing == true and this.HarvestHour > 0 then Set(name, "Quantity",20) else Set(name, "Quantity",10) end
		local velX = -1.0 + math.random() + math.random()
		local velY = -1.0 + math.random() + math.random()
		Object.ApplyVelocity(name, velX, velY)
	else
		local myContents = TomatoNr
		if this.PlantType == "GardenCucumber" then myContents = CucumberNr
		elseif this.PlantType == "GardenRose" then myContents = RoseNr
		elseif this.PlantType == "GardenLily" then myContents = LilyNr end
		
		local name = Object.Spawn("Stack", this.Pos.x, this.Pos.y )
		Set(name, "Contents",myContents)
		if this.FastGrowing == true and this.HarvestHour > 0 then Set(name, "Quantity",20) else Set(name, "Quantity",10) end
		local velX = -1.0 + math.random() + math.random()
		local velY = -1.0 + math.random() + math.random()
		Object.ApplyVelocity(name, velX, velY)
	end
	
	Set(this,"FastGrowing",nil) -- stop fast growing after harvest due to SuperCompost
	
--	if math.random() > .5 then
--		Set(this,"SubType", 10)
--			else
		Set(this,"SubType", 1)
--	end
	if this.RemainHarvest == 0 then		-- harvest times before plant is dead and needs replacement
		Set(this,"IsDead", "Yes")
	else
		if this.NeedsPruning == "No" and this.IsRipe == "No" and this.IsDead == "No" then
			Set(this,"NeedsPruning","Yes")
		end
		if this.PlantType~="Potatoes" and this.PlantType~="Ingredients" then
			Set(this,"RemainHarvest", this.RemainHarvest-1)
		end
	end
	
	SetPlantTooltip()
end

function SetPlantTooltip()
	if this.IsDead == "Yes" then
		this.Tooltip = { "tooltip_R4_PlantDead",this.ControlUID,"X" }
	elseif this.IsEmpty == nil or this.IsEmpty == "Yes" then
		this.Tooltip = { "tooltip_R4_PlantSeed",this.ControlUID,"X" }
	else
		if this.FastGrowing == true then
			this.Tooltip = { "tooltip_R4_PlantStatus",this.ControlUID,"X","tooltip_R4_button_"..this.PlantType,"A","tooltip_R4_FastGrowYes","L",this.AgeHours,"B",this.AgeMinutes,"C",HourToHarvest[this.HarvestHour],"D","tooltip_R4_button_Needs"..this.NeedsTending,"E","tooltip_R4_button_Needs"..this.NeedsWater,"F","tooltip_R4_button_Needs"..this.NeedsDDT,"G","tooltip_R4_button_Needs"..this.NeedsFerti,"H","tooltip_R4_button_Needs"..this.NeedsPruning,"I","tooltip_R4_button_Needs"..this.IsRipe,"J", this.RemainHarvest,"K"}
		else
			this.Tooltip = { "tooltip_R4_PlantStatus",this.ControlUID,"X","tooltip_R4_button_"..this.PlantType,"A","tooltip_R4_FastGrowNo","L",this.AgeHours,"B",this.AgeMinutes,"C",HourToHarvest[this.HarvestHour],"D","tooltip_R4_button_Needs"..this.NeedsTending,"E","tooltip_R4_button_Needs"..this.NeedsWater,"F","tooltip_R4_button_Needs"..this.NeedsDDT,"G","tooltip_R4_button_Needs"..this.NeedsFerti,"H","tooltip_R4_button_Needs"..this.NeedsPruning,"I","tooltip_R4_button_Needs"..this.IsRipe,"J", this.RemainHarvest,"K"}
		end
	end
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
		if totalFound == 5 then
			newStack.Delete()
			break
		end
	end
end
