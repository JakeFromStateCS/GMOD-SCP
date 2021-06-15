local PANEL = {};



function PANEL:Init()
	self.allowedTeams = {};
	self:SetSize( 300, 400 );
	self:Center();
	self.list = vgui.Create( "DPanelList", self );
	self.list:SetSize( self:GetWide() - 2, self:GetTall() - 40 );
	self.list:SetPos( 1, 40 );
	self.list:SetDrawBackground( false );
	self.list:EnableVerticalScrollbar( true );
	self.close = vgui.Create( "DLabel" );
	function self.close:OnMousePressed()
		surface.PlaySound( "buttons/button14.wav" );
		local parent = self:GetParent();
		parent:Remove();
		SCP.ClearanceMenu = nil;
		gui.EnableScreenClicker( false );
	end;
	self.close:SetParent( self );
	self.close:SetFont( "flatUI TitleText small" );
	self.close:SetText( "x" );
	self.close:SetSize( 40, 40 );
	self.close:SetPos( self:GetWide() - self.close:GetWide() / 2 - 10, -2 );
	self.close:SetTextColor( Color( 255, 255, 255 ) );
	gui.EnableScreenClicker( true );
end;



function PANEL:ClearList()
	for _,child in pairs( self.list:GetItems() ) do
		child:Remove();
	end;
end;



function PANEL:SetScanner( ent )
	self.scanner = ent;
	local clearance = ent:GetNWInt( "ClearanceLevel" );
	local allowedTeams = SCP:GetAllowedTeams( clearance );
	local deniedTeams = SCP:GetDeniedTeams( clearance );
	self:SetAllowedTeams( allowedTeams );
	self:SetDeniedTeams( deniedTeams );
end;



function PANEL:AddButton( teamID, allowed )
	local senior = false;
	if( table.HasValue( SCP.SeniorResearchers, teamID ) ) then
		if( self.SeniorResearchers ) then
			return;
		else
			self.SeniorResearchers = true;
			senior = true;
		end;
	end;
	local label = vgui.Create( "DLabel" );
	label:SetFont( "flatUI TitleText small" );
	label:SetText( "  " .. team.GetName( teamID ) );
	if( senior ) then
		label:SetText( "  Senior Researchers" );
	end;
	label:SizeToContents();
	label:SetTextColor( Color( 50, 50, 50 ) );
	label.barColor = Color( 50, 50, 50 );
	label.teamID = teamID;
	label.allowed = allowed;
	label.scanner = self.scanner;
	local allowedNW = self.scanner:GetNWBool( "Clearance_Allowed_" .. teamID );
	local clearanceSet = self.scanner:GetNWBool( "Clearance_Set_" .. teamID );
	if( clearanceSet and allowedNW ~= allowed ) then
		label.allowed = allowedNW;
	end;
	if( label.allowed ) then
		label.barColor = team.GetColor( teamID );
	end;
	function label:Paint( w, h )
		surface.SetDrawColor( Color( 250, 250, 250, 255 ) );
		surface.DrawRect( 0, 0, w, h );
		surface.SetDrawColor( Color( 50, 50, 50 ) );
		surface.DrawOutlinedRect( 0, 0, w, h );
		surface.SetDrawColor( self.barColor );
		surface.DrawRect( 1, 1, 4, h - 2 );
	end;
	function label:OnMousePressed()
		if( self.allowed ) then
			self.barColor = Color( 50, 50, 50 );
		else
			self.barColor = team.GetColor( self.teamID );
		end;
		self.allowed = !self.allowed;
		if( !senior ) then
			SCP:NetMessage( "Keycard_SetClearance", self.scanner, self.teamID, self.allowed );
		else
			for _,teamID in pairs( SCP.SeniorResearchers ) do
				SCP:NetMessage( "Keycard_SetClearance", self.scanner, teamID, self.allowed );
			end;
		end;
		surface.PlaySound( "buttons/button14.wav" );
	end;
	self.list:AddItem( label );
end;



function PANEL:SetAllowedTeams( teams )
	self.allowedTeams = teams;
	local maxHeight = 0;
	for _,teamID in pairs( teams ) do
		self:AddButton( teamID, true );
	end;
end;



function PANEL:SetDeniedTeams( teams )
	self.deniedTeams = teams;
	local maxHeight = self.list:GetTall();
	for _,teamID in pairs( teams ) do
		self:AddButton( teamID, false );
	end;
end;



function PANEL:Paint( w, h )
	surface.SetDrawColor( Color( 250, 250, 250, 255 ) );
	surface.DrawRect( 0, 0, w, h );
	surface.SetDrawColor( Color( 50, 50, 50 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	surface.DrawRect( 0, 0, w, 40 );
	surface.SetFont( "flatUI TitleText medium" );
	local textW, textH = surface.GetTextSize( "Clearances:" );
	draw.SimpleText( "Clearances:", "flatUI TitleText medium", textW / 2 + 10, 20, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
	surface.DrawLine( 5, 32, w - 10, 32 );
end;
vgui.Register( "Keycard_ClearanceMenu", PANEL, "DPanel" );



function SCP.Nets:ClearanceMenu()
	local ent = net.ReadEntity();
	local data = net.ReadTable();
	if( ent:IsValid() ) then
		if( SCP.ClearanceMenu == nil ) then
			SCP.ClearanceMenu = vgui.Create( "Keycard_ClearanceMenu" );
			SCP.ClearanceMenu:SetScanner( ent );
		end;
	end;
end;