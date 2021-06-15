--[[
	Coded by Matt Anderson
	hello moto
]]--
CLASS = CLASS or {};

/*
	HOOKS:
*/
function CLASS.Hooks:KeyPress( client, key )
	if( table.HasValue( self.Teams, client:Team() ) ) then
		if( key == IN_USE ) then
			local dClass = client:GetDClass();
			if( !dClass:IsValid() ) then
				local trace = client:GetEyeTrace();
				if( trace.Entity:IsValid() and trace.Entity:IsPlayer() ) then
					dClass = trace.Entity;
					if( dClass:Team() == TEAM_DCLASS or dClass:Team() == TEAM_BUBBA ) then
						if( !dClass:GetResearcher():IsValid() ) then
							if( dClass:GetPos():Distance( client:GetPos() ) <= 200 ) then
								print( "Setting DClass and Researcher", client );
								trace.Entity:SetResearcher( client );
								client:SetDClass( trace.Entity );
							end;
						end;
					end;
				end;
			end;
		end;
	end;
end;


function CLASS.Hooks:Think()
	for _,teamID in pairs( self.Teams ) do
		for _,client in pairs( team.GetPlayers( teamID ) ) do
			local SCPID = client:GetSCP();
			local dClass = client:GetDClass();
			if( SCPID ~= 0 and dClass:IsValid() ) then
				local SCP = SCP.Classes.Stored[SCPID];
				if( dClass:GetPos():Distance( SCP.CellPos ) <= 300 ) then
					client:ClearSCP();
					hook.Call( "OnClientResearch", GAMEMODE, SCPID, client, dClass );
				end;
			end;
		end;
	end;
end;


function CLASS.Hooks:OnPlayerChangedTeam( client, oldTeam, newTeam )
	if( table.HasValue( self.Teams, oldTeam ) ) then
		local dClass = client:GetDClass();
		if( dClass:IsValid() ) then
			client:ClearDClass();
		end;
	elseif( oldTeam == TEAM_DCLASS or oldTeam == TEAM_BUBBA ) then
		local researcher = client:GetResearcher();
		if( researcher:IsValid() ) then
			client:ClearResearcher();
			researcher:ClearDClass();
		end;
	end;
end;


function CLASS.Hooks:PlayerDeath( client )
	if( table.HasValue( self.Teams, client:Team() ) ) then
		local dClass = client:GetDClass();
		if( dClass:IsValid() ) then
			client:ClearDClass();
		end;
	elseif( client:Team() == TEAM_DCLASS or client:Team() == TEAM_BUBBA ) then
		local researcher = client:GetResearcher();
		print( researcher );
		if( researcher:IsValid() ) then
			client:ClearResearcher();
			researcher:ClearDClass();
		end;
	end;
end;


function CLASS.Hooks:PlayerDisconnected( client )
	local researcher = client:GetResearcher();
	if( researcher ) then
		if( researcher:IsValid() ) then
			researcher:ClearDClass();
		end;
	elseif( client:GetDClass() ) then
		local dClass = client:GetDClass();
		if( dClass:IsValid() ) then
			dClass:ClearResearcher();
		end;
	end;
end;