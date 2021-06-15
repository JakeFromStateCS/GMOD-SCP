--[[
	Plague doctor sh_init.lua
]]--

CLASS = CLASS or {};
CLASS.Zombies = {};
CLASS.ZombieKeys = {};
CLASS.PlayerWeapons = {};

local pMeta = FindMetaTable( "Player" );

--Infect the player
function pMeta:Infect()
	local CLASS = SCP.Classes[049];
	self:StoreWeapons();
	self:StripWeapons();
	self:SetNWBool( "Infected", true );
	self:SetNWString( "OldModel", self:GetModel() );
	self:SetNWInt( "OldHealth", self:Health() );
	self:SetModel( CLASS.Model );
	self:SetHealth( CLASS.ZombieHealth );
	self:SetRunSpeed( CLASS.ZombieSpeed );
	self:SetWalkSpeed( CLASS.ZombieSpeed );
	self:Give( CLASS.Weapon );
	--SCP.Music:PlaySong( self, "https://www.youtube.com/watch?v=G5HQvzQlkho" );
	DarkRP.notifyAll( 1, 3, self:Nick() .. " has been Cured!" );
	table.insert( CLASS.Zombies, self );
	CLASS.ZombieKeys[self] = #CLASS.Zombies;
end;



--Cure the player
function pMeta:Cure()
	local CLASS = SCP.Classes[049];
	self:StripWeapons();
	self:SetNWBool( "Infected", false );
	self:SetModel( self:GetOldModel() );
	self:SetWalkSpeed( GAMEMODE.Config.walkspeed );
	self:SetRunSpeed( GAMEMODE.Config.runspeed );
	self:SetHealth( 100 );
	self:RestoreWeapons();
	local key = CLASS.ZombieKeys[self];
	if( key ) then
		table.remove( CLASS.Zombies, key );
	end;
	CLASS.ZombieKeys[self] = nil;
end;



--Is the player infected
function pMeta:IsInfected()
	return ( self:GetNWBool( "Infected" ) == true );
end;



--Is the client the witch doctor?
function pMeta:IsDoctor()
	local CLASS = SCP.Classes[049];
	if( self:Team() == CLASS.Team ) then
		return true;
	end;
	return false;
end;



--Get their model before infection
function pMeta:GetOldModel()
	return self:GetNWString( "OldModel" );
end;



--Get their old health before infection
function pMeta:GetOldHealth()
	return self:GetNWInt( "OldHealth" );
end;



--Store the player's weapons for later use
function pMeta:StoreWeapons()
	local CLASS = SCP.Classes[049];
	CLASS.PlayerWeapons[self] = {};
	local weapons = self:GetWeapons();
	for _,weapon in pairs( weapons ) do
		local class = weapon:GetClass();
		table.insert( CLASS.PlayerWeapons[self], class );
	end;
end;



--Restore the player's weapons after they are cured
function pMeta:RestoreWeapons()
	if( SCP.Classes[049].CuringAll ) then
		local CLASS = SCP.Classes[049];
		local weapons = CLASS.PlayerWeapons[self];
		if( weapons ) then
			for _,class in pairs( weapons ) do
				self:Give( class );
			end;
		end;
	end;
end;



--Get a table of zombies
function CLASS:GetZombies()
	local zombies = {};
	for _,client in pairs( player.GetAll() ) do
		if( client:IsInfected() or client:IsDoctor() ) then
			table.insert( zombies, client );
		end;
	end;
	return zombies;
end;



--Get a table of humans
function CLASS:GetHumans()
	local humans = {};
	for _,client in pairs( player.GetAll() ) do
		if( !client:IsInfected() and !table.HasValue( self.Blacklist, client:Team() ) and !client:InPocketDimension() ) then
			if( !client:IsDoctor() ) then
				table.insert( humans, client );
			end;
		end;
	end;
	return humans;
end;