VGUIColors = {
	theme = Color( 41, 128, 185 ),
	background = Color( 250, 250, 250 )
};

--[[
	flatUI by Matt.
]]--
surface.CreateFont( "flatUI ButtonText fine", {
	font = "Roboto",
	size =  16
} );

surface.CreateFont( "flatUI ButtonText tiny", {
	font = "Roboto",
	size =  18
} );

surface.CreateFont( "flatUI ButtonText small", {
	font = "Roboto",
	size =  22
} );

surface.CreateFont( "flatUI TitleText fine", {
	font = "Roboto",
	size = 22,
} );

surface.CreateFont( "flatUI TitleText tiny", {
	font = "Roboto",
	size = 24,
} );

surface.CreateFont( "flatUI TitleText small", {
	font = "Roboto",
	size = 26,
} );

surface.CreateFont( "flatUI TitleText medium", {
	font = "Roboto",
	size = 28,
} );

surface.CreateFont( "flatUI TitleText large", {
	font = "Roboto",
	size = 32,
} );

surface.CreateFont( "flatUI ControlText", {
	font = "Arial",
	weight = 800,
	size = 16,
} );

surface.CreateFont( "flatUI Icon_Text", {
	font = "CloseCaption_Normal",
	weight = 800,
	size = 30,
} );

surface.CreateFont( "flatUI Icon_Text slim4", {
	font = "Trebuchet",
	weight = 400,
	size = 30
} );


--[[
	Close button.
]]--

local PANEL = {};

function PANEL:Init()
	self.Hovered = false;
	self.TargetAlpha = 0;
	self.Alpha = 0;

	self:SetSize(22, 22);
	self:SetMouseInputEnabled(true);
	self.Text = "x";
end;

function PANEL:Paint( w, h )
	if (self.Alpha != self.TargetAlpha) then
		self.Alpha = math.Approach(self.Alpha, self.TargetAlpha, 355 * FrameTime());
	end;
	local col = self:GetParent().BackgroundColor;
	surface.SetDrawColor(Color(100, 100, 100, self.Alpha));
	surface.DrawRect(0, 0, w, h);

	--surface.SetDrawColor( col );
	--surface.DrawRect( 0, 0, w, 4 );
	--surface.DrawRect( 0, 6, w, 4 );
	--surface.DrawRect( 0, 12, w, 4 );
	
	
	surface.SetFont("flatUI Icon_Text slim4");
	surface.SetTextPos(4, -6);
	surface.SetTextColor(self:GetParent().BackgroundColor);--Color(100, 100, 100, 200));
	surface.DrawText( self.Text );
end;

function PANEL:SetText( text )
	self.Text = text;
end;

function PANEL:OnCursorEntered()
	self.Hovered = true;
	self.TargetAlpha = 100;
end;

function PANEL:OnCursorExited()
	self.Hovered = false;
	self.TargetAlpha = 0;
end;

function PANEL:OnMousePressed()
	local Parent = self:GetParent();

	if (Parent.Metro) then
		Parent:Close();
		return;
	end;

	Parent:SetVisible(false);
end;

function PANEL:Align()
	local Parent = self:GetParent();
	local ParentWidth, ParentHeight = Parent:GetSize();

	self:SetPos( ParentWidth - ( self:GetWide() + 8 ), 6 );
end;

vgui.Register("flatUI_CloseButton", PANEL, "DPanel");

--[[
	FlatUI Kick from lobby button
	( The little X on their player button );
]]--

local PANEL = {};

function PANEL:Init()
	self.Hovered = false;
	self.TargetAlpha = 0;
	self.Alpha = 0;

	self:SetSize(22, 22);
	self:SetMouseInputEnabled(true);
end;

function PANEL:Paint( w, h )
	if (self.Alpha != self.TargetAlpha) then
		self.Alpha = math.Approach(self.Alpha, self.TargetAlpha, 355 * FrameTime());
	end;
	local col = self:GetParent().BackgroundColor;
	surface.SetDrawColor(Color(100, 100, 100, self.Alpha));
	surface.DrawRect(0, 0, w, h);

	--surface.SetDrawColor( col );
	--surface.DrawRect( 0, 0, w, 4 );
	--surface.DrawRect( 0, 6, w, 4 );
	--surface.DrawRect( 0, 12, w, 4 );
	
	
	surface.SetFont("flatUI Icon_Text slim4");
	surface.SetTextPos(4, -6);
	surface.SetTextColor(self:GetParent().BackgroundColor);--Color(100, 100, 100, 200));
	surface.DrawText("x");
end;

function PANEL:OnCursorEntered()
	self.Hovered = true;
	self.TargetAlpha = 100;
end;

function PANEL:OnCursorExited()
	self.Hovered = false;
	self.TargetAlpha = 0;
end;

function PANEL:OnMousePressed()
	local Parent = self:GetParent();

	if (Parent.Metro) then
		Parent:Close();
		return;
	end;

	Parent:SetVisible(false);
end;

function PANEL:Align()
	local Parent = self:GetParent();
	local ParentWidth, ParentHeight = Parent:GetSize();

	self:SetPos( ParentWidth - ( self:GetWide() + 8 ), 6 );
end;

vgui.Register("flatUI_KickButton", PANEL, "DPanel");


--[[
	Menu button.
]]--

local PANEL = {};

function PANEL:Init()
	self.Hovered = false;
	self.TargetAlpha = 0;
	self.Alpha = 0;
	self.Open = false;

	self:SetSize(22, 16);
	self:SetMouseInputEnabled(true);
end;

function PANEL:Paint( w, h )
	if (self.Alpha != self.TargetAlpha) then
		self.Alpha = math.Approach(self.Alpha, self.TargetAlpha, 355 * FrameTime());
	end;
	local col = self:GetParent().BackgroundColor;
	surface.SetDrawColor(Color(100, 100, 100, self.Alpha));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor( col );
	surface.DrawRect( 0, 0, w, 4 );
	surface.DrawRect( 0, 6, w, 4 );
	surface.DrawRect( 0, 12, w, 4 );
	
	
	--surface.SetFont("flatUI ControlText");
	--surface.SetTextPos(7, 2);
	--surface.SetTextColor(self:GetParent().BackgroundColor);--Color(100, 100, 100, 200));
	--surface.DrawText("x");
end;

function PANEL:OnCursorEntered()
	self.Hovered = true;
	self.TargetAlpha = 100;
end;

function PANEL:OnCursorExited()
	self.Hovered = false;
	self.TargetAlpha = 0;
end;

function PANEL:OnMousePressed()
	local Parent = self:GetParent();

	if( Parent.DMenu ~= nil ) then
		Parent.DMenu = nil;
		--return;
	else
		Parent.DMenu = vgui.Create( "DMenu", Parent );
		Parent.DMenu:SetPos( 0, 30 );
		for text, func in pairs( Parent.MenuOptions ) do
			Parent.DMenu:AddOption( text, func );
		end;
		self.Open = true;
		--Parent.DMenu:Open();
		--Parent:AddMenuOption( "Shit", function() print( "hi" ) end );
	end;
	--Parent:SetVisible(false);
end;

function PANEL:Align()
	local Parent = self:GetParent();
	local ParentWidth, ParentHeight = Parent:GetSize();

	self:SetPos( 10, 9 );


end;

vgui.Register("flatUI_MenuButton", PANEL, "DPanel");



--[[
	Base Panel
]]--
local PANEL = {};

function PANEL:Init()
	self.BackgroundColor = VGUIColors.background;
	self.ThemeColor = VGUIColors.theme;
end;

function PANEL:Paint( w, h )
	surface.SetDrawColor( self.ThemeColor );
	surface.DrawRect( 0, 0, w, 36 );
	surface.DrawOutlinedRect( 0, 0, w, h );
end;

vgui.Register( "flatUI_Panel", PANEL, "DPanel" );
print( "Created flatUI_Panel" );


--[[
	Base frame.
]]--

local PANEL = {};

function PANEL:Init()
	self.Title = "flatUI frame";
	self.Hovered = false;
	self.ShowCloseButton = true;
	self.ShowMenuButton = true;
	self.MouseDown = false;
	self.BackgroundColor = VGUIColors.background;
	self.ThemeColor = VGUIColors.theme;
	self.HighlightColor = Color( math.Clamp( self.ThemeColor.r + 20, 0, 255 ), math.Clamp( self.ThemeColor.g + 20, 0, 255 ), math.Clamp( self.ThemeColor.b + 20, 0, 255 ) );
	self.MenuOptions = {};

	self.Draggable = true;
	self.DragOffset = {
		x = 0,
		y = 0
	};

	self.Closing = false;
	self.DeleteOnClose = false;

	self.FadingToView = false;
	self.TitlePosition = -1000;
	self.TargetTitlePosition = -1000;

	self.MenuButton = vgui.Create( "flatUI_MenuButton", self );
	--self.CloseButton = vgui.Create( "flatUI_CloseButton", self );
	self.DMenu = vgui.Create( "DMenu", self );
	self.Icon = Material( "icon16/color_wheel.png" );
	--self.DMenu:Open();
	--self:AddMenuOption( "Shit", function() print( "hi" ) end );
	--self.DMenu:SetVisible( false );
end;

function PANEL:SetTitle( text )
	self.Title = text;
end;

function PANEL:MenuButtonVisible( bool )
	self.ShowMenuButton = bool;
	if( bool == false ) then
		if( self.MenuButton != nil ) then
			self.MenuButton:Remove();
			self.MenuButton = nil;
		end;
	end;
end;

function PANEL:SetDraggable( bool )
	self.Draggable = false;
end;

function PANEL:SetBackgroundColor( col )
	if( col.r and col.g and col.b ) then
		VGUIColors.background = col;
		self.BackgroundColor = col;
	end;
end;

function PANEL:SetThemeColor( col )
	if( col.r and col.g and col.b ) then
		VGUIColors.theme = col;
		self.ThemeColor = col;

		self.HighlightColor = Color( math.Clamp( self.ThemeColor.r + 20, 0, 255 ), math.Clamp( self.ThemeColor.g + 20, 0, 255 ), math.Clamp( self.ThemeColor.b + 20, 0, 255 ) );
	end;
end;

function PANEL:AddMenuOption( text, icon, func )
	if( text ) then
		if( type( icon ) == "function" ) then
			func = icon;
			self.MenuOptions[text] = function()
				self.DMenu = nil;
				func();
			end;
			--self.DMenu:AddOption( text, func );
		end;
	end;
end;

function PANEL:SetCallback( func )
	self.Callback = func;
end;

function PANEL:OnCursorEntered()
	self.Hovered = true;
end;

function PANEL:OnCursorExited()
	self.Hovered = false;
end;

function PANEL:CheckCursorPos()
	local posX, posY = self:GetPos();
	if( gui.MouseX() >= posX and gui.MouseX() <= posX + self:GetWide() ) then
		if( gui.MouseY() >= posY and gui.MouseY() <= posY + 36 ) then
			if( self.Hovered and input.IsMouseDown( MOUSE_LEFT ) and !self.Dragging ) then
				self.Dragging = true;

				self.DragOffset.x = gui.MouseX() - posX;
				self.DragOffset.y = gui.MouseY() - posY;
				return true;
			end;
		end;
	end;
end;

function PANEL:Think()
	if( input.IsMouseDown( MOUSE_LEFT ) ) then

		if( self.Dragging ) then
			if( self.Draggable ) then
				self:CheckCursorPos();
				self:SetPos( gui.MouseX() - self.DragOffset.x, gui.MouseY() - self.DragOffset.y );
			end;
		end;

		if( self:CheckCursorPos() ) then
			self.MouseDown = true;
		end;
	else
		if( self.Dragging ) then
			self.Dragging = false;
		end;
		if( self.MouseDown ) then
			self.MouseDown = false;
			if( self.Callback ~= nil ) then
				self.Callback( self );
			end;
		end;
	end;
end;

function PANEL:Paint( w, h )
	--self.CloseButton:Align();
	if( self.MenuButton != nil ) then
		self.MenuButton:Align();
	end;

	draw.RoundedBox( 4, 0, 0, w, h, self.BackgroundColor );

	surface.SetDrawColor( self.ThemeColor );
	surface.DrawRect( 0, 0, w, 36 );
	surface.DrawOutlinedRect( 0, 0, w, h );
	--surface.DrawRect( 0, 0, 200, h );

	local x, y = 42, 4;
	if( self.MenuButton == nil ) then
		x = 10;
	end;
	surface.SetFont( "flatUI TitleText small" );
	surface.SetTextPos( x, y );
	surface.SetTextColor( self.BackgroundColor );
	surface.DrawText( self.Title );

	surface.SetDrawColor( Color( 255, 255, 255 ) );
	--surface.DrawRect( 10, 30, 1200, 10 );

	--surface.SetDrawColor( Color( 255, 255, 255 ) );
	--surface.SetMaterial( self.Icon );
	--surface.DrawTexturedRect( 10, 10, 16, 16 );
end;

vgui.Register( "flatUI_Frame", PANEL, "DPanel" );

--[[
	Base button.
]]--

local PANEL = {};

function PANEL:Init()
	local Parent = self:GetParent();
	if( !Parent.ThemeColor ) then
		Parent = Parent:GetParent();
	end;
	self:SetSize( 190, 50 );
	self.Hovered = false;
	self.Text = "Button";
	self.TextColor = Parent.BackgroundColor;
	self.BackgroundColor = Parent.ThemeColor;
end;

function PANEL:SetText( text )
	self.Text = text;
end;

function PANEL:OnCursorEntered()
	self.Hovered = true;
end;

function PANEL:OnCursorExited()
	self.Hovered = false;
end;

function PANEL:OnMousePressed()
end;

function PANEL:Paint( w, h )
	local Parent = self:GetParent();
	if( !Parent.ThemeColor ) then
		Parent = Parent:GetParent();
	end;
	if( Parent.ThemeColor ) then
		--surface.SetDrawColor( Parent.ThemeColor );
		--surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( self.BackgroundColor );
		surface.DrawRect( 0, 0, w, h );

		surface.SetTextColor( self.TextColor );
		surface.SetFont( "flatUI Icon_Text" );
		local textW, textH = surface.GetTextSize( self.Text );
		surface.SetTextPos( w - textW - 10, h / 2 - textH / 2 );
		surface.DrawText( self.Text );
	end;
end;

--vgui.Register( "flatUI_Button", PANEL, "DPanel" );





--[[
	Minigame/Lobby buttons
	Basically the button with a bar
]]--

local PANEL = {};

function PANEL:Init()
	self.barColor = Color( 255, 255, 255 );
	self.textColor = Color( 255, 255, 255 );
	self.backgroundColor = Color( 50, 50, 50, 255 );--Color( self.barColor.r, self.barColor.g, self.barColor.b, 100 );--Color( 153, 153, 153 );
	self.text = "undefined";
	self.font = "flatUI TitleText medium";
	self.click = false;
	self.size = 0;
	self.alpha = 150;
	self.barWidth = 30;
	self.clickable = true;
	self.animateBar = true;
	self.drawBar = true;
	self.centerText = false;
	self.HCenterText = false;
	self.textPos = {
		x = 20,
		y = 5
	};
	self.clickTime = CurTime();
end;

function PANEL:PerformLayout()
	--self:SetSize( 200, 70 );
	surface.SetFont( self.font );
	local W,H = surface.GetTextSize( self.text );
	self.textPos.y = self:GetTall() / 2 - H / 2;
end;

function PANEL:SetAlpha( num )
	self.alpha = num;
end;

function PANEL:SetBarColor( color )
	self.barColor = color;
	self.backgroundColor = Color( self.barColor.r, self.barColor.g, self.barColor.b, self.alpha );
end;

function PANEL:SetTextColor( color )
	self.textColor = color;
end;

function PANEL:SetText( text )
	self.text = text;
	if( self.centerText ) then
		surface.SetFont( self.font );
		local W,H = surface.GetTextSize( text );
		self:SetTextPos( self:GetWide() / 2 - W / 2, self:GetTall() / 2 - H / 2 );
	end;
end;

function PANEL:GetTextPos()
	return { x = self.textPos.x, y = self.textPos.y };
end;

function PANEL:SetTextPos( x, y )
	self.textPos.x = x;
	self.textPos.y = y;
end;

function PANEL:SetCenterText( bool )
	self.centerText = bool;
end;

function PANEL:SetHorizontalCenterText( bool )
	self.HCenterText = bool;
end;

function PANEL:SetClickable( bool )
	self.clickable = bool;
end;

function PANEL:SetAnimateBar( bool )
	self.animateBar = bool;
end;

function PANEL:SetDrawBar( bool )
	self.drawBar = bool;
end;

function PANEL:SetBackgroundColor( color )
	self.backgroundColor = color;
end;

function PANEL:SetHovered( hovered )
	self.hovered = hovered;
end;

function PANEL:GetHovered()
	return self.hovered;
end;

function PANEL:OnCursorEntered()
	--local hBackgroundColor = Color( self.backgroundColor.r + 20, self.backgroundColor.g + 20, self.backgroundColor.b + 20 );
	self:SetHovered( true );
	--self.backgroundColor = hBackgroundColor;
end;

function PANEL:OnCursorExited()
	--local hBackgroundColor = Color( self.backgroundColor.r - 20, self.backgroundColor.g - 20, self.backgroundColor.b - 20 );
	self:SetHovered( false );
	--self.backgroundColor = hBackgroundColor;
end;

function PANEL:OnMousePressed( code )
	if( self.clickable ) then
		self:MouseCapture( true );
		self.click = true;
	end;
end;

function PANEL:OnMouseReleased( code )
	self:MouseCapture( false );
	self.click = false;
	
	if( !self:GetHovered() ) then
		return;
	end;
	
	if( self.clickable ) then
		if( code == MOUSE_LEFT and self.DoClick ) then
			self.DoClick( self );
			self.clickTime = CurTime();
		end;
	end;
end;

function PANEL:SetCallback( callback )
	self.DoClick = function( panel )
		callback( panel );
		surface.PlaySound( "buttons/button14.wav" );
	end;
end;

function PANEL:Paint( w, h )
	local x, y = self:GetPos();
	local themeColor = VGUIColors.theme;
	local highlightColor = Color( math.Clamp( themeColor.r + 20, 0, 255 ), math.Clamp( themeColor.g + 20, 0, 255 ), math.Clamp( themeColor.b + 20, 0, 255 ) );
	if( !themeColor ) then
		--themeColor = --Base.VGUI.ThemeColor;
	end;
	if( !highlightColor ) then
		highlightColor = Base.VGUI.HighlightColor;
	end;
	--local width, height = self:GetSize();
	--local textHeight = draw.GetFontHeight( self.font );
	


	if( self.click ) then
		self.size = math.Approach( self.size, 5, 1.5 );
	else
		if( self.size > 0 ) then
			self.size = math.Approach( self.size, 0, 1.5 );
		end;
	end;

	surface.SetDrawColor( self.backgroundColor );
	surface.DrawRect( self.size, self.size, w - self.size * 2, h - self.size * 2 );
	
	if( self.drawBar ) then
		surface.SetDrawColor( self.barColor );
		surface.DrawRect( self.size, self.size, self.barWidth - self.size, h - self.size * 2 );
	end;

	if( self:GetHovered() ) then
		surface.SetDrawColor( highlightColor );
		surface.DrawRect( 0 + self.size, h - 4 - self.size, w - self.size * 2, 4 );
		surface.DrawRect( 0 + self.size, self.size, w - self.size * 2, 4 );
		surface.DrawRect( w - 4 - self.size, self.size, 4, h - self.size * 2 );
		surface.DrawRect( 0 + self.size, self.size, 4, h - self.size * 2 );
		--self.barWidth = math.Approach( self.barWidth, w - 5, 10 );
		if( self.animateBar ) then
			self.barWidth = math.Clamp( self.barWidth + 1000 * FrameTime(), 30, w - 5 );
		end;
	else
		self.barWidth = math.Clamp( self.barWidth - 1000 * FrameTime(), 30, w - 5 );
		--self.barWidth = math.Approach( self.barWidth, 30, 10 );
	end;
	
	--surface.SetDrawColor( bhColor );
	--surface.DrawRect( 0, 0, 30, 2 );
	
	--surface.SetDrawColor( bghColor );
	--surface.DrawLine( 30, 0, w, 0 );
	
	
	
	surface.SetFont( self.font );
	surface.SetTextColor( Color( 255, 255, 255 ) );
	surface.SetTextPos( self.textPos.x, self.textPos.y + self.size );
	surface.DrawText( self.text );
end;

vgui.Register( "flatUI_Button", PANEL );





--[[
	Container, dunno why I made it lol
]]--

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
	/*
	panel.oPerformLayout = panel.PerformLayout;
	function panel.PerformLayout( w, h )
		self:SizeToContents();
		panel.oPerformLayout( panel, w, h );
	end;
	*/
	--function panel:OnMouseWheeled
	self.Panels[panel.id] = panel;
	return panel;
	--self:OAdd();
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

	--surface.SetDrawColor( themeColor );
	--surface.DrawRect( 0, 0, w, h );
	--Top Horizontal
	--surface.DrawRect( 0, 0, w, 4 );
	--Bottom Horizontal
	--surface.DrawRect( 0, h - 4, w, 4 );
	--Top Vertical
	--surface.DrawRect( 0, 0, 4, h );
	--Bottom Vertical
	--surface.DrawRect( w - 4, 0, 4, h );
end;

vgui.Register( "flatUI_Container", PANEL, "DIconLayout" );


local PANEL = {};

function PANEL:Init()
	self.TabCont = vgui.Create( "flatUI_Container", self );
	self.TabCont:SetSize( self:GetWide(), 35 );
	self.TabCont:SetPos( 3, 0 );

	self.Options = {};
end;

function PANEL:Paint()

end;

function PANEL:PerformLayout( w, h )
	self.TabCont:SetSize( w, 35 );
	self.TabCont:SizeToContents();
end;

function PANEL:SetActiveTab( name )
	if( self.Options[name] ) then
		self.Options[name]:MoveToFront();
		for nName,panel in pairs( self.Options ) do
			if( panel ~= self.Options[name] ) then
				panel:SetPos( 1000, 0 );
			end;
		end;
	end;
	self.TabCont:SizeToContents();
end;

function PANEL:AddTab( text, panel )
	panel:SetSize( self:GetWide(), self:GetTall() );
	panel:SetPos( 0, 38 );
	panel:SetParent( self );
	function panel:Paint()
	
	end;
	
	local tabButton = self.TabCont:Add( "flatUI_Button" );
	tabButton:SetSize( 100, 35 );
	tabButton:SetText( text );
	tabButton:SetAnimateBar( false );
	tabButton:SetClickable( true );
	tabButton:SetBarColor( Color( 50, 50, 50 ) );
	tabButton:SetCallback( function( button )
		panel:MoveToFront();
		panel:SetPos( 0, 38 );
		for _,newPan in pairs( self.Options ) do
			if( newPan ~= panel ) then
				newPan:SetPos( 1000, 0 );
			end;
		end;
	end );
	self.Options[text] = panel;
	return panel;
end;

vgui.Register( "flatUI_PropertySheet", PANEL );



local PANEL = {};

function PANEL:Init()
	self.Text = "";
	self.Editable = true;
	self.Font = "flatUI TitleText small";
	self.BackSpace = false;
	self.Shift = false;
	self.BackspaceTime = CurTime();
end;

function PANEL:GetText()
	return self.Text;
end;

function PANEL:SetText( text )
	self.Text = text;
end;

function PANEL:SetEditable( bool )
	self.Editable = bool;
end;

function PANEL:SetFont( font )
	self.Font = font;
end;

function PANEL:SetCallback( func )
	self.Callback = func;
end;

function PANEL:SetEnter( func )
	self.OnEnter = func;
end;

function PANEL:OnClick()
	if( self.Editable ) then
		self:SetKeyboardInputEnabled( true );
	end
end;

function PANEL:OnKeyCodePressed( key )
	if( self.Editable ) then
		if( self.Text == "Lobby Name" ) then
			self:SetText( "" );
		end;
		local specials = {
			KEY_BACKSPACE,
			KEY_ENTER,
			KEY_LSHIFT,
			KEY_RSHIFT,
			KEY_SPACE
		};
		if( !table.HasValue( specials, key ) ) then
			local letter = input.GetKeyName( key );
			if( self.Shift ) then
				letter = string.upper( letter );
			end;
			self:SetText( self.Text .. letter );
		else
			if( key == KEY_ENTER ) then
				if( self.OnEnter ) then
					self:OnEnter( self );
				end;
			elseif( key == KEY_BACKSPACE ) then
				self.BackSpace = true;
			elseif( key == KEY_LSHIFT or key == KEY_RSHIFT ) then
				self.Shift = true;
			elseif( key == KEY_SPACE ) then
				self:SetText( self.Text .. " " );
			end;
		end;
	end;
end;

function PANEL:Think()
	if( !input.IsKeyDown( KEY_BACKSPACE ) ) then
		self.BackSpace = false;
	end;
	if( !input.IsKeyDown( KEY_LSHIFT ) and !input.IsKeyDown( KEY_RSHIFT ) ) then
		self.Shift = false;
	end;
	if( self.BackSpace ) then
		if( CurTime() > self.BackspaceTime ) then
			self:SetText( string.sub( self.Text, 1, string.len( self.Text ) - 1 ) );
			self.BackspaceTime = CurTime() + 0.1;
		end;
	end;
end;

function PANEL:Paint( w, h )
	local Parent = self:GetParent();
	local themeColor = Parent.ThemeColor;
	local backgroundColor = Parent.BackgroundColor;

	surface.SetDrawColor( backgroundColor );
	surface.DrawRect( 1, 1, w - 2, h - 2 );

	surface.SetDrawColor( themeColor );
	surface.DrawOutlinedRect( 0, 0, w, h );

	surface.SetFont( self.Font );
	local W, H = surface.GetTextSize( self.Text );

	surface.SetTextColor( Color( 0, 0, 0 ) );
	surface.SetTextPos( w / 2 - W / 2, h / 2 - H / 2 );
	surface.DrawText( self.Text );

end;

--function PANEL:Paint( w, h )
--	local Parent = self:GetParent();
--	local themeColor = Parent.ThemeColor;
--	local backgroundColor = Parent.BackgroundColor;

--	surface.SetDrawColor( backgroundColor );
--	surface.DrawRect( 1, 1, w - 2, h - 2 );

--	surface.SetDrawColor( themeColor );
--	surface.DrawOutlinedRect( 0, 0, w, h );
	--Top Horizontal
	--surface.DrawRect( 0, -4, w, 4 );
	--Bottom Horizontal
	--surface.DrawRect( 0, h - 4, w, 4 );
	--Top Vertical
	--surface.DrawRect( 0, 0, 4, h );
	--Bottom Vertical
	--surface.DrawRect( w - 4, 0, 4, h );
--end;

vgui.Register( "flatUI_TextEntry", PANEL );



local PANEL = {};

function PANEL:Init()
	self.tabContainer = vgui.Create( "flatUI_Container", self );
	self.tabContainer:SetSize( self:GetWide(), 50 );
	self.buttons = {};
end;

function PANEL:PerformLayout( w, h )
	self.tabContainer:SetSize( w, 50 );
end;

function PANEL:Add( text, panel )
	
	self.buttons[text] = panel;
end;



vgui.Register( "flatUI_DProperySheet", PANEL, "DPropertySheet" );

local PANEL = {};

local oldPaint = PANEL.Paint;

function PANEL:Paint( w, h )
	local x, y = self:LocalToScreen( 0, 0 )
	 
	local sl, st, sr, sb = x, y, x + w, y + h
	 
	local p = self
	while p:GetParent() do
		p = p:GetParent()
		local pl, pt = p:LocalToScreen( 0, 0 )
		local pr, pb = pl + p:GetWide(), pt + p:GetTall()
		sl = sl < pl and pl or sl
		st = st < pt and pt or st
		sr = sr > pr and pr or sr
		sb = sb > pb and pb or sb
	end
	 
	render.SetScissorRect( sl, st, sr, sb, true )
		oldPaint(self)
	render.SetScissorRect( 0, 0, 0, 0, false )
end;

vgui.Register( "flatUI_ModelPanel", PANEL, "DModelPanel" );

print( "Loaded FLATUI" );