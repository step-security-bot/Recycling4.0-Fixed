
function CreateGrants()
	Create_R4_RecycleGrant()
	Create_R4_Garden()
	Create_R4_GardenProduction()
end

function Create_R4_RecycleGrant()
	Objective.CreateGrant			( "Grant_R4_Recycle", 1500, 2500 )
	Objective.CreateGrant			( "Grant_R4_Recycle_Requirement1", 0, 500 )
	Objective.SetParent				( "Grant_R4_Recycle" )
	Objective.RequireRoom			( "R4_Recycling", true )

	Objective.CreateGrant			( "Grant_R4_Recycle_Requirement2", 0, 500 )
	Objective.SetParent				( "Grant_R4_Recycle" )
	Objective.RequireObjects		( "R4_RecycleDeskVisible", 1 )
	
	Objective.CreateGrant			( "Grant_R4_Recycle_Requirement3", 0, 500 )
	Objective.SetParent				( "Grant_R4_Recycle" )
	Objective.RequireObjects		( "R4_TrashBin", 1 )
	
	Objective.CreateGrant			( "Grant_R4_Recycle_Requirement4", 0, 500 )
	Objective.SetParent				( "Grant_R4_Recycle" )
	Objective.RequireObjects		( "R4_TrashCompactor", 1 )
end

function Create_R4_Garden()
	Objective.CreateGrant			( "Grant_R4_Garden", 1500, 2500 )
	Objective.SetPreRequisite		( "Unlocked", "GroundsKeeping", 0 )
    Objective.HiddenWhileLocked     ()

	Objective.CreateGrant			( "Grant_R4_Garden_GardenRoom", 0, 0 )
	Objective.SetParent				( "Grant_R4_Garden" )
	Objective.RequireRoom			( "R4_Garden", true )
	
	Objective.CreateGrant			( "Grant_R4_Garden_GardenControlNumber", 0, 0 )
	Objective.SetParent				( "Grant_R4_Garden" )
	Objective.RequireObjects		( "R4_GardenControl", 1 )
	
	Objective.CreateGrant			( "Grant_R4_Garden_GardenPotNumber", 0, 0 )
	Objective.SetParent				( "Grant_R4_Garden" )
	Objective.RequireObjects		( "R4_GardenPot", 8 )
end

function Create_R4_GardenProduction()
	Objective.CreateGrant			( "Grant_R4_Garden_Production", 1500, 2500 )
	Objective.SetPreRequisite		( "Unlocked", "PrisonLabour", 0 )
    Objective.HiddenWhileLocked     ()
	
	Objective.CreateGrant			( "Grant_R4_Garden_Production_Research", 0, 0 )
	Objective.SetParent				( "Grant_R4_Garden_Production" )
	Objective.Requires				( "Completed", "Grant_R4_Garden", 0 )
	
	Objective.CreateGrant			( "Grant_R4_Garden_Production_Passed", 0, 0 )
	Objective.SetParent				( "Grant_R4_Garden_Production" )
	Objective.Requires				( "ReformPassed", "R4_PlantCultivation", 5 )
	
	Objective.CreateGrant			( "Grant_R4_Garden_Production_Assigned", 0, 0 )
	Objective.SetParent				( "Grant_R4_Garden_Production")
	Objective.Requires				( "PrisonerJobs", "R4_Garden", 2 )
	
	Objective.CreateGrant			( "Grant_R4_Garden_Production_Tomato", 0, 5000 )
	Objective.SetParent				( "Grant_R4_Garden_Production")
	Objective.RequireObjects	 	( "R4_GardenTomato", 11 )
	
	Objective.CreateGrant			( "Grant_R4_Garden_Production_Cucumber", 0, 5000 )
	Objective.SetParent				( "Grant_R4_Garden_Production")
	Objective.RequireObjects 		( "R4_GardenCucumber", 11 )
	
	Objective.CreateGrant			( "Grant_R4_Garden_Production_Rose", 0, 5000 )
	Objective.SetParent				( "Grant_R4_Garden_Production")
	Objective.RequireObjects	 	( "R4_GardenRose", 11 )
	
	Objective.CreateGrant			( "Grant_R4_Garden_Production_Lily", 0, 5000 )
	Objective.SetParent				( "Grant_R4_Garden_Production")
	Objective.RequireObjects 		( "R4_GardenLily", 11 )
end
