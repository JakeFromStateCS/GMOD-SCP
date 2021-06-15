--[[
	Plague doctor cl_init.lua
	--Add manual blinking for time syncing
]]--
CLASS = CLASS or {};
CLASS.BlinkTimers = {};

surface.CreateFont( "SCP_Test1", {
	font = "Trebuchet",
	size = 20,
	weight = 700
} );

function CLASS:DrawNeckBreak( client )
	local scrPos = ( client:EyePos() - Vector( 0, 0, 10 ) ):ToScreen();
	local text = "Press E To Kill";
	surface.SetFont( "SCP_Test1" );
	local w, h = surface.GetTextSize( text );
	local boxSize = math.Max( 100, w + 10 );
	local posX, posY = scrPos.x - boxSize / 2, scrPos.y - boxSize / 2;
	
	surface.SetDrawColor( team.GetColor( client:Team() ) );
	surface.DrawOutlinedRect( posX, posY, boxSize, boxSize );
	surface.DrawRect( posX, posY, boxSize, h + 4 );
	
	surface.SetTextColor( Color( 255, 255, 255 ) );
	surface.SetTextPos( scrPos.x - w / 2, posY );
	surface.DrawText( text );
end;

function CLASS:DrawBlink()
	local time = self.BlinkTimers[LocalPlayer()];
	if( time ) then
		if( LocalPlayer().blinking ) then
			local since = time - self.BlinkTime;
			local diff = CurTime() - since;
			local barHeight = ScrH() / 2;
			local botBarY = ScrH() - math.sin( diff * self.CloseTime ) * barHeight;
			local topBarY = -barHeight + math.sin( diff * self.CloseTime ) * barHeight;
			local alpha = math.sin( diff * self.CloseTime ) * 255;
			local barWidth = ( 100 / ( time - CurTime() ) );
			surface.SetDrawColor( Color( 0, 0, 0, alpha ) );
			surface.DrawRect( 0, topBarY, ScrW(), barHeight );
			surface.DrawRect( 0, botBarY, ScrW(), barHeight );
		else
			local divisor = self.BlinkTime - self.CloseTime + ( CurTime() - time );
			local maxBarWidth = 150;
			local barWidth = maxBarWidth / ( self.BlinkTime - self.CloseTime ) * divisor;
			local col = 150 / ( self.BlinkTime - self.CloseTime ) * divisor;
			local xPos = ScrW() / 2 - maxBarWidth / 2;
			local yPos = ScrH() - 15 - 20;
			surface.SetDrawColor( Color( 0, 0, col, col + 100 ) );
			surface.DrawRect( xPos, yPos, barWidth, 15 );
			surface.SetDrawColor( Color( 0, 0, 0 ) );
			surface.DrawOutlinedRect( xPos, yPos, maxBarWidth, 15 );
		end;
	end;
end;

/*
	NETS:
*/
function CLASS.Nets:BlinkTime()
	self.BlinkTimers[LocalPlayer()] = CurTime() + self.BlinkTime;
	LocalPlayer().blinking = true;
	timer.Simple( self.CloseTime, function()
		LocalPlayer().blinking = false;
	end );
end;

/*
	HOOKS:
*/
function CLASS.Hooks:HUDPaint()
	if( LocalPlayer():Team() ~= self.Team ) then
		if( !table.HasValue( self.BlackList, LocalPlayer():Team() ) ) then
			self:DrawBlink();
		end;
	else
		if( !LocalPlayer():GetFrozen() and LocalPlayer():CanFreeze() ) then
			local trace = LocalPlayer():GetEyeTrace();
			local client = trace.Entity;
			local clients = ents.FindInSphere( LocalPlayer():EyePos(), self.KillDistance );
			for _,client in pairs( clients ) do
				if( client ) then
					if( client:IsPlayer() and client ~= LocalPlayer() ) then
						if( LocalPlayer():InPocketDimension() and client:InPocketDimension() or !LocalPlayer():InPocketDimension() and !client:InPocketDimension() ) then
							self:DrawNeckBreak( client );
						end;
					end;
				end;
			end;
		end;
	end;
end;

function CLASS.Hooks:Think()
	
end;