
local timeTot = 0
local DeskFound = false
local retrycounter = 0

local StackNumbers = { [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10] = 0, [11] = 0 }
local SalvagedWaste = { [1] = "R4_GreenGarbage", [2] = "SheetMetal", [3] = "Log", [4] = "Wood", [5] = "LibraryBookSorted", [6] = "LicensePlate", [7] = "DirtyPrisonerUniform", [8] = "FoodTrayDirty", [9] = "CrumpledPrisonerUniform", [10] = "ShopGoods", [11] = "Ingredients" }
local SalvagedItem = 1
local SpawnThis = { [1] = "Yes", [2] = "Yes", [3] = "Yes", [4] = "Yes", [5] = "Yes", [6] = "Yes", [7] = "Yes", [8] = "Yes", [9] = "Yes", [10] = "Yes", [11] = "Yes" }

local Direction1 = {									-- when Or.x = 0 & Or.y = 1
		[1] = { X = -3, Y = 0, PosX = -2, PosY = 1 },			-- R4_GreenGarbage
		[2] = { X = 3, Y = 0, PosX = 2, PosY = 1 },				-- SheetMetal
		[3] = { X = 1.75, Y = 1.25, PosX = 1, PosY = 2 },		-- Log
		[4] = { X = 3.25, Y = -1.5, PosX = 2, PosY = 0 },		-- Wood
		[5] = { X = 3, Y = -3, PosX = 2, PosY = -1 },			-- LibraryBookSorted
		[6] = { X = 1.75, Y = -3, PosX = 1, PosY = -1 },		-- LicensePlate
		[7] = { X = 0, Y = -3, PosX = 0, PosY = -1 },			-- DirtyPrisonerUniform
		[8] = { X = -3, Y = -3, PosX = -2, PosY = -1 },			-- FoodTrayDirty
		[9] = { X = -1.25, Y = -3.25, PosX = -1, PosY = -1 },	-- CrumpledPrisonerUniform
		[10] = { X = -3.25, Y = -1.5, PosX = -2, PosY = 0 },	-- ShopGoods
		[11] = { X = -1.75, Y = 0.25, PosX = -1, PosY = 1.5 }	-- Ingredients
	}
	
local Direction2 = {									-- when Or.x = 0 & Or.y = -1
		[1] = { X = 3, Y = 0, PosX = 2, PosY = -1 },			-- R4_GreenGarbage
		[2] = { X = -3, Y = 0, PosX = -2, PosY = -1 },			-- SheetMetal
		[3] = { X = 1.75, Y = -1.25, PosX = 1, PosY = -2 },		-- Log
		[4] = { X = -3.25, Y = 1.5, PosX = -2, PosY = 0 },		-- Wood
		[5] = { X = -3, Y = 3, PosX = -2, PosY = 1 },			-- LibraryBookSorted
		[6] = { X = -1.75, Y = 3, PosX = -1, PosY = 1 },		-- LicensePlate
		[7] = { X = 0, Y = 3, PosX = 0, PosY = 1 },				-- DirtyPrisonerUniform
		[8] = { X = 3, Y = 3, PosX = 2, PosY = 1 },				-- FoodTrayDirty
		[9] = { X = 1.25, Y = 3.25, PosX = 1, PosY = 1 },		-- CrumpledPrisonerUniform
		[10] = { X = 3.25, Y = 1.5, PosX = 2, PosY = 0 },		-- ShopGoods
		[11] = { X = -1.75, Y = -0.5, PosX = -1, PosY = -1.5 }	-- Ingredients
	}
	
local Direction3 = {									-- when Or.x = -1 & Or.y = 0
		[1] = { X = 0, Y = -3, PosX = -1, PosY = -2 },			-- R4_GreenGarbage
		[2] = { X = 0, Y = 3, PosX = -1, PosY = 2 },			-- SheetMetal
		[3] = { X = -1.5, Y = 1, PosX = -2, PosY = 1 },			-- Log
		[4] = { X = 1.5, Y = 3, PosX = 0, PosY = 2 },			-- Wood
		[5] = { X = 3, Y = 3, PosX = 1, PosY = 2 },				-- LibraryBookSorted
		[6] = { X = 3, Y = 1.5, PosX = 1, PosY = 1 },			-- LicensePlate
		[7] = { X = 3, Y = 0, PosX = 1, PosY = 0 },				-- DirtyPrisonerUniform
		[8] = { X = 3, Y = -3, PosX = 1, PosY = -2 },			-- FoodTrayDirty
		[9] = { X = 3, Y = -1.5, PosX = 1, PosY = -1 },			-- CrumpledPrisonerUniform
		[10] = { X = 1.25, Y = -3, PosX = 0, PosY = -2 },		-- ShopGoods
		[11] = { X = -0.75, Y = -1.5, PosX = -1.5, PosY = -1 }	-- Ingredients
	}
	
local Direction4 = {									-- when Or.x = 1 & Or.y = 0
		[1] = { X = 0, Y = -3, PosX = 1, PosY = -2 },			-- R4_GreenGarbage
		[2] = { X = 0, Y = 3, PosX = 1, PosY = 2 },				-- SheetMetal
		[3] = { X = 1.5, Y = 1.5, PosX = 2, PosY = 1 },			-- Log
		[4] = { X = -1.5, Y = 3, PosX = 0, PosY = 2 },			-- Wood
		[5] = { X = -3, Y = 3, PosX = -1, PosY = 2 },			-- LibraryBookSorted
		[6] = { X = -3, Y = 1.5, PosX = -1, PosY = 1 },			-- LicensePlate
		[7] = { X = -3, Y = 0, PosX = -1, PosY = 0 },			-- DirtyPrisonerUniform
		[8] = { X = -3, Y = -3, PosX = -1, PosY = -2 },			-- FoodTrayDirty
		[9] = { X = -3, Y = -1.5, PosX = -1, PosY = -1 },		-- CrumpledPrisonerUniform
		[10] = { X = -1.25, Y = -3, PosX = 0, PosY = -2 },		-- ShopGoods
		[11] = { X = 0.75, Y = -1.5, PosX = 1.5, PosY = -1 }	-- Ingredients
	}
	
local ThrowSalvaged = {}


local Get = Object.GetProperty
local Set = Object.SetProperty
local Find = Object.GetNearbyObjects

function Create()
end

function FindStackNumbers()
	local StackFinder = Object.Spawn("Stack",this.Pos.x,this.Pos.y)
	local StackToFind = 1
	while StackToFind < 12 do
		StackNumbers[StackToFind] = 0										-- find out the contents number of UnsortedGarbage stack
		Set(StackFinder,"Quantity",1)
		while not FoundContents do
			StackNumbers[StackToFind] = StackNumbers[StackToFind]+1
			Set(StackFinder,"Contents",StackNumbers[StackToFind])				-- stack contents is set by a number...
			if StackFinder.Contents == SalvagedWaste[StackToFind] then					-- ...but reads out as a string
				print("Found"..SalvagedWaste[StackToFind])
				FoundContents = true
			end
		end
		StackToFind = StackToFind + 1
		FoundContents = nil
	end
	StackFinder.Delete()
end

function AddToStack()		-- puts previously thrown item on its stack type or creates a new stack
	local found = false
	local existingItems = Find(previousItem,previousItem.Type,1)
	if next(existingItems) then
		for existingItem, dist in pairs(existingItems) do
			if existingItem.Id.u ~= previousItem.Id.u then
				local newStack = Object.Spawn("Stack",this.Pos.x+ThrowSalvaged[previousNr].PosX,this.Pos.y+ThrowSalvaged[previousNr].PosY)
				newStack.Contents = StackNumbers[previousNr]
				newStack.Quantity = 2
				if previousNr == 1 then Set(newStack,"Tooltip","tooltip_R4_GreenGarbage") end
				existingItem.Delete()
				previousItem.Delete()
				found = true
			end
		end
	end
	if found == false then
		local existingStacks = Find(previousItem,"Stack",1)
		if next(existingStacks) then
			for existingStack, dist in pairs(existingStacks) do
				if existingStack.Contents == previousItem.Type then
					existingStack.Quantity = existingStack.Quantity+1
					previousItem.Delete()
					break
				end
			end
		end
	end
	previousItem,previousNr = nil,nil
end

function FindMyRecycleDesk()
	if Get(this,"DeskUID") ~= nil then
		local RecycleDesks = Find(this,"R4_RecycleDeskVisible",2)
		if next(RecycleDesks) then
			for thatDesk,dist in pairs(RecycleDesks) do
				if Get(thatDesk,"DeskUID") == this.DeskUID then
					print("[A1] -- "..this.DeskUID.." RecycleDeskVisible found at "..dist)
					MyDesk = thatDesk
					DeskFound = true
					break
				end
			end
		end
		RecycleDesks = nil
		if DeskFound == false then
			print("[A2] -- "..this.DeskUID.." RecycleDeskVisible not found")
		end
	else
		print("No DeskUID")
	end
end

function toggleSpawn1Clicked()
	if this.GreenGarbage == "Yes" then
		Set(this,"GreenGarbage","No")
		DeleteLeftOvers("R4_GreenGarbage")
	else
		Set(this,"GreenGarbage","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn1", "tooltip_R4_button_ToggleSpawn1","tooltip_R4_button_"..this.GreenGarbage,"X")
	SpawnThis[1] = this.GreenGarbage
	MyDesk.UpdateButtons = true
end

function toggleSpawn2Clicked()
	if this.SheetMetal == "Yes" then
		Set(this,"SheetMetal","No")
		DeleteLeftOvers("SheetMetal")
	else
		Set(this,"SheetMetal","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn2", "tooltip_R4_button_ToggleSpawn2","tooltip_R4_button_"..this.SheetMetal,"X")
	SpawnThis[2] = this.SheetMetal
	MyDesk.UpdateButtons = true
end

function toggleSpawn3Clicked()
	if this.Log == "Yes" then
		Set(this,"Log","No")
		DeleteLeftOvers("Log")
	else
		Set(this,"Log","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn3", "tooltip_R4_button_ToggleSpawn3","tooltip_R4_button_"..this.Log,"X")
	SpawnThis[3] = this.Log
	MyDesk.UpdateButtons = true
end

function toggleSpawn4Clicked()
	if this.Wood == "Yes" then
		Set(this,"Wood","No")
		DeleteLeftOvers("Wood")
	else
		Set(this,"Wood","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn4", "tooltip_R4_button_ToggleSpawn4","tooltip_R4_button_"..this.Wood,"X")
	SpawnThis[4] = this.Wood
	MyDesk.UpdateButtons = true
end

function toggleSpawn5Clicked()
	if this.LibraryBookSorted == "Yes" then
		Set(this,"LibraryBookSorted","No")
		DeleteLeftOvers("LibraryBookSorted")
	else
		Set(this,"LibraryBookSorted","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn5", "tooltip_R4_button_ToggleSpawn5","tooltip_R4_button_"..this.LibraryBookSorted,"X")
	SpawnThis[5] = this.LibraryBookSorted
	MyDesk.UpdateButtons = true
end

function toggleSpawn6Clicked()
	if this.LicensePlate == "Yes" then
		Set(this,"LicensePlate","No")
		DeleteLeftOvers("LicensePlate")
	else
		Set(this,"LicensePlate","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn6", "tooltip_R4_button_ToggleSpawn6","tooltip_R4_button_"..this.LicensePlate,"X")
	SpawnThis[6] = this.LicensePlate
	MyDesk.UpdateButtons = true
end

function toggleSpawn7Clicked()
	if this.DirtyPrisonerUniform == "Yes" then
		Set(this,"DirtyPrisonerUniform","No")
		DeleteLeftOvers("DirtyPrisonerUniform")
	else
		Set(this,"DirtyPrisonerUniform","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn7", "tooltip_R4_button_ToggleSpawn7","tooltip_R4_button_"..this.DirtyPrisonerUniform,"X")
	SpawnThis[7] = this.DirtyPrisonerUniform
	MyDesk.UpdateButtons = true
end

function toggleSpawn8Clicked()
	if this.FoodTrayDirty == "Yes" then
		Set(this,"FoodTrayDirty","No")
		DeleteLeftOvers("FoodTrayDirty")
	else
		Set(this,"FoodTrayDirty","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn8", "tooltip_R4_button_ToggleSpawn8","tooltip_R4_button_"..this.FoodTrayDirty,"X")
	SpawnThis[8] = this.FoodTrayDirty
	MyDesk.UpdateButtons = true
end

function toggleSpawn9Clicked()
	if this.CrumpledPrisonerUniform == "Yes" then
		Set(this,"CrumpledPrisonerUniform","No")
		DeleteLeftOvers("CrumpledPrisonerUniform")
	else
		Set(this,"CrumpledPrisonerUniform","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn9", "tooltip_R4_button_ToggleSpawn9","tooltip_R4_button_"..this.CrumpledPrisonerUniform,"X")
	SpawnThis[9] = this.CrumpledPrisonerUniform
	MyDesk.UpdateButtons = true
end

function toggleSpawn10Clicked()
	if this.ShopGoods == "Yes" then
		Set(this,"ShopGoods","No")
		DeleteLeftOvers("ShopGoods")
	else
		Set(this,"ShopGoods","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn10", "tooltip_R4_button_ToggleSpawn10","tooltip_R4_button_"..this.ShopGoods,"X")
	SpawnThis[10] = this.ShopGoods
	MyDesk.UpdateButtons = true
end

function toggleSpawn11Clicked()
	if this.Ingredients=="Yes" then
		Set(this,"Ingredients","No")
		DeleteLeftOvers("Ingredients")
	else
		Set(this,"Ingredients","Yes")
	end
	SpawnThis[11] = this.Ingredients
	this.SetInterfaceCaption("toggleSpawn11", "tooltip_R4_button_ToggleSpawn11","tooltip_R4_button_"..this.Ingredients,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawnRateClicked()
	Set(this,"SpawnRate",this.SpawnRate+2)
	if this.SpawnRate>9 then
		Set(this,"SpawnRate",1)
	end
	this.SetInterfaceCaption("toggleSpawnRate", "tooltip_R4_button_ToggleSpawnRate",this.SpawnRate,"X")
	MyDesk.UpdateButtons = true
end

function DeleteLeftOvers(ItemToDelete)
	local LeftOverItems = Find(this,ItemToDelete,2)
	if next(LeftOverItems) then
		for thatItem, distance in pairs (LeftOverItems) do
			thatItem.Delete()
		end
	end
	local LeftOverStacks = Find(this,"Stack",2)
	if next(LeftOverStacks) then
		for thatStack, distance in pairs (LeftOverStacks) do
			if thatStack.Contents == ItemToDelete then
				thatStack.Delete()
			end
		end
	end
end

function UnloadGarbage()
	local LeftOverItems = Find(this,"R4_UnsortedGarbage",2)
	if next(LeftOverItems) then
		for thatItem, distance in pairs (LeftOverItems) do
			thatItem.CarrierId.i = -1
			thatItem.CarrierId.u = -1
			this.Slot0.i = -1
			this.Slot0.u = -1
			thatItem.Loaded = false
			thatItem.Locked = false
			Object.ApplyVelocity(thatItem, 0.2, -0.1)
		end
	end
	local LeftOverItems = Find(this,"R4_SortedGarbage",2)
	if next(LeftOverItems) then
		for thatItem, distance in pairs (LeftOverItems) do
			thatItem.CarrierId.i = -1
			thatItem.CarrierId.u = -1
			this.Slot2.i = -1
			this.Slot2.u = -1
			thatItem.Loaded = false
			thatItem.Locked = false
			Object.ApplyVelocity(thatItem, 0.2, -0.1)
		end
	end
	local LeftOverStacks = Find(this,"Stack",2)
	if next(LeftOverStacks) then
		for thatStack, distance in pairs (LeftOverStacks) do
			if thatStack.CarrierId.u==this.Id.u then
				thatStack.CarrierId.i = -1
				thatStack.CarrierId.u = -1
				this.Slot0.i = -1
				this.Slot0.u = -1
				this.Slot2.i = -1
				this.Slot2.u = -1
				thatStack.Loaded = false
				thatStack.Locked = false
				Object.ApplyVelocity(thatStack, 0.2, -0.1)
			end
		end
	end
end

function UpdateButtons()
	this.SetInterfaceCaption("toggleSpawn1", "tooltip_R4_button_ToggleSpawn1","tooltip_R4_button_"..this.GreenGarbage,"X")
	this.SetInterfaceCaption("toggleSpawn2", "tooltip_R4_button_ToggleSpawn2","tooltip_R4_button_"..this.SheetMetal,"X")
	this.SetInterfaceCaption("toggleSpawn3", "tooltip_R4_button_ToggleSpawn3","tooltip_R4_button_"..this.Log,"X")
	this.SetInterfaceCaption("toggleSpawn4", "tooltip_R4_button_ToggleSpawn4","tooltip_R4_button_"..this.Wood,"X")
	this.SetInterfaceCaption("toggleSpawn5", "tooltip_R4_button_ToggleSpawn5","tooltip_R4_button_"..this.LibraryBookSorted,"X")
	this.SetInterfaceCaption("toggleSpawn6", "tooltip_R4_button_ToggleSpawn6","tooltip_R4_button_"..this.LicensePlate,"X")
	this.SetInterfaceCaption("toggleSpawn7", "tooltip_R4_button_ToggleSpawn7","tooltip_R4_button_"..this.DirtyPrisonerUniform,"X")
	this.SetInterfaceCaption("toggleSpawn8", "tooltip_R4_button_ToggleSpawn8","tooltip_R4_button_"..this.FoodTrayDirty,"X")
	this.SetInterfaceCaption("toggleSpawn9", "tooltip_R4_button_ToggleSpawn9","tooltip_R4_button_"..this.CrumpledPrisonerUniform,"X")
	this.SetInterfaceCaption("toggleSpawn10", "tooltip_R4_button_ToggleSpawn10","tooltip_R4_button_"..this.ShopGoods,"X")
	this.SetInterfaceCaption("toggleSpawn11", "tooltip_R4_button_ToggleSpawn11","tooltip_R4_button_"..this.Ingredients,"X")
	this.SetInterfaceCaption("toggleSpawnRate", "tooltip_R4_button_ToggleSpawnRate",this.SpawnRate,"X")
	SpawnThis[1] = this.GreenGarbage
	SpawnThis[2] = this.SheetMetal
	SpawnThis[3] = this.Log
	SpawnThis[4] = this.Wood
	SpawnThis[5] = this.LibraryBookSorted
	SpawnThis[6] = this.LicensePlate
	SpawnThis[7] = this.DirtyPrisonerUniform
	SpawnThis[8] = this.FoodTrayDirty
	SpawnThis[9] = this.CrumpledPrisonerUniform
	SpawnThis[10] = this.ShopGoods
	SpawnThis[11] = this.Ingredients
	this.UpdateButtons = false
end

function toggleDeleteClicked()
	if Exists(MyDesk) then MyDesk.Delete() end
	this.Delete()
end

function Update( timePassed )
	if timePerUpdate==nil then
		if Get(this,"DeskUID") == nil then
			return
		else
			FindMyRecycleDesk()
		end
		Interface.AddComponent(this,"toggleDelete", "Button", "tooltip_R4_button_Delete")
		Interface.AddComponent(this,"SeparatorRecycle1", "Caption", "tooltip_R4_SeparatorLine")
		Interface.AddComponent(this,"toggleSpawn1", "Button", "tooltip_R4_button_ToggleSpawn1","tooltip_R4_button_"..this.GreenGarbage,"X")
		Interface.AddComponent(this,"toggleSpawn2", "Button", "tooltip_R4_button_ToggleSpawn2","tooltip_R4_button_"..this.SheetMetal,"X")
		Interface.AddComponent(this,"toggleSpawn3", "Button", "tooltip_R4_button_ToggleSpawn3","tooltip_R4_button_"..this.Log,"X")
		Interface.AddComponent(this,"toggleSpawn4", "Button", "tooltip_R4_button_ToggleSpawn4","tooltip_R4_button_"..this.Wood,"X")
		Interface.AddComponent(this,"toggleSpawn5", "Button", "tooltip_R4_button_ToggleSpawn5","tooltip_R4_button_"..this.LibraryBookSorted,"X")
		Interface.AddComponent(this,"toggleSpawn6", "Button", "tooltip_R4_button_ToggleSpawn6","tooltip_R4_button_"..this.LicensePlate,"X")
		Interface.AddComponent(this,"toggleSpawn7", "Button", "tooltip_R4_button_ToggleSpawn7","tooltip_R4_button_"..this.DirtyPrisonerUniform,"X")
		Interface.AddComponent(this,"toggleSpawn8", "Button", "tooltip_R4_button_ToggleSpawn8","tooltip_R4_button_"..this.FoodTrayDirty,"X")
		Interface.AddComponent(this,"toggleSpawn9", "Button", "tooltip_R4_button_ToggleSpawn9","tooltip_R4_button_"..this.CrumpledPrisonerUniform,"X")
		Interface.AddComponent(this,"toggleSpawn10", "Button", "tooltip_R4_button_ToggleSpawn10","tooltip_R4_button_"..this.ShopGoods,"X")
		Interface.AddComponent(this,"toggleSpawn11", "Button", "tooltip_R4_button_ToggleSpawn11","tooltip_R4_button_"..this.Ingredients,"X")
		Interface.AddComponent(this,"SeparatorRecycle2", "Caption", "tooltip_R4_SeparatorLine")
		Interface.AddComponent(this,"toggleSpawnRate", "Button", "tooltip_R4_button_ToggleSpawnRate",this.SpawnRate,"X")
		SpawnThis[1] = this.GreenGarbage
		SpawnThis[2] = this.SheetMetal
		SpawnThis[3] = this.Log
		SpawnThis[4] = this.Wood
		SpawnThis[5] = this.LibraryBookSorted
		SpawnThis[6] = this.LicensePlate
		SpawnThis[7] = this.DirtyPrisonerUniform
		SpawnThis[8] = this.FoodTrayDirty
		SpawnThis[9] = this.CrumpledPrisonerUniform
		SpawnThis[10] = this.ShopGoods
		SpawnThis[11] = this.Ingredients
		FindStackNumbers()
		if this.Or.x == 0 and this.Or.y == 1	 then ThrowSalvaged = Direction1
		elseif this.Or.x == 0 and this.Or.y == -1 then ThrowSalvaged = Direction2
		elseif this.Or.x == -1 and this.Or.y == 0 then ThrowSalvaged = Direction3
		else ThrowSalvaged = Direction4
		end
		timePerUpdate = 1 / World.TimeWarpFactor
	end
	timeTot = timeTot + timePassed
	if timeTot >= timePerUpdate then
		timeTot = 0
		
		if this.UpdateButtons == true then UpdateButtons() end
		
		if this.Slot0.i > -1 and this.Slot2.i > -1 then
			if Exists(previousItem) then
				AddToStack()
			end
			Set(this,"SpawnTimer",this.SpawnTimer+1)
			if this.SpawnTimer >= this.SpawnRate then
				Set(this,"SpawnTimer",0)
				local ItemSpawned = false
				local myTimer = 1
				while ItemSpawned == false do
					SalvagedItem = math.random(1,11)
					if SpawnThis[SalvagedItem] == "Yes" then
						local name = Object.Spawn(SalvagedWaste[SalvagedItem],this.SpawnX,this.SpawnY)
						if SalvagedItem == 1 then Set(name,"Tooltip","tooltip_R4_GreenGarbage") end
						Object.ApplyVelocity(name,ThrowSalvaged[SalvagedItem].X,ThrowSalvaged[SalvagedItem].Y)
						ItemSpawned = true
						previousItem = name
						previousNr = SalvagedItem
					end
					myTimer = myTimer + 1
					if myTimer >= 3 and ItemSpawned == false then	-- 3 chances to spawn something
						ItemSpawned = true
					end																		 						
				end
			end
			SetGarbageTooltips()
		end
		
		
		if tonumber(this.JobId) == -1 and this.Slot2.i > -1 then	-- unload leftover Garbage
			UnloadGarbage()
		end
		
	end
end

function SetGarbageTooltips()
	local nearbyStack = Find(this,"Stack",5)
	if next(nearbyStack) then
		for thatStack, dist in pairs(nearbyStack) do
			if thatStack.Contents == "R4_SortedGarbage" and thatStack.Tooltip == nil then
				Set(thatStack,"Tooltip","tooltip_R4_SortedGarbage")
				print("R4_SortedGarbage found at "..dist)
			end
		end
	end
	nearbyStack = nil
	local nearbyGreen = Find(this,"R4_GreenGarbage",5)
	if next(nearbyGreen) then
		for thatGarbage, dist in pairs(nearbyGreen) do
			if thatGarbage.Tooltip == nil then
				Set(thatGarbage,"Tooltip","tooltip_R4_GreenGarbage")
				print("R4_GreenGarbage found at "..dist)
			end
		end
	end
	nearbyGreen = nil
end

function Exists(theObject)
	if theObject ~= nil and theObject.SubType ~= nil then
		return true
	else
		return false
	end
end
