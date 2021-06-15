SCP = SCP or {};
SCP.Lights = {};
SCP.Lights.Hooks = {};
SCP.Lights.LightSwitchPos = Vector( -8850, 373, -616 );
SCP.Lights.SwitchTime = CurTime();
SCP.Lights.On = true;


--Turn on the lights
function SCP.Lights:TurnOn()
	self.On = true;
	SCP:NetMessage( "LightSwitch", true );
	for _,ent in pairs( ents.FindByClass( "func_door" ) ) do
		if( ent:GetPos().z < -550 ) then
			if( ent:GetPos():Distance( Vector( -10559, -3222, -844 ) ) > 150 ) then
				ent:Fire( "Close" );
			end;
		end;
	end;
end;



--Turn off the lights
function SCP.Lights:TurnOff()
	self.On = false;
	SCP:NetMessage( "LightSwitch", false );
	for _,ent in pairs( ents.FindByClass( "func_door" ) ) do
		ent:Fire( "Open" );
	end;
end;



--Get the light value
function SCP.Lights:IsOn()
	local on = self.On or false;
	return on;
end;


if( SERVER ) then
	SCP.Lights.On = true;

	function SCP.Lights:OnLoad()
		SCP:NetMessage( "LightSwitch", self.On );
		self:TurnOn();
	end;

	function SCP.Lights.Hooks:KeyPress( client, key )
		if( key == IN_USE ) then
			local hitPos = client:GetEyeTrace().HitPos;
			if( hitPos:Distance( client:GetPos() ) <= 120 ) then
				local dist = hitPos:Distance( SCP.Lights.LightSwitchPos );
				if( dist <= 40 ) then
					if( SCP.Lights.SwitchTime < CurTime() ) then
						local val = SCP.Lights:IsOn();
						if( val == true ) then
							if( !SCP.Lights.Cooldown or SCP.Lights.Cooldown and SCP.Lights.Cooldown < CurTime() ) then
								SCP.Lights:TurnOff();
								client:ConCommand( "say /advert Power Off!" );
							else
								local diff = SCP.Lights.Cooldown - CurTime();
								DarkRP.notify( client, 1, 3, "You cannot turn the lights off for another " .. math.ceil( diff ) .. " seconds." );
							end;
						else
							SCP.Lights:TurnOn();
							client:ConCommand( "say /advert Power On!" );
							if( !SCP.Lights.Cooldown ) then
								SCP.Lights.Cooldown = CurTime() + 60 * 10;
							end;
						end;
						SCP.Lights.SwitchTime = CurTime() + 1;
					end;
				end;
			end;
		end;
	end;


	function SCP.Nets:RequestLightInfo( client )
		SCP:NetMessage( "LightSwitch", SCP.Lights.On );
	end;

end;



function SCP.Hooks:PlayerInitialSpawn( client )
	SCP:NetMessage( client, "LightSwitch", SCP.Lights.On );
end;



if( CLIENT ) then
	function SCP.Lights:OnLoad()
		SCP:NetMessage( "RequestLightInfo" );
	end;

	function SCP.Hooks:RenderScreenspaceEffects()
		if( !SCP.Lights:IsOn() ) then
			local pos = LocalPlayer():GetPos();
			local div = ( pos.z / -550 ) / 2;
			if( pos.z < -550 ) then
				local tab = {
					[ "$pp_colour_addr" ] = 0.4,
					[ "$pp_colour_addg" ] = 0.4,
					[ "$pp_colour_addb" ] = 0.4,
					[ "$pp_colour_brightness" ] = -div,
					[ "$pp_colour_contrast" ] = 1.0,
					[ "$pp_colour_colour" ] = 1.0,
					[ "$pp_colour_mulr" ] = 0,
					[ "$pp_colour_mulg" ] = 0,
					[ "$pp_colour_mulb" ] = 0
				}
				DrawColorModify( tab );
			end;
		else
			local pos = LocalPlayer():GetPos();
			if( pos.z < -550 ) then
				local tab = {
					[ "$pp_colour_addr" ] = 0,
					[ "$pp_colour_addg" ] = 0,
					[ "$pp_colour_addb" ] = 0,
					[ "$pp_colour_brightness" ] = -0.05,
					[ "$pp_colour_contrast" ] = 1.3,
					[ "$pp_colour_colour" ] = 1.25,
					[ "$pp_colour_mulr" ] = 0,
					[ "$pp_colour_mulg" ] = 0,
					[ "$pp_colour_mulb" ] = 0
				}
				DrawColorModify( tab );
			end;
		end;
	end;

	function SCP.Nets:LightSwitch()
		local bool = net.ReadBool();
		SCP.Lights.On = bool;
	end;
end;