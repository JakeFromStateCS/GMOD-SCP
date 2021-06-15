--[[
	Plague doctor cl_init.lua
	--Add manual blinking for time syncing
]]--
CLASS = CLASS or {};
CLASS.MoveData = {};

surface.CreateFont( "SCP_Test1", {
	font = "Trebuchet",
	size = 20,
	weight = 700
} );

function CLASS:Circle( x, y, rad )
	local circle = {};
	local tmp = 0;
	local qual = 50;
	for i=1,qual do
		tmp = math.rad( i * 360 ) / qual;
		circle[i] = { x = x + math.cos( tmp ) * rad, y = y + math.sin( tmp ) * rad };
	end;
	return circle;
end;

function CLASS:DrawPossess( client )
	local scrPos = ( client:EyePos() - Vector( 0, 0, 10 ) ):ToScreen();
	local text = "Press E To Possess";
	surface.SetFont( "SCP_Test1" );
	local w, h = surface.GetTextSize( text );
	local boxSize = math.Max( 100, w + 10 );
	local posX, posY = scrPos.x - boxSize / 2, scrPos.y - boxSize / 2;
	
	surface.SetDrawColor( team.GetColor( LocalPlayer():Team() ) );
	surface.DrawOutlinedRect( posX, posY, boxSize, boxSize );
	surface.DrawRect( posX, posY, boxSize, h + 4 );
	
	surface.SetTextColor( Color( 255, 255, 255 ) );
	surface.SetTextPos( scrPos.x - w / 2, posY );
	surface.DrawText( text );
end;



--Draw the weapon selection
function CLASS:DrawWeapons()
	if( LocalPlayer():Team() == self.Team ) then
		local puppet = LocalPlayer():GetPuppet();
		if( puppet and puppet:IsValid() and puppet:IsPossessed() ) then
			if( self.ShouldDrawWeapons ) then
				local weaponTab = puppet:GetWeapons();
				local activeWeapon = puppet:GetActiveWeapon();
				local selectedWeapon = LocalPlayer():GetSelectedWeapon();
				for index,weapon in pairs( weaponTab ) do
					local name = weapon.PrintName or weapon:GetClass();
					surface.SetFont( "flatUI TitleText fine" );
					local w, h = surface.GetTextSize( name );
					local rectWidth = math.Max( 150, w );
					surface.SetDrawColor( Color( 50, 50, 50, 150 ) );
					surface.DrawRect( ScrW() / 2 + 20, ScrH() / 2 + 52 * index, rectWidth, 50 );
					surface.SetTextPos( ScrW() / 2 + 20, ScrH() / 2 + 52 * index );
					surface.SetTextColor( Color( 255, 255, 255 ) );
					if( weapon == activeWeapon ) then
						surface.SetTextColor( Color( 255, 150, 150 ) );
						surface.SetDrawColor( Color( 255, 150, 150 ) );
						surface.DrawOutlinedRect( ScrW() / 2 + 20, ScrH() / 2 + 52 * index - 1, rectWidth + 2, 52 );
					end;
					surface.DrawText( name );
				end;
			end;
		end;
	end;
end;

/*
	HOOKS:
*/
--Send the bind to the server so it can force it on the puppet
--Don't let the puppet run any binds, sucks mate
function CLASS.Hooks:PlayerBindPress( client, bind, pressed )
	if( client:Team() == self.Team ) then
		local puppet = client:GetPuppet();
		if( puppet and puppet:IsValid() and puppet:IsPossessed() ) then
			if( table.HasValue( self.Binds.Weapon, bind ) ) then
				--self.ShouldDrawWeapons = true;
				--timer.Simple( 2, function()
				--	self.ShouldDrawWeapons = false;
				--end );
				SCP:NetMessage( "PossessionBind", bind );
			end;
		end;
	elseif( client:IsPossessed() ) then
		return true;
	end;
end;



function CLASS.Hooks:PostDrawOpaqueRenderables()
	local clients = team.GetPlayers( self.Team );
	if( clients ) then
		local client = clients[1];
		if( client ) then
			local pos = client:GetPos();
			local dist = LocalPlayer():GetPos():Distance( pos );
			if( dist <= self.InfluenceRadius ) then
				local alpha = 150 - ( 150 / self.InfluenceRadius * dist );
				cam.Start3D2D( client:GetPos() + Vector( 0, 0, 10 ), Angle( 0, 0, 0 ), 1 );
					local circle = self:Circle( 0, 0, self.InfluenceRadius );
					draw.NoTexture();
					surface.SetDrawColor( Color( 100, 0, 0, alpha ) );
					surface.DrawPoly( circle );
				cam.End3D2D();
			end;
		end;
	end;
end;



--Add halos to the possessed
function CLASS.Hooks:PreDrawHalos()
	for _,client in pairs( player.GetAll() ) do
		if( client:IsPossessed() ) then
			if( client:GetPos():Distance( LocalPlayer():GetPos() ) <= self.InfluenceRadius * 3 ) then
				halo.Add( { client }, team.GetColor( client:Team() ), 2, 2, 1 );
			end;
		end;
	end;
end;



function CLASS.Hooks:HUDPaint()
	if( LocalPlayer():Team() == self.Team ) then
		local clients = ents.FindInSphere( LocalPlayer():GetPos(), self.InfluenceRadius );
		for _,client in pairs( clients ) do
			if( client ) then
				if( client:IsPlayer() and client ~= LocalPlayer() and !client:IsPossessed() ) then
					self:DrawPossess( client );
				end;
			end;
		end;
		--self:DrawWeapons();
	end;
end;



--Draw the local player when we're possessing someone
function CLASS.Hooks:ShouldDrawLocalPlayer()
	if( LocalPlayer():Team() == self.Team ) then
		local puppet = LocalPlayer():GetPuppet();
		if( puppet and puppet:IsValid() and puppet:IsPossessed() ) then
			return true;
		end;
	end;
end;