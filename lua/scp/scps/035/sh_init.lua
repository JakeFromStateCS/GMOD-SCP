--[[
	Plague doctor sh_init.lua
]]--

CLASS = CLASS or {};
CLASS.MoveData = {};

local pMeta = FindMetaTable( "Player" );

--Is Possessed
function pMeta:IsPossessed()
	return ( self:GetNWBool( "Possessed" ) == true );
end;



--Set the player to be possessed
function pMeta:SetPossessed( client )
	self:SetNWBool( "Possessed", true );
	self:SetNWEntity( "Master", client );
	client:SetNWEntity( "Puppet", self );
	self.MaxHealth = self:Health();
	if( SERVER ) then
		client:Spectate( OBS_MODE_CHASE );
		client:SpectateEntity( self );
	end;
end;



--Stop the player being possessed
function pMeta:StopPossess()
	local master = self:GetMaster();
	self:SetNWBool( "Possessed", false );
	self:SetNWEntity( "Master", nil );
	if( master:IsValid() ) then
		if( SERVER ) then
			master:UnSpectate();
			master:SetNWEntity( "Puppet", nil );
			master:Spawn();
			for _,bind in pairs( SCP.Classes[035].Binds.Toggle ) do
				self:ConCommand( "-" .. bind );
			end;
		end;
	end;
	self:UnSpectate();
end;



--Set selected weapon, for use with the weapon selection simulation
function pMeta:SetSelectedWeapon( int )
	self:SetNWInt( "SelectedWeapon", int );
	local puppet = self:GetPuppet();
	if( puppet and puppet:IsValid() and puppet:IsPossessed() ) then
		local weaponTab = puppet:GetWeapons();
		puppet:SetActiveWeapon( weaponTab[int] );
	end;
end;



--Get selected weapon, for use with the weapon selection simulation
function pMeta:GetSelectedWeapon()
	return self:GetNWInt( "SelectedWeapon" );
end;



--Get the client's master
function pMeta:GetMaster()
	return self:GetNWEntity( "Master" );
end;



--Is the master speaking?
function pMeta:IsMasterSpeaking()
	return ( self:GetNWBool( "MasterSpeaking" ) == true );
end;



--Set the master speaking
function pMeta:SetMasterSpeaking( bool )
	self:SetNWBool( "MasterSpeaking", bool );
end;



--Get the client's puppet
function pMeta:GetPuppet()
	local puppet = self:GetNWEntity( "Puppet" );
	if( puppet and puppet:IsValid() and puppet:IsPossessed() ) then
		return puppet;
	end;
end;



--Clear the puppet data
function pMeta:ClearPuppet()
	self:SetNWEntity( "Puppet", nil );
	if( SERVER ) then
		self:UnSpectate();
		self:Spawn();
	end;
end;


/*
	Hooks:
*/


--SetupMove, store the movedata from the master
function CLASS.Hooks:SetupMove( client, moveData, command )
	if( client:IsPossessed() ) then
		local master = client:GetMaster();
		if( master:IsValid() ) then
			client:SetEyeAngles( master:EyeAngles() );
		else
			client:StopPossess();
		end;
	elseif( client:Team() == self.Team ) then
		self.MoveData[client] = {
			forward = command:GetForwardMove(),
			side = command:GetSideMove(),
			up = command:GetUpMove(),
			buttons = command:GetButtons()
		};
	end;
end;



--Move, stop the puppet from moving as well as the mask.
function CLASS.Hooks:Move( client, moveData )
	if( client:IsPossessed() ) then
		local master = client:GetMaster();
		local masterData = self.MoveData[master];
		if( masterData ) then
			local vel = Vector( 0, 0, moveData:GetVelocity().z );
			local maxSpeed = moveData:GetMaxSpeed();

			vel = vel + client:GetForward() * math.Clamp( masterData.forward, -maxSpeed, maxSpeed );
			vel = vel + client:GetRight() * math.Clamp( masterData.side, -maxSpeed, maxSpeed );
			vel = vel + client:GetUp() * math.Clamp( masterData.up, -maxSpeed, maxSpeed );

			moveData:SetVelocity( vel );
		end;
	elseif( client:Team() == self.Team ) then
		return true;
	end;
end;