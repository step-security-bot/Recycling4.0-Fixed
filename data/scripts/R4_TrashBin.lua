
local timeTot = 0
local timeFX = 0
local Find = Object.GetNearbyObjects
local Get = Object.GetProperty
local Set = Object.SetProperty
local UnsortedGarbageContentsNr = 0
local soundTimer = 0
local SoundMade = false
local MaxStackSize = 0
local InQueue = 0
local CurrentSlot = 0

function Create()
	Set(this,"MaxStack",30)
	Set(this,"QueuedQuantity",0)
end

function toggleMaxStackSizeClicked()
	Set(this,"MaxStack",this.MaxStack+10)
	if this.MaxStack > 50 then
		Set(this,"MaxStack",10)
	end
	MaxStackSize = this.MaxStack
	this.SetInterfaceCaption("toggleMaxStackSize", "tooltip_R4_button_MaxStackSize",MaxStackSize,"X")
	this.Tooltip = {"tooltip_R4_TrashBin",MaxStackSize,"M",InQueue,"Q"}
end

function PutGarbageInQueue(SlotNr)
	QueuedStack = Find(this,"Stack",1)												-- check if there is a stack of garbage at specified slot
	if next(QueuedStack) then
		for thatQueuedStack, distance in pairs (QueuedStack) do	
			if thatQueuedStack.Id.u == Get(this,"Slot"..SlotNr..".u") then
				Set(this,"QueuedQuantity",Get(this,"QueuedQuantity") + thatQueuedStack.Quantity)
				Set(this,"Slot"..SlotNr..".i",-1)
				Set(this,"Slot"..SlotNr..".u",-1)
				thatQueuedStack.CarrierId.i = -1
				thatQueuedStack.CarrierId.u = -1
				thatQueuedStack.Loaded = false
				thatQueuedStack.Delete()
			end
		end
	end
	local MyGarbage = Find(this,"R4_UnsortedTrash",1)
	if next(MyGarbage) then														-- check if there is just a bag of garbage instead of a stack
		for thatGarbage, distance in pairs (MyGarbage) do	
			if thatGarbage.Id.u == Get(this,"Slot"..SlotNr..".u") then
				Set(this,"QueuedQuantity",Get(this,"QueuedQuantity") + 1)
				Set(this,"Slot"..SlotNr..".i",-1)
				Set(this,"Slot"..SlotNr..".u",-1)
				thatGarbage.CarrierId.i = -1
				thatGarbage.CarrierId.u = -1
				thatGarbage.Loaded = false
				thatGarbage.Delete()
			end
		end	
	end
	QueuedStack = nil
	MyGarbage = nil
	InQueue = Get(this,"QueuedQuantity")
	this.SubType = 1
	this.Tooltip = {"tooltip_R4_TrashBin",MaxStackSize,"M",InQueue,"Q"}
end

function SpawnUnsortedGarbage()
	newGarbage = Object.Spawn("Stack",this.Pos.x+this.Or.x,this.Pos.y+this.Or.y)
	if UnsortedGarbageContentsNr == 0 then
		FindStackNr(newGarbage)
	else
		newGarbage.Contents = UnsortedGarbageContentsNr
		newGarbage.Quantity = MaxStackSize
	end
	newGarbage.Tooltip = "tooltip_R4_UnsortedGarbage"
	Set(this,"QueuedQuantity",InQueue - MaxStackSize)
	if Get(this,"QueuedQuantity") < 0 then Set(this,"QueuedQuantity",0) end
	InQueue = Get(this,"QueuedQuantity")
	newGarbage = nil
	this.Tooltip = {"tooltip_R4_TrashBin",MaxStackSize,"M",InQueue,"Q"}
end

function FindStackNr(theStack)
	UnsortedGarbageContentsNr = 0										-- find out the contents number of UnsortedGarbage stack
	Set(theStack,"Quantity",MaxStackSize)
	while not FoundContents do
		UnsortedGarbageContentsNr = UnsortedGarbageContentsNr+1
		Set(theStack,"Contents",UnsortedGarbageContentsNr)				-- stack contents is set by a number...
		if theStack.Contents == "R4_UnsortedGarbage" then					-- ...but reads out as a string
			FoundContents = true
		end
	end
end

function Update( timePassed )
	if timePerUpdate == nil then
		MaxStackSize = Get(this,"MaxStack")
		InQueue = Get(this,"QueuedQuantity")
		Interface.AddComponent(this,"toggleMaxStackSize", "Button", "tooltip_R4_button_MaxStackSize",MaxStackSize,"X")
		this.Tooltip = {"tooltip_R4_TrashBin",MaxStackSize,"M",InQueue,"Q"}
		timePerUpdate = 0.1
		timePerFX = 0.5 / World.TimeWarpFactor
	end
	
	timeTot = timeTot + timePassed
	if timeTot >= timePerUpdate then
		timeTot=0		
		CurrentSlot = CurrentSlot + 1
		if CurrentSlot > 7 then CurrentSlot = 0 end
		if Get(this,"Slot"..CurrentSlot..".i") > -1 then						-- stack UnsortedTrash coming from dumped stuff
			PutGarbageInQueue(CurrentSlot)
		end
	end
	
	timeFX = timeFX + timePassed
	if timeFX >= timePerFX then
		timeFX = 0
		if InQueue >= MaxStackSize then
			if SoundMade == false then
				this.Sound("TrashBin","ProcessTrash")
				soundTimer = 0
				SoundMade = true
			else
				if soundTimer < 1.5 then
					if this.SubType == 1 then this.SubType = 2 else this.SubType = 1 end		-- blink the statusLED
					soundTimer=soundTimer+0.1
				else
					SpawnUnsortedGarbage()
					if InQueue == 0 then this.SubType = 0 else this.SubType = 1 end
					SoundMade = false
				end
			end
		end
	end
end
