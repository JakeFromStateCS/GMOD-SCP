local pMeta = FindMetaTable( "Player" );
SCP.Security = {};
function SCP:DefineSecurity()
	SCP.SecurityClasses = {
		TEAM_SEC,
		TEAM_MTF,
		TEAM_FA,
		TEAM_NINE,
		TEAM_O5,
		TEAM_RES,
		TEAM_BRIGHT,
		TEAM_RIGHTS,
		TEAM_CLEF,
		TEAM_KONDRAKI,
		TEAM_GEARS,
		TEAM_ANT,
		TEAM_SECTRON,
		TEAM_NIGHTHAWK,
		TEAM_KAIN,
		TEAM_ECU,
		TEAM_HNT
	};

	SCP.SeniorResearchers = {
		TEAM_BRIGHT,
		TEAM_RIGHTS,
		TEAM_CLEF,
		TEAM_KONDRAKI,
		TEAM_KAIN,
		TEAM_GEARS
	};

	SCP.Clearances = {
		[TEAM_SEC] = 1,
		[TEAM_MTF] = 2,
		[TEAM_FA] = 5,
		[TEAM_NINE] = 8,
		[TEAM_O5] = 10,
		[TEAM_RES] = 5,
		[TEAM_BRIGHT] = 7,
		[TEAM_RIGHTS] = 7,
		[TEAM_KAIN] = 7,
		[TEAM_CLEF] = 7,
		[TEAM_KONDRAKI] = 7,
		[TEAM_GEARS] = 7,
		[TEAM_ANT] = 8,
		[TEAM_SECTRON] = 7,
		[TEAM_ECU] = 8,
		[TEAM_NIGHTHAWK] = 8,
		[TEAM_HNT] = 8
	};
end;



function SCP:IsSecurity( client )
	return table.HasValue( self.SecurityClasses, client:Team() );
end;



function SCP:GetClearance( client )
	return ( self.Clearances[client:Team()] or 0 );
end;



function SCP:GetAllowedTeams( clearance )
	local teams = {};
	for teamID,level in pairs( self.Clearances ) do
		if( level >= clearance ) then
			table.insert( teams, teamID );
		end;
	end;
	return teams;
end;



function SCP:GetDeniedTeams( clearance )
	local teams = {};
	for teamID,level in pairs( self.Clearances ) do
		if( level < clearance ) then
			table.insert( teams, teamID );
		end;
	end;
	return teams;
end;



function pMeta:IsSecurity()
	return SCP:IsSecurity( self );
end;



function pMeta:GetClearance()
	return SCP:GetClearance( self );
end;