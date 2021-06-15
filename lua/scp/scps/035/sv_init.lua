--[[
	Plague doctor sv_init.lua
	Coded by Matt Anderson
	hello moto
]]--
CLASS = CLASS or {};
CLASS.MoveData = {};
CLASS.NextTick = CurTime();

function CLASS:OnLoad()
	for _,client in pairs( player.GetAll() ) do
		if( client:IsPossessed() ) then
			client:StopPossess();
		elseif( client:Team() == self.Team ) then
			client:ClearPuppet();
		end;
	end;
end;



function CLASS:UpdateStats( client )
	
end;



function CLASS:HandlePossess( client )
	local trace = client:GetEyeTrace();
	local victim = trace.Entity;
	if( victim and victim:IsPlayer() ) then
		if( trace.HitPos:Distance( client:EyePos() ) <= self.InfluenceRadius ) then
			if( !table.HasValue( self.BlackList, victim:Team() ) ) then
				victim:SetPossessed( client );
			end;
		end;
	end;
end;




/*
	HOOKS:
*/

--Free the puppet when the client changes team
function CLASS.Hooks:OnPlayerChangedTeam( client, oldTeam, newTeam )
	if( newTeam == self.Team ) then
		client:SetSelectedWeapon( 1 );
		self:UpdateStats( client );
	elseif( oldTeam == self.Team ) then
		local puppet = client:GetPuppet();
		if( puppet and puppet:IsValid() ) then
			puppet:StopPossess();
		else
			client:ClearPuppet();
		end;
	end;
end;



--Stop the player from suiciding while they're possessed
function CLASS.Hooks:CanPlayerSuicide( client )
	if( client:IsPossessed() ) then
		DarkRP.notify( client, 1, 3, "You cannot suicide while being possessed!" );
		return false;
	end;
end;



--Send the player's chat to their puppet
function CLASS.Hooks:PlayerSay( client, text, team )
	if( client:Team() == self.Team ) then
		local puppet = client:GetPuppet();
		if( puppet and puppet:IsValid() ) then
			local command = string.sub( string.lower( text ), 1, 2 );
			if( command ~= "/w" and string.sub( text, 1, 1 ) ~= "!" and string.sub( text, 1, 1) ~= "/" ) then
				puppet:ConCommand( "say " .. text );
				client:ChatPrint( puppet:Nick() .. ": " .. text );
			else
				puppet:ChatPrint( client:Nick() .. ": " .. string.sub( text, 3, #text ) );
				return "";
			end;
		end;
	end;
end;



--Set the master to speaking on the puppet
function CLASS.Hooks:PlayerStartVoice( client )
	if( client:Team() == self.Team ) then
		local puppet = client:GetPuppet();
		if( puppet and puppet:IsValid() ) then
			puppet:SetMasterSpeaking( true );
		end;
	end;
end;



--Set the master to not speaking on the puppet
function CLASS.Hooks:PlayerEndVoice( client )
	if( client:Team() == self.Team ) then
		local puppet = client:GetPuppet();
		if( puppet and puppet:IsValid() ) then
			puppet:SetMasterSpeaking( false );
		end;
	end;
end;



--Make it so the clients can't hear the puppet speak, only the master
function CLASS.Hooks:PlayerCanHearPlayersVoice( listener, speaker )
	
end;



--Stop the mask from picking up any weapons
function CLASS.Hooks:PlayerCanPickupWeapon( client, weapon )
	if( client:Team() == self.Team ) then
		return false;
	end;
end;



--Send all the key binds to the puppet
function CLASS.Hooks:KeyPress( client, key )
	if( client:Team() == self.Team ) then
		local puppet = client:GetPuppet();
		if( !puppet or !puppet:IsValid() ) then
			if( key == IN_USE ) then
				self:HandlePossess( client );
			end;
		else
			local command = self.Binds.Toggle[key];
			if( command ) then
				command = "+" .. command;
				puppet:ConCommand( command );
			end;
		end;
	end;
end;



--Send all the key binds to the puppet
function CLASS.Hooks:KeyRelease( client, key )
	if( client:Team() == self.Team ) then
		local puppet = client:GetPuppet();
		if( puppet and puppet:IsValid() ) then
			local command = self.Binds.Toggle[key];
			if( command ) then
				command = "-" .. command;
				puppet:ConCommand( command );
			end;
		end;
	end;
end;



--Clear the possession on either the client's death or puppet death
function CLASS.Hooks:PlayerDeath( client, inflictor, killer )
	if( client:Team() == self.Team ) then
		local puppet = client:GetPuppet();
		if( puppet and puppet:IsValid() ) then
			puppet:StopPossess();
		end;
		client:ClearPuppet();
	elseif( client:IsPossessed() ) then
		client:StopPossess();
	end;
end;



--Stop the possession on player disconnect
function CLASS.Hooks:PlayerDisconnected( client )
	if( client:Team() == self.Team ) then
		local puppet = client:GetPuppet();
		if( puppet and puppet:IsValid() ) then
			puppet:StopPossess();
		end;
	elseif( client:IsPossessed() ) then
		local master = client:GetMaster();
		if( master and master:IsValid() ) then
			master:ClearPuppet();
		end;
	end
end;



--kill the player slowly
function CLASS.Hooks:Think()
	if( self.NextTick < CurTime() ) then
		local clients = team.GetPlayers( self.Team );
		local client = clients[1];
		if( client ) then
			if( client:IsValid() ) then
				local puppet = client:GetPuppet();
				if( puppet and puppet:IsValid() and puppet:IsPossessed() ) then
					local deathTime = self.DeathTime;
					local group = string.lower( client:GetUserGroup() );
					local health = client:Health();
					if( self.DeathTimeMods[group] ) then
						deathTime = self.DeathTimeMods[group];
					end;
					local healthSub = puppet.MaxHealth / deathTime;
					local dmgInfo = DamageInfo();
					dmgInfo:SetAttacker( client );
					dmgInfo:SetDamage( math.ceil( healthSub ) );
					puppet:TakeDamageInfo( dmgInfo );
				end;
			end;
		end;
		self.NextTick = CurTime() + self.TickRate;
	end;
end;




/*
	Nets:
*/

function CLASS.Nets:PossessionBind( client )
	local puppet = client:GetPuppet();
	if( puppet and puppet:IsValid() ) then
		local bind = net.ReadString();
		/*
		local selectedWeapon = client:GetSelectedWeapon();
		local weaponCount = #client:GetWeapons();
		if( bind == "invnext" ) then
			selectedWeapon = selectedWeapon + 1;
			if( selectedWeapon > weaponCount ) then
				selectedWeapon = 1;
			end;
		else
			selectedWeapon = selectedWeapon - 1;
			if( selectedWeapon < 1 ) then
				selectedWeapon = 1;
			end;
		end;
		client:SetSelectedWeapon( selectedWeapon );
		*/
		puppet:ConCommand( bind );
	end;
end;