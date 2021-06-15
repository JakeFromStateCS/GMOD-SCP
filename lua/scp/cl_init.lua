--[[
	cl_init.lua
	Let them be
	Secured.
	Contained.
	and
	Protected.
]]--

function surface.DrawTriangle( x, y, size )
	local tri = {
		{ x = x - size / 2, y = y - size * .75 },
		{ x = x + size / 2, y = y - size * .75 },
		{ x = x, y = y }	
	}
	surface.DrawPoly( tri );
end;


SCP = {};
include( "sh_init.lua" );


function SCP.Nets:OverrideTargetID()
	function GAMEMODE:HUDDrawTargetID()
		local tr = util.GetPlayerTrace( LocalPlayer() )
		local trace = util.TraceLine( tr )
		if ( !trace.Hit ) then return end
		if ( !trace.HitNonWorld ) then return end
		
		local text = "ERROR"
		local font = "TargetID"
		local col = Color( 255, 255, 255 );
		if ( trace.Entity:IsPlayer() ) then
			text = trace.Entity:Nick()
			if( trace.Entity:GetNWBool( "Disguised" ) == true ) then
				local strCol = trace.Entity:GetDisTeamColour();
				local split = string.Split( strCol, "," );
				col = Color( split[1], split[2], split[3], split[4] );
			else
				col = team.GetColor( trace.Entity:Team() );
			end;
		else
			return
			--text = trace.Entity:GetClass()
		end

		if( trace.Entity:InPocketDimension() ) then
			if( !LocalPlayer():InPocketDimension() ) then
				return;
			end;
		else
			if( LocalPlayer():InPocketDimension() ) then
				return;
			end;
		end;
		
		surface.SetFont( font )
		local w, h = surface.GetTextSize( text )
		
		local MouseX, MouseY = gui.MousePos()
		
		if ( MouseX == 0 && MouseY == 0 ) then
		
			MouseX = ScrW() / 2
			MouseY = ScrH() / 2
		
		end
		
		local x = MouseX
		local y = MouseY
		
		x = x - w / 2
		y = y + 30
		
		-- The fonts internal drop shadow looks lousy with AA on
		draw.SimpleText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ) )
		draw.SimpleText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ) )
		draw.SimpleText( text, font, x, y, col )
	end;
end;