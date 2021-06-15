--[[
	Glass scoreboard
]]--

--[[
	Glass scoreboard playercontainer
]]--
local PANEL = {};

function PANEL:Init()
	self.Blur = Material( "pp/blurx" );
	self.Blur:SetFloat( "$blur", 3 );
	self.Container = vgui.Create( "Glass Container", self );
	self.Categories = {
		"Name",
		"Rank",
		"Job",
		"Ping"
	};
end;

function PANEL:Paint( w, h )
	surface.SetDrawColor( Color( 255, 255, 255 ) );
	surface.SetMaterial( self.Blur );
	render.UpdateScreenEffectTexture();
	surface.DrawTexturedRect( 0, 0, w, h );
	surface.SetDrawColor( Color( 20, 20, 20, 180 ) );
	surface.DrawRect( 0, 0, w, h );
	surface.SetDrawColor( Color( 20, 20, 20, 200 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	surface.DrawRect( 0, 20, w, 52 );

	for index,category in pairs( self.Categories ) do
		surface.SetFont( "Glass TitleText Massive" );
		local width, height = surface.GetTextSize( category );
		surface.SetTextPos( w / ( 10 - index * 1.5 ), 52 / 2 - height / 2 );
		surface.SetTextColor( Color( 255, 255, 255 ) );
		surface.DrawText( category );
	end;
end;

vgui.Register( "Glass Scoreboard PlayerFrame", PANEL, "DPanel" );


--[[
	Base container of the scoreboard.
]]--
local PANEL = {};

function PANEL:Init()
	self:SetSize( ScrW() - 100, ScrH() - 100 );
	self:Center();
	self.NameContainer = vgui.Create( "Glass Scoreboard PlayerFrame", self );
	self.NameContainer:SetSize( self:GetWide() / 1.5 - 20, self:GetTall() );
	self.NameContainer:SetPos( self:GetWide() - self.NameContainer:GetWide(), 0 );
end;

function PANEL:Paint( w, h )

end;

vgui.Register( "Glass Scoreboard BaseFrame", PANEL, "DPanel" );