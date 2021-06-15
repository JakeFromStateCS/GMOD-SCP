CLASS = CLASS or {};
CLASS.Clients = {};
CLASS.TeamVoice = false;

/*
	Hooks:
*/
function CLASS.Hooks:Think()
	if( table.HasValue( self.Teams, LocalPlayer():Team() ) ) then
		for client,_ in pairs( self.Clients ) do
			if( !client:IsValid() ) then
				self.SquadMenu:RemoveClient( client );
				self.Clients[client] = nil;
			else
				if( !table.HasValue( self.Teams, client:Team() ) ) then
					print( "Removing", client );
					self.SquadMenu:RemoveClient( client );
					self.Clients[client] = nil;
				end;
			end;
		end;
		if( input.IsMouseDown( MOUSE_MIDDLE ) ) then
			if( !self.TeamVoice ) then
				self.TeamVoice = true;
				SCP:NetMessage( "TeamVoice", true );
				RunConsoleCommand( "+voicerecord" );
			end;
		else
			if( self.TeamVoice ) then
				self.TeamVoice = false;
				SCP:NetMessage( "TeamVoice", false );
				RunConsoleCommand( "-voicerecord" );
			end;
		end;
	else
		if( self.SquadMenu ) then
			self.SquadMenu:Remove();
			self.SquadMenu = nil;
			self.Clients = {};
		end;
	end;
end;

/*
	Nets:
*/

function CLASS.Nets:SquadMenu()
	self.SquadMenu = vgui.Create( "squad_status_container" );
	for _,teamID in pairs( self.Teams ) do
		local clients = team.GetPlayers( teamID );
		for _,client in pairs( clients ) do
			if( client ~= LocalPlayer() ) then
				self.SquadMenu:AddClient( client );
				self.Clients[client] = true;
			end;
		end;
	end;
end;

function CLASS.Nets:NewChaos()
	local client = net.ReadEntity();
	timer.Simple( 0.1, function()
		self.SquadMenu:AddClient( client );
		self.Clients[client] = true;
	end );
end;