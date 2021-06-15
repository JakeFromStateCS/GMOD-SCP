local PANEL = {};

function PANEL:Init()
	self:SetSize( 400, 40 );
	self.Text = "Get a DClass for research.";
	self.Alpha = 255;
end;


function PANEL:SetAlpha( int )
	self.Alpha = int;
end;


function PANEL:Paint( w, h )
	surface.SetDrawColor( Color( 200, 200, 200, self.Alpha ) );
	surface.DrawRect( 1, 0, w - 2, h );
	surface.SetDrawColor( Color( 0, 0, 0, self.Alpha ) );
	surface.DrawOutlinedRect( 8, 0, w - 8, h );
	surface.SetDrawColor( Color( 50, 50, 50, self.Alpha ) );
	surface.DrawRect( 0, 0, 8, h );
	
	draw.SimpleTextOutlined( self.Text, "Researcher_AreaText", w / 2, 20, Color( 255, 255, 255, self.Alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 50, 50, 50, self.Alpha ) );
end;
vgui.Register( "Researcher_NotifyPanel", PANEL );