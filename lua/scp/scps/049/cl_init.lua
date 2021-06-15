--[[
	Plague doctor cl_init.lua
	https://www.youtube.com/watch?v=G5HQvzQlkho - Rob Zombie instrumental
]]--
CLASS = CLASS or {};

surface.CreateFont( "SCP_InfectText1", {
	font = "Trebuchet",
	size = 25,
	weight = 700
} );

surface.CreateFont( "SCP_AllyNick1", {
	font = "Trebuchet",
	size = 25,
	weight = 700
} );

surface.CreateFont( "SCP_StatsText1", {
	font = "Trebuchet",
	size = 20,
	weight = 700
} );

surface.CreateFont( "SCP_TextThin_15", {
	font = "Trebuchet",
	size = 15,
	weight = 500
} );


function CLASS:DrawCircle( x, y, radius )
	local cir = {}
	local seg = 360;
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end;



function CLASS:ClampPos( pos, dist )
	dist = dist or 10;
	local half = dist / 2;
	if( pos.x + half > ScrW() ) then
		pos.x = ScrW() - half;
	elseif( pos.x - half < 0 ) then
		pos.x = half;
	end;
	if( pos.y + half > ScrH() ) then
		pos.y = ScrH() - half;
	elseif( pos.y - half < 0 ) then
		pos.y = half;
	end;
	return pos;
end;



function CLASS:DrawEnemy( client )
	local pos = ( client:GetPos() + client:OBBCenter() + Vector( 0, 0, 15 ) ):ToScreen();
	local circ = 30;
	local text = "Cure!";
	surface.SetFont( "SCP_AllyNick1" );
	local w, h = surface.GetTextSize( text );
	circ = math.Max( circ, w / 2 + 10 );

	pos = self:ClampPos( pos, circ );

	surface.SetDrawColor( Color( 20, 20, 20, 100 ) );
	self:DrawCircle( pos.x, pos.y, circ );

	surface.SetTextColor( Color( 255, 255, 255 ) );
	surface.SetTextPos( pos.x - w / 2, pos.y - h / 2 );
	surface.DrawText( text );
end;



function CLASS:DrawAlly( client )
	local pos = ( client:GetPos() + client:OBBCenter() + Vector( 0, 0, 15 ) ):ToScreen();

	local circ = 30;
	local allyText = "Ally:";
	local nick = client:Nick() .. ":";
	local health = client:Health();
	local hpText = health .. " HP";
	
	local healthColor = HSVToColor( ( 100 / self.ZombieHealth ) * health, 1, 1 );
	healthColor.a = 120;

	local maxWidth = 0;
	surface.SetTextColor( Color( 255, 255, 255 ) );

	surface.SetFont( "SCP_AllyNick1" );
	local allyW, allyH = surface.GetTextSize( allyText );

	surface.SetFont( "SCP_StatsText1" );
	local nickW, nickH = surface.GetTextSize( nick );
	local healthW, healthH = surface.GetTextSize( client:Health() );

	circ = math.Max( circ, nickW / 2 + 10, allyW / 2 + 10, healthW / 2 + 10 );

	pos = self:ClampPos( pos, circ );

	surface.SetDrawColor( Color( 20, 20, 20, 100 ) );
	self:DrawCircle( pos.x, pos.y, circ );
	surface.DrawCircle( pos.x + 1, pos.y + 1, circ + 2, healthColor );

	--Nick text
	local posY = pos.y - nickH / 2;
	surface.SetTextPos( pos.x - nickW / 2, posY );
	surface.DrawText( nick );

	--Health text
	local hposY = posY + healthH;
	surface.SetTextColor( healthColor );
	surface.SetTextPos( pos.x - healthW / 2, hposY );
	surface.DrawText( client:Health() );

	--Ally text
	surface.SetFont( "SCP_AllyNick1" );
	surface.SetTextColor( Color( 50, 255, 50, 120 ) );
	surface.SetTextPos( pos.x - allyW / 2, pos.y - allyH / 2 - ( hposY - posY ) );
	surface.DrawText( allyText );
end;



function CLASS:DrawRatio()
	local barWidth = 120;
	local barPos = {
		x = ScrW() - barWidth - 10,
		y = 200
	};
	local zombies = table.Count( self:GetZombies() );
	local players = #player.GetAll();
	local pDiff = players - zombies;
	local zBarW = barWidth / players * zombies;
	local pBarW = barWidth / players * pDiff;
	local pBarX = barPos.x - barWidth / 2 + zBarW;


	--Zombie ratio
	surface.SetDrawColor( Color( 50, 255, 50, 120 ) );
	surface.DrawRect( barPos.x - barWidth / 2, barPos.y, zBarW, 20 );
	surface.SetFont( "SCP_TextThin_15" );
	if( zombies > 0 ) then
		local w, h = surface.GetTextSize( zombies );
		surface.SetTextColor( Color( 255, 255, 255 ) );
		surface.SetTextPos( barPos.x - barWidth / 2 + w / 2, barPos.y );
		surface.DrawText( zombies );
	end;

	--Human ratio
	surface.SetDrawColor( Color( 255, 50, 50, 120 ) );
	surface.DrawRect( pBarX, barPos.y, pBarW, 20 );

	local w, h = surface.GetTextSize( players - zombies );
	surface.SetTextColor( Color( 255, 255, 255 ) );
	surface.SetTextPos( pBarX + w / 2, barPos.y )
	surface.DrawText( players - zombies );

	surface.SetDrawColor( Color( 0, 0, 0 ) );
	surface.DrawOutlinedRect( barPos.x - barWidth / 2, barPos.y, barWidth, 20 );
end;



/*
	HOOKS:
*/

function CLASS.Hooks:HUDPaint()
	local client = LocalPlayer();
	if( client:IsDoctor() or client:IsInfected() ) then
		local zombies = self:GetZombies();
		local humans = self:GetHumans();
		for _,zombie in pairs( zombies ) do
			if( LocalPlayer():InPocketDimension() and zombie:InPocketDimension() or !LocalPlayer():InPocketDimension() and !zombie:InPocketDimension() ) then
				local pos = zombie:GetPos();
				if( pos:Distance( client:GetPos() ) <= self.EnemyRadius ) then
					if( zombie ~= client ) then
						self:DrawAlly( zombie );
					end;
				end;
			end;
		end;
		for _,human in pairs( humans ) do
			if( LocalPlayer():InPocketDimension() and human:InPocketDimension() or !LocalPlayer():InPocketDimension() and !human:InPocketDimension() ) then
				local pos = human:GetPos();
				if( pos:Distance( client:GetPos() ) <= self.EnemyRadius ) then
					self:DrawEnemy( human );
				end;
			end;
		end;
	end;
end;



function CLASS.Hooks:Think()
	for client,_ in pairs( self.Zombies ) do
		if( client ) then
			if( !client:IsValid() ) then
				self.Zombies[client] = nil;
			end;
		end;
	end;
end;