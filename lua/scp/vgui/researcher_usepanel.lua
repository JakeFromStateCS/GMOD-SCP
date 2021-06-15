local PANEL = {};

function PANEL:Init()
	self:SetSize( 160, 40 );
	self.Text = "Press Use.";
end;


function PANEL:Paint( w, h )
	surface.SetDrawColor( Color( 200, 200, 200 ) );
	surface.DrawRect( 1, 0, w - 2, h );
	surface.SetDrawColor( Color( 0, 0, 0 ) );
	surface.DrawOutlinedRect( 8, 0, w - 8, h );
	surface.SetDrawColor( Color( 50, 50, 50 ) );
	surface.DrawRect( 0, 0, 8, h );
	
	draw.SimpleTextOutlined( self.Text, "Researcher_DClass", w / 2, 20, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 50, 50, 50 ) );
end;
vgui.Register( "Researcher_UsePanel", PANEL );