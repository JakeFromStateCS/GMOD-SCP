--[[
	sv_init.lua
	Let them be
	Secured.
	Contained.
	and
	Protected.
]]--
SCP = {};
AddCSLuaFile( "sh_init.lua" );
include( "sh_init.lua" );



/*
	HOOKS:
*/
function SCP.Hooks:PlayerAuthed( client )
	SCP:NetMessage( client, "DefineSecurity" );
	SCP:NetMessage( client, "OverrideTargetID" );
end;



function SCP.Hooks:EntityTakeDamage( ent, dmgInfo )
	if( ent:IsPlayer() ) then
		local attacker = dmgInfo:GetAttacker();
		if( attacker:IsPlayer() ) then
			local weapon = attacker:GetActiveWeapon();
			if( weapon:IsValid() ) then
				if( weapon:GetClass() == "weapon_stunstick" or weapon:GetClass() == "stunstick" ) then
					if( !ent.Slowed ) then
						ent.Slowed = true;
						ent.LastRunSpeed = ent:GetRunSpeed();
						ent.LastWalkSpeed = ent:GetWalkSpeed();
						ent:SetRunSpeed( ent.LastRunSpeed / 2 );
						ent:SetWalkSpeed( ent.LastWalkSpeed / 2 );
						timer.Simple( 2, function()
							ent:SetRunSpeed( ent.LastRunSpeed );
							ent:SetWalkSpeed( ent.LastWalkSpeed );
							ent.Slowed = nil;
							ent.LastRunSpeed = nil;
							ent.LastWalkSpeed = nil;
						end );
					end;
				end;
			end;
		end;
	end;
end;



function SCP.Hooks:KeyPress( client, key )

end;