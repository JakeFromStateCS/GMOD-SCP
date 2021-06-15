surface.CreateFont( "scp_target_square", {
	font = "Roboto",
	size = 20
} );

local PANEL = {};

function PANEL:Init()
	self.Text = "Press Use.";
	self.Font = "scp_target_square";
	self.Color = Color( 50, 50, 50 );
	surface.SetFont( self.Font );
	local w, h = surface.GetTextSize( self.Text );
	self:SetSize( w + 4, w + 4 );
	self.TextH = h;
end;


function PANEL:SetText( text )
	surface.SetFont( self.Font );
	local w, h = surface.GetTextSize( text );
	w = math.Max( w + 8, 150 );
	self:SetSize( w, w );
	self.Text = text;
	self.TextH = h;
end;


function PANEL:SetColor( col )
	self.Color = col;
end;


function PANEL:SetFont( font )
	self.Font = font;
	self:SetText( self.Text );
end;


function PANEL:Paint( w, h )
	surface.SetDrawColor( self.Color );
	surface.DrawRect( 0, 0, w, self.TextH + 4 );
	surface.DrawOutlinedRect( 0, 0, w, h );
	
	draw.SimpleTextOutlined( self.Text, self.Font, w / 2, 2 + self.TextH / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 50, 50, 50 ) );
end;
vgui.Register( "scp_target_square", PANEL );