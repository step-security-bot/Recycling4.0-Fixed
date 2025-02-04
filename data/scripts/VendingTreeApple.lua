
local timeTot=0
local timePerUpdate=(10+math.random()+math.random()) / World.TimeWarpFactor

local Get = Object.GetProperty
local Set = Object.SetProperty
local Find = Object.GetNearbyObjects

function Create()
	Set(this,"HomeUID",me["id-uniqueId"])
	Set(this,"Stage1Age", math.random(240,360) )
    Set(this,"Stage2Age", math.random(this.Stage1Age+240,this.Stage1Age+360) )
    Set(this,"Stage3Age", math.random(this.Stage2Age+240,this.Stage2Age+360) )
    Set(this,"Stage4Age", math.random(this.Stage3Age+240,this.Stage3Age+360) )
    Set(this,"Stage5Age", math.random(this.Stage4Age+240,this.Stage4Age+360) )
	Set(this,"Age", 0 )
	Set(this,"FlowersSpawned", false )
    Set(this,"NeedsTending", false )
    Set(this,"Stage2Complete", false )
    Set(this,"Stage3Complete", false )
    Set(this,"Stage4Complete", false )
    Set(this,"Stage5Complete", false )
	Set(this,"FruitType",string.sub(this.Type,12,-1))
	this.Tooltip = { "tooltip_R4_VendingTree",this.FruitType,"F" }
end

function SpawnFruit(theX,theY)
	newFruit = Object.Spawn( "VendingTreeFruit"..this.FruitType, theX, theY )
	Set(newFruit, "SubType",0)
	Set(newFruit, "HomeUID",this.HomeUID)
	Set(newFruit, "Tooltip", "tooltip_R4_VendingTreeStage1" )
	local velX = -0.5 + math.random()
	local velY = -0.5 + math.random()
	Object.ApplyVelocity(newFruit, velX, velY)
end

function UpdateFruit(newSubType)
	MyFruit = Find(this,"VendingTreeFruit"..this.FruitType,2)
	if next(MyFruit) then
		for thatFruit, dist in pairs(MyFruit) do
			if thatFruit.HomeUID == this.HomeUID then
				if newSubType < 13 then
					if math.random() > 0.33 then
						thatFruit.SubType = newSubType
						Set(thatFruit, "Tooltip", "tooltip_R4_VendingTreeStage2" )
					else
						thatFruit.Delete()
					end
				elseif newSubType == 13 then
					if math.random() > 0.66 then
						thatFruit.SubType = newSubType
						Set(thatFruit, "Tooltip", "tooltip_R4_VendingTreeStage3" )
					else
						thatFruit.Delete()
					end
				elseif newSubType == 14 then
					thatFruit.SubType = newSubType
					Set(thatFruit, "Tooltip", "tooltip_R4_VendingTreeStage4" )
				end
			end
		end
	end
	MyFruit = nil
end

function SpawnHarvestFruit()
	MyFruit = Find(this,"VendingTreeFruit"..this.FruitType,2)
	if next(MyFruit) then
		for thatFruit, dist in pairs(MyFruit) do
			if thatFruit.HomeUID == this.HomeUID then
				if math.random() > 0.85 then
					newFruit = Object.Spawn("VendingTreeFruitRotten"..this.FruitType, thatFruit.Pos.x, thatFruit.Pos.y )
				else
					newFruit = Object.Spawn("Vending"..this.FruitType,thatFruit.Pos.x,thatFruit.Pos.y)
				end
				local velY = 1.75 + this.Pos.y - thatFruit.Pos.y
				thatFruit.Delete()
				Object.ApplyVelocity(newFruit, 0, velY )
				timePerUpdate = math.random(1,5)
				return
			end
		end
	else
		Set(this,"Stage5Complete", true)
		Set(this,"NeedsTending", true)
	end
	MyFruit = nil
end

function Update( timePassed )
	timeTot=timeTot+timePassed
	if timeTot>timePerUpdate then
		timeTot=0
		this.Tooltip = { "tooltip_R4_VendingTree",this.FruitType,"F" }
		
		if Get(this,"NeedsTending") == true then
			timePerUpdate = 25
			Object.CreateJob(this,"R4_TendVendingTree")
			this.Tooltip = { "tooltip_R4_VendingTreeTending",this.FruitType,"F" }
			return
		end
			
		local age = Get(this,"Age")
		age = age + timePerUpdate
		Set(this,"Age", age )
		
		if Get(this,"FlowersSpawned") == false then
			if age >= this.Stage1Age then
				for i=1,math.random(3,9) do
					SpawnFruit(this.Pos.x,this.Pos.y-0.75)
				end
				for i=1,math.random(3,9) do
					SpawnFruit(this.Pos.x-0.5,this.Pos.y-0.35)
				end
				for i=1,math.random(3,9) do
					SpawnFruit(this.Pos.x,this.Pos.y-0.35)
				end
				for i=1,math.random(3,9) do
					SpawnFruit(this.Pos.x+0.5,this.Pos.y-0.35)
				end
				for i=1,math.random(3,9) do
					SpawnFruit(this.Pos.x-0.25,this.Pos.y+0.15)
				end
				for i=1,math.random(3,9) do
					SpawnFruit(this.Pos.x,this.Pos.y+0.15)
				end
				for i=1,math.random(3,9) do
					SpawnFruit(this.Pos.x+0.25,this.Pos.y+0.15)
				end
				Set(this,"FlowersSpawned", true )
			end
		else
			if age > this.Stage5Age and Get(this,"Stage5Complete") == false then
				SpawnHarvestFruit()
			elseif age >= this.Stage4Age and Get(this,"Stage4Complete") == false then
				UpdateFruit(14)
				Set(this,"Stage4Complete", true )
			elseif age >= this.Stage3Age and Get(this,"Stage3Complete") == false then
				UpdateFruit(13)
				Set(this,"Stage3Complete", true )
			elseif age >= this.Stage2Age and Get(this,"Stage2Complete") == false then
				UpdateFruit(math.random(1,12))
				Set(this,"Stage2Complete", true )
			end
		end
	end
end

function JobComplete_R4_TendVendingTree()
	Set(this,"Tooltip", "")
	Set(this,"Stage1Age", math.random(240,360) )
    Set(this,"Stage2Age", math.random(this.Stage1Age+240,this.Stage1Age+360) )
    Set(this,"Stage3Age", math.random(this.Stage2Age+240,this.Stage2Age+360) )
    Set(this,"Stage4Age", math.random(this.Stage3Age+240,this.Stage3Age+360) )
    Set(this,"Stage5Age", math.random(this.Stage4Age+240,this.Stage4Age+360) )
	Set(this,"Age", 0 )
	Set(this,"FlowersSpawned", false )
    Set(this,"NeedsTending", false )
    Set(this,"Stage5Complete", false )
    Set(this,"Stage4Complete", false )
    Set(this,"Stage3Complete", false )
    Set(this,"Stage2Complete", false )
	this.Tooltip = { "tooltip_R4_VendingTree",this.FruitType,"F" }
	timePerUpdate=(10+math.random()+math.random()) / World.TimeWarpFactor
end
