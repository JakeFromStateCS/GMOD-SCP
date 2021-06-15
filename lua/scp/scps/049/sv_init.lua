--[[
	Plague doctor sv_init.lua
	Coded by Matt Anderson
	hello moto
]]--
CLASS = CLASS or {};

function CLASS:OnLoad()
	for _,client in pairs( player.GetAll() ) do
		if( client:IsInfected() ) then
			client:Cure();
		end;
	end;
end;



--Cure the entire server
function CLASS:CureAll()
	self.CuringAll = true;
	local zombies = self:GetZombies();
	for _,client in pairs( zombies ) do
		client:Cure();
	end;
	self.CuringAll = nil;
	DarkRP.notifyAll( 1, 3, "The entire server has been Cured!" );
end;


/*
	HOOKS:
*/

--If the player is about to die then infect them
function CLASS.Hooks:EntityTakeDamage( client, dmgInfo )
	if( client:IsPlayer() ) then
		local attacker = dmgInfo:GetAttacker();
		local damage = dmgInfo:GetDamage();
		if( attacker:IsPlayer() ) then
			if( attacker:IsDoctor() or attacker:IsInfected() ) then
				if( !client:IsInfected() and !client:IsDoctor() ) then
					if( client:Health() - damage <= 0 ) then
						if( !table.HasValue( self.Blacklist, client:Team() ) ) then
							if( attacker:IsDoctor() ) then
								if( attacker:GetPos():Distance( self.CellPos ) > 500 ) then
									dmgInfo:ScaleDamage( 0 );
									return;
								end;
							end;
							client:Infect();
							dmgInfo:ScaleDamage( 0 );
							hook.Call( "OnPlayerInfected", GAMEMODE, client, attacker );
						end;
					end;
				else
					dmgInfo:ScaleDamage( 0 );
				end;
			elseif( client:IsInfected() ) then
				client:EmitSound( self.ZombieSounds.Pain .. math.random( 1, 6 ) .. ".wav" );
			elseif( attacker:IsInfected() and client:IsDoctor() ) then
				dmgInfo:ScaleDamage( 0 );
			end;
		end;
	end;
end;



--Cure the player when they die as infected
function CLASS.Hooks:PlayerDeath( client )
	if( client:IsInfected() ) then
		client:EmitSound( self.ZombieSounds.Death .. math.random( 1, 3 ) .. ".wav" );
		client:Cure();
	end;
end;



--Stop the player from changing jobs while they're infected
function CLASS.Hooks:playerCanChangeTeam( client, teamID, force )
	if( !force ) then
		if( client:IsInfected() ) then
			DarkRP.notify( client, 1, 3, "You cannot change jobs while you're infected!" );
			return false;
		end;
	else
		if( client:IsInfected() ) then
			client:Cure();
		end;
	end;
end;



--Stop the player from suiciding while they're infected
function CLASS.Hooks:CanPlayerSuicide( client )
	if( client:IsInfected() ) then
		DarkRP.notify( client, 1, 3, "You cannot suicide while you're infected!" );
		return false;
	end;
end;



--Stop the infected player from
function CLASS.Hooks:PlayerCanPickupWeapon( client, weapon )
	if( client:IsInfected() ) then
		if( weapon:GetClass() ~= "weapon_zfists" ) then
			return false;
		end;
	end;
end;



--Check if the player infected was the last human, if so, cure everyone
function CLASS.Hooks:OnPlayerInfected( client )
	local humans = self:GetHumans();
	if( #humans == 0 ) then
		self:CureAll();
	end;
end;



--If a client disconnects, check if there are any humans, if not, cure the server.
function CLASS.Hooks:PlayerDisconnected( client )
	if( !client:IsInfected() ) then
		local humans = self:GetHumans();
		if( #humans == 1 ) then
			if( humans[1] == client ) then
				self:CureAll();
			end;
		end;
	end;
end;