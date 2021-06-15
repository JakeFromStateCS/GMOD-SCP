SCP = SCP or {};
SCP.Security = SCP.Security or {};
SCP.Security.Hooks = SCP.Security.Hooks or {};

function SCP.Security.Hooks:KeyPress( client, key )
	if( key == IN_USE ) then
		if( client:IsSecurity() or client:IsAdmin() ) then
			local trace = client:GetEyeTrace();
			if( trace.Entity and trace.Entity:IsPlayer() ) then
				local weapon = trace.Entity:GetActiveWeapon();
				if( weapon:IsValid() ) then
					if( weapon:GetClass() == "weapon_keycard" or weapon:GetClass() == "weapon_admin_keycard" ) then
						SCP:NetMessage( client, "ShowID", trace.Entity );
					elseif( weapon:GetClass() == "weapon_hacking_keycard") then
						SCP:NetMessage( client, "ShowFakeID", trace.Entity );
					end;
				end;
			end;
		end;
	end;
end;


function SCP.Nets:Keycard_SetClearance( client )
	local ent = net.ReadEntity();
	local teamID = net.ReadDouble();
	local bool = net.ReadBool();
	if( ent.TeamData == nil ) then
		ent.ExtraTeamData = {};
	end;
	ent.ExtraTeamData[teamID] = bool;
	ent:SetNWBool( "Clearance_Allowed_" .. teamID, bool );
	ent:SetNWBool( "Clearance_Set_" .. teamID, true );
end;