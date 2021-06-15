surface.CreateFont( "Glass TitleText Large 50", {
	font = "Roboto",
	size = 32,
	weight = 50
} );

surface.CreateFont( "Glass TitleText Massive 50", {
	font = "Roboto",
	size = 42,
	weight = 50
} );

local PANEL = {};

function PANEL:Init()
	self.Panels = {};
	self.xSpacing = 1;
	self.ySpacing = 1;
	self.xOffset = 0;
	self.yOffset = 0;
	--self.maxHeight = 
	--local OAdd = self.Add;
	--self.OAdd = OAdd;
end;

function PANEL:GetXSpacing()
	return self.xSpacing;
end;

function PANEL:GetYSpacing()
	return self.ySpacing;
end;

function PANEL:SetXSpacing( num )
	self.xSpacing = num;
end;

function PANEL:SetYSpacing( num )
	self.ySpacing = num;
end;

function PANEL:SizeToContents()
	local w, h = self:GetSize();
	local totalH = 0;
	local totalW = 0;
	local col = 1;
	local row = 1;
	local xChange = false;
	for k,panel in pairs( self:GetItems() ) do
		if( panel ~= nil and panel:IsValid() ) then
			local xVal = 0;
			local yVal = 0;
			totalW = totalW + panel:GetWide();
			yVal = ( row - 1 ) * panel:GetTall() + ( row - 1 ) * self.ySpacing;
			
			if( ( col ) * panel:GetWide() + ( col - 1 ) * self.xSpacing < w ) then
				xVal = ( col ) * panel:GetWide() + ( col - 1 ) * self.xSpacing - panel:GetWide();
				col = col + 1;
				xChange = true;
			else
				col = 2;
				row = row + 1;
				totalH = totalH + panel:GetTall();
				if( xChange ) then
					yVal = ( row - 1 ) * panel:GetTall() + ( row - 1 ) * self.ySpacing;
				end
				xChange = false;
			end;
			panel:SetPos( xVal, yVal );
		else
			table.remove( self.Panels, k );
		end;
	end;
	totalH = math.max( totalH, h );
	self.totalHeight = totalH;

	self:SetSize( w, totalH );
end;

function PANEL:Add( panel )
	local panel = vgui.Create( panel, self );
	panel.id = #self.Panels + 1
	self.Panels[panel.id] = panel;
	return panel;
end;

function PANEL:GetItems()
	return self.Panels;
end;

function PANEL:PerformLayout( w, h )
	self:SetSize( w, h );
end;

function PANEL:OnMouseWheeled( delt )
	self.yOffset = delt * 30;
	if( self.totalHeight > self:GetParent():GetTall() ) then
		local x, y = self:GetItems()[1]:GetPos();
		if( y + self.yOffset <= 0 ) then
			for k,panel in pairs( self:GetItems() ) do
				local x,y = panel:GetPos();
				if( panel ~= nil and panel:IsValid() ) then
					panel:SetPos( x,y + self.yOffset );
				else
					table.remove( self.Panels, k );
				end;
			end;
		end;
	end;
end;

function PANEL:Paint( w, h )
	local Parent = self:GetParent();
	local themeColor = Color( 0, 0, 0 );
	local backgroundColor = Parent.BackgroundColor;
end;

vgui.Register( "Glass Container", PANEL, "DIconLayout" );



local PANEL = {};

function PANEL:Init()
	self:SetSize( ScrW() - 100, ScrH() - 100 );
	self.Blur = Material( "pp/blurx" );
	self.Blur:SetFloat( "$blur", 3 );
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
end;

vgui.Register( "Glass Frame", PANEL, "DPanel" );



local PANEL = {};

function PANEL:PopulateCategories()
	for _,category in pairs( self.Categories ) do
		--local button = self.Container:Add( "Glass Button" );
		--	
	end;
end;

function PANEL:Init()
	local parent = self:GetParent();
	self:SetSize( parent:GetWide() / 1.5, parent:GetTall() );
	self:SetPos( parent:GetWide(), 0 );
	self:MoveTo( parent:GetWide() - self:GetWide(), 0, 1 );
	self.Categories = {
		"Name",
		"Job",
		"Usergroup",
		"Ping"
	};
	self.Blur = Material( "pp/blurx" );
	self.Blur:SetFloat( "$blur", 3 );
	self.Container = vgui.Create( "Glass Container", self );
	self.Container:SetSize( self:GetWide() - 20, 42 + 20 );
	self.Container:SetPos( 10, 10 );
end;

function PANEL:Paint( w, h )
	surface.SetDrawColor( Color( 20, 20, 20, 150 ) );
	surface.DrawRect( 0, 0, w, h );
	surface.SetDrawColor( Color( 20, 20, 20, 200 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
end;

vgui.Register( "Glass SubPanel", PANEL, "DPanel" );



local PANEL = {};

function PANEL:Init()
	
end;

function PANEL:Paint( w, h )
	surface.SetDrawColor( Color( 20, 20, 20, 200 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	surface.SetDrawColor( Color( 20, 20, 20, 150 ) );
	surface.DrawRect( 0, 0, w, h );
	surface.SetDrawColor( Color( 20, 20, 20, 200 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
end;

--vgui.Register( "Glass SubPanel", PANEL, "DPanel" );

--[[
	Glass scoreboard
]]--

--[[
	Glass scoreboard playercontainer
]]--
local PANEL = {};

function PANEL:Init()
	self.Blur = Material( "pp/blurx" );
	self.Blur:SetFloat( "$blur", 1 );
	self.Container = vgui.Create( "Glass Container", self );
	self.Categories = {
		"Name",
		"Rank",
		"Job",
		"Ping"
	};
end;

function PANEL:Paint( w, h )
	surface.SetDrawColor( Color( 20, 20, 20, 220 ) );
	surface.DrawRect( 0, 0, w, h );
	surface.SetDrawColor( Color( 35, 30, 30, 250 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	surface.DrawRect( 0, 20, w, 42 );

	local categories = {};
	local maxWidth = 0;
	for index,category in pairs( self.Categories ) do
		surface.SetFont( "Glass TitleText Large 50" );
		local width, height = surface.GetTextSize( category );
		categories[category] = {
			x = maxWidth + index * 50,
			y = 42 - height / 2
		};
		maxWidth = maxWidth + width;
	end;
	
	for category,tab in pairs( categories ) do
		surface.SetTextPos( tab.x, tab.y );
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

