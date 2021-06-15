local PANEL = {};

function PANEL:Init()
	self.Text = "Press Use.";
	self.Font = "Researcher_DClass";
	surface.SetFont( self.Font );
	local w, h = surface.GetTextSize( self.Text );
	self:SetSize( w + 16, h + 4 );
end;


function PANEL:SetText( text )
	surface.SetFont( self.Font );
	local w, h = surface.GetTextSize( text );
	self:SetSize( w + 16, h + 4 );
	self.Text = text;
end;


function PANEL:SetFont( font )
	self.Font = font;
	self:SetText( self.Text );
end;


function PANEL:Paint( w, h )
	surface.SetDrawColor( Color( 200, 200, 200 ) );
	surface.DrawRect( 1, 0, w - 2, h );
	surface.SetDrawColor( Color( 0, 0, 0 ) );
	surface.DrawOutlinedRect( 8, 0, w - 8, h );
	surface.SetDrawColor( Color( 50, 50, 50 ) );
	surface.DrawRect( 0, 0, 8, h );
	
	draw.SimpleTextOutlined( self.Text, self.Font, ( w - 8 ) / 2 + 8, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 50, 50, 50 ) );
end;
vgui.Register( "SCP_Notice", PANEL );