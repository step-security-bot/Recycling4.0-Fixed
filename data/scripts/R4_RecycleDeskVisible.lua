
local timeTot=0
local DeskFound = false

local Get = Object.GetProperty
local Set = Object.SetProperty
local Find = Object.GetNearbyObjects

function Create()
end

function FindMyRecycleDesk()
	if Get(this,"DeskUID") ~= nil then
		local RecycleDesks = Find(this,"R4_RecycleDeskProcessor",2)
		if next(RecycleDesks) then
			for thatDesk,dist in pairs(RecycleDesks) do
				if Get(thatDesk,"DeskUID") == this.DeskUID then
					print("[A1] -- "..this.DeskUID.." RecycleDeskProcessor found at "..dist)
					MyDesk = thatDesk
					DeskFound = true
					break
				end
			end
		end
		RecycleDesks = nil
		if DeskFound == false then
			print("[A2] -- "..this.DeskUID.." RecycleDeskProcessor not found")
		end
	end
end

function toggleSpawn1Clicked()
	if MyDesk.GreenGarbage=="Yes" then
		Set(MyDesk,"GreenGarbage","No")
		DeleteLeftOvers("R4_GreenGarbage")
	else
		Set(MyDesk,"GreenGarbage","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn1", "tooltip_R4_button_ToggleSpawn1","tooltip_R4_button_"..MyDesk.GreenGarbage,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawn2Clicked()
	if MyDesk.SheetMetal=="Yes" then
		Set(MyDesk,"SheetMetal","No")
		DeleteLeftOvers("SheetMetal")
	else
		Set(MyDesk,"SheetMetal","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn2", "tooltip_R4_button_ToggleSpawn2","tooltip_R4_button_"..MyDesk.SheetMetal,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawn3Clicked()
	if MyDesk.Log=="Yes" then
		Set(MyDesk,"Log","No")
		DeleteLeftOvers("Log")
	else
		Set(MyDesk,"Log","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn3", "tooltip_R4_button_ToggleSpawn3","tooltip_R4_button_"..MyDesk.Log,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawn4Clicked()
	if MyDesk.Wood=="Yes" then
		Set(MyDesk,"Wood","No")
		DeleteLeftOvers("Wood")
	else
		Set(MyDesk,"Wood","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn4", "tooltip_R4_button_ToggleSpawn4","tooltip_R4_button_"..MyDesk.Wood,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawn5Clicked()
	if MyDesk.LibraryBookSorted=="Yes" then
		Set(MyDesk,"LibraryBookSorted","No")
		DeleteLeftOvers("LibraryBookSorted")
	else
		Set(MyDesk,"LibraryBookSorted","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn5", "tooltip_R4_button_ToggleSpawn5","tooltip_R4_button_"..MyDesk.LibraryBookSorted,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawn6Clicked()
	if MyDesk.LicensePlate=="Yes" then
		Set(MyDesk,"LicensePlate","No")
		DeleteLeftOvers("LicensePlate")
	else
		Set(MyDesk,"LicensePlate","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn6", "tooltip_R4_button_ToggleSpawn6","tooltip_R4_button_"..MyDesk.LicensePlate,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawn7Clicked()
	if MyDesk.DirtyPrisonerUniform=="Yes" then
		Set(MyDesk,"DirtyPrisonerUniform","No")
		DeleteLeftOvers("DirtyPrisonerUniform")
	else
		Set(MyDesk,"DirtyPrisonerUniform","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn7", "tooltip_R4_button_ToggleSpawn7","tooltip_R4_button_"..MyDesk.DirtyPrisonerUniform,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawn8Clicked()
	if MyDesk.FoodTrayDirty=="Yes" then
		Set(MyDesk,"FoodTrayDirty","No")
		DeleteLeftOvers("FoodTrayDirty")
	else
		Set(MyDesk,"FoodTrayDirty","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn8", "tooltip_R4_button_ToggleSpawn8","tooltip_R4_button_"..MyDesk.FoodTrayDirty,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawn9Clicked()
	if MyDesk.CrumpledPrisonerUniform=="Yes" then
		Set(MyDesk,"CrumpledPrisonerUniform","No")
		DeleteLeftOvers("CrumpledPrisonerUniform")
	else
		Set(MyDesk,"CrumpledPrisonerUniform","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn9", "tooltip_R4_button_ToggleSpawn9","tooltip_R4_button_"..MyDesk.CrumpledPrisonerUniform,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawn10Clicked()
	if MyDesk.ShopGoods=="Yes" then
		Set(MyDesk,"ShopGoods","No")
		DeleteLeftOvers("ShopGoods")
	else
		Set(MyDesk,"ShopGoods","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn10", "tooltip_R4_button_ToggleSpawn10","tooltip_R4_button_"..MyDesk.ShopGoods,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawn11Clicked()
	if MyDesk.Ingredients=="Yes" then
		Set(MyDesk,"Ingredients","No")
		DeleteLeftOvers("Ingredients")
	else
		Set(MyDesk,"Ingredients","Yes")
	end
	this.SetInterfaceCaption("toggleSpawn11", "tooltip_R4_button_ToggleSpawn11","tooltip_R4_button_"..MyDesk.Ingredients,"X")
	MyDesk.UpdateButtons = true
end

function toggleSpawnRateClicked()
	Set(MyDesk,"SpawnRate",MyDesk.SpawnRate+2)
	if MyDesk.SpawnRate>9 then
		Set(MyDesk,"SpawnRate",1)
	end
	this.SetInterfaceCaption("toggleSpawnRate", "tooltip_R4_button_ToggleSpawnRate",MyDesk.SpawnRate,"X")
	MyDesk.UpdateButtons = true
end

function toggleDeleteClicked()
	if Exists(MyDesk) then MyDesk.Delete() end
	this.Delete()
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
			if thatStack.Contents==ItemToDelete then
				thatStack.Delete()
			end
		end
	end
end

function UpdateButtons()
	this.SetInterfaceCaption("toggleSpawn1", "tooltip_R4_button_ToggleSpawn1","tooltip_R4_button_"..MyDesk.GreenGarbage,"X")
	this.SetInterfaceCaption("toggleSpawn2", "tooltip_R4_button_ToggleSpawn2","tooltip_R4_button_"..MyDesk.SheetMetal,"X")
	this.SetInterfaceCaption("toggleSpawn3", "tooltip_R4_button_ToggleSpawn3","tooltip_R4_button_"..MyDesk.Log,"X")
	this.SetInterfaceCaption("toggleSpawn4", "tooltip_R4_button_ToggleSpawn4","tooltip_R4_button_"..MyDesk.Wood,"X")
	this.SetInterfaceCaption("toggleSpawn5", "tooltip_R4_button_ToggleSpawn5","tooltip_R4_button_"..MyDesk.LibraryBookSorted,"X")
	this.SetInterfaceCaption("toggleSpawn6", "tooltip_R4_button_ToggleSpawn6","tooltip_R4_button_"..MyDesk.LicensePlate,"X")
	this.SetInterfaceCaption("toggleSpawn7", "tooltip_R4_button_ToggleSpawn7","tooltip_R4_button_"..MyDesk.DirtyPrisonerUniform,"X")
	this.SetInterfaceCaption("toggleSpawn8", "tooltip_R4_button_ToggleSpawn8","tooltip_R4_button_"..MyDesk.FoodTrayDirty,"X")
	this.SetInterfaceCaption("toggleSpawn9", "tooltip_R4_button_ToggleSpawn9","tooltip_R4_button_"..MyDesk.CrumpledPrisonerUniform,"X")
	this.SetInterfaceCaption("toggleSpawn10", "tooltip_R4_button_ToggleSpawn10","tooltip_R4_button_"..MyDesk.ShopGoods,"X")
	this.SetInterfaceCaption("toggleSpawn11", "tooltip_R4_button_ToggleSpawn11","tooltip_R4_button_"..MyDesk.Ingredients,"X")
	this.SetInterfaceCaption("toggleSpawnRate", "tooltip_R4_button_ToggleSpawnRate",MyDesk.SpawnRate,"X")
	this.UpdateButtons = false
end

function MakeDesk()
		-- print("Or.x: "..this.Or.x)
		-- print("Or.y: "..this.Or.y)
		-- print("Walls.x: "..this.Walls.x)
		-- print("Walls.y: "..this.Walls.y)
		
	Set(this,"DeskUID",me["id-uniqueId"])
	Set(this,"Tooltip","tooltip_R4_RecycleDeskProcessor")
	MyDesk = Object.Spawn("R4_RecycleDeskProcessor",this.Pos.x,this.Pos.y)
	
	if this.Or.x == -1 and this.Or.y == 0 then
	
		MyDesk.Pos.x = this.Pos.x+0.5
		MyDesk.Or.x = -1
		MyDesk.Or.y = 0
		
	elseif this.Or.x == 1 and this.Or.y == 0 then
		
		MyDesk.Pos.x = this.Pos.x-0.5
		MyDesk.Or.x = 1
		MyDesk.Or.y = 0
		
	elseif this.Or.x == 0 and this.Or.y == -1 then
		
		MyDesk.Pos.y = this.Pos.y+0.5
		MyDesk.Or.x = 0
		MyDesk.Or.y = -1
		
	elseif this.Or.x == 0 and this.Or.y == 1 then
		
		MyDesk.Pos.y = this.Pos.y-0.5
		
	end
	Set(MyDesk,"SpawnX",MyDesk.Pos.x+this.Or.x)
	Set(MyDesk,"SpawnY",MyDesk.Pos.y+this.Or.y)
	Set(MyDesk,"GreenGarbage","No")
	Set(MyDesk,"SheetMetal","No")
	Set(MyDesk,"Log","No")
	Set(MyDesk,"Wood","No")
	Set(MyDesk,"LibraryBookSorted","No")
	Set(MyDesk,"LicensePlate","No")
	Set(MyDesk,"DirtyPrisonerUniform","No")
	Set(MyDesk,"FoodTrayDirty","No")
	Set(MyDesk,"CrumpledPrisonerUniform","No")
	Set(MyDesk,"ShopGoods","No")
	Set(MyDesk,"Ingredients","No")
	Set(MyDesk,"SpawnTimer",0)
	Set(MyDesk,"SpawnRate",3)
	Set(MyDesk,"Tooltip","tooltip_R4_RecycleDeskProcessor")
	Set(MyDesk,"DeskUID",this.DeskUID)
	print("[B1] -- "..this.DeskUID.." RecycleDesk ceated")
end

function Update( timePassed )
	if timePerUpdate == nil then
		FindMyRecycleDesk()
		if DeskFound == false then
			MakeDesk()
		end
		Interface.AddComponent(this,"toggleDelete", "Button", "tooltip_R4_button_Delete")
		Interface.AddComponent(this,"SeparatorRecycle1", "Caption", "tooltip_R4_SeparatorLine")
		Interface.AddComponent(this,"toggleSpawn1", "Button", "tooltip_R4_button_ToggleSpawn1","tooltip_R4_button_"..MyDesk.GreenGarbage,"X")
		Interface.AddComponent(this,"toggleSpawn2", "Button", "tooltip_R4_button_ToggleSpawn2","tooltip_R4_button_"..MyDesk.SheetMetal,"X")
		Interface.AddComponent(this,"toggleSpawn3", "Button", "tooltip_R4_button_ToggleSpawn3","tooltip_R4_button_"..MyDesk.Log,"X")
		Interface.AddComponent(this,"toggleSpawn4", "Button", "tooltip_R4_button_ToggleSpawn4","tooltip_R4_button_"..MyDesk.Wood,"X")
		Interface.AddComponent(this,"toggleSpawn5", "Button", "tooltip_R4_button_ToggleSpawn5","tooltip_R4_button_"..MyDesk.LibraryBookSorted,"X")
		Interface.AddComponent(this,"toggleSpawn6", "Button", "tooltip_R4_button_ToggleSpawn6","tooltip_R4_button_"..MyDesk.LicensePlate,"X")
		Interface.AddComponent(this,"toggleSpawn7", "Button", "tooltip_R4_button_ToggleSpawn7","tooltip_R4_button_"..MyDesk.DirtyPrisonerUniform,"X")
		Interface.AddComponent(this,"toggleSpawn8", "Button", "tooltip_R4_button_ToggleSpawn8","tooltip_R4_button_"..MyDesk.FoodTrayDirty,"X")
		Interface.AddComponent(this,"toggleSpawn9", "Button", "tooltip_R4_button_ToggleSpawn9","tooltip_R4_button_"..MyDesk.CrumpledPrisonerUniform,"X")
		Interface.AddComponent(this,"toggleSpawn10", "Button", "tooltip_R4_button_ToggleSpawn10","tooltip_R4_button_"..MyDesk.ShopGoods,"X")
		Interface.AddComponent(this,"toggleSpawn11", "Button", "tooltip_R4_button_ToggleSpawn11","tooltip_R4_button_"..MyDesk.Ingredients,"X")
		Interface.AddComponent(this,"SeparatorRecycle2", "Caption", "tooltip_R4_SeparatorLine")
		Interface.AddComponent(this,"toggleSpawnRate", "Button", "tooltip_R4_button_ToggleSpawnRate",MyDesk.SpawnRate,"X")
		timePerUpdate = 1 / World.TimeWarpFactor
	end
	timeTot = timeTot + timePassed
	if timeTot>=timePerUpdate then
		timeTot = 0
		if this.UpdateButtons == true then UpdateButtons() end
	end
end

function Exists(theObject)
	if theObject ~= nil and theObject.SubType ~= nil then
		return true
	else
		return false
	end
end
