--[[
	Old Man
	Spoopy void dimension leedle
	Coded by Matt Anderson
	hello moto
]]--
CLASS = CLASS or {};

function CLASS:OnLoad()
	
end;


function CLASS:PlacePortal( client )
	if( !self.FemurBreaker and !client:IsHandcuffed() ) then
		local maxDist = 40;
		local canTeleport, dist = self:CanTeleport( client, maxDist );
		if( canTeleport ) then
			if( self.Portal ) then
				if( self.Portal:IsValid() ) then
					self.Portal:Remove();
					self.Portal = nil;
				end;
			end;
			local trace = client:GetEyeTrace();
			self.Portal = ents.Create( "scp_portal" );
			self.Portal:SetPos( trace.HitPos + trace.HitNormal * 5 );
			self.Portal:Spawn();
			self.Portal.MaxDist = maxDist;
			self.Portal:SetClient( client );
			self.Portal:SetAngles( ( trace.HitNormal * 90 ):Angle() + Angle( 90, 180, 0 ) );
			local trace = {
				start = self.Portal:GetPos(),
				endpos = self.Portal:GetPos() - client:GetUp() * 100,
				filter = { client, self.Portal }
			};
			trace = util.TraceLine( trace );
			self.Portal:SetPos( trace.HitPos + Vector( 0, 0, 28 ) );
		end;
	end;
end;


function CLASS.Hooks:Think()
	
end;


function CLASS.Hooks:PlayerInitialSpawn( client )
	client:SetCustomCollisionCheck( true );
end;


function CLASS.Hooks:OnPlayerChangedTeam( client, oldTeam, newTeam )
	if( oldTeam == self.Team ) then
		if( self.Portal ) then
			self.Portal:Remove();
			self.Portal = nil;
		end;
		client:SetPocketDimension( false );
		for _,client in pairs( player.GetAll() ) do
			if( client:InPocketDimension() ) then
				client:SetPocketDimension( false );
			end;
		end;
	elseif( newTeam ~= self.Team ) then
		if( client:InPocketDimension() ) then
			client:SetPocketDimension( false );
		end;
	end;
end;


function CLASS.Hooks:PlayerDeath( client )
	if( client:InPocketDimension() ) then
		client:SetPocketDimension( false );
	end;
end;


function CLASS.Hooks:PlayerCanHearPlayersVoice( client1, client2 )
	if( client1:InPocketDimension() and !client2:InPocketDimension() ) then
		return false;
	elseif( !client1:InPocketDimension() and client2:InPocketDimension() ) then
		return false;
	end;
end;


function CLASS.Hooks:PlayerCanSeePlayersChat( text, team, listener, speaker )
	if( speaker:InPocketDimension() and !listener:InPocketDimension() ) then
		return false;
	end;
end;


function CLASS.Hooks:OnPlayerEnterPortal( client, portal, target )
	client:SetPocketDimension( !client:InPocketDimension() );
	if( client:IsPlayer() ) then
		if( client:Team() == self.Team ) then
			local parent = portal:GetParent();
			if( parent ) then
				if( parent:IsValid() ) then
					portal:SetWidth( 0 );
					portal:SetHeight( 0 );
					target:SetWidth( 0 );
					target:SetHeight( 0 );
					timer.Simple( 0.5, function()
						if( parent:IsValid() ) then
							parent:Remove();
						end;
					end );
				end;
			end;
		end;
	end;
end;


function CLASS.Hooks:PlayerSwitchFlashlight( client, bool )
	if( client:InPocketDimension() ) then
		if( bool == true ) then
			return false;
		end;
	end;
end;


function CLASS.Hooks:PlayerSpawnedProp( client, model, ent )
	if( client:InPocketDimension() ) then
		ent:SetPocketDimension( true );
	end;
end;


function CLASS.Hooks:OnEntityCreated( ent )
	if( ent.dtvars ) then
		if( ent.dtvars.owner ) then
			if( ent.dtvars.owner:InPocketDimension() ) then
				ent:SetPocketDimension( true );
			end;
		end;
	end;
end;


function CLASS.Hooks:KeyPress( client, key )
	if( client:Team() == self.Team ) then
		if( key == IN_USE ) then
			local weapon = client:GetActiveWeapon();
			if( weapon:GetClass() ~= "weapon_handcuffs" ) then
				local trace = client:GetEyeTrace();
				if( trace.Entity and trace.Entity:IsValid() ) then
					if( trace.Entity:IsPlayer() ) then
						local victim = trace.Entity;
						if( victim:Health() <= self.HealthReq ) then
							if( !victim:InPocketDimension() ) then
								victim:SetPocketDimension( true );
							end;
						end;
					end;
				else
					self:PlacePortal( client );
				end;
			end;
		end;
	elseif( client:InPocketDimension() ) then
		return false;
	elseif( client:IsSecurity() ) then
		if( key == IN_USE ) then
			local trace = client:GetEyeTrace();
			if( trace.HitPos:Distance( self.FemurBreakerPos ) <= 50 ) then
				if( !self.FemurBreaker ) then
					if( !self.FemurCooldown ) then
						self.FemurBreaker = !self.FemurBreaker;
						SCP:NetMessage( "FemurBreaker", self.FemurBreaker );
						local clients = team.GetPlayers( self.Team );
						if( clients[1] ) then
							if( clients[1]:IsValid() ) then
								clients[1]:SetPocketDimension( false );
							end;
						end;
						for _,client in pairs( player.GetAll() ) do
							if( client:InPocketDimension() ) then
								client:SetPocketDimension( false );
							end;	
						end;
						self.FemurCooldown = true;
						self.FemurCooldownTime = CurTime() + ( 60 * 2 );
						timer.Simple( 60 * 2, function()
							self.FemurBreaker = !self.FemurBreaker;
							self.FemurCooldown = nil;
							self.FemurCooldownTime = nil;
							SCP:NetMessage( "FemurBreaker", self.FemurBreaker );
						end );
					else
						DarkRP.notify( client, 1, 3, "You cannot use Femur Breaker for another: " .. math.ceil( self.FemurCooldownTime - CurTime() ) .. " seconds." );
					end;
				else
					self.FemurBreaker = !self.FemurBreaker;
					SCP:NetMessage( "FemurBreaker", self.FemurBreaker );
				end;
			end;
		end;
	end;
end;


function CLASS.Hooks:OnHandcuffed( cuffer, target, ent )
	if( target:Team() == self.Team ) then
		cuffer:SetPocketDimension( false );
		target:SetPocketDimension( false );
	end;
end;