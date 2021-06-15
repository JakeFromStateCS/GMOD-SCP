--[[
	Coded by Matt Anderson
	hello moto
]]--
CLASS = CLASS or {};

/*
	HOOKS:
*/

function CLASS.Hooks:OnPlayerChangedTeam( client, oldTeam, newTeam )
	if( table.HasValue( self.Teams, newTeam ) ) then
		SCP:NetMessage( client, "SquadMenu" );
		for _,teamID in pairs( self.Teams ) do
			SCP:NetMessage( team.GetPlayers( teamID ), "NewChaos", client );
		end;
	end;
end;


function CLASS.Hooks:PlayerCanHearPlayersVoice( listener, speaker )
	if( table.HasValue( self.Teams, speaker:Team() ) ) then
		if( !table.HasValue( self.Teams, listener:Team() ) ) then
			if( speaker:GetNWBool( "TeamVoice" ) ) then
				return false;
			end;
		else
			if( speaker:GetNWBool( "TeamVoice" ) ) then
				return true;
			end;
		end;
	end;
end;



function CLASS.Nets:TeamVoice( client )
	local bool = net.ReadBool();
	client:SetNWBool( "TeamVoice", bool );
end;